import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/constants/project_padding.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:focusflow_mobile/product/theme/app_text_styles.dart';

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    required this.formKey,
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const ProjectPadding.allLarge(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: WidgetSizes.loginMaxWidth,
              ),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: WidgetSizes.authIconCircleSize,
                      height: WidgetSizes.authIconCircleSize,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primary,
                        size: WidgetSizes.authIconSize,
                      ),
                    ),
                    const SizedBox(height: WidgetSizes.textFieldSpacing),
                    Text(
                      title,
                      style: AppTextStyles.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: WidgetSizes.textFieldSpacing),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: WidgetSizes.pageTitleSpacing),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
