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
    final exportsDir = Directory('${dir.path}/exports');
    
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }
    
    final file = File('${exportsDir.path}/$filename');
    return file.writeAsString(csv);
  }

  Future<File> exportPdf(
    String filename,
    String title,
    List<List<String>> table,
    Map<String, dynamic>? additionalData,
  ) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Financial Report',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColors.blue700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Generated on ${DateTime.now().toString().split('.')[0]}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          
          // Summary Section
          if (additionalData != null) ...[
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Financial Summary',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Total Income: ${additionalData['totalIncome'] ?? 'N/A'}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Total Expenses: ${additionalData['totalExpenses'] ?? 'N/A'}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Net Profit: ${additionalData['netProfit'] ?? 'N/A'}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'After Tax: ${additionalData['afterTax'] ?? 'N/A'}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ],
          
          // Goals Section
          if (additionalData != null && additionalData['goals'] != null) ...[
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Financial Goals',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  ...(additionalData['goals'] as List).map((goal) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: 8,
                          height: 8,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.green600,
                            shape: pw.BoxShape.circle,
                          ),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Expanded(
                          child: pw.Text(
                            '${goal['name']}: ${goal['targetAmount']} (${goal['progress']}% complete)',
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ],
          
          // Data Table
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Transaction Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.TableHelper.fromTextArray(
                  data: table,
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.blue600),
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  cellPadding: const pw.EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    final dir = await getTemporaryDirectory();
    final exportsDir = Directory('${dir.path}/exports');
    
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }
    
    final file = File('${exportsDir.path}/$filename');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
