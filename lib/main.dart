import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutterwebscrapping/pantalla_populares.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePrincipal(),
    );
  }
}

class MyHomePrincipal extends StatefulWidget {
  MyHomePrincipal({super.key});

  @override
  State<MyHomePrincipal> createState() => _MyHomePrincipalState();
}

class _MyHomePrincipalState extends State<MyHomePrincipal> {
  List<Map<String, dynamic>> listaCriptmonedas = [];
  List listaPopulares = [];
  List listIconsCripto = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          title: Icon(
            Icons.api_sharp,
            size: 45,
          ),
          expandedHeight: 150,
          flexibleSpace: Container(
            child: FlexibleSpaceBar(
              title: ListTile(
                title: Text(
                  "Web Scrapping",
                  textAlign: TextAlign.center,
                ),
                subtitle: Text("criptomonedas", textAlign: TextAlign.center),
              ),
              titlePadding: EdgeInsets.only(),
            ),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(
                        color: Color.fromARGB(255, 166, 92, 255), width: 2)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 113, 4, 208),
                      Color.fromARGB(255, 94, 4, 143)
                    ])),
          ),
        ),
        FutureBuilder(
          future: webScrapping(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: 1, (context, index) => Container()));
            } else {
              var aux = generarIcons(snapshot.data);
              var auxList = aux.sublist(0, 4);
              return SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [...auxList],
                    ),
                  );
                },
              );
            }
          },
        ),
        SliverAppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Mas Populares : ",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Baja",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Sube",
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder(
          future: webScrappingPopulares(),
          builder: (context, snapshot) {
            print("estamos en future buidler de populares");
            if (!snapshot.hasData) {
              return SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Container(),
              );
            } else {
              var filas = generarFilasDePopulares(snapshot.data);
              return SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  print("dentro de silver list  , llamda");
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaPopulares(
                            listaCriptomonedas: listaPopulares,
                          ),
                        )),
                    child: Table(
                      columnWidths: {
                        0: FixedColumnWidth(64),
                        1: FlexColumnWidth(),
                        2: FixedColumnWidth(84),
                        3: FixedColumnWidth(84),
                      },
                      children: [
                        TableRow(children: [
                          Text(''),
                          Text(
                            "nombre",
                            style: TextStyle(color: Colors.white38),
                          ),
                          Text(
                            "precio",
                            style: TextStyle(color: Colors.white38),
                          ),
                          Text(
                            "1h%",
                            style: TextStyle(color: Colors.white38),
                          )
                        ]),
                        ...filas
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
        SliverAppBar(
          title: Text("Criptomonedas :"),
        ),
        FutureBuilder(
          future: webScrapping(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SliverList.list(children: [
                Container(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.amber, size: 20),
                ),
              ]);
            } else {
              var auxK = generarFilasDePopulares(snapshot.data);
              return SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Table(
                    columnWidths: {
                      0: FixedColumnWidth(64),
                      1: FlexColumnWidth(),
                      2: FixedColumnWidth(84),
                      3: FixedColumnWidth(84),
                    },
                    children: [...auxK],
                  );
                },
              );
            }
          },
        )
      ],
    )));
  }

  List generarFilasDePopulares(list) {
    var listAux = [];
    try {
      list.forEach((element) {
        listAux.add(TableRow(children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 30,
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.network(
              element['urlIcon'],
              errorBuilder: (context, error, stackTrace) => Icon(Icons.abc),
            ),
          ),
          Container(
              padding: EdgeInsets.all(5),
              child: Text(
                element['nameIcon'],
              )),
          Container(
              padding: EdgeInsets.all(5),
              child: Text(element['valor'].toString())),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              element['1h%'],
              style: TextStyle(
                  color: element['estado'].toString().contains('up')
                      ? Colors.green
                      : Colors.red),
            ),
          ),
        ]));
      });
      return listAux;
    } catch (e) {
      print(e);
      return [];
    }
  }

  List generarIcons(list) {
    var listaIcons = [];

    list.forEach((element) {
      listaIcons.add(Container(
          height: 40,
          padding: EdgeInsets.all(5),
          child: Image.network(
            element['urlIcon'],
            errorBuilder: (context, error, stackTrace) {
              return SliverAppBar();
            },
          )));
    });
    return listaIcons;
  }

  webScrapping() async {
    try {
      var url = 'https://coinmarketcap.com/es/';
      var response = await Chaleno().load(url);
      var aux = response?.querySelectorAll('tbody > tr[style]');
      aux?.forEach(
        (element) {
          listIconsCripto.add(element.querySelector('img')?.src);
          listaCriptmonedas.add({
            'urlIcon': element.querySelector('img')?.src,
            'nameIcon':
                element.querySelector('div > div > p.sc-4984dd93-0')?.text,
            'valor': element.querySelector('div.sc-9d064f2d-0 > span')?.text,
            '1h%': element.querySelector('span.sc-6a54057-0')?.text,
            'estado': element.querySelector('span.sc-6a54057-0 > span')?.classe
          });
        },
      );

      List auxLista = listaCriptmonedas.sublist(0, 10);

      return auxLista;
    } catch (e) {
      print(" error en web scrapping : ${e}");
    }
  }

  webScrappingPopulares() async {
    try {
      var url = 'https://coinmarketcap.com/es/trending-cryptocurrencies/';
      var response = await Chaleno().load(url);
      var aux = response?.querySelectorAll('tbody > tr[style]');
      aux?.forEach(
        (element) {
          listaPopulares.add({
            'urlIcon': element.querySelector('img')?.src,
            'nameIcon':
                element.querySelector('div > div > p.sc-4984dd93-0')?.text,
            'valor': element.querySelectorAll('span')?[1].text,
            '1h%': element.querySelector('span.sc-6a54057-0')?.text,
            'estado': element.querySelector('span.sc-6a54057-0 > span')?.classe
          });
        },
      );
      List auxLista = listaPopulares.sublist(0, 3);
      return auxLista;
    } catch (e) {
      print(" error en web populares : ${e}");
    }
  }
}
