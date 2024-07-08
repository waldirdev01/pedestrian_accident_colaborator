import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/ocorrence_helper.dart';
import '../../models/occurrence.dart';

class OccurrenceCreatePage extends StatefulWidget {
  const OccurrenceCreatePage({super.key});

  @override
  State<OccurrenceCreatePage> createState() => _OccurrenceCreatePageState();
}

class _OccurrenceCreatePageState extends State<OccurrenceCreatePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();

  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _showCupertinoDatePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDate = newDateTime;
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(_selectedDate!);
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await _showCupertinoDatePicker(context);
    } else {
      await _showMaterialDatePicker(context);
    }
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final ocorrence = Occurrence(
        title: _titleController.text,
        date: _selectedDate!,
      );
      await OccurrenceHelper().createOccurrence(ocorrence);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'occurrence_create'.tr(),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'occurrence_title'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'occurrence_date'.tr(),
                  hintText: 'dd/MM/yyyy ou use o calendário',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma data';
                  }

                  // Regex para validar o formato dd/MM/yyyy
                  final dateRegExp = RegExp(
                    r'^\d{2}/\d{2}/\d{4}$',
                  );

                  if (!dateRegExp.hasMatch(value)) {
                    return 'Formato de data inválido. Use dd/MM/yyyy';
                  }

                  // Verificar se a data é válida
                  try {
                    _selectedDate = DateFormat('dd/MM/yyyy').parseStrict(value);
                    return null;
                  } catch (e) {
                    return 'Data inválida';
                  }
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: submit,
                child:
                    const Text('Salvar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
