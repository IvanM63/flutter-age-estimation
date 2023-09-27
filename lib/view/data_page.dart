import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:firebase_database/firebase_database.dart';

List<Map<String, dynamic>> tess = [
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
  {
    'tanggal': DateTime.now().toString(),
    'lokasi': 'Plasa Pahlawan',
    'umur': '34'
  },
];

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(DateFormat.EEEE().format(DateTime.parse(tess[1]['tanggal'])));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Data",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 237, 2, 38),
        shadowColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 50,
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 0,
            rightHandSideColumnWidth: MediaQuery.of(context).size.width,
            isFixedHeader: true,
            itemCount: tess.length,
            rowSeparatorWidget: const Divider(
              color: Colors.black54,
              height: 1.0,
              thickness: 0.0,
            ),
            headerWidgets: [
              const Text('Bambang'),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 56,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 56,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Jam',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4 + 12,
                height: 56,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Lokasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4 + 12,
                height: 56,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Usia',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            leftSideItemBuilder: _dummy,
          ),
        ),
      ),
    );
  }
}

Widget _dummy(BuildContext context, int index) {
  return Container(
    width: 0,
  );
}

Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  return Row(
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(tess[index]['tanggal'].substring(0, 10)),
      ),
      Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(tess[index]['tanggal'].substring(11, 19)),
      ),
      Container(
        width: MediaQuery.of(context).size.width / 4 + 12,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(tess[index]['lokasi']),
      ),
      Container(
        width: MediaQuery.of(context).size.width / 4 - 12,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(tess[index]['umur']),
      ),
    ],
  );
}
