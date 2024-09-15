// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:molle/Controllers/api_servie_login.dart';
//
// import '../../../../Utils/constants.dart';
//
// class CNICScannerScreen extends StatefulWidget {
//   const CNICScannerScreen({super.key});
//
//   @override
//   _CNICScannerScreenState createState() => _CNICScannerScreenState();
// }
//
// class _CNICScannerScreenState extends State<CNICScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;
//   final AuthService _authService = AuthService();
//   File? _documentFront;
//   File? _documentBack;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     }
//     controller?.resumeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _uploadDocuments(File documentFront, File documentBack) async {
//     try {
//       // Upload document to server
//       final response = await _authService.uploadDocuments(documentFront, documentBack);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Documents uploaded successfully: ${response['message']}')),
//       );
//
//       // Navigate back or show a success screen as needed
//       Navigator.of(context).pop();
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to upload documents: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Scan Your Card',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: ColorConstants.mainColor,
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: ColorConstants.mainColor,
//                 borderRadius: 10,
//                 borderLength: 30,
//                 borderWidth: 10,
//                 cutOutSize: 300,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: (result != null)
//                   ? Text('Result: ${result!.code}')
//                   : const Text(
//                 'Scan a CNIC QR code',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//
//       if (result != null && result!.code!.startsWith("CNIC")) {
//         _verifyCNIC(result!.code!);
//       }
//     });
//   }
//
//   void _verifyCNIC(String scannedCode) {
//     // Open the camera to capture the front and back of CNIC
//     // Use a separate method to capture images
//     // For example, capture both front and back using ImagePicker or another package
//     _captureDocument();
//   }
//
//   Future<void> _captureDocument() async {
//     // Assuming the user captures front and back images of the CNIC
//     final picker = ImagePicker();
//     final frontFile = await picker.pickImage(source: ImageSource.camera);
//     final backFile = await picker.pickImage(source: ImageSource.camera);
//
//     if (frontFile != null && backFile != null) {
//       setState(() {
//         _documentFront = File(frontFile.path);
//         _documentBack = File(backFile.path);
//       });
//
//       // Upload the documents
//       await _uploadDocuments(_documentFront!, _documentBack!);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please capture both front and back images of your CNIC.')),
//       );
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molle/Controllers/api_servie_login.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final AuthService _authService = AuthService();
  File? _documentFront;
  File? _documentBack;

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _documentFront = File(pickedFile.path);
        } else {
          _documentBack = File(pickedFile.path);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  Future<void> _uploadDocuments() async {
    if (_documentFront == null || _documentBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both front and back images.')),
      );
      return;
    }

    try {
      // Upload documents to server
      final response = await _authService.uploadDocuments(_documentFront!, _documentBack!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Documents uploaded successfully: ${response['message']}')),
      );

      // Navigate back or show a success screen as needed
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload documents: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Documents',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _pickImage(true), // Pick front image
            child: const Text('Select Front Image'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(false), // Pick back image
            child: const Text('Select Back Image'),
          ),
          ElevatedButton(
            onPressed: _uploadDocuments,
            child: const Text('Upload Documents'),
          ),
        ],
      ),
    );
  }
}
