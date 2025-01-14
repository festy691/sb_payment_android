class AmountBreakdownModel {
  num total;
  num subtotal;
  num taxAndLevy;
  List<TaxBreak> taxBreak;

  AmountBreakdownModel(
      {required this.total,
      required this.subtotal,
      required this.taxAndLevy,
      required this.taxBreak});

  factory AmountBreakdownModel.fromJson(Map<String, dynamic> data) {
    return AmountBreakdownModel(
      total: data["total"] ?? 0,
      subtotal: data["subtotal"] ?? 0,
      taxAndLevy: data["totalRate"] ?? 0,
      taxBreak: data["taxes"] == null
          ? []
          : (data["taxes"] as List).map((br) => TaxBreak.fromJson(br)).toList(),
    );
  }
}

class TaxBreak {
  String name;
  num amount;
  num rate;

  TaxBreak({required this.name, required this.amount, required this.rate});

  factory TaxBreak.fromJson(Map<String, dynamic> data) {
    String key = data.keys.first != 'rate' ? data.keys.first : data.keys.last;
    return TaxBreak(name: key, amount: data[key] ?? 0, rate: data['rate']);
  }
}
