import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PDFScreen extends StatefulWidget {
  final String url;

  PDFScreen({required this.url});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PdfControllerPinch? _pdfController; 
  int _currentPage = 1;
  int _totalPages = 0;
  List<int> _bookmarkedPages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      final pdfData = await _downloadPdf(widget.url);

      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(pdfData),
      );

      final pdfDocument = await _pdfController!.document;

      setState(() {
        _totalPages = pdfDocument.pagesCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  Future<Uint8List> _downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  void _bookmarkPage() {
    setState(() {
      if (_bookmarkedPages.contains(_currentPage)) {
        _bookmarkedPages.remove(_currentPage);
      } else {
        _bookmarkedPages.add(_currentPage);
      }
    });
  }

  void _goToBookmark(int page) {
    _pdfController?.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer", style: TextStyle(fontSize: screenSize.width > 600 ? 24 : 20)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: _bookmarkPage,
            color: _bookmarkedPages.contains(_currentPage)
                ? Colors.yellow
                : Colors.white,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PdfViewPinch(
                    controller: _pdfController!,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenSize.width > 600 ? 16.0 : 8.0),
                  child: Text(
                    'Page $_currentPage/$_totalPages',
                    style: TextStyle(fontSize: screenSize.width > 600 ? 18 : 14),
                  ),
                ),
                _buildBookmarkList(),
              ],
            ),
      floatingActionButton: _isLoading
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_currentPage > 1) {
                      _pdfController?.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
                SizedBox(width: screenSize.width > 600 ? 16 : 8),
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_currentPage < _totalPages) {
                      _pdfController?.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildBookmarkList() {
    return _bookmarkedPages.isEmpty
        ? SizedBox.shrink() // Use SizedBox.shrink() instead of Container()
        : Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 16.0 : 8.0),
            child: Wrap(
              spacing: 8.0,
              children: _bookmarkedPages.map((page) {
                return ElevatedButton(
                  child: Text('Page $page'),
                  onPressed: () => _goToBookmark(page),
                );
              }).toList(),
            ),
          );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
