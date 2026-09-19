import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/luxury_button.dart';
import '../../../shared/widgets/bounce_tap.dart';
import 'counter_stepper.dart';

class SearchFilterSheet extends StatefulWidget {
  final SearchFilterCriteria initialCriteria;
  final ValueChanged<SearchFilterCriteria> onApply;

  const SearchFilterSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late String? _selectedDistrict;
  late PropertyType? _selectedType;
  late RangeValues _priceRange;
  late int _minBedrooms;
  late int _minBathrooms;

  static const List<String> _districts = [
    'Paris 8e',
    'Paris 16e',
    'Paris 7e',
    'Le Marais',
    'Neuilly-sur-Seine',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDistrict = widget.initialCriteria.district;
    _selectedType = widget.initialCriteria.type;
    _priceRange = RangeValues(
      widget.initialCriteria.minPrice,
      widget.initialCriteria.maxPrice,
    );
    _minBedrooms = widget.initialCriteria.minBedrooms;
    _minBathrooms = widget.initialCriteria.minBathrooms;
  }

  void _reset() {
    setState(() {
      _selectedDistrict = null;
      _selectedType = null;
      _priceRange = const RangeValues(1000000, 10000000);
      _minBedrooms = 0;
      _minBathrooms = 0;
    });
  }

  void _apply() {
    final criteria = widget.initialCriteria.copyWith(
      district: _selectedDistrict,
      clearDistrict: _selectedDistrict == null,
      type: _selectedType,
      clearType: _selectedType == null,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minBedrooms: _minBedrooms,
      minBathrooms: _minBathrooms,
    );
    widget.onApply(criteria);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.modal),
          topRight: Radius.circular(AppRadius.modal),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.base,
        bottom: bottomInset > 0 ? bottomInset + 12 : 24,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // Sheet Title & Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtres', style: AppTypography.sectionTitle),
                BounceTap(
                  onTap: _reset,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Tout réinitialiser',
                      style: AppTypography.button.copyWith(
                        color: AppColors.primaryBrown,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // District / Location Section
            Text('Quartier / Zone', style: AppTypography.propertyTitle.copyWith(fontSize: 16)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _districts.map((d) {
                final isSel = _selectedDistrict == d;
                return _FilterChipItem(
                  label: d,
                  isSelected: isSel,
                  onTap: () {
                    setState(() {
                      _selectedDistrict = isSel ? null : d;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Property Type Section
            Text('Type de bien', style: AppTypography.propertyTitle.copyWith(fontSize: 16)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PropertyType.values.map((t) {
                final isSel = _selectedType == t;
                return _FilterChipItem(
                  label: t.label,
                  isSelected: isSel,
                  onTap: () {
                    setState(() {
                      _selectedType = isSel ? null : t;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Price Range Slider Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fourchette de prix', style: AppTypography.propertyTitle.copyWith(fontSize: 16)),
                Text(
                  '${Formatters.formatCompactCurrency(_priceRange.start)} – ${Formatters.formatCompactCurrency(_priceRange.end)}',
                  style: AppTypography.metadata.copyWith(
                    color: AppColors.primaryBrown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 1000000,
              max: 10000000,
              divisions: 18,
              activeColor: AppColors.primaryBrown,
              inactiveColor: AppColors.separator,
              onChanged: (values) {
                setState(() => _priceRange = values);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Bedrooms & Bathrooms Steppers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chambres', style: AppTypography.propertyTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 8),
                    CounterStepper(
                      value: _minBedrooms,
                      onChanged: (val) => setState(() => _minBedrooms = val),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Salles de bain', style: AppTypography.propertyTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 8),
                    CounterStepper(
                      value: _minBathrooms,
                      onChanged: (val) => setState(() => _minBathrooms = val),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Apply Button
            LuxuryButton(
              text: 'Appliquer les filtres',
              width: double.infinity,
              onPressed: _apply,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scaleFactor: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.background,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.separator,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.tag.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
