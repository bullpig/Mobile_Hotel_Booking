class Voucher {
  String id;
  String name;
  String description;
  String imageUrl;
  DateTime startTime;
  DateTime endTime;
  bool isForAll;
  VoucherType type;
  int discountValue;
  int? maxDiscount;

  Voucher({
    this.id = "",
    this.name = "",
    this.description = "",
    this.imageUrl = "",
    DateTime? startTime,
    DateTime? endTime,
    this.type = VoucherType.percent,
    this.discountValue = 0,
    this.maxDiscount,
    this.isForAll = false,
  })  : this.startTime = startTime ?? DateTime(0),
        this.endTime = endTime ?? DateTime(0);
}

enum VoucherType {
  percent,
  fixed,
}