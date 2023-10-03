import 'package:age_recog_pkl/models/plasa.model.dart';
import 'package:age_recog_pkl/view/Camera/Add%20Plasa/add_plasa_view.dart';
import 'package:age_recog_pkl/view/Camera/plasa_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/plasa_controller.dart';

class CameraHome extends StatefulWidget {
  const CameraHome({super.key});

  @override
  State<CameraHome> createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  //Plasa Controller
  final PlasaController _plasaController = Get.put(PlasaController());

  List<Plasa> _foundPlasa = [];

  @override
  void initState() {
    // TODO: implement initState
    _foundPlasa = _plasaController.plasaList;
    super.initState();
  }

  void _runFilter(String keyword) {
    List<Plasa> results = [];
    if (keyword.isEmpty) {
      results = _plasaController.plasaList;
    } else {
      results = _plasaController.plasaList
          .where((plasa) =>
              plasa.name!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundPlasa = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    _plasaController.getAllPlasa();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 2, 38),
        key: GlobalKey(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //navigate to add plasa
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddPlasa();
            }));
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 246, 247),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 2, 38),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 1,
                            offset: const Offset(0, 1))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                    child: TextField(
                      onChanged: (value) {
                        _runFilter(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.focused)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                        hintText: "Cari Plasa",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: const Text(
                    "Daftar Plasa Telkomsel",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _foundPlasa.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: PlasaCard(
                              index: index,
                              plasaController: _plasaController,
                            ));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
