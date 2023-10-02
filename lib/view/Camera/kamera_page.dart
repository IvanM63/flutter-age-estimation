import 'package:flutter/material.dart';
import 'dart:async';
import 'package:age_recog_pkl/view/Camera/face_detector_view.dart';

class KameraPage extends StatefulWidget {
  const KameraPage({super.key});

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  LabelLokasi? labelLokasi;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final TextEditingController lokasiController = TextEditingController();

    String? lokasisekarang;

    if (labelLokasi != null) {
      lokasisekarang = labelLokasi?.label;
    } else {
      lokasisekarang = '...';
    }

    final List<DropdownMenuEntry<LabelLokasi>> lokasis =
        <DropdownMenuEntry<LabelLokasi>>[];
    for (final LabelLokasi lokasi in LabelLokasi.values) {
      lokasis.add(
        DropdownMenuEntry<LabelLokasi>(value: lokasi, label: lokasi.label),
      );
    }

    Future<void> massage(BuildContext context) async {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Dialog(
          child: Container(
            width: 300,
            color: const Color.fromARGB(255, 237, 2, 38),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: const Text(
                  "Masukkan Lokasi",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: DropdownMenu<LabelLokasi>(
                  width: 300,
                  controller: lokasiController,
                  hintText: lokasisekarang,
                  dropdownMenuEntries: lokasis,
                  onSelected: (LabelLokasi? lokasi) {
                    setState(() {
                      labelLokasi = lokasi;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ]),
          ),
        ),
      );
    }

    // @override
    // void initState() {
    //   // TODO: implement initState
    //   massage(context);
    //   debugPrint('tes');
    //   super.initState();
    // }

    showDialogIfFirstLoaded(BuildContext context) async {
      debugPrint('tes');
      if (firstTime == true) {
        setState(() {
          massage(context);
          firstTime = false;
        });
      } else {}
    }

    Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));

    // return FaceDetectorView();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Kamera",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                massage(context);
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 40,
              ))
        ],
        backgroundColor: const Color.fromARGB(255, 237, 2, 38),
        shadowColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 50,
      ),
      body: Center(
        child: Column(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height * 2 / 3,
            //   child: FaceDetectorView(),
            // ),
          ],
        ),
      ),
    );
  }
}

enum LabelLokasi {
  pahlawan("Plasa Pahlawan", "Telkomsel Pahlawan"),
  tantular("Plasa Tantular", "Telkomsel Tantular");

  const LabelLokasi(this.label, this.lokasi);
  final String label;
  final String lokasi;
}
