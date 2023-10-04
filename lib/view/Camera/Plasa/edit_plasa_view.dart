import 'dart:io';

import 'package:age_recog_pkl/models/plasa.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../../../controller/plasa_controller.dart';
import '../Add Plasa/button.dart';
import '../Add Plasa/input_field.dart';

class EditPlasa extends StatefulWidget {
  const EditPlasa({super.key, required this.index, plasaController})
      : _plasaController = plasaController;

  final int index;
  final PlasaController _plasaController;

  @override
  State<EditPlasa> createState() => _EditPlasaState();
}

class _EditPlasaState extends State<EditPlasa> {
  //Plasa Controller
  final PlasaController _plasaController = Get.put(PlasaController());
  //Text Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _nameController.text = _plasaController.plasaList[widget.index].name!;
      _jalanController.text = _plasaController.plasaList[widget.index].jalan!;
      _kecamatanController.text =
          _plasaController.plasaList[widget.index].kecamatan!;
      _kotaController.text = _plasaController.plasaList[widget.index].kota!;
      _selectedImage = File(_plasaController.plasaList[widget.index].image!);
    });
    print(_plasaController.plasaList[widget.index].id!);
    super.initState();
  }

  //Image File
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit Plasa",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                //Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Material(
                    child: InkWell(
                      highlightColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      splashColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: Ink(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!)
                                : Image.file(
                                    File(_plasaController
                                        .plasaList[widget.index].image!),
                                    fit: BoxFit.fill,
                                  )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MyInputField(
                  hint: 'Nama Plasa',
                  title: 'Name',
                  icon: Icons.title,
                  controller: _nameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyInputField(
                  hint: 'Enter Jalan',
                  title: 'Jalan',
                  icon: Icons.home,
                  controller: _jalanController,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MyInputField(
                        hint: 'Enter Kecamatan',
                        title: 'Kecamatan',
                        icon: Icons.home_mini,
                        controller: _kecamatanController,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MyInputField(
                        hint: 'Enter Kota',
                        title: 'Kota',
                        icon: Icons.location_city,
                        controller: _kotaController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: MyButton(
                            label: "Delete Plasa",
                            onPressed: () {
                              _dialogBuilder(context);
                            },
                            icon: Icons.delete,
                            color: Colors.pinkAccent)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MyButton(
                        label: "Edit Plasa",
                        icon: Icons.edit,
                        onPressed: _validateForm,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
      //print(_selectedImage!.path);
    });
  }

  _updatePlasaToDb() async {
    File tmpFile = File(_selectedImage!.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName =
        Path.basename(tmpFile.path); // Filename without extension
    final String fileExtension = Path.extension(_selectedImage!.path);
    tmpFile = await tmpFile.copy('$path/$fileName$fileExtension');

    Plasa plasa = Plasa(
        id: _plasaController.plasaList[widget.index].id,
        name: _nameController.text,
        jalan: _jalanController.text,
        kecamatan: _kecamatanController.text,
        kota: _kotaController.text,
        pengunjung: _plasaController.plasaList[widget.index].pengunjung,
        image: tmpFile.path);
    var value = await _plasaController.updatePlasa(plasa: plasa);
    setState(() {});
    //print("MY ID IS: " + "$value");
  }

  _validateForm() async {
    if (_nameController.text.isNotEmpty &&
        _jalanController.text.isNotEmpty &&
        _kecamatanController.text.isNotEmpty &&
        _kotaController.text.isNotEmpty &&
        _selectedImage != null) {
      //add data to database
      _updatePlasaToDb();
      //refresh task list
      await _plasaController.getAllPlasa();
      //Navigate back to home page
      Navigator.of(context).pop();
      setState(() {});
    } else {
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text("Anda yakin ingin menghapus plasa ini?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ya'),
              onPressed: () {
                _plasaController
                    .delete(_plasaController.plasaList[widget.index]);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
