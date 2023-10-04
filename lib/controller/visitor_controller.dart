import 'package:age_recog_pkl/db/database_helper.dart';
import 'package:age_recog_pkl/models/visitor.model.dart';
import 'package:get/get.dart';

class VisitorController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getAllVisitor();
  }

  var visitorList = <Visitor>[].obs;

  //Get all data from table
  getAllVisitor() async {
    //print("get all plasa function terpanggil");
    List<Map<String, dynamic>> _visitorList = await DBHelper.queryVisitor();
    //print(_visitorList);
    visitorList
        .assignAll(_visitorList.map((data) => Visitor.fromJson(data)).toList());
  }

  Future<List<Visitor>> getVisitorByPlasaId(int id) async {
    List<Map<String, dynamic>> _visitorList =
        await DBHelper.queryVisitorByPlasaId(id);
    return _visitorList.map((data) => Visitor.fromJson(data)).toList();
  }

  Future<int> addVisitor({Visitor? visitor}) async {
    return await DBHelper.insertVisitor(visitor);
  }

  delete(Visitor visitor) {
    //DBHelper.delete(visitor);
  }

  void completePlasa(int id) async {
    await DBHelper.update(id);
  }
}
