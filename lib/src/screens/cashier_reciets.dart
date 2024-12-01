import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart'; // Import for PdfPageFormat
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const ReceiptScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Preview'),
        backgroundColor: Colors.deepOrange,
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        pdfFileName: 'receipt_${order['item']}.pdf',
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Receipt',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            pw.Text('Item: ${order['item']}'),
            pw.Text('Notes: ${order['notes']}'),
            pw.Text('Status: ${order['status']}'),
            pw.Text('Price: \$${order['price']?.toStringAsFixed(2) ?? 'N/A'}'),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}
