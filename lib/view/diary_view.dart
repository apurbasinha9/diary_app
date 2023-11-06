import 'package:diary_app/controller/diary_controller.dart';
import 'package:diary_app/model/diary_model.dart';
import 'package:diary_app/view/diary_add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DiaryController controller = DiaryController();

  @override
  Widget build(BuildContext context) {
    final entries = controller.listDiaryEntries();
    final groupedEntries = groupEntriesByDate(entries);

    // Sort the keys (dates) in descending order
    final sortedDates = groupedEntries.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Diary Entries",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 26, 46),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDiary(
                    onDiaryAdded: () {},
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.white,
                      ),
                      title: const Text(
                        "User Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color.fromARGB(255, 2, 26, 46),
                      centerTitle: true,
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final date = sortedDates[index];
          final entriesForDate = groupedEntries[date];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    DateFormat('MMMM y').format(date),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: entriesForDate!.length,
                itemBuilder: (context, subIndex) {
                  final entry = entriesForDate[subIndex];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('E, MMM d').format(date),
                              style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < entry.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color.fromARGB(255, 224, 67, 9),
                                );
                              }),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 5, 51, 79),
                              ),
                              onPressed: () {
                                controller
                                    .deleteDiary(index); // Delete the entry
                                setState(() {});
                              },
                            )
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            entry.description,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<DiaryModel>> groupEntriesByDate(List<DiaryModel> entries) {
    final groupedEntries = <DateTime, List<DiaryModel>>{};

    for (final entry in entries) {
      final date = DateFormat('yyyy-MM-dd').parse(entry.date);
      if (groupedEntries.containsKey(date)) {
        groupedEntries[date]!.add(entry);
      } else {
        groupedEntries[date] = [entry];
      }
    }

    return groupedEntries;
  }
}
