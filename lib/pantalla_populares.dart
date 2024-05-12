import 'package:flutter/material.dart';

class PantallaPopulares extends StatefulWidget {
  var listaCriptomonedas;
  PantallaPopulares({super.key, required this.listaCriptomonedas});

  @override
  State<PantallaPopulares> createState() => _PantallaPopularesState();
}

class _PantallaPopularesState extends State<PantallaPopulares> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Populares",
            style: TextStyle(letterSpacing: 3),
          ),
          backgroundColor: Color.fromARGB(255, 156, 3, 207),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {
                  0: FixedColumnWidth(64),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(84),
                  3: FixedColumnWidth(84),
                },
                children: [
                  TableRow(children: [
                    Text(""),
                    Text("Nombre"),
                    Text("Precio"),
                    Text("1h%"),
                  ]),
                  ...cargarCripto(widget.listaCriptomonedas)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  cargarCripto(list) {
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
      List auxFinal = listAux.sublist(0, 30);
      return auxFinal;
    } catch (e) {
      print(e);
      print("error en generarListaPopulares");
      return [];
    }
  }
}
