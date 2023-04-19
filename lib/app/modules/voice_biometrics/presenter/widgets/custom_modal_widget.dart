import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rounded_button_widget.dart';
import '../../../../core/presenter/theme/assets_paths.dart';
import '../../../../core/presenter/theme/minds_colors.dart';
import '../../domain/entites/minds_response.dart';

class CustomModalWidget extends StatelessWidget {
  final MindsResponse mindsResponse;

  const CustomModalWidget({
    super.key,
    required this.mindsResponse,
  });

  Future<void> show(context) => showModalBottomSheet(
        context: context,
        builder: (context) => this,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      );

  @override
  Widget build(BuildContext context) {
    String prettyJsonString = const JsonEncoder.withIndent('  ')
        .convert(jsonDecode(mindsResponse.rawResponse));
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: false,
          children: [
            IconButton(
                onPressed: () => Modular.to.pop(),
                icon: SvgPicture.asset(AssetPaths.chevronDownIcon)),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      "success: ${mindsResponse.success}",
                    ),
                    backgroundColor: MindsColors.green.withOpacity(0.2),
                  ),
                  const SizedBox(width: 5),
                  Chip(
                    label: Text(
                      "status: ${mindsResponse.details?.voiceMatch?.result?.name}",
                    ),
                    backgroundColor: MindsColors.green.withOpacity(0.2),
                  ),
                  const SizedBox(width: 5),
                  Chip(
                    label: Text(
                      "confidence: ${mindsResponse.details?.voiceMatch?.confidence}",
                    ),
                    backgroundColor: MindsColors.green.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: MindsColors.greyLight.withOpacity(0.6),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                    child: Text(
                      prettyJsonString,
                      style: GoogleFonts.inconsolata(
                        fontSize: 16,
                        color: MindsColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: RoundedButtonWidget(
                            icon: Icons.copy,
                            noPadding: true,
                            backgroundColor: MindsColors.blue,
                            label: "Copiar",
                            onPressed: () => Clipboard.setData(
                                ClipboardData(text: prettyJsonString)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
