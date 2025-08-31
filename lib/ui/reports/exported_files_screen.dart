import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';

class ExportedFilesScreen extends StatefulWidget {
  const ExportedFilesScreen({super.key});

  @override
  State<ExportedFilesScreen> createState() => _ExportedFilesScreenState();
}

class _ExportedFilesScreenState extends State<ExportedFilesScreen> {
  List<FileSystemEntity> _exportedFiles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExportedFiles();
  }

  Future<void> _loadExportedFiles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final tempDir = await getTemporaryDirectory();
      final dir = Directory('${tempDir.path}/exports');

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final files = await dir.list().toList();
      final filteredFiles = files.where((file) {
        final extension = file.path.split('.').last.toLowerCase();
        return extension == 'pdf' || extension == 'csv';
      }).toList();

      // Sort files by modification time (newest first)
      filteredFiles.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      setState(() {
        _exportedFiles = filteredFiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load files: $e';
        _isLoading = false;
      });
    }
  }

  String _getFileIcon(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return '📄';
      case 'csv':
        return '📊';
      default:
        return '📁';
    }
  }

  String _getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return extension.toUpperCase();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openFile(File file) async {
    try {
      final extension = file.path.split('.').last.toLowerCase();

      if (extension == 'pdf') {
        await _openPdfFile(file);
      } else if (extension == 'csv') {
        await _openCsvFile(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _openPdfFile(File file) async {
    final bytes = await file.readAsBytes();

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(file.path.split('/').last),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            body: PdfPreview(
              build: (format) => bytes,
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              canChangeOrientation: false,
              maxPageWidth: 700,
              actions: [
                PdfPreviewAction(
                  icon: const Icon(Icons.print),
                  onPressed: (context, pdf, action) {
                    Printing.layoutPdf(onLayout: (format) async => bytes);
                  },
                ),
                PdfPreviewAction(
                  icon: const Icon(Icons.share),
                  onPressed: (context, pdf, action) async {
                    await Share.shareXFiles([
                      XFile(file.path),
                    ], text: 'Financial Report PDF');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _openCsvFile(File file) async {
    try {
      final content = await file.readAsString();
      final csvTable = const CsvToListConverter().convert(content);

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(file.path.split('/').last),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: csvTable.isNotEmpty
                        ? csvTable.first
                              .map(
                                (cell) => DataColumn(
                                  label: Text(
                                    cell?.toString() ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                        : [],
                    rows: csvTable
                        .skip(1)
                        .map(
                          (row) => DataRow(
                            cells: row
                                .map(
                                  (cell) =>
                                      DataCell(Text(cell?.toString() ?? '')),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to parse CSV: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _shareFile(File file) async {
    try {
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Financial Report: ${file.path.split('/').last}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      await _loadExportedFiles(); // Refresh the list

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File deleted successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exported Files'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: _loadExportedFiles,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadExportedFiles,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _exportedFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Exported Files',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Export reports from the Reports screen to see them here',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _exportedFiles.length,
              itemBuilder: (context, index) {
                final file = _exportedFiles[index];
                final fileName = file.path.split('/').last;
                final fileStat = file.statSync();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      _getFileIcon(file.path),
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(
                      fileName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getFileType(file.path)} • ${_formatFileSize(fileStat.size)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Exported: ${_formatDate(fileStat.modified)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'open':
                            await _openFile(File(file.path));
                            break;
                          case 'share':
                            await _shareFile(File(file.path));
                            break;
                          case 'delete':
                            await _deleteFile(File(file.path));
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new),
                              SizedBox(width: 8),
                              Text('Open'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _openFile(File(file.path)),
                  ),
                );
              },
            ),
    );
  }
}
