import 'package:flutter/material.dart';
import 'package:wallet_system_2/screens/handling_screens/qr_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:wallet_system_2/services/api.dart';
import 'package:wallet_system_2/widgets/dialogs/flush_bar.dart';


class InvoicesContent extends StatefulWidget {
  const InvoicesContent({super.key});

  @override
  State<InvoicesContent> createState() => InvoicesContentState();
}

class InvoicesContentState extends State<InvoicesContent> {
  get $qrValue => qrValue;
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
   ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 50,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
    
    icon: const Icon(Icons.upload_file),
    label: const Text("Select & Upload File"),
    onPressed: () async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
    );

      if (result != null) {
        selectedFile = File(result.files.single.path!);
      final api = Api();
      final success = await api.upload(selectedFile!);

      if (success.statusCode == 200) {
       showCustomFlushBar(
        context,
        "Success",
       "File uploaded successfully",
         true,
        true,
           );

      } else {
         showCustomFlushBar(
          context,
         "Error",
          "File upload failed",
          false,
            false,
        );

      }
    }
  },
),

          
        ],
      ),
    );
  }
}
