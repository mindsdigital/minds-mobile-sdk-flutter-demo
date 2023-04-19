import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/presenter/helpers/base_state.dart';
import '../../../../core/presenter/theme/assets_paths.dart';
import '../../../../core/presenter/theme/minds_colors.dart';
import '../../domain/enums/process_type.dart';
import '../stores/voice_biometrics_state.dart';
import '../stores/voice_biometrics_store.dart';
import '../widgets/custom_modal_widget.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/rounded_button_widget.dart';

class VoiceBiometricsPage extends StatefulWidget {
  final VoiceBiometricsStore store;

  const VoiceBiometricsPage({super.key, required this.store});

  @override
  State<VoiceBiometricsPage> createState() => _VoiceBiometricsPageState();
}

class _VoiceBiometricsPageState extends State<VoiceBiometricsPage> {
  VoiceBiometricsStore get store => widget.store;
  late final TextEditingController _cpfController;
  late final TextEditingController _phoneNumberController;
  late final GlobalKey<FormState> _formKey;
  late final StreamSubscription stream;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _cpfController = TextEditingController();
    _phoneNumberController = TextEditingController();
    stream = store.stream.listen((event) {
      if (event.state is SuccessState) {
        CustomModalWidget(mindsResponse: event.mindsResponse).show(context);
      }

      if (event.state is FailureState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((event.state as FailureState).message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocBuilder<VoiceBiometricsStore, VoiceBiometricsState>(
              bloc: store,
              builder: (context, state) {
                if (state.state is LoadingState) {
                  return LottieBuilder.asset(AssetPaths.animationLoading);
                }
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: SvgPicture.asset(AssetPaths.ilustration)),
                    const SizedBox(height: 20),
                    const Text(
                      "Olá :) Seja Bem-vindo",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Preencha os dados abaixo e confira nosso conteúdo",
                      style: TextStyle(color: MindsColors.grey),
                    ),
                    const SizedBox(height: 20),
                    CustomTextfieldWidget(
                      controller: _cpfController,
                      enabled: state.state is! LoadingState,
                      icon: AssetPaths.idCardIcon,
                      hintText: "CPF",
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      onChanged: store.onChangeCpf,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                    ),
                    CustomTextfieldWidget(
                      controller: _phoneNumberController,
                      enabled: state.state is! LoadingState,
                      icon: AssetPaths.phoneIcon,
                      hintText: "TELEFONE + DDD",
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      onChanged: store.onChangePhoneNumber,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    RoundedButtonWidget.green(
                      label: "Cadastro por voz",
                      onPressed: state.state is! LoadingState
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                await requestSDK(ProcessType.enrollment);
                              }
                            }
                          : null,
                    ),
                    RoundedButtonWidget.blue(
                      label: "Autenticação por voz",
                      onPressed: state.state is! LoadingState
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                await requestSDK(ProcessType.authentication);
                              }
                            }
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SvgPicture.asset(AssetPaths.mindsLogo),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> requestSDK(ProcessType processType) async {
    if (await Permission.microphone.request().isGranted) {
      await store.callSDK(processType);
    }
  }
}
