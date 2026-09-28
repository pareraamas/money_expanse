import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/services/transaction_import.dart';
import 'package:money_expense/app/theme/app_theme.dart';
import 'package:money_expense/app/ui/ui.dart';

import '../controllers/import_preview_controller.dart';

class ImportPreviewView extends GetView<ImportPreviewController> {
  const ImportPreviewView({super.key});

  /// Batas baris yang ditampilkan agar layar tetap ringan untuk file besar.
  static const _sampleCount = 5;
  static const _issueCount = 20;

  @override
  Widget build(BuildContext context) {
    final plan = controller.plan;
    final n = plan.expenses.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Pratinjau Import')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s24),
        children: [
          if (plan.missingColumns.isNotEmpty)
            _Notice(
              title: 'Kolom wajib tidak ditemukan',
              message:
                  'File harus punya kolom ${[for (final c in plan.missingColumns) _columnLabel(c)].join(', ')}. '
                  'Pakai template agar formatnya pas.',
            )
          else if (plan.isEmpty)
            _Notice(
              title: 'Tidak ada transaksi baru',
              message: plan.duplicates > 0
                  ? 'Semua transaksi di file ini sudah ada di catatanmu.'
                  : 'Tidak ada baris yang bisa dibaca. Cek bagian "Dilewati" di bawah atau pakai template.',
            )
          else
            _Summary(controller: controller),
          if (plan.newCategories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.section),
            _Header('Kategori baru (${plan.newCategories.length})'),
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Dibuat otomatis. Ikon dan warnanya bisa diubah di Kelola Kategori.',
              style: context.text.bodyMedium?.copyWith(color: context.colors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final c in plan.newCategories)
                  Chip(
                    avatar: CircleAvatar(backgroundColor: c.color, radius: 6),
                    label: Text(c.label),
                  ),
              ],
            ),
          ],
          if (plan.duplicates > 0 || plan.issues.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.section),
            _Header('Dilewati (${plan.duplicates + plan.issues.length})'),
            const SizedBox(height: AppSpacing.s8),
            _Skipped(plan: plan, maxIssues: _issueCount),
          ],
          if (n > 0) ...[
            const SizedBox(height: AppSpacing.section),
            _Header(n > _sampleCount ? 'Contoh $_sampleCount dari $n transaksi' : 'Transaksi'),
            const SizedBox(height: AppSpacing.s8),
            for (final e in plan.expenses.take(_sampleCount)) ...[
              TransactionTile(
                title: e.name,
                amount: e.price,
                kind: e.transactionType == 'income' ? AmountKind.income : AmountKind.expense,
                categoryIcon: e.category!.icon,
                categoryColor: e.category!.color,
                categoryLabel: e.category!.label,
                dateLabel: '${AppFormat.dayMonthShort(e.dateTime)} ${e.dateTime.year}',
              ),
              const SizedBox(height: AppSpacing.s8),
            ],
          ],
          const SizedBox(height: AppSpacing.s16),
          Center(
            child: Builder(
              builder: (context) => TextButton.icon(
                onPressed: () => controller.shareTemplate(origin: _originOf(context)),
                icon: const Icon(AppIcons.fileCsv),
                label: const Text('Bagikan template CSV'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: n == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s16),
                child: Obx(() => FilledButton(onPressed: controller.isSaving.value ? null : controller.save, child: Text('Impor $n transaksi'))),
              ),
            ),
    );
  }
}

String _columnLabel(ImportColumn c) => switch (c) {
  ImportColumn.date => 'Tanggal',
  ImportColumn.type => 'Jenis',
  ImportColumn.category => 'Kategori',
  ImportColumn.name => 'Nama',
  ImportColumn.amount => 'Jumlah',
  ImportColumn.id => 'ID',
};

Rect? _originOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  return box == null ? null : box.localToGlobal(Offset.zero) & box.size;
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(header: true, child: Text(text, style: context.text.titleMedium));
}

class _Summary extends StatelessWidget {
  const _Summary({required this.controller});

  final ImportPreviewController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final range = controller.range!;
    String date(DateTime d) => '${AppFormat.dayMonthShort(d)} ${d.year}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text('${controller.expenses.length} transaksi siap diimpor', style: context.text.titleLarge),
            const SizedBox(height: AppSpacing.s4),
            Text(
              range.$1 == range.$2 ? date(range.$1) : '${date(range.$1)} – ${date(range.$2)}',
              style: context.text.bodyMedium?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s4,
              children: [
                AmountText(controller.total('income'), kind: AmountKind.income, semanticsPrefix: 'Total pemasukan'),
                AmountText(controller.total('expense'), kind: AmountKind.expense, semanticsPrefix: 'Total pengeluaran'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Card(
      color: c.warningContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(AppIcons.warning, color: c.onWarningContainer),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall?.copyWith(color: c.onWarningContainer)),
                  const SizedBox(height: AppSpacing.s4),
                  Text(message, style: context.text.bodyMedium?.copyWith(color: c.onWarningContainer)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Skipped extends StatelessWidget {
  const _Skipped({required this.plan, required this.maxIssues});

  final ImportPlan plan;
  final int maxIssues;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final muted = context.text.bodyMedium?.copyWith(color: c.inkMuted);
    final rest = plan.issues.length - maxIssues;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.duplicates > 0) Text('${plan.duplicates} transaksi sudah ada di catatanmu', style: context.text.bodyLarge),
            if (plan.duplicates > 0 && plan.issues.isNotEmpty) const SizedBox(height: AppSpacing.s12),
            if (plan.issues.isNotEmpty) ...[
              Text('${plan.issues.length} baris tidak bisa dibaca', style: context.text.bodyLarge),
              const SizedBox(height: AppSpacing.s4),
              for (final issue in plan.issues.take(maxIssues)) Text(issue.toString(), style: muted),
              if (rest > 0) Text('+$rest baris lainnya', style: muted),
            ],
          ],
        ),
      ),
    );
  }
}
