import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../../app/router/ld_app_routes.dart';
import '../../../../../di/service_locator.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../widgets/delivery_illustration_widget.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/phone_input_widget.dart';
import '../widgets/terms_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final phone = _phoneController.text.trim();
    final firstDigit = phone.isNotEmpty ? (int.tryParse(phone[0]) ?? 0) : 0;
    final valid = phone.length == 10 && firstDigit >= 6;
    if (valid != _isButtonEnabled) {
      setState(() => _isButtonEnabled = valid);
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp(BuildContext context) {
    context.read<LoginCubit>().sendOtp(phone: '+91${_phoneController.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<LoginCubit>(),
      child: Scaffold(
        backgroundColor: LDColors.surface,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: _handleState,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      MediaQuery.of(context).padding.top + 24,
                      24,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoginHeaderWidget(),
                        const SizedBox(height: 40),
                        PhoneInputWidget(
                          controller: _phoneController,
                          onSubmitted: _isButtonEnabled ? () => _sendOtp(context) : null,
                        ),
                        const SizedBox(height: 24),
                        LDButton(
                          label: 'Send OTP',
                          enabled: _isButtonEnabled,
                          isLoading: state is LoginLoading,
                          onPressed: () => _sendOtp(context),
                          borderRadius: 32,
                        ),
                        const SizedBox(height: 16),
                        const TermsTextWidget(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const DeliveryIllustrationWidget(),
                  const SizedBox(height: 32),
                  const Text(
                    '© 2024 LOCAL MARKET COLLECTIVE',
                    style: TextStyle(
                      color: LDColors.textDisabled,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleState(BuildContext context, LoginState state) {
    if (state is LoginOtpSent) {
      context.push(
        LDAppRoute.otp.path,
        extra: {'phone': '+91${_phoneController.text.trim()}'},
      );
    } else if (state is LoginError) {
      LDToast.show(context, message: state.message, type: LDToastType.error);
    }
  }
}
