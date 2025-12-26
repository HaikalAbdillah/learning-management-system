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
  final PageController _pageController = PageController();
  int currentPage = 1;
  int totalPage = 1;
  bool isPdf = true;
  bool isImageSlides = false;
  bool isLoading = true;
  List<String> slideImages = [];

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
    final String path = lampiran['path'] ?? lampiran['url'] ?? '';

    isImageSlides = type == 'ppt' && path == 'assets/materi/cyber_security';
    isPdf = (type == 'pdf' || type == 'ppt') && !isImageSlides;

    if (isImageSlides) {
      slideImages = [
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0001.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0002.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0003.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0004.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0005.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0006.jpg',
        'assets/materi/cyber_security/pertemuan pertama cyber_page-0007.jpg',
      ];
      totalPage = slideImages.length;
      currentPage = 1;
    } else if (!isPdf) {
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
    if (isImageSlides) {
      _pageController.dispose();
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
      body: isImageSlides
          ? Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: slideImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index + 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[100],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            slideImages[index],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: currentPage > 1
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: currentPage > 1 ? Colors.blue : Colors.grey,
                        ),
                      ),
                      Text(
                        'Halaman $currentPage / $totalPage',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: currentPage < totalPage
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: currentPage < totalPage ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : isPdf
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
