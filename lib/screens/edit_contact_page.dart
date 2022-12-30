import 'package:after_layout/after_layout.dart';
import 'package:contact_manager/components/email_form.dart';
import 'package:contact_manager/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

import '../components/address_form.dart';
import '../components/event_form.dart';
import '../components/name_form.dart';
import '../components/organization_form.dart';
import '../components/phone_form.dart';
import '../components/social_media_form.dart';
import '../components/website_form.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen>
    with AfterLayoutMixin<EditContactScreen> {
  var _contact = Contact();
  bool _isEdit = false;
  void Function()? _onUpdate;

  final _imagePicker = ImagePicker();

  @override
  void afterFirstLayout(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      _contact = args['contact'];
      _isEdit = true;
      _onUpdate = args['onUpdate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_isEdit ? 'Edit' : 'New'} contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (_isEdit) {
                await _contact.update(withGroups: true);
              } else {
                await _contact.insert();
              }
              if (_onUpdate != null) _onUpdate!();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          child: Column(
            children: _contactFields(),
          ),
        ),
      ),
    );
  }

  List<Widget> _contactFields() => [
        _photoField(),
        _nameCard(),
        _phoneCard(),
        _emailCard(),
        _addressCard(),
        _organizationCard(),
        _websiteCard(),
        _socialMediaCard(),
        _eventCard(),
      ];

  Future _pickPhoto() async {
    final photo = await _imagePicker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _contact.photo = bytes;
      });
    }
  }

  Widget _photoField() => Stack(
        children: [
          Center(
            child: InkWell(
              onTap: _pickPhoto,
              child: avatar(_contact, 48, Icons.add),
            ),
          ),
          _contact.photo == null
              ? Container()
              : Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'Delete',
                          child: Text(
                            'Delete photo',
                          ))
                    ],
                    onSelected: (_) => setState(() {
                      _contact.photo = null;
                    }),
                  ),
                ),
        ],
      );

  Card _fieldCard(
    String fieldName,
    List<dynamic> fields,
    Function()? addField,
    Widget Function(int, dynamic) formWidget,
    void Function()? clearAllFields, {
    bool createAsync = false,
  }) {
    var forms = <Widget>[
      Text(fieldName, style: const TextStyle(fontSize: 18)),
    ];
    fields.asMap().forEach((int i, dynamic p) => forms.add(formWidget(i, p)));
    void Function() onPressed;
    if (createAsync) {
      onPressed = () async {
        await addField!();
        setState(() {});
      };
    } else {
      onPressed = () => setState(() {
            addField!();
          });
    }
    var buttons = <ElevatedButton>[];
    if (addField != null) {
      buttons.add(
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('+ New'),
        ),
      );
    }
    if (clearAllFields != null) {
      buttons.add(ElevatedButton(
        onPressed: () {
          clearAllFields();
          setState(() {});
        },
        child: const Text('Delete all'),
      ));
    }
    if (buttons.isNotEmpty) {
      forms.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ));
    }

    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: forms,
          ),
        ),
      ),
    );
  }

  Card _nameCard() => _fieldCard(
        'Name',
        [_contact.name],
        null,
        (int i, dynamic n) => NameForm(
          n,
          onUpdate: (name) => _contact.name = name,
          key: UniqueKey(),
        ),
        null,
      );

  Card _phoneCard() => _fieldCard(
        'Phones',
        _contact.phones,
        () => _contact.phones = _contact.phones + [Phone('')],
        (int i, dynamic p) => PhoneForm(
          p,
          onUpdate: (phone) => _contact.phones[i] = phone,
          onDelete: () => setState(() => _contact.phones.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.phones = [],
      );

  Card _emailCard() => _fieldCard(
        'Emails',
        _contact.emails,
        () => _contact.emails = _contact.emails + [Email('')],
        (int i, dynamic e) => EmailForm(
          e,
          onUpdate: (email) => _contact.emails[i] = email,
          onDelete: () => setState(() => _contact.emails.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.emails = [],
      );

  Card _addressCard() => _fieldCard(
        'Addresses',
        _contact.addresses,
        () => _contact.addresses = _contact.addresses + [Address('')],
        (int i, dynamic a) => AddressForm(
          a,
          onUpdate: (address) => _contact.addresses[i] = address,
          onDelete: () => setState(() => _contact.addresses.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.addresses = [],
      );

  Card _organizationCard() => _fieldCard(
        'Organizations',
        _contact.organizations,
        () =>
            _contact.organizations = _contact.organizations + [Organization()],
        (int i, dynamic o) => OrganizationForm(
          o,
          onUpdate: (organization) => _contact.organizations[i] = organization,
          onDelete: () => setState(() => _contact.organizations.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.organizations = [],
      );

  Card _websiteCard() => _fieldCard(
        'Websites',
        _contact.websites,
        () => _contact.websites = _contact.websites + [Website('')],
        (int i, dynamic w) => WebsiteForm(
          w,
          onUpdate: (website) => _contact.websites[i] = website,
          onDelete: () => setState(() => _contact.websites.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.websites = [],
      );

  Card _socialMediaCard() => _fieldCard(
        'Social medias',
        _contact.socialMedias,
        () => _contact.socialMedias = _contact.socialMedias + [SocialMedia('')],
        (int i, dynamic w) => SocialMediaForm(
          w,
          onUpdate: (socialMedia) => _contact.socialMedias[i] = socialMedia,
          onDelete: () => setState(() => _contact.socialMedias.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.socialMedias = [],
      );

  Future<DateTime?> _selectDate(BuildContext context) async => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000));

  Card _eventCard() => _fieldCard(
        'Events',
        _contact.events,
        () async {
          final date = await _selectDate(context);
          if (date != null) {
            _contact.events = _contact.events +
                [Event(year: date.year, month: date.month, day: date.day)];
          }
        },
        (int i, dynamic w) => EventForm(
          w,
          onUpdate: (event) => _contact.events[i] = event,
          onDelete: () => setState(() => _contact.events.removeAt(i)),
          key: UniqueKey(),
        ),
        () => _contact.events = [],
        createAsync: true,
      );
}
