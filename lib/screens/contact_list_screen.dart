import 'package:after_layout/after_layout.dart';
import 'package:contact_manager/widgets/avatar.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with AfterLayoutMixin<ContactListScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() {
        _contacts = null;
        _permissionDenied = true;
      });
      return;
    }
    await _refetchContacts();
    FlutterContacts.addListener(() async {
      print('Contacts DB changed, refecthing contacts');
      await _refetchContacts();
    });
  }

  Future _refetchContacts() async {
    await _loadContacts(false);
    await _loadContacts(true);
  }

  Future _loadContacts(bool withPhotos) async {
    final contacts = withPhotos
        ? (await FlutterContacts.getContacts(withThumbnail: true)).toList()
        : (await FlutterContacts.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contacts',
            style: TextStyle(fontSize: 22),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/editContact'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: _body(),
      );

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts?.length,
        itemBuilder: (context, i) {
          final contact = _contacts![i];
          return ListTile(
            leading: avatar(contact, 25.0),
            title: Text(
              contact.displayName,
              style: const TextStyle(fontSize: 20),
            ),
            onTap: () =>
                Navigator.of(context).pushNamed('/contact', arguments: contact),
          );
        });
  }
}
