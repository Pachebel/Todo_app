import 'package:get/get.dart';
import 'package:economizze/app/modules/home/list/list_controller.dart';

class ListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListController>(() => ListController());
  }
}
