import 'dart:math';

import 'package:age_recog_pkl/controller/plasa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../controller/visitor_controller.dart';
import '../../models/visitor.model.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Visitor> _visitorList = [];

  //Visitor Controller
  final VisitorController _visitorController = Get.put(VisitorController());
  final PlasaController _plasaController = Get.put(PlasaController());

  _getAllVisitors() async {
    await _visitorController.getAllVisitor();
    List<Visitor> _visitorListTemp = _visitorController.visitorList.toList();

    Map.fromIterable(_visitorListTemp).values.forEach((element) {
      _visitorList.add(element);
    });

    //print("CALLED");
    //print(await _visitorController.visitorList[1].toJson());

    //
  }

  @override
  Widget build(BuildContext context) {
    print(_visitorList);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Pengunjung Terakhir",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 237, 2, 38),
        shadowColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 50,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getAllVisitors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DataTable(
                dataTextStyle: TextStyle(fontSize: 10, color: Colors.black),
                headingTextStyle: TextStyle(fontSize: 12, color: Colors.black),
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
                        'Plasa',
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
                          DataCell(Text(_plasaController
                              .plasaList[e.plasa_id! - 1].name!)),
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
        ),
      ),
    );
  }
}
