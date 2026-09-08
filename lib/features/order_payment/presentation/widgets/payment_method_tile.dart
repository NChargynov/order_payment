import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_payment/core/theme/app_styles.dart';
import 'package:order_payment/core/theme/app_colors.dart';
import 'package:order_payment/features/order_payment/domain/entities/payment_method.dart';
import 'package:order_payment/gen/assets.gen.dart';

import 'payment_method_icon.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.onTap,
    this.subtitle,
    this.showRadio = false,
    this.selected = false,
    this.emptyLabel = 'Выберите метод оплаты',
  });

  final PaymentMethod? method;
  final VoidCallback? onTap;
  final Widget? subtitle;
  final bool showRadio;
  final bool selected;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final label = method?.displayTitle ?? emptyLabel;
    final enabled = onTap != null;
    final labelStyle = method == null
        ? AppStyles.textSemiBold.copyWith(height: 20 / 14)
        : AppStyles.smallMedium;

    return Semantics(
      label: label,
      button: !showRadio,
      checked: showRadio ? selected : null,
      inMutuallyExclusiveGroup: showRadio,
      enabled: enabled,
      child: Material(
        color: AppColors.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: method == PaymentMethod.account
              ? const BorderSide(color: AppColors.primary)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: showRadio ? 40 : 48),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (method != null) ...[
                  Opacity(
                    opacity: enabled ? 1 : 0.45,
                    child: PaymentMethodIcon(method!),
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: labelStyle.copyWith(
                          color: enabled
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      ?subtitle,
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (showRadio)
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: selected
                            ? AppColors.primary
                            : AppColors.radioColor,
                      ),
                    ),
                    child: selected
                        ? const DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  )
                else
                  SvgPicture.asset(Assets.icons.icChevronRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
