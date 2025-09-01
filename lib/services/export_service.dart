// export_service.dart
// CSV and PDF export generation

import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';

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
    // Load logo bytes first
    final logoBytes = await _getLogoBytes();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Header with centered logo
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#0B0F13'), // Dark background from theme
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Centered Logo
                pw.Container(
                  width: 80,
                  height: 80,
                  child: pw.Image(
                    pw.MemoryImage(logoBytes),
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(height: 16),
                // Report title
                pw.Text(
                  'Financial Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#D6B25E'), // Gold from theme
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColor.fromHex('#E6E9ED'), // Light text from theme
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Generated on ${DateTime.now().toString().split('.')[0]}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColor.fromHex('#A7B0BA'), // Muted text from theme
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
                color: PdfColor.fromHex(
                  '#1A2128',
                ), // Surface container from theme
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(
                  color: PdfColor.fromHex('#4A5568'), // Outline from theme
                  width: 0.5,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Financial Summary',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#D6B25E'), // Gold from theme
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
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromHex(
                                  '#E6E9ED',
                                ), // Light text from theme
                              ),
                            ),
                            pw.Text(
                              'Total Expenses: ${additionalData['totalExpenses'] ?? 'N/A'}',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromHex(
                                  '#E6E9ED',
                                ), // Light text from theme
                              ),
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
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromHex(
                                  '#E6E9ED',
                                ), // Light text from theme
                              ),
                            ),
                            pw.Text(
                              'After Tax: ${additionalData['afterTax'] ?? 'N/A'}',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromHex(
                                  '#E6E9ED',
                                ), // Light text from theme
                              ),
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
                color: PdfColor.fromHex(
                  '#1A2128',
                ), // Surface container from theme
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(
                  color: PdfColor.fromHex('#4A5568'), // Outline from theme
                  width: 0.5,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Financial Goals',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#D6B25E'), // Gold from theme
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  ...(additionalData['goals'] as List).map(
                    (goal) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 8,
                            height: 8,
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex(
                                '#D6B25E',
                              ), // Gold from theme
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Expanded(
                            child: pw.Text(
                              '${goal['name']}: ${goal['targetAmount']} (${goal['progress']}% complete)',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromHex(
                                  '#E6E9ED',
                                ), // Light text from theme
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              color: PdfColor.fromHex(
                '#1A2128',
              ), // Surface container from theme
              border: pw.Border.all(
                color: PdfColor.fromHex('#4A5568'),
              ), // Outline from theme
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
                    color: PdfColor.fromHex('#D6B25E'), // Gold from theme
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.TableHelper.fromTextArray(
                  data: table,
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex(
                      '#0B0F13',
                    ), // Dark text on gold background
                  ),
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#D6B25E'),
                  ), // Gold header
                  border: pw.TableBorder.all(
                    color: PdfColor.fromHex('#4A5568'),
                  ), // Outline from theme
                  cellPadding: const pw.EdgeInsets.all(8),
                  cellStyle: pw.TextStyle(
                    color: PdfColor.fromHex('#E6E9ED'), // Light text from theme
                  ),
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

  /// Helper method to get logo bytes for PDF generation
  /// Uses dark logo for PDF as it's typically viewed on light backgrounds
  Future<Uint8List> _getLogoBytes() async {
    try {
      // Load the dark logo from assets for PDF generation
      // Dark logo works better on light PDF backgrounds
      final logoData = await rootBundle.load('assets/logo_dark.png');
      return logoData.buffer.asUint8List();
    } catch (e) {
      // Return empty bytes if logo loading fails
      return Uint8List(0);
    }
  }
}
