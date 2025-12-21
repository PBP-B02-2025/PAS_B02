import 'dart:convert';

ProductEntry productEntryFromJson(String str) => ProductEntry.fromJson(json.decode(str));

String productEntryToJson(ProductEntry data) => json.encode(data.toJson());

class ProductEntry {
    List<Voucher> vouchers;

    ProductEntry({
        required this.vouchers,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        vouchers: List<Voucher>.from(json["vouchers"].map((x) => Voucher.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
    };
}

class Voucher {
    String id;
    String kode;
    String deskripsi;
    String persentaseDiskon;
    bool isActive;

    Voucher({
        required this.id,
        required this.kode,
        required this.deskripsi,
        required this.persentaseDiskon,
        required this.isActive,
    });

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        kode: json["kode"],
        deskripsi: json["deskripsi"],
        persentaseDiskon: json["persentase_diskon"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "deskripsi": deskripsi,
        "persentase_diskon": persentaseDiskon,
        "is_active": isActive,
    };
}