import 'package:economizze/shared/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import 'list_controller.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ListController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Lista de compras',
                  style: AppFonts.appBarTitle,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    _ShowAddItemBottomSheet(),
                  );
                },
                icon: const Icon(Icons.add),
              ),
              if (controller.groceryList.isNotEmpty)
                AnimationLimiter(
                  child: AnimationConfiguration.synchronized(
                    child: FadeInAnimation(
                      duration: const Duration(seconds: 2),
                      child: IconButton(
                        onPressed: () {
                          Get.dialog(
                            _ShowDeleteAllDialog(),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: controller.groceryList.isEmpty
            ? AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 500),
                child: FadeInAnimation(
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            'assets/svg/add_note.svg',
                            height: 300,
                            width: 300,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Parece que sua lista está vazia',
                            style: AppFonts.appBarTitle,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.bottomSheet(
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                _ShowAddItemBottomSheet(),
                              );
                            },
                            child: const Text('Deseja adicionar um item?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView(
                children: [
                  Obx(
                    () => AnimationLimiter(
                      child: AnimatedList(
                        key: controller.listKey,
                        initialItemCount: controller.groceryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Interval(
                                  0,
                                  1,
                                  curve: Curves.ease,
                                ),
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-0.2, 0),
                                end: Offset.zero,
                              ).animate(
                                animation.drive(
                                  CurveTween(curve: Curves.ease),
                                ),
                              ),
                              child: Obx(
                                () => Dismissible(
                                  key: Key(
                                      '${controller.groceryList[index].hashCode}'),
                                  movementDuration:
                                      const Duration(milliseconds: 500),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (direction) async {
                                    controller.deleteItem(
                                        controller.groceryList[index], index);
                                    Get.snackbar(
                                      snackStyle: SnackStyle.FLOATING,
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration:
                                          const Duration(milliseconds: 500),
                                      '',
                                      titleText: Text(
                                        'Item removido',
                                        style: AppFonts.listTileTitle,
                                      ),
                                      '${controller.deletedItem.value.name} foi removido da lista de compras',
                                      mainButton: TextButton(
                                        onPressed: () {
                                          controller.undoDeleteItem(index);
                                          Get.back();
                                        },
                                        child: const Text('Desfazer'),
                                      ),
                                    );
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      horizontalOffset: -50,
                                      child: FadeInAnimation(
                                        child: ListTile(
                                          leading: Checkbox(
                                            value: controller
                                                .groceryList[index].isChecked,
                                            onChanged: (bool? value) {
                                              controller.groceryList[index]
                                                  .isChecked = value!;
                                              controller.updateList();
                                            },
                                          ),
                                          onTap: () {
                                            controller.groceryList[index]
                                                    .isChecked =
                                                !controller.groceryList[index]
                                                    .isChecked;
                                            controller.updateList();
                                          },
                                          title: Text(
                                            controller.groceryList[index].name,
                                            style: AppFonts.listTileTitle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class _ShowAddItemBottomSheet extends StatelessWidget {
  final controller = Get.find<ListController>();
  _ShowAddItemBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: controller.textkey,
                  maxLength: 30,
                  controller: controller.textController,
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      Get.focusScope?.requestFocus();
                      return;
                    }
                    controller.getStorageListItem(
                      GroceryListModel(name: value, isChecked: false),
                    );
                    controller.textController.clear();
                    Get.focusScope?.requestFocus();
                  },
                  autofocus: true,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 254, 254, 254),
                      hintText: 'Adicionar um produto',
                      border: InputBorder.none),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (controller.textController.text.isEmpty) {
                    return;
                  }
                  controller.getStorageListItem(
                    GroceryListModel(
                        name: controller.textController.text, isChecked: false),
                  );
                  controller.textController.clear();
                  Get.back();
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowDeleteAllDialog extends StatelessWidget {
  final controller = Get.find<ListController>();
  _ShowDeleteAllDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remover todos os itens'),
      content: const Text('Deseja remover todos os itens da lista?'),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: () {
            controller.deleteAllItems();

            Get.back();
          },
          child: const Text('Remover'),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
