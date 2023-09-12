import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc_hugo/services/storage.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = user;
      isLoading = false;

      notifyListeners();
    });
  }

  refresh() async {
    try {
      await _auth.currentUser?.reload();

      _getUser();
      print(_auth.currentUser!.emailVerified);
    } catch (e) {
      print(e);
    }
  }

  _getUser() async {
    await _auth.currentUser?.reload();
    usuario = _auth.currentUser;

    notifyListeners();
  }

  registrar(XFile? fotoPerfil, String nome, String email, String senha) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: senha)
          .then((value) async {
        if (value.user != null && !value.user!.emailVerified) {
          value.user!.updateDisplayName(nome);
        }

        if (fotoPerfil != null) {
          // Realiza o upload da foto para o Firebase Storage
          final storage = Storage(auth: this);
          final task = await storage.upload(fotoPerfil.path);
          final snapshot = await task.whenComplete(() {});
          final downloadUrl = await snapshot.ref.getDownloadURL();

          // Atualiza a foto de perfil do usuário
          await value.user!.updatePhotoURL(downloadUrl);
        }

        value.user!.sendEmailVerification();
      });

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      _getUser();

      if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
        throw AuthException(
            'Email não verificado. Verifique seu email antes de fazer login.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _authCheck();
    isLoading = true; //verificar se precisa disso

    notifyListeners();
  }

  sendEmailVerification() {
    _auth.currentUser!.sendEmailVerification();
  }

  resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
    }
  }

  updateDisplayName(String nome) async {
    try {
      await usuario!.updateDisplayName(nome);
      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException('Erro ao atualizar o nome. Tente novamente');
    }
  }

  updatePassword(String senhaAtual, String novaSenha) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: usuario!.email!,
        password: senhaAtual,
      );
      await usuario!.reauthenticateWithCredential(credential);

      await _auth.currentUser!.updatePassword(novaSenha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw AuthException('Senha atual incorreta. Tente novamente');
      }
    }
  }

  updateFoto(XFile? fotoPerfil) async {
    if (usuario != null && fotoPerfil != null) {
      try {
        final storage = Storage(auth: this);

        if (usuario!.photoURL != null) {
          await storage.deleteImage(usuario!.photoURL!);
        }

        final task = await storage.upload(fotoPerfil.path);
        final snapshot = await task.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Atualiza a foto de perfil do usuário
        await usuario!.updatePhotoURL(downloadUrl);
        _getUser();
      } on FirebaseAuthException catch (e) {
        throw AuthException('Falha em atualizar a foto do perfil');
      }
    }
  }

  excluirConta(String senha)async{
   try {
    User user = _auth.currentUser!;
    
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: senha,
    );

    await user.reauthenticateWithCredential(credential);

    await user.delete();
    print('Conta excluída com sucesso.');
  } catch (e) {
    print('Erro ao excluir conta: $e');
  }
}
}