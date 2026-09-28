import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/theme/app_theme.dart';
import 'package:money_expense/app/ui/ui.dart';

import '../controllers/share_card_controller.dart';

class ShareCardView extends GetView<ShareCardController> {
  const ShareCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Bagikan Ringkasan')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const SkeletonList(itemCount: 1, shape: SkeletonShape.card, padding: EdgeInsets.all(AppSpacing.page));
        }
        final format = controller.format.value;
        return SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s16),
                  // Pratinjau diperkecil agar muat; gambar tetap diekspor di ukuran penuh.
                  child: Semantics(
                    label: 'Pratinjau gambar ${format.label} ringkasan ${AppFormat.monthYear(controller.month)}',
                    image: true,
                    excludeSemantics: true,
                    child: FittedBox(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.cardAll,
                          boxShadow: [BoxShadow(color: c.scrim.withValues(alpha: 0.16), blurRadius: 24, offset: const Offset(0, 8))],
                        ),
                        child: ClipRRect(
                          borderRadius: AppRadius.cardAll,
                          child: RepaintBoundary(
                            key: controller.cardKey,
                            child: ShareSummaryCard(
                              month: controller.month,
                              income: controller.income.value,
                              expense: controller.expense.value,
                              slices: controller.slices.toList(),
                              format: format,
                              hideAmounts: controller.hideAmounts.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: SegmentedButton<ShareCardFormat>(
                  showSelectedIcon: false,
                  segments: [for (final f in ShareCardFormat.values) ButtonSegment(value: f, label: Text(f.label))],
                  selected: {format},
                  onSelectionChanged: (s) => controller.format.value = s.first,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              SwitchListTile(
                value: controller.hideAmounts.value,
                onChanged: (v) => controller.hideAmounts.value = v,
                title: const Text('Sembunyikan nominal'),
                subtitle: Text('Hanya persentase yang tampil', style: context.text.bodyMedium?.copyWith(color: c.inkMuted)),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s16),
                child: Builder(
                  builder: (context) => FilledButton.icon(
                    onPressed: controller.isSharing.value ? null : () => controller.share(origin: _originOf(context)),
                    icon: const Icon(AppIcons.shareNetwork),
                    label: const Text('Bagikan gambar'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Rect? _originOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  return box == null ? null : box.localToGlobal(Offset.zero) & box.size;
}
