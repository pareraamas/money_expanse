import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/app/modules/expanse_create/dialogs/dialogs_expanse_type.dart';
import 'package:money_expense/app/modules/expanse_create/widgets/type_widget.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/curency_formatter.dart';
import '../controllers/expanse_create_controller.dart';

class ExpanseCreateView extends GetView<ExpanseCreateController> {
  const ExpanseCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pengeluaran Baru',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColor.gray1, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Obx(
            () => Column(
              spacing: 18,
              children: [
                // Name
                TextFormField(
                  style: TextStyle(fontSize: 14, color: AppColor.gray1),
                  controller: controller.nameController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    labelText: "Nama Pengeluaran",
                    labelStyle: TextStyle(fontSize: 14, color: Color(0xff828282)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: (value) => value == null || value.isEmpty ? "masukan nama pengeluaran" : null,
                ),

                // Type
                TypeWidget(
                  controller: controller.typeController,
                  label: "Type",
                  iconPath: controller.expenseType.value.icon,
                  iconColor: controller.expenseType.value.color,
                  readOnly: true,
                  onTap: () async {
                    final data = await dialogExpanseType(context);
                    if (data != null) {
                      controller.expenseType.value = data;
                      controller.typeController.text = data.label;
                    }
                  },
                  suffix: CircleAvatar(
                    backgroundColor: AppColor.gray5,
                    radius: 16,
                    child: Icon(Icons.arrow_forward_ios_outlined, color: AppColor.gray3, size: 12),
                  ),
                ),

                // Date Picker
                TextFormField(
                  controller: controller.dateController,
                  readOnly: true,
                  style: TextStyle(fontSize: 14, color: AppColor.gray1),
                  decoration: InputDecoration(
                    labelText: "Tanggal Pengeluaran",
                    labelStyle: TextStyle(fontSize: 14, color: Color(0xff828282)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(0xffBDBDBD)),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(2000), lastDate: now);
                    if (picked != null) {
                      //Senin, 4 Januari 2021
                      controller.dateController.text = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(picked);
                      controller.selectedDate.value = picked;
                    }
                  },
                  validator: (value) => value == null || value.isEmpty ? "Tanggal tidak boleh kosong" : null,
                ),

                // Nominal
                TextFormField(
                  maxLength: 18,
                  style: TextStyle(fontSize: 14, color: AppColor.gray1),
                  controller: controller.priceController,

                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    labelText: "Nominal",
                    labelStyle: TextStyle(fontSize: 14, color: Color(0xff828282)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderTextInput),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, CureencyFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Submit button
                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.submitForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    "Simpan",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
