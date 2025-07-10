import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/PropertyPostDto.dart';
import '../services/property_service.dart';

class PostPropertyScreen extends StatefulWidget {
  const PostPropertyScreen({super.key});

  @override
  State<PostPropertyScreen> createState() => _PostPropertyScreenState();
}

class _PostPropertyScreenState extends State<PostPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _propertyService = PropertyService();
  final List<File> _images = [];

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  final contactPersonController = TextEditingController();
  final contactNumberController = TextEditingController();
  final areaController = TextEditingController();
  final rentController = TextEditingController();
  final divisionController = TextEditingController();
  final districtController = TextEditingController();
  final thanaController = TextEditingController();
  final sectionController = TextEditingController();
  final roadController = TextEditingController();
  final houseController = TextEditingController();
  DateTime? availableFrom;
  String selectedCategory = "FAMILY";

  Future<void> _pickImages() async {
    // Handle different versions
    Permission permission = Permission.storage;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
        permission = Permission.photos;
      } else if (await Permission.photos.isDenied || await Permission.storage.isDenied) {
        permission = Platform.isAndroid && (await Permission.photos.isDenied)
            ? Permission.photos
            : Permission.storage;
      }
    }

    final status = await permission.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission to access gallery denied")),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 85);

    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.clear();
        _images.addAll(pickedImages.map((e) => File(e.path)));
      });
    } else {
      debugPrint("No images selected.");
    }
  }



  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || availableFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields and pick at least one image.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("id") ?? 0;

    final dto = PropertyPostDto(
      userID: userId,
      category: selectedCategory,
      title: titleController.text,
      description: descController.text,
      address: addressController.text,
      contactPerson: contactPersonController.text,
      contactNumber: contactNumberController.text,
      area: areaController.text,
      availableFrom: DateFormat("yyyy-MM-dd").format(availableFrom!),
      rentAmount: int.parse(rentController.text),
      division: divisionController.text,
      district: districtController.text,
      thana: thanaController.text,
      section: sectionController.text,
      roadNumber: roadController.text,
      houseNumber: houseController.text,
    );

    final success = await _propertyService.postProperty(dto, _images);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "✅ Property posted!" : "❌ Failed to post.")),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Property")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(titleController, "Title"),
              _buildInput(descController, "Description"),
              _buildInput(addressController, "Address"),
              _buildInput(contactPersonController, "Contact Person"),
              _buildInput(contactNumberController, "Contact Number"),
              _buildInput(areaController, "Area"),
              _buildInput(rentController, "Rent Amount", TextInputType.number),
              _buildInput(divisionController, "Division"),
              _buildInput(districtController, "District"),
              _buildInput(thanaController, "Thana"),
              _buildInput(sectionController, "Section"),
              _buildInput(roadController, "Road No."),
              _buildInput(houseController, "House No."),

              ListTile(
                title: Text(
                  availableFrom == null
                      ? "Select Available Date"
                      : "Available from: ${DateFormat('yyyy-MM-dd').format(availableFrom!)}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => availableFrom = picked);
                  }
                },
              ),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: "FAMILY", child: Text("Family")),
                  DropdownMenuItem(value: "ROOMMATE", child: Text("Roommate")),
                  DropdownMenuItem(value: "OFFICE", child: Text("Office")),
                  DropdownMenuItem(value: "HOUSE", child: Text("House")),
                  DropdownMenuItem(value: "BACHELOR", child: Text("Bachelor")),
                  DropdownMenuItem(value: "SUBLET", child: Text("Sublet")),
                ],
                onChanged: (val) => setState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: "Category"),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.image),
                    label: const Text("Pick Images"),
                  ),
                  Text("${_images.length} image(s) selected"),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.upload),
                label: const Text("Post Property"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, [TextInputType? type]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: type,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }
}
