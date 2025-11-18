import 'dart:io';

import 'package:apk_veiculos/database/model/car_model.dart';
import 'package:apk_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardGradientStart,
                AppTheme.cardGradientEnd,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cardShadow.withAlpha(65),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    child: Container(
                      width: 86.0,
                      height: 86.0,
                      color: AppTheme.imagePlaceholderColor,
                      child: car.img != null
                          ? Image.file(
                              File(car.img!),
                              fit: BoxFit.cover,
                              width: 86,
                              height: 86,
                            )
                          : Image.asset(
                              'assets/imgs/images.png',
                              fit: BoxFit.cover,
                              width: 86,
                              height: 86,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${car.brand} ${car.model}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              car.year,
                              style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.plateBadgeBackground,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                              ),
                              child: Text(
                                car.plate ?? 'N/A',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          car.color.isNotEmpty ? car.color : '',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}