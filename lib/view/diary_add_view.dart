import 'dart:io';

import 'package:diary_app/model/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:diary_app/controller/diary_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddDiary extends StatefulWidget {
  final Function onDiaryAdded;

  const AddDiary({
    super.key,
    required this.onDiaryAdded,
  });

  @override
  State<AddDiary> createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  final DiaryController controller = DiaryController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  double rating = 1.0;
  File? _imageFile;

  void saveEntry() async {
    final date = selectedDate;
    final description = descriptionController.text;
    String imageURL = _imageFile != null ? _imageFile!.path : '';

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a description.'),
      ));
    } else {
      final formattedDate = date.toLocal().toString();

      final entry = DiaryModel(
        id: UniqueKey().toString(),
        date: formattedDate,
        description: description,
        rating: rating.toInt(),
        imageURL: imageURL, // Image URL initially empty
      );
      await controller.addDiary(entry, imageFile: _imageFile);
      setState(() {});
      widget.onDiaryAdded.call();
      Navigator.pop(context);
    }
  }

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _displaySelectedImage() {
    if (_imageFile != null) {
      return Container(
        height: 50, // Adjust the height as needed
        width: 50, // Adjust the width as needed
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_imageFile!), // Display the selected image
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(); // Return an empty container if no image is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Entry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 26, 46),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: descriptionController,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              maxLength: 140,
            ),
            Row(
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text("Pick Image: "),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: const Icon(Icons.image),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _getImageFromCamera,
                  child: const Icon(Icons.camera_alt),
                ),
                _displaySelectedImage(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Rate your day:",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Slider(
                  value: rating,
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                  min: 1.0,
                  max: 5.0,
                  divisions: 4,
                  label: rating.toStringAsFixed(1),
                  activeColor: const Color.fromARGB(255, 17, 153, 177),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            ElevatedButton(
              onPressed: saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 48, 150,
                    234), // Set the background color of the button
              ),
              child: const Text(
                'Save Entry',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
