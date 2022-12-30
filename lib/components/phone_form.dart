import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/phone.dart';

class PhoneForm extends StatefulWidget {
  final Phone phone;
  final void Function(Phone) onUpdate;
  final void Function() onDelete;

  const PhoneForm(
    this.phone, {
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  static const _validLabels = PhoneLabel.values;

  TextEditingController _numberController = TextEditingController();
  late PhoneLabel _label;
  TextEditingController _customLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.phone.number);
    _label = widget.phone.label;
    _customLabelController =
        TextEditingController(text: widget.phone.customLabel);
  }

  void _onChanged() {
    final phone = Phone(_numberController.text,
        label: _label,
        customLabel:
            _label == PhoneLabel.custom ? _customLabelController.text : '');
    widget.onUpdate(phone);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (_) => widget.onDelete(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onChanged: _onChanged,
          child: Column(
            children: [
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Phone'),
              ),
              DropdownButtonFormField(
                isExpanded: true, // to avoid overflow
                items: _validLabels
                    .map((e) => DropdownMenuItem<PhoneLabel>(
                        value: e, child: Text(e.toString())))
                    .toList(),
                value: _label,
                onChanged: (label) {
                  setState(() {
                    _label = label!;
                  });
                  _onChanged();
                },
              ),
              _label == PhoneLabel.custom
                  ? TextFormField(
                      controller: _customLabelController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          const InputDecoration(hintText: 'Custom label'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
