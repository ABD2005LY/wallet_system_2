import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet_system_2/helpers/consts.dart';
import 'package:wallet_system_2/helpers/functions_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallet_system_2/widgets/dialogs/flush_bar.dart';
import 'package:wallet_system_2/providers/invoices_provider.dart';
import 'package:wallet_system_2/widgets/cickables/main_button.dart';
import 'package:wallet_system_2/widgets/statics/shimmer_widget.dart';
import 'package:wallet_system_2/widgets/inputs/text_field_widget.dart';

class PlaceInvoiceSheet extends StatefulWidget {
  const PlaceInvoiceSheet({super.key, required this.cardUid});
  final String cardUid;
  @override
  State<PlaceInvoiceSheet> createState() => _PlaceInvoiceSheetState();
}

class _PlaceInvoiceSheetState extends State<PlaceInvoiceSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? imageUrl;
  
  bool _isPickingImage = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesConsumer, _) {
       return BottomSheet(
  showDragHandle: true,
  onClosing: () {},
  builder: (context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text("Add Invoice", style: displaySmall),
              ),

              TextFieldWidget(
                label: "Amount",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                controller: amountController,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "Amount is Required";
                  }
                  if (int.parse(v) <= 0) {
                    return "Amount must be positive value";
                  }
                  return null;
                },
              ),

              TextFieldWidget(
                label: "Description",
                controller: descriptionController,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "Description is Required";
                  }
                  return null;
                }, 
              ),

      ImageInput(
  imgUrl: imageUrl,
  enabled: !_isPickingImage,
  onTap: () async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        setState(() {
          _isPickingImage = false;
        });
        return;
      }

      final uploadResponse =
          await invoicesConsumer.api.upload(
        File(pickedFile.path),
      );

      if (uploadResponse.statusCode != 200) {
        if (context.mounted) {
          showCustomFlushBar(
            context,
            "Upload Failed",
            "Please try again.",
            false,
          );
        }
        setState(() {
          _isPickingImage = false;
        });
        return;
      }

      setState(() {
        imageUrl = json.decode(
          uploadResponse.body,
        )["full_path"];
        _isPickingImage = false;
      });
    } catch (e) {
      setState(() {
        _isPickingImage = false;
      });
      debugPrint("Image picker error: $e");
    }
  },
),


              MainButton(
                busy: invoicesConsumer.busy,
                title: "Add",
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    invoicesConsumer
                        .placeInvoice({
                          "amount": amountController.text,
                          "wallet_uuid": widget.cardUid,
                          "image": imageUrl.toString(),
                          "description":
                              descriptionController.text,
                        })
                        .then((addResponse) {
                          if (context.mounted) {
                            showCustomFlushBar(
                              context,
                              addResponse.first
                                  ? "Success"
                                  : "Failed",
                              addResponse.last,
                              addResponse.first,
                            );
                          }
                          if (addResponse.first) {
                            Timer(
                              const Duration(seconds: 3),
                              () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          }
                        });
                  } else {
                    showCustomFlushBar(
                      context,
                      "Missed Data",
                      "Fill the form and add image",
                      false,
                    );
                  }
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  },
);

      },
    );
  }
}

class ImageInput extends StatelessWidget {
  const ImageInput({super.key, this.imgUrl, required this.onTap, this.enabled=true});
  final String? imgUrl;
  final Function onTap;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: getSize(context).height * 0.1,
          child: imgUrl != null
              ? CachedNetworkImage(
                  imageUrl: "$imgUrl",

                  placeholder: (context, url) {
                    return SizedBox(
                      height: getSize(context).height * 0.1,
                      width: getSize(context).width,
                      child: ShimmerWidget(),
                    );
                  },

                  errorWidget: (context, url, error) {
                    return Container(
                      height: getSize(context).height * 0.1,
                      width: getSize(context).width,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: redColor.withValues(alpha: 0.33),
                        ),
                        color: redColor.withValues(alpha: 0.1),
                      ),

                      child: Center(
                        child: Text(
                          "Image Error",
                          style: labelMedium.copyWith(color: redColor),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.33),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor.withValues(alpha: 0.1),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: primaryColor.withValues(alpha: 0.33),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
