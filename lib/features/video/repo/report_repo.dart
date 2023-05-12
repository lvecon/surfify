import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surfify/features/video/models/report_model.dart';

class ReportRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReport(ReportModel report) async {
    await _db.collection("report").add(report.toJson());
  }
}

final reportRepo = Provider((ref) => ReportRepository());
