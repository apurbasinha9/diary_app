import 'package:diary_app/model/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:diary_app/controller/diary_controller.dart';
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
  double rating = 1.0;

  void saveEntry() {
    final date = selectedDate;
    final description = descriptionController.text;

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a description.'),
      ));
    } else {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final entries = controller.listDiaryEntries();

      if (entries.any((entry) => entry.date == formattedDate)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An entry for this date already exists!'),
        ));
      } else {
        final entry = DiaryModel(
          formattedDate,
          description,
          rating.toInt(),
        );
        controller.addDiary(entry);
        widget.onDiaryAdded.call();
        Navigator.pop(context);
      }
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
              height: 30,
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
                  activeColor: Color.fromARGB(255, 17, 153, 177),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
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
