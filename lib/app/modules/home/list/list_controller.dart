import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:economizze/shared/models/todo_model.dart';

class ListController extends GetxController {
  ListController() {
    onInit();
  }

  var isLoading = false.obs;

  var deletedItem = GroceryListModel(name: '', isChecked: false).obs;

  final GlobalKey<FormState> textkey = GlobalKey();

  final TextEditingController textController = TextEditingController();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  RxList<GroceryListModel> groceryList = <GroceryListModel>[].obs;

  @override
  void onInit() async {
    isLoading.value = true;
    await Future.wait([
      shimmerTimer(),
      getStorageList(),
    ]);

    isLoading.value = false;
    super.onInit();
  }

  void getStorageListItem(GroceryListModel item) {
    if (groceryList.any(
        (element) => element.name.toLowerCase() == item.name.toLowerCase())) {
      Get.dialog(
        AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                addProductToList(item);
                Get.back();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Text('Adicionar novamente'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Text('Cancelar'),
            ),
          ],
          title: const Text('Produto duplicado'),
          content: const Text('Esse produto já foi adicionado a sua lista'),
        ),
      );
      return;
    } else {
      addProductToList(item);
    }
    // para inserir por cima da lista
    // groceryList.add(item);
    // para inserir por cima da lista
    // groceryList.length - 1,
    // startAnimation(
    //   item,
    // );
  }

  void addProductToList(GroceryListModel item) {
    groceryList.insert(0, item);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );
    updateList();
  }

  void deleteItem(GroceryListModel item, int index) {
    deletedItem.value = item;
    groceryList.remove(item);
    listKey.currentState?.removeItem(
        index, (context, animation) => const SizedBox(),
        duration: const Duration(milliseconds: 300));

    updateList();
  }

  Future<void> shimmerTimer() async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
  }

  Future getStorageList() async {
    final cache = GetStorage();
    final list = await cache.read('list');
    if (list != null) {
      groceryList.value = List<GroceryListModel>.from(
        list.map(
          (item) => GroceryListModel.fromJson(item),
        ),
      );
    }
    groceryList.refresh();
  }

  Future updateList() async {
    final cache = GetStorage();
    await cache.write('list', groceryList);

    groceryList.refresh();
  }

  undoDeleteItem(int index) {
    groceryList.insert(index, deletedItem.value);
    listKey.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 300),
    );
    updateList();
  }

  void deleteAllItems() {
    groceryList.clear();
    updateList();
  }
}
