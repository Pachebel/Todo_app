import 'dart:convert';

// posteriormente o usuário poderá "salvar" uma lista recorrente
// e poderá dar um nome para ela, tipo "compras do mês"
// essa lista ficará salva na API e poderá ser acessada por ele

// mas por enquanto ficaremos somente com o armazenamento local, sem id

class GroceryListModel {
  final String name;
  bool isChecked;

  GroceryListModel({
    required this.name,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'isChecked': isChecked,
    };
  }

  factory GroceryListModel.fromMap(Map<String, dynamic> map) {
    return GroceryListModel(
      name: map['name'] as String,
      isChecked: map['isChecked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroceryListModel.fromJson(String source) =>
      GroceryListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
