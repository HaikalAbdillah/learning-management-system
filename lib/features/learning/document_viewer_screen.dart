import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/app_theme.dart';

class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({super.key});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late final PdfViewerController _pdfController;
  late final WebViewController _webController;
  int currentPage = 1;
  int totalPage = 1;
  bool isPdf = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lampiran =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String type = (lampiran['type'] ?? 'pdf').toString().toLowerCase();
    
    isPdf = type == 'pdf';

    if (!isPdf) {
      String path = lampiran['path'] ?? lampiran['url'] ?? '';
      // Use Google Docs Viewer for PPT/other docs
      String docUrl = "https://docs.google.com/viewer?url=$path&embedded=true";
      
      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              setState(() => isLoading = true);
            },
            onPageFinished: (String url) {
              setState(() => isLoading = false);
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(docUrl));
    }
  }

  @override
  void dispose() {
    if (isPdf) {
      _pdfController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lampiran =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String title = lampiran['title'] ?? 'Document Viewer';
    final String path = lampiran['path'] ?? lampiran['url'] ?? '';
    final String source = lampiran['source'] ?? 'url'; // default to url if missing

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: isPdf ? [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Halaman $currentPage / $totalPage',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ] : null,
      ),
      body: isPdf 
          ? (source == 'asset'
              ? SfPdfViewer.asset(
                  path,
                  controller: _pdfController,
                  onPageChanged: (details) {
                    setState(() {
                      currentPage = details.newPageNumber;
                      totalPage = _pdfController.pageCount;
                    });
                  },
                  onDocumentLoaded: (details) {
                    setState(() {
                      totalPage = _pdfController.pageCount;
                    });
                  },
                )
              : SfPdfViewer.network(
                  path,
                  controller: _pdfController,
                  onPageChanged: (details) {
                    setState(() {
                      currentPage = details.newPageNumber;
                      totalPage = _pdfController.pageCount;
                    });
                  },
                  onDocumentLoaded: (details) {
                    setState(() {
                      totalPage = _pdfController.pageCount;
                    });
                  },
                ))
          : Stack(
              children: [
                WebViewWidget(controller: _webController),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }
}
