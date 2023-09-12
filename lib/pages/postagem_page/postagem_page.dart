import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/postagem.dart';
import 'package:tcc_hugo/my_drawer.dart';

class PostagemPage extends StatefulWidget {
  static const routeName = '/postagem';

  PostagemPage({super.key});

  @override
  State<PostagemPage> createState() => _PostagemPageState();
}

class _PostagemPageState extends State<PostagemPage> {
  @override
  Widget build(BuildContext context) {
    Postagem postagem = ModalRoute.of(context)!.settings.arguments as Postagem;

    return Scaffold(
      appBar: AppBar(
        title: Text("Voltar",
            style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                  color: kPrimaryColor.withAlpha(50),
                  child: postagem.urlImage != null
                      ? FadeInImage.assetNetwork(
                          fit: BoxFit.contain,
                          placeholder: "assets/images/logo.png",
                          image: postagem.urlImage!,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                            );
                          })
                      : Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                          width: 220,
                        )),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                DateFormat('dd-MM-yyyy').format(postagem.date!),
                textAlign: TextAlign.left,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: kSecundaryColor),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                postagem.titulo!.toUpperCase(),
                textAlign: TextAlign.left,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: kPrimaryColor),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              child: Text(
                postagem.subtitulo!,
                textAlign: TextAlign.left,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black45),
              ),
            ),
            Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(horizontal:30.0, vertical: 20),
              child: Text(
                "${postagem.descricao!.replaceAll("#", "\n")}",
                textAlign: TextAlign.justify,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54),
                    softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
