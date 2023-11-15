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
      body: FutureBuilder<List<DiaryModel>>(
        future: controller.listDiaryEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No diary entries found.'));
          } else {
            final entries = snapshot.data!;
            final groupedEntries = groupEntriesByMonthAndYear(entries);

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 247, 246, 245),
              body: ListView.builder(
                itemCount: groupedEntries.length,
                itemBuilder: (context, index) {
                  final monthYear = groupedEntries.keys.toList()[index];
                  final entriesForMonthYear = groupedEntries[monthYear];

                  return Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              monthYear,
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
                          itemCount: entriesForMonthYear!.length,
                          itemBuilder: (context, subIndex) {
                            final entry = entriesForMonthYear[subIndex];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 238, 236),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 238, 238, 236),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (entry.imageURL.isNotEmpty)
                                              Image.network(
                                                entry.imageURL,
                                                height: 150,
                                              ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Card(
                                        elevation: 2,
                                        color: const Color.fromARGB(
                                            255, 255, 217, 168),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat('E, MMM d').format(
                                                    DateTime.parse(entry.date)),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      AutofillHints.countryCode,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationThickness: 2,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children:
                                                    List.generate(5, (index) {
                                                  return Icon(
                                                    index < entry.rating
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: const Color.fromARGB(
                                                        255, 224, 67, 9),
                                                  );
                                                }),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 5, 51, 79),
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .deleteDiary(entry.id);
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Center(
                                    child: Text(
                                      entry.description,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 12,
                                        fontFamily:
                                            AutofillHints.streetAddressLevel4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Map<String, List<DiaryModel>> groupEntriesByMonthAndYear(
      List<DiaryModel> entries) {
    final groupedEntries = <String, List<DiaryModel>>{};

    for (final entry in entries) {
      final monthYear = DateFormat('MMMM y').format(DateTime.parse(entry.date));
      if (groupedEntries.containsKey(monthYear)) {
        groupedEntries[monthYear]!.add(entry);
      } else {
        groupedEntries[monthYear] = [entry];
      }
    }

    // Sort entries within each month and year
    groupedEntries.forEach((monthYear, entries) {
      entries.sort((a, b) => b.date.compareTo(a.date));
    });

    return groupedEntries;
  }
}
