import 'package:sqlite_flutter_crud/settings/constants_db.dart';

class LlibreModel {
  final int? llibreId;
  final String llibreTitol;
  final String llibreSinopsi;
  final String createdAt;

  LlibreModel({
    this.llibreId,
    required this.llibreTitol,
    required this.llibreSinopsi,
    required this.createdAt,
  });

  factory LlibreModel.fromMap(Map<String, dynamic> json) => LlibreModel(
        llibreId: json[ConstantsDb.FIELD_LLIBRES_ID],
        llibreTitol: json[ConstantsDb.FIELD_LLIBRES_TITOL],
        llibreSinopsi: json[ConstantsDb.FIELD_LLIBRES_SINOPSI],
        createdAt: json[ConstantsDb.FIELD_LLIBRES_CREATED_AT],
      );

  Map<String, dynamic> toMap() => {
    ConstantsDb.FIELD_LLIBRES_ID: llibreId,
    ConstantsDb.FIELD_LLIBRES_TITOL: llibreTitol,
    ConstantsDb.FIELD_LLIBRES_SINOPSI: llibreSinopsi,
    ConstantsDb.FIELD_LLIBRES_CREATED_AT: createdAt,
      };
}
