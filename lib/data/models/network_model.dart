
import 'package:ditonton/domain/entities/network.dart';
import 'package:equatable/equatable.dart';

class NetworkModel extends Equatable {
    NetworkModel({
        required this.name,
        required this.id,
        required this.logoPath,
        required this.originCountry,
    });

    final String name;
    final int id;
    final String logoPath;
    final String originCountry;

    factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        name: json["name"],
        id: json["id"],
        logoPath: json["logo_path"] == null ? null : json["logo_path"],
        originCountry: json["origin_country"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "logo_path": logoPath == null ? null : logoPath,
        "origin_country": originCountry,
    };
    Network toEntity() {
     return Network(
        name: this.name,
        id: this.id,
        logoPath: this.logoPath,
        originCountry: this.originCountry,
     );
    }

    @override
    List<Object?> get props => [
        name,
        id,
        logoPath,
        originCountry,
     ];
}