import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../models/history_item.dart';
import '../../services/history_service.dart';

// Apple Color Palette
const Color appleBlue = Color(0xFF007AFF);
const Color appleRed = Color(0xFFFF3B30);
const Color appleGreen = Color(0xFF34C759);
const Color applePurple = Color(0xFF5856D6);
const Color appleGray = Color(0xFFF2F2F7);
const Color appleDarkText = Color(0xFF1C1C1E);
const Color appleSecondaryText = Color(0xFF8E8E93);

const List<Color> qrColors = [
  Colors.white,                // Clean white
  Color(0xFFFFD93D),           // Sunny Yellow
  Color(0xFFFF6B6B),           // Coral Red
  Color(0xFF6BCB77),           // Fresh Green
  Color(0xFF4D96FF),           // Sky Blue
  Color(0xFFB983FF),           // Lavender Purple
  Color(0xFFFF9F45),           // Orange
  Color(0xFF00D9FF),           // Turquoise Cyan
  Color(0xFFFF69B4),           // Hot Pink
];

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _textController = TextEditingController();

  String? _qrData;
  Color _qrColor = Colors.white;
  bool _hasReceivedInitialData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasReceivedInitialData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        setState(() {
          _qrData = args;
          _textController.text = args;
        });
      }
      _hasReceivedInitialData = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // --- PDF GENERATION ---
  Future<void> _generateAndPrintPdf() async {
    if (_qrData == null || _qrData!.isEmpty) {
      _showErrorSnackBar();
      return;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(color: appleBlue),
        ),
      ),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final imageBytes = await _screenshotController.capture(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);

      if (imageBytes == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      final pdf = pw.Document();
      final qrImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Text(
                      'QR S&G',
                      style: pw.TextStyle(
                        fontSize: 80,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('QR Code Result',
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 30),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(20),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 2),
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: pw.Image(qrImage, width: 250, height: 250),
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text('Data:',
                          style: pw.TextStyle(
                              fontSize: 16, color: PdfColors.grey700)),
                      pw.SizedBox(height: 5),
                      pw.Text(_qrData ?? '-',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Spacer(),
                      pw.Text('Generated by QR S&G App',
                          style: pw.TextStyle(
                              fontSize: 12, color: PdfColors.grey)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      if (!kIsWeb) {
        String? path;
        try {
          if (Platform.isAndroid) {
            path =
                '/storage/emulated/0/Download/QR_${DateTime.now().millisecondsSinceEpoch}.pdf';
          } else {
            final dir = await getDownloadsDirectory();
            if (dir != null) {
              path =
                  '${dir.path}/QR_${DateTime.now().millisecondsSinceEpoch}.pdf';
            }
          }

          if (path != null) {
            final file = File(path);
            await file.writeAsBytes(await pdf.save());

            await HistoryService().addToHistory(HistoryItem(
              id: DateTime.now().toString(),
              type: HistoryType.create,
              data: _qrData!,
              timestamp: DateTime.now(),
            ));

            if (mounted) Navigator.pop(context);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PDF Saved: $path'),
                  backgroundColor: appleGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  action: SnackBarAction(
                    label: 'OPEN',
                    textColor: Colors.white,
                    onPressed: () => OpenFile.open(path),
                  ),
                ),
              );
            }
            await OpenFile.open(path);
            return;
          }
        } catch (e) {
          debugPrint('Failed to save file: $e');
        }
      }

      if (mounted) Navigator.pop(context);
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'QR_Code_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'), 
          backgroundColor: appleRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // --- PNG SAVING ---
  Future<void> _savePng() async {
    if (_qrData == null || _qrData!.isEmpty) {
      _showErrorSnackBar();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(color: appleBlue),
        ),
      ),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final imageBytes = await _screenshotController.capture(pixelRatio: 3.0);

      if (imageBytes == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      if (kIsWeb) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Use Share feature for Web download.'),
              backgroundColor: appleBlue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      String? path;
      if (Platform.isAndroid) {
        path =
            '/storage/emulated/0/Download/QR_${DateTime.now().millisecondsSinceEpoch}.png';
      } else {
        final dir = await getDownloadsDirectory();
        if (dir != null) {
          path = '${dir.path}/QR_${DateTime.now().millisecondsSinceEpoch}.png';
        }
      }

      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(imageBytes);

        await HistoryService().addToHistory(HistoryItem(
          id: DateTime.now().toString(),
          type: HistoryType.create,
          data: _qrData!,
          timestamp: DateTime.now(),
        ));

        if (mounted) Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PNG Saved: $path'),
              backgroundColor: appleGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              action: SnackBarAction(
                label: 'OPEN',
                textColor: Colors.white,
                onPressed: () => OpenFile.open(path),
              ),
            ),
          );
        }
        await OpenFile.open(path);
      } else {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'), 
            backgroundColor: appleRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Please enter content first!'),
          ],
        ),
        backgroundColor: appleRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appleGray,
      appBar: AppBar(
        title: const Text(
          'Create QR',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            color: appleDarkText,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: appleBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            // QR Preview Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: appleBlue.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _qrColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: _qrData == null || _qrData!.isEmpty
                      ? Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: appleGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_2_rounded,
                                  size: 56, color: appleSecondaryText.withOpacity(0.4)),
                              const SizedBox(height: 12),
                              Text(
                                'QR Preview',
                                style: TextStyle(
                                  color: appleSecondaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 200,
                          height: 200,
                          child: PrettyQrView.data(
                            data: _qrData!,
                            decoration: const PrettyQrDecoration(
                              shape: PrettyQrSmoothSymbol(),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Content Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Content',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: appleDarkText,
                    ),
                  ),
                ),
                TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Enter text or URL...',
                    hintStyle: TextStyle(color: appleSecondaryText.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: appleBlue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.link_rounded, color: appleSecondaryText),
                  ),
                  onChanged: (value) {
                    setState(() =>
                        _qrData = value.trim().isEmpty ? null : value.trim());
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Color Picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Background',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: appleDarkText,
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: qrColors.length,
                    separatorBuilder: (c, i) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final color = qrColors[index];
                      final isSelected = _qrColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _qrColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? appleBlue : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: appleBlue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: isSelected
                              ? Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 20,
                                    color: color == Colors.white 
                                        ? appleBlue 
                                        : appleDarkText,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _AppleActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    color: appleBlue,
                    isEnabled: _qrData != null && _qrData!.isNotEmpty,
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      final imageBytes = await _screenshotController.capture(
                          pixelRatio: MediaQuery.of(context).devicePixelRatio);
                      if (imageBytes != null) {
                        await Share.shareXFiles([
                          XFile.fromData(imageBytes,
                              name: 'qr_${DateTime.now().millisecondsSinceEpoch}.png',
                              mimeType: 'image/png')
                        ]);
                        await HistoryService().addToHistory(HistoryItem(
                          id: DateTime.now().toString(),
                          type: HistoryType.create,
                          data: _qrData!,
                          timestamp: DateTime.now(),
                        ));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AppleActionButton(
                    icon: Icons.download_rounded,
                    label: 'Save',
                    color: appleGreen,
                    isEnabled: _qrData != null && _qrData!.isNotEmpty,
                    onTap: _savePng,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AppleActionButton(
                    icon: Icons.print_rounded,
                    label: 'PDF',
                    color: applePurple,
                    isEnabled: _qrData != null && _qrData!.isNotEmpty,
                    onTap: _generateAndPrintPdf,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reset Button
            TextButton(
              onPressed: () {
                setState(() {
                  _qrData = null;
                  _qrColor = Colors.white;
                  _textController.clear();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: appleRed, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Reset',
                    style: TextStyle(
                      color: appleRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AppleActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _AppleActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  State<_AppleActionButton> createState() => _AppleActionButtonState();
}

class _AppleActionButtonState extends State<_AppleActionButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  double get _scale {
    if (_isPressed) return 0.95;
    if (_isHovered && widget.isEnabled) return 1.03;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    // Show original color with reduced opacity when disabled
    final double buttonOpacity = widget.isEnabled ? 1.0 : 0.35;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.isEnabled ? (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        } : null,
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              // Always use the original color, but with opacity when disabled
              color: widget.color.withOpacity(buttonOpacity),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isHovered && widget.isEnabled 
                    ? Colors.white.withOpacity(0.3) 
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(
                    widget.isEnabled 
                        ? (_isHovered ? 0.4 : 0.3) 
                        : 0.15
                  ),
                  blurRadius: widget.isEnabled 
                      ? (_isHovered ? 16 : 12) 
                      : 8,
                  offset: Offset(0, widget.isEnabled 
                      ? (_isHovered ? 6 : 4) 
                      : 2),
                  spreadRadius: _isHovered && widget.isEnabled ? 1 : 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon, 
                  size: 22, 
                  color: Colors.white.withOpacity(widget.isEnabled ? 1.0 : 0.7),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white.withOpacity(widget.isEnabled ? 1.0 : 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
