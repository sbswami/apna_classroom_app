import 'dart:io';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewer extends StatefulWidget {
  final File pdf;
  final String url;

  const PdfViewer({Key key, this.pdf, this.url}) : super(key: key);
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  int _actualPageNumber = 1, _allPagesCount = 0;
  PdfController _pdfController;

  bool isLoading = false;

  @override
  void initState() {
    if (widget.url != null) {
      isLoading = true;
    } else {
      setController(widget.pdf);
    }
    super.initState();
    loadPdf();
  }

  _onFinish() {
    if (mounted) loadPdf();
  }

  loadPdf() async {
    if (widget.url != null) {
      File _pdf = await getFile(
        widget.url,
        name: FileName.MAIN,
        onLoadFinish: _onFinish,
      );
      if (_pdf != null) {
        setState(() {
          setController(_pdf);
          isLoading = false;
        });
      }
    }

    // Track Event
    track(EventName.PDF_VIEWER, {
      EventProp.TYPE: widget.url == null ? 'File' : 'URL',
    });
  }

  setController(File file) {
    _pdfController = PdfController(
      document: PdfDocument.openFile(file.path),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.PDF_VIEWER.tr),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? DetailsSkeleton(
              type: DetailsType.ImageInfo,
            )
          : PdfView(
              documentLoader: Center(child: CircularProgressIndicator()),
              pageLoader: Center(child: CircularProgressIndicator()),
              controller: _pdfController,
              onDocumentLoaded: (document) {
                setState(() {
                  _actualPageNumber = 1;
                  _allPagesCount = document.pagesCount;
                });
              },
              onPageChanged: (page) {
                setState(() {
                  _actualPageNumber = page;
                });
              },
            ),
    );
  }
}
