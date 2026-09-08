import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/widgets/app_card.dart';
import 'package:order_payment/core/widgets/app_text_field.dart';
import 'package:order_payment/gen/assets.gen.dart';

class PaymentPhoneField extends StatefulWidget {
  const PaymentPhoneField({
    super.key,
    required this.phone,
    required this.onChanged,
    required this.onUnfocused,
    this.errorText,
    this.enabled = true,
  });

  final String phone;
  final ValueChanged<String> onChanged;
  final VoidCallback onUnfocused;
  final String? errorText;
  final bool enabled;

  @override
  State<PaymentPhoneField> createState() => _PaymentPhoneFieldState();
}

class _PaymentPhoneFieldState extends State<PaymentPhoneField> {
  late final _phoneMask = MaskTextInputFormatter(
    mask: '+### ### ### ###',
    filter: {'#': RegExp(r'[0-9]')},
    initialText: widget.phone,
  );
  late final _controller = TextEditingController(
    text: _phoneMask.getMaskedText(),
  );
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) widget.onUnfocused();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Введите номер телефона', style: AppStyles.textSemiBold),
        const SizedBox(height: 8),
        Semantics(
          label: 'Номер телефона',
          child: AppTextField(
            controller: _controller,
            focusNode: _focus,
            label: '+996',
            errorText: widget.errorText,
            enabled: widget.enabled,
            keyboardType: TextInputType.phone,
            inputFormatters: [_phoneMask],
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(Assets.icons.icPhone),
            ),
            onChanged: (_) => widget.onChanged(_phoneMask.getUnmaskedText()),
            onSubmitted: (_) => _focus.unfocus(),
          ),
        ),
      ],
    ),
  );
}
