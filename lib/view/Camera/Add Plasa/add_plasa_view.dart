import 'dart:io';

import 'package:age_recog_pkl/models/plasa.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../../../controller/plasa_controller.dart';
import 'button.dart';
import 'input_field.dart';

class AddPlasa extends StatefulWidget {
  const AddPlasa({super.key});

  @override
  State<AddPlasa> createState() => _AddPlasaState();
}

class _AddPlasaState extends State<AddPlasa> {
  //Plasa Controller
  final PlasaController _plasaController = Get.put(PlasaController());
  //Text Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();

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
                Text("Add New Plasa",
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
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Add Image",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.grey),
                                    )
                                  ],
                                ),
                        ),
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
                    MyButton(
                        label: "Create Plasa",
                        icon: Icons.add_task,
                        onPressed: _validateForm),
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

  _addTaskToDb() async {
    File tmpFile = File(_selectedImage!.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName =
        Path.basename(tmpFile.path); // Filename without extension
    final String fileExtension = Path.extension(_selectedImage!.path);
    tmpFile = await tmpFile.copy('$path/$fileName$fileExtension');

    var value = await _plasaController.addPlasa(
        plasa: Plasa(
            name: _nameController.text,
            jalan: _jalanController.text,
            kecamatan: _kecamatanController.text,
            kota: _kotaController.text,
            image: _selectedImage!.path));
    //print("MY ID IS: " + "$value");
  }

  _validateForm() async {
    if (_nameController.text.isNotEmpty &&
        _jalanController.text.isNotEmpty &&
        _kecamatanController.text.isNotEmpty &&
        _kotaController.text.isNotEmpty &&
        _selectedImage != null) {
      //add data to database
      _addTaskToDb();
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
