import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/theme/app_theme.dart';
import 'package:money_expense/app/ui/ui.dart';
import 'package:money_expense/app/ults/clock.dart';
import 'package:money_expense/app/widgets/app_snackbar.dart';

import '../controllers/expanse_create_controller.dart';
import '../widgets/category_sheet.dart';

class ExpanseCreateView extends GetView<ExpanseCreateController> {
  const ExpanseCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(AppIcons.x), tooltip: 'Tutup', onPressed: Get.back),
            title: Obx(() => Text(controller.title)),
            actions: [
              Obx(() {
                if (!controller.isEditing) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(AppIcons.trash),
                  tooltip: 'Hapus transaksi',
                  onPressed: () => _confirmDelete(context),
                );
              }),
              const SizedBox(width: AppSpacing.s4),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s16),
                    children: [
                      const _TypeToggle(),
                      const SizedBox(height: AppSpacing.section),
                      const _AmountDisplay(),
                      const SizedBox(height: AppSpacing.section),
                      _CategoryChips(onOpenAll: () => showCategorySheet(context, controller)),
                      const SizedBox(height: AppSpacing.s16),
                      _DateField(onTap: () => _pickDate(context)),
                      const SizedBox(height: AppSpacing.stack),
                      TextField(
                        controller: controller.nameController,
                        maxLength: 50,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Catatan',
                          hintText: 'Opsional, mis. makan siang',
                          prefixIcon: Icon(AppIcons.note),
                          counterText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                _BottomPanel(controller: controller),
              ],
            ),
          ),
        ),
        const _SuccessOverlay(),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: Clock.now(),
    );
    if (picked != null) controller.setDate(picked);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Hapus transaksi ini?',
      message: 'Catatan ini akan dihapus permanen dan tidak bisa dikembalikan.',
    );
    if (!ok) return;
    if (await controller.deleteExpanse()) {
      Get.back(result: true);
      showAppSnackBar('Transaksi dihapus');
    } else {
      showAppSnackBar('Gagal menghapus transaksi. Coba lagi, ya.');
    }
  }
}

/// Toggle Keluar/Masuk; warnanya mengikuti tipe (coral / hijau).
class _TypeToggle extends GetView<ExpanseCreateController> {
  const _TypeToggle();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final income = controller.isIncome;
      return SegmentedButton<String>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: 'expense', label: Text('Keluar')),
          ButtonSegment(value: 'income', label: Text('Masuk')),
        ],
        selected: {controller.transactionType.value},
        onSelectionChanged: (s) => controller.setType(s.first),
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: income ? c.incomeContainer : c.expenseContainer,
          selectedForegroundColor: income ? c.onIncomeContainer : c.onExpenseContainer,
        ),
      );
    });
  }
}

class _AmountDisplay extends GetView<ExpanseCreateController> {
  const _AmountDisplay();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final error = controller.amountError.value;
      final kind = controller.isIncome ? AmountKind.income : AmountKind.expense;
      return Column(
        children: [
          Text('Nominal', style: context.text.labelLarge?.copyWith(color: c.inkMuted)),
          const SizedBox(height: AppSpacing.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: AmountText(
              controller.amount.value,
              kind: controller.amount.value == 0 ? AmountKind.neutral : kind,
              size: AmountSize.display,
              color: controller.amount.value == 0 ? c.inkMuted : null,
              semanticsPrefix: 'Nominal',
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s4),
              child: Text(error, style: context.text.bodyMedium?.copyWith(color: c.danger)),
            ),
        ],
      );
    });
  }
}

/// 5 kategori terakhir sebagai chip + "Semua" untuk membuka sheet.
class _CategoryChips extends GetView<ExpanseCreateController> {
  const _CategoryChips({required this.onOpenAll});

  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final selectedId = controller.selectedCategory.value?.id;
      final error = controller.categoryError.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategori', style: context.text.labelLarge?.copyWith(color: c.inkMuted)),
          const SizedBox(height: AppSpacing.s8),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final cat in controller.recentCategories)
                ChoiceChip(
                  avatar: CategoryBlob(iconAsset: cat.icon, color: cat.color, size: CategoryBlobSize.small),
                  label: Text(cat.label),
                  selected: cat.id == selectedId,
                  showCheckmark: false,
                  onSelected: (_) => controller.selectCategory(cat),
                ),
              ActionChip(
                avatar: Icon(AppIcons.magnifyingGlass, color: c.brand),
                label: const Text('Semua'),
                tooltip: 'Pilih kategori',
                onPressed: onOpenAll,
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s4),
              child: Text(error, style: context.text.bodyMedium?.copyWith(color: c.danger)),
            ),
        ],
      );
    });
  }
}

class _DateField extends GetView<ExpanseCreateController> {
  const _DateField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(
      () => Semantics(
        button: true,
        label: 'Tanggal ${controller.dateLabel}, ketuk untuk mengubah',
        excludeSemantics: true,
        child: Material(
          color: c.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.inputAll, side: BorderSide(color: c.outlineVariant)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                child: Row(
                  children: [
                    Icon(AppIcons.calendarBlank, color: c.inkMuted),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(child: Text(controller.dateLabel, style: context.text.bodyLarge)),
                    Icon(AppIcons.caretRight, color: c.inkMuted),
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

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.controller});

  final ExpanseCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s12, AppSpacing.page, AppSpacing.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => AmountKeypad(value: controller.amount.value, onChanged: controller.onAmountChanged)),
            const SizedBox(height: AppSpacing.s12),
            Obx(
              () => FilledButton(
                onPressed: controller.isSaving.value ? null : controller.save,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Momen sukses: centang Lottie + Dompi senang, lalu form tertutup.
class _SuccessOverlay extends GetView<ExpanseCreateController> {
  const _SuccessOverlay();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      if (!controller.justSaved.value) return const SizedBox.shrink();
      Widget content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIllustration.dompi(DompiMood.senang, size: 140),
          const SizedBox(height: AppSpacing.s8),
          SuccessCheck(onCompleted: controller.finishSave),
          const SizedBox(height: AppSpacing.s8),
          Text('Tersimpan!', style: context.text.titleLarge),
        ],
      );
      if (!AppMotion.reduced(context)) {
        content = content.animate().fadeIn(duration: AppMotion.short).scaleXY(begin: 0.9, end: 1, curve: AppMotion.emphasized);
      }
      return Positioned.fill(
        child: Material(
          color: c.surface.withValues(alpha: 0.94),
          child: Center(child: content),
        ),
      );
    });
  }
}
