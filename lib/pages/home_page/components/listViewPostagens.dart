import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/repositorys/postagem_repository.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';

class ListViewPostagens extends StatefulWidget {
  const ListViewPostagens({Key? key}) : super(key: key);

  @override
  State<ListViewPostagens> createState() => _ListViewPostagensState();
}

class _ListViewPostagensState extends State<ListViewPostagens> {
  TextEditingController pesquisaController = TextEditingController();
  String _pesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<PostagensRepository>(builder: (context, posts, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Feed Notícias",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextFormGenerico(
              controller: pesquisaController,
              label: "Pesquise",
              onChanged: (txt) {
                setState(() {
                  _pesquisa = txt;
                });
              },
              prefix: Icons.search,
            ),
          ),
          (posts.isLoading)
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: posts.lista.length == 0 ? 20 : 250,
                  child: posts.lista.isEmpty
                      ? Center(
                          child: Text("Nenhuma notícia encontrada"),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: posts.lista.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 0),
                          itemBuilder: (context, index) {
                            if (posts.lista[index].descricao!
                                    .contains(_pesquisa) ||
                                posts.lista[index].titulo!
                                    .contains(_pesquisa) ||
                                posts.lista[index].subtitulo!
                                    .contains(_pesquisa)) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/postagem',
                                      arguments: posts.lista[index]);
                                },
                                child: Container(
                                  width: 220,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 2,
                                    color: kWhite,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                              child: Container(
                                                color: kWhite,
                                                child: posts.lista[index]
                                                            .urlImage !=
                                                        null
                                                    ? FadeInImage.assetNetwork(
                                                        fit: BoxFit.fitHeight,
                                                        width: 220,
                                                        placeholder:
                                                            "assets/images/loading_postagem.gif",
                                                        image: posts
                                                            .lista[index]
                                                            .urlImage!,
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                            "assets/images/logo.png",
                                                            fit: BoxFit.contain,
                                                            width: 220,
                                                          );
                                                        },
                                                      )
                                                    : Image.asset(
                                                        "assets/images/logo.png",
                                                        fit: BoxFit.contain,
                                                        width: 220,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 8.0, right: 8.0),
                                          child: Text(
                                            posts.lista[index].titulo!
                                                .toUpperCase(),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                              left: 8.0,
                                              right: 8.0),
                                          child: Text(
                                            posts.lista[index].subtitulo!,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            posts.lista[index].descricao!,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(); // Retorna um widget vazio como separador para os itens que não atendem ao critério de pesquisa.
                            }
                          },
                        ),
                ),
        ],
      );
    });
  }
}
