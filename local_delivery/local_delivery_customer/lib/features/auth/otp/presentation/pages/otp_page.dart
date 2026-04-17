import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../../app/router/ld_app_routes.dart';
import '../../../../../di/service_locator.dart';
import '../../cubit/otp_cubit.dart';
import '../../cubit/otp_state.dart';
import '../widgets/otp_app_bar_widget.dart';
import '../widgets/resend_code_widget.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phone});
  final String phone;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _nameController = TextEditingController();
  String _otp = '';
  bool _showNameSection = false;
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final valid = _nameController.text.trim().isNotEmpty;
    if (valid != _isNameValid) setState(() => _isNameValid = valid);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onPrimaryTap(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_showNameSection) {
      // Phase 2: save name and continue
      context.read<OtpCubit>().saveName(name: _nameController.text.trim());
    } else {
      // Phase 1: verify OTP
      context.read<OtpCubit>().verifyOtp(phone: widget.phone, otp: _otp);
    }
  }

  bool get _isButtonEnabled {
    if (_showNameSection) return _isNameValid;
    return _otp.length == 6;
  }

  String get _buttonLabel => _showNameSection ? 'Continue' : 'Verify';

  bool get _isLoading =>
      _showNameSection ? false : false; // handled via state

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<OtpCubit>(),
      child: Scaffold(
        backgroundColor: LDColors.background,
        body: BlocConsumer<OtpCubit, OtpState>(
          listener: _handleState,
          builder: (context, state) {
            final loading = state is OtpLoading || state is OtpSavingName;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const OtpAppBarWidget(),
                    const SizedBox(height: 40),
                    Text('Verify your number', style: context.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit code sent to',
                      style: context.bodyMedium
                          .copyWith(color: LDColors.textSecondary),
                    ),
                    Text(
                      widget.phone,
                      style: context.bodyMedium.copyWith(
                        color: LDColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _SectionLabel(label: 'VERIFICATION CODE'),
                    const SizedBox(height: 10),
                    LDOtpField(
                      onCompleted: (otp) => setState(() => _otp = otp),
                      onChanged: (otp) => setState(() => _otp = otp),
                    ),
                    // Name section — shown only for new users
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      child: _showNameSection
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 28),
                                _SectionLabel(label: 'YOUR NAME'),
                                const SizedBox(height: 10),
                                LDTextField(
                                  controller: _nameController,
                                  hint: 'Enter your full name',
                                  textCapitalization:
                                      TextCapitalization.words,
                                  textInputAction: TextInputAction.done,
                                  autofocus: true,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                    LDButton(
                      label: _buttonLabel,
                      enabled: _isButtonEnabled,
                      isLoading: loading,
                      onPressed: () => _onPrimaryTap(context),
                      borderRadius: 32,
                    ),
                    const SizedBox(height: 24),
                    ResendCodeWidget(
                      onResend: () => context
                          .read<OtpCubit>()
                          .resendOtp(phone: widget.phone),
                    ),
                    const SizedBox(height: 32),
                    const _ContactSupport(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '© 2024 LOCAL MARKET COLLECTIVE',
                        style: TextStyle(
                          color: LDColors.textDisabled,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleState(BuildContext context, OtpState state) {
    if (state is OtpVerified) {
      context.go(LDAppRoute.home.path);
    } else if (state is OtpVerifiedNeedName) {
      setState(() => _showNameSection = true);
    } else if (state is OtpError) {
      LDToast.show(context, message: state.message, type: LDToastType.error);
    } else if (state is OtpResent) {
      LDToast.show(context,
          message: 'OTP resent successfully', type: LDToastType.success);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.labelMedium.copyWith(
        color: LDColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ContactSupport extends StatelessWidget {
  const _ContactSupport();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.headset_mic_outlined,
              size: 16, color: LDColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            'Contact Support',
            style: context.bodySmall.copyWith(color: LDColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
