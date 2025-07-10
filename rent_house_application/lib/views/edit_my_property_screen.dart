import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/MyPostPropertyResponseDto.dart';
import '../models/UpdateMyPostedPropertyDto.dart';
import '../services/property_service.dart';

class EditMyPropertyScreen extends StatefulWidget {
  final MyPostPropertyResponseDto property;

  const EditMyPropertyScreen({super.key, required this.property});

  @override
  State<EditMyPropertyScreen> createState() => _EditMyPropertyScreenState();
}

class _EditMyPropertyScreenState extends State<EditMyPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final PropertyService _propertyService = PropertyService();

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController contactPersonController;
  late TextEditingController contactNumberController;
  late TextEditingController rentController;
  late TextEditingController divisionController;
  late TextEditingController districtController;
  late TextEditingController thanaController;
  late TextEditingController sectionController;
  late TextEditingController roadController;
  late TextEditingController houseController;
  late TextEditingController addressController;

  late String selectedCategory;
  DateTime? availableFrom;

  @override
  void initState() {
    super.initState();
    final prop = widget.property;
    titleController = TextEditingController(text: prop.title);
    descController = TextEditingController(text: prop.description);
    contactPersonController = TextEditingController(text: prop.contactPerson);
    contactNumberController = TextEditingController(text: prop.contactNumber);
    rentController = TextEditingController(text: prop.rentAmount.toString());
    divisionController = TextEditingController(text: prop.division);
    districtController = TextEditingController(text: prop.district);
    thanaController = TextEditingController(text: prop.thana);
    sectionController = TextEditingController(text: prop.section);
    roadController = TextEditingController(text: prop.roadNumber);
    houseController = TextEditingController(text: prop.houseNumber);
    addressController = TextEditingController(text: prop.address);
    selectedCategory = prop.category;
    availableFrom = DateTime.parse(prop.availableFrom);
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate() || availableFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    final dto = UpdateMyPostedPropertyDto(
      postId: widget.property.id,
      contactNumber: contactNumberController.text,
      contactPerson: contactPersonController.text,
      availableFrom: DateFormat("yyyy-MM-dd").format(availableFrom!),
      category: selectedCategory,
      title: titleController.text,
      description: descController.text,
      rentAmount: int.parse(rentController.text),
      division: divisionController.text,
      district: districtController.text,
      thana: thanaController.text,
      section: sectionController.text,
      roadNumber: roadController.text,
      houseNumber: houseController.text,
      address: addressController.text,
    );

    final success = await _propertyService.updateMyPostedProperty(dto);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "✅ Property updated!" : "❌ Update failed")),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Property")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: titleController, decoration: const InputDecoration(labelText: "Title"), validator: (v) => v!.isEmpty ? "Required" : null),
              TextFormField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
              TextFormField(controller: contactPersonController, decoration: const InputDecoration(labelText: "Contact Person")),
              TextFormField(controller: contactNumberController, decoration: const InputDecoration(labelText: "Contact Number")),
              TextFormField(controller: rentController, decoration: const InputDecoration(labelText: "Rent"), keyboardType: TextInputType.number),
              TextFormField(controller: divisionController, decoration: const InputDecoration(labelText: "Division")),
              TextFormField(controller: districtController, decoration: const InputDecoration(labelText: "District")),
              TextFormField(controller: thanaController, decoration: const InputDecoration(labelText: "Thana")),
              TextFormField(controller: sectionController, decoration: const InputDecoration(labelText: "Section")),
              TextFormField(controller: roadController, decoration: const InputDecoration(labelText: "Road No.")),
              TextFormField(controller: houseController, decoration: const InputDecoration(labelText: "House No.")),
              TextFormField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  availableFrom == null
                      ? "Pick Available Date"
                      : "Available from: ${DateFormat('yyyy-MM-dd').format(availableFrom!)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: availableFrom ?? DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => availableFrom = picked);
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: "Category"),
                items: const [
                  DropdownMenuItem(value: "FAMILY", child: Text("Family")),
                  DropdownMenuItem(value: "ROOMMATE", child: Text("Roommate")),
                  DropdownMenuItem(value: "OFFICE", child: Text("Office")),
                  DropdownMenuItem(value: "HOUSE", child: Text("House")),
                  DropdownMenuItem(value: "BACHELOR", child: Text("Bachelor")),
                  DropdownMenuItem(value: "SUBLET", child: Text("Sublet")),
                ],
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitUpdate,
                icon: const Icon(Icons.save),
                label: const Text("Update Property"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              )
            ],
          ),
        ),
      ),
    );
  }
}
