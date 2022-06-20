import 'dart:developer';
import '../index.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

Future<Uint8List> generatePdfInventory(
    PdfPageFormat pageFormat, List<Product> products) async {
  print("-------------------");
  print(products.length);
  log(products.length.toString());
  final protocoll = pdfApi(
    products: products,
    companyName: company.name,
    companyAddress: company.adress,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await protocoll.buildPdf(pageFormat);
}

class pdfApi {
  String companyName;
  String companyAddress;
  List<Product> products;
  final PdfColor baseColor;
  final PdfColor accentColor;

  pdfApi({
    this.companyName,
    this.companyAddress,
    this.products,
    this.baseColor,
    this.accentColor,
  });

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  String _bgShape;
  String _qrCode = "test";
  DateTime date;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    _generateSignaturPDF();
    final pw.Document doc = pw.Document();

    _bgShape = await rootBundle.loadString('assets/img/blue-footer.svg');
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    // Build and return the final Pdf file data
    return doc.save();
  }

  _generateSignaturPDF() async {
    date = DateTime.now();

    _qrCode = await docPDFProvider.addPDF(
        docPDF: DocPDF(
            name: "document_${date}",
            category: products[0]?.category,
            date: date.toString(),
            quantity: products.length.toString(),
            companyName: company.name));
  }

  _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    if (prefs.getBool("Footer") ?? true) {
      return pw.PageTheme(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          base: base,
          bold: bold,
          italic: italic,
        ),
        buildBackground: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.SvgImage(svg: _bgShape),
        ),
      );
    } else {
      return pw.PageTheme(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          base: base,
          bold: bold,
          italic: italic,
        ),
      );
    }
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  if (prefs.getBool("Titel") ?? true) ...[
                    pw.Container(
                      height: 50,
                      padding: const pw.EdgeInsets.only(left: 20),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        products[0]?.category,
                        style: pw.TextStyle(
                          color: baseColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child:
                        logoCompany != null && (prefs.getBool("Logo") ?? true)
                            ? pw.Image(pw.MemoryImage(logoCompany))
                            : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Company:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    //fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: companyName,
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: companyAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    log("qrCode");
    log(_qrCode);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (prefs.getBool("QrCode") ?? true) ...[
                pw.Text(
                  ' ',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        height: 50,
                        width: 150,
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: _qrCode,
                          drawText: true,
                        ),
                      ),
                      pw.Text(
                        _qrCode,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 6,
                        ),
                      ),
                    ]),
              ]
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sign:'),
                  ],
                ),
                pw.Divider(color: accentColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {}

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Item Nr.',
      'Item Description',
      'Quantity',
      'Type',
      'Position',
      'Date'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  Future open_File(String name, Uint8List bytes) async {
    final dir = await getExternalStorageDirectory();
    final file = File('${dir.path}/$name');
    await File('${dir.path}/$name').writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future open_FilePdf(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }
}
