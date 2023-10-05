import 'dart:io';

import 'package:age_recog_pkl/controller/plasa_controller.dart';
import 'package:age_recog_pkl/view/Camera/Plasa/plasa_detail_view.dart';
import 'package:flutter/material.dart';

class PlasaCard extends StatelessWidget {
  const PlasaCard(
      {super.key,
      required PlasaController plasaController,
      required this.index})
      : _plasaController = plasaController;
  final int index;
  final PlasaController _plasaController;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PlasaDetail(index: index, plasaController: _plasaController),
            ),
          );
        },
        child: Ink(
          height: 151,
          //margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 1,
                    offset: const Offset(0, 1))
              ]),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      image: DecorationImage(
                          image: FileImage(
                              File(_plasaController.plasaList[index].image!)),
                          fit: BoxFit.fill)),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _plasaController.plasaList[index].name!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${_plasaController.plasaList[index].jalan!}, ${_plasaController.plasaList[index].kecamatan!}, ${_plasaController.plasaList[index].kota!}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            _plasaController.plasaList[index].pengunjung!,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
