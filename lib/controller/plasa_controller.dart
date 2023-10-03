import 'package:age_recog_pkl/db/database_helper.dart';
import 'package:age_recog_pkl/models/plasa.model.dart';
import 'package:get/get.dart';

class PlasaController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getAllPlasa();
  }

  var plasaList = <Plasa>[].obs;

  //Get all data from table
  getAllPlasa() async {
    //print("get all plasa function terpanggil");
    List<Map<String, dynamic>> _plasaList = await DBHelper.queryPlasa();
    //print(_plasaList);
    plasaList
        .assignAll(_plasaList.map((data) => Plasa.fromJson(data)).toList());
  }

  //Get Plasa by id
  getPlasaById(int id) async {
    Plasa plasa = await DBHelper.getPlasaById(id);
    return plasa;
  }

  Future<int> addPlasa({Plasa? plasa}) async {
    return await DBHelper.insertPlasa(plasa);
  }

  delete(Plasa plasa) {
    DBHelper.delete(plasa);
  }

  void updatePlasa(Plasa plasa) async {
    await DBHelper.updatePlasa(plasa);
  }

  void completePlasa(int id) async {
    await DBHelper.update(id);
  }
}
