import 'package:after_layout/after_layout.dart';
import 'package:contact_manager/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with AfterLayoutMixin<ContactScreen> {
  late Contact _contact;

  @override
  void afterFirstLayout(BuildContext context) {
    final contact = ModalRoute.of(context)?.settings.arguments as Contact;
    setState(() {
      _contact = contact;
    });
    _fetchContact();
  }

  Future _fetchContact() async {
    await _fetchContactWith(highRes: false);
    await _fetchContactWith(highRes: true);
  }

  Future _fetchContactWith({required bool highRes}) async {
    final contact = await FlutterContacts.getContact(
      _contact.id,
      withThumbnail: !highRes,
      withPhoto: highRes,
      withGroups: true,
      withAccounts: true,
    );
    setState(() {
      _contact = contact!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/editContact', arguments: {
              'contact': _contact,
              'onUpdate': _fetchContact,
            }),
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _contact,
                child: const Text('Delete contact'),
              )
            ],
            onSelected: (contact) async {
              await contact.delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _body(_contact),
    );
  }

  Widget _body(Contact contact) {
    if (_contact.name == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing([
          Center(child: avatar(contact)),
          contact.name.first.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Text(
                    contact.displayName,
                    style: const TextStyle(fontSize: 20),
                  )),
                )
              : const SizedBox(),
          contact.phones.isNotEmpty
              ? _makeCard(
                  'Phones',
                  contact.phones,
                  (x) => [
                        const Divider(),
                        Text('Custom label: ${x.customLabel}'),
                        Text('Number: ${x.number}'),
                        Text('Normalized number: ${x.normalizedNumber}'),
                        Text('Label: ${x.label}'),
                        Text('Primary: ${x.isPrimary}')
                      ])
              : const SizedBox(),
          contact.emails.isNotEmpty
              ? _makeCard(
                  'Emails',
                  contact.emails,
                  (x) => [
                        const Divider(),
                        Text('Address: ${x.address}'),
                        Text('Label: ${x.label}'),
                      ])
              : const SizedBox(),
          contact.addresses.isNotEmpty
              ? _makeCard(
                  'Addresses',
                  contact.addresses,
                  (x) => [
                        const Divider(),
                        Text('Address: ${x.address}'),
                        Text('Label: ${x.label}'),
                        Text('Custom label: ${x.customLabel}'),
                        Text('Street: ${x.street}'),
                        Text('PO box: ${x.pobox}'),
                        Text('Neighborhood: ${x.neighborhood}'),
                        Text('City: ${x.city}'),
                        Text('State: ${x.state}'),
                        Text('Postal code: ${x.postalCode}'),
                        Text('Country: ${x.country}'),
                        Text('ISO country: ${x.isoCountry}'),
                        Text('Sub admin area: ${x.subAdminArea}'),
                        Text('Sub locality: ${x.subLocality}'),
                      ])
              : const SizedBox(),
          contact.organizations.isNotEmpty
              ? _makeCard(
                  'Organizations',
                  contact.organizations,
                  (x) => [
                        const Divider(),
                        Text('Company: ${x.company}'),
                        Text('Title: ${x.title}'),
                        Text('Department: ${x.department}'),
                        Text('Job description: ${x.jobDescription}'),
                        Text('Symbol: ${x.symbol}'),
                        Text('Phonetic name: ${x.phoneticName}'),
                        Text('Office location: ${x.officeLocation}'),
                      ])
              : const SizedBox(),
          contact.websites.isNotEmpty
              ? _makeCard(
                  'Websites',
                  contact.websites,
                  (x) => [
                        const Divider(),
                        Text('URL: ${x.url}'),
                        Text('Label: ${x.label}'),
                        Text('Custom label: ${x.customLabel}'),
                      ])
              : const SizedBox(),
          contact.socialMedias.isNotEmpty
              ? _makeCard(
                  'Social medias',
                  contact.socialMedias,
                  (x) => [
                        const Divider(),
                        Text('Value: ${x.userName}'),
                        Text('Label: ${x.label}'),
                        Text('Custom label: ${x.customLabel}'),
                      ])
              : const SizedBox(),
          contact.events.isNotEmpty
              ? _makeCard(
                  'Events',
                  contact.events,
                  (x) => [
                        const Divider(),
                        Text('Date: ${_formatDate(x)}'),
                        Text('Label: ${x.label}'),
                        Text('Custom label: ${x.customLabel}'),
                      ])
              : const SizedBox(),
        ]),
      ),
    );
  }

  String _formatDate(Event e) =>
      '${e.year?.toString().padLeft(4, '0') ?? '--'}/'
      '${e.month.toString().padLeft(2, '0')}/'
      '${e.day.toString().padLeft(2, '0')}';

  List<Widget> _withSpacing(List<Widget> widgets) {
    const spacer = SizedBox(height: 8);
    return <Widget>[spacer] +
        widgets.map((p) => [p, spacer]).expand((p) => p).toList();
  }

  Card _makeCard(
      String title, List fields, List<Widget> Function(dynamic) mapper) {
    var elements = <Widget>[];
    for (var field in fields) {
      elements.addAll(mapper(field));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _withSpacing(<Widget>[
                Text(
                  title,
                  style: const TextStyle(fontSize: 22),
                ),
              ] +
              elements),
        ),
      ),
    );
  }
}
