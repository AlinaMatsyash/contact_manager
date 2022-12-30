import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/social_media.dart';

class SocialMediaForm extends StatefulWidget {
  final SocialMedia socialMedia;
  final void Function(SocialMedia) onUpdate;
  final void Function() onDelete;

  const SocialMediaForm(
    this.socialMedia, {
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _SocialMediaFormState createState() => _SocialMediaFormState();
}

class _SocialMediaFormState extends State<SocialMediaForm> {
  final _formKey = GlobalKey<FormState>();
  static const _validLabels = SocialMediaLabel.values;

  TextEditingController _userNameController = TextEditingController();
  late SocialMediaLabel _label;
  TextEditingController _customLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.socialMedia.userName);
    _label = widget.socialMedia.label;
    _customLabelController =
        TextEditingController(text: widget.socialMedia.customLabel);
  }

  void _onChanged() {
    final socialMedia = SocialMedia(
      _userNameController.text,
      label: _label,
      customLabel:
          _label == SocialMediaLabel.custom ? _customLabelController.text : '',
    );
    widget.onUpdate(socialMedia);
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
                controller: _userNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'User name'),
              ),
              DropdownButtonFormField(
                isExpanded: true, // to avoid overflow
                items: _validLabels
                    .map((e) => DropdownMenuItem<SocialMediaLabel>(
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
              _label == SocialMediaLabel.custom
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
