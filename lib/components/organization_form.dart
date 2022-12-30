import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/organization.dart';

class OrganizationForm extends StatefulWidget {
  final Organization organization;
  final void Function(Organization) onUpdate;
  final void Function() onDelete;

  const OrganizationForm(
    this.organization, {
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _OrganizationFormState createState() => _OrganizationFormState();
}

class _OrganizationFormState extends State<OrganizationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _companyController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _jobDescriptionController = TextEditingController();
  TextEditingController _symbolController = TextEditingController();
  TextEditingController _phoneticNameController = TextEditingController();
  TextEditingController _officeLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _companyController =
        TextEditingController(text: widget.organization.company);
    _titleController = TextEditingController(text: widget.organization.title);
    _departmentController =
        TextEditingController(text: widget.organization.department);
    _jobDescriptionController =
        TextEditingController(text: widget.organization.jobDescription);
    _symbolController = TextEditingController(text: widget.organization.symbol);
    _phoneticNameController =
        TextEditingController(text: widget.organization.phoneticName);
    _officeLocationController =
        TextEditingController(text: widget.organization.officeLocation);
  }

  void _onChanged() {
    final organization = Organization(
        company: _companyController.text,
        title: _titleController.text,
        department: _departmentController.text,
        jobDescription: _jobDescriptionController.text,
        symbol: _symbolController.text,
        phoneticName: _phoneticNameController.text,
        officeLocation: _officeLocationController.text);
    widget.onUpdate(organization);
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
                controller: _companyController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Organization'),
              ),
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextFormField(
                controller: _departmentController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Department'),
              ),
              TextFormField(
                controller: _jobDescriptionController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Job description'),
              ),
              TextFormField(
                controller: _symbolController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Symbol'),
              ),
              TextFormField(
                controller: _phoneticNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Phonetic name'),
              ),
              TextFormField(
                controller: _officeLocationController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Office location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
