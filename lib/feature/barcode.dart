
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeView extends StatefulWidget {
  const BarcodeView({Key? key}) : super(key: key);

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {
  String _scanBarcode = 'Ooups!';

  Future<void> goToLink(String link) async {
    final Uri _url = Uri.parse(link);
    if (!await launchUrl(_url)) throw 'Failed progress $_url';
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      goToLink(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scan'),
      ),
      body: Builder(builder: (context) {
        return Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QRButton(
                onTap: () => scanQR(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Scan result : $_scanBarcode\n',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class QRButton extends StatelessWidget {
  const QRButton({Key? key, required this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        width: MediaQuery.of(context).size.width / 2,
        child: Center(
          child: Text(
            'QR Scanner',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(colors: [Colors.deepPurple, Colors.teal]),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(2, 1), blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
