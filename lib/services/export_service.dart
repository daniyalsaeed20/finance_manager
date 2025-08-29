// export_service.dart
// CSV and PDF export generation

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ExportService {
  ExportService._();
  static final ExportService instance = ExportService._();

  Future<File> exportCsv(String filename, List<List<dynamic>> rows) async {
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    return file.writeAsString(csv);
  }

  Future<File> exportPdf(String filename, String title, List<List<String>> table) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(data: table),
        ],
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}

