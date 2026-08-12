import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class BrandLogo extends StatelessWidget {
  final double fontSize;

  const BrandLogo({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        children: const [
          TextSpan(
            text: 'Uni',
            style: TextStyle(color: AppColors.primary),
          ),
          TextSpan(
            text: 'Biz',
            style: TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
