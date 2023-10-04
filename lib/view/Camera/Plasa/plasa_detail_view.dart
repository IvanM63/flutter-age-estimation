import 'dart:async';
import 'dart:io';

import 'package:age_recog_pkl/models/visitor.model.dart';
import 'package:age_recog_pkl/view/Camera/Plasa/edit_plasa_view.dart';
import 'package:age_recog_pkl/view/Camera/face_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

import '../../../controller/plasa_controller.dart';
import '../../../controller/visitor_controller.dart';
import '../Add Plasa/button.dart';
import '../plasa_card.dart';

class PlasaDetail extends StatefulWidget {
  const PlasaDetail({super.key, required this.index, plasaController})
      : _plasaController = plasaController;

  final int index;
  final PlasaController _plasaController;

  @override
  State<PlasaDetail> createState() => _PlasaDetailState();
}

class _PlasaDetailState extends State<PlasaDetail> {
  //list of visitor
  List<Visitor> _visitorList = [];

  //Visitor Controller
  final VisitorController _visitorController = Get.put(VisitorController());

  //Quick info two dimensional array
  List<List<dynamic>> _quickInfo = [
    ["0-14yo", "0", Icons.people],
    ["15-40yo", "0", Icons.people],
    ["41-60yo", "0", Icons.people],
    ["61-100yo", "0", Icons.people],
    ["Male", "0", Icons.male],
    ["Female", "0", Icons.female],
  ];

  Future<void> calculateQuickInfo() async {
    await _getAllVisitors();
    _getQuickInfoStats();
  }

  _getAllVisitors() async {
    _visitorList = await _visitorController.getVisitorByPlasaId(
        widget._plasaController.plasaList[widget.index].id!);

    // Update _pengunjung using the StreamController
    String newValue =
        widget._plasaController.plasaList[widget.index].pengunjung!;
    _pengunjungController.sink.add(newValue);
    //print("CALLED");
    //print(await _visitorController.visitorList[1].toJson());

    //
  }

  _getQuickInfoStats() {
    //Reset to zero
    _quickInfo = [
      ["0-14yo", "0", Icons.people],
      ["15-40yo", "0", Icons.people],
      ["41-60yo", "0", Icons.people],
      ["61-100yo", "0", Icons.people],
      ["Male", "0", Icons.male],
      ["Female", "0", Icons.female]
    ]; //visitor list loop
    for (var i = 0; i < _visitorList.length; i++) {
      if (_visitorList[i].ageRange == "0-14yo") {
        _quickInfo[0][1] = (int.parse(_quickInfo[0][1]) + 1).toString();
      } else if (_visitorList[i].ageRange == "15-40yo") {
        _quickInfo[1][1] = (int.parse(_quickInfo[1][1]) + 1).toString();
      } else if (_visitorList[i].ageRange == "41-60yo") {
        _quickInfo[2][1] = (int.parse(_quickInfo[2][1]) + 1).toString();
      } else if (_visitorList[i].ageRange == "61-100yo") {
        _quickInfo[3][1] = (int.parse(_quickInfo[3][1]) + 1).toString();
      } else if (_visitorList[i].gender == "Male") {
        _quickInfo[4][1] = (int.parse(_quickInfo[4][1]) + 1).toString();
      } else if (_visitorList[i].gender == "Female") {
        _quickInfo[5][1] = (int.parse(_quickInfo[5][1]) + 1).toString();
      }
      // print("Gender: ${_visitorList[i].gender}");
    }
  }

  // Create a StreamController to manage _pengunjung updates
  final StreamController<String> _pengunjungController =
      StreamController<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getAllVisitors();
    //_getQuickInfoStats();
  }

  @override
  void dispose() {
    super.dispose();
    // Close the StreamController when the widget is disposed
    _pengunjungController.close();
  }

  @override
  Widget build(BuildContext context) {
    //print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    //print(widget._plasaController.plasaList[widget.index].pengunjung!);
    // print(_quickInfo);
    return Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          //Image
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image(
              image: FileImage(
                  File(widget._plasaController.plasaList[widget.index].image!)),
              fit: BoxFit.cover,
            ),
          ),
          //Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget._plasaController.plasaList[widget.index].name!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          //Address
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${widget._plasaController.plasaList[widget.index].jalan!}, ${widget._plasaController.plasaList[widget.index].kecamatan!}, ${widget._plasaController.plasaList[widget.index].kota!}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          //Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: MyButton(
                  label: "Edit",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPlasa(
                            index: widget.index,
                            plasaController: widget._plasaController),
                      ),
                    );
                  },
                  icon: Icons.edit,
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyButton(
                      label: "Ambil Gambar",
                      icon: Icons.camera,
                      onPressed: () {
                        //navigate to camera
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FaceDetectorView(
                            index: widget.index,
                            plasaController: widget._plasaController,
                          );
                        })).then((_) => setState(() {}));
                      }),
                ),
              ],
            ),
          ),
          //Quick info
          FutureBuilder<void>(
              future: calculateQuickInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: Map.fromIterable(_quickInfo, key: (e) => e[0])
                            .values
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            e[2],
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            e[0],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        e[1],
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          //Daftar Pengunjung
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daftar Pengunjung",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                StreamBuilder<String>(
                    stream: _pengunjungController.stream,
                    initialData: widget
                        ._plasaController.plasaList[widget.index].pengunjung,
                    builder: (context, snapshot) {
                      String pengunjung = snapshot.data ?? '';
                      return Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.black,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            pengunjung,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      );
                    }),
                Text(
                  "Lihat Semua",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ),

          FutureBuilder(
            future: _getAllVisitors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return DataTable(
                  dataTextStyle: TextStyle(fontSize: 10, color: Colors.black),
                  headingTextStyle:
                      TextStyle(fontSize: 12, color: Colors.black),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Tanggal',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Accuracy',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Age',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Gender',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: Map.fromIterable(_visitorList)
                      .values
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e.date!)),
                            DataCell(
                                Text(double.parse(e.acc!).toStringAsFixed(7))),
                            DataCell(Text(e.ageRange!)),
                            DataCell(
                              Text(e.gender!),
                            )
                          ]))
                      .toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ])));
  }
}

class _appBar extends StatefulWidget implements PreferredSizeWidget {
  const _appBar({
    super.key,
  });

  @override
  State<_appBar> createState() => _appBarState();

  //implementing preferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _appBarState extends State<_appBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        //backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            )));
  }
}
