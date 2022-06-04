import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var date;
  var explanation;
  var url;
  var title;
  String api =
      "https://api.nasa.gov/planetary/apod?api_key=mopXvZZHOffYJrDNbbtIINbzAz0oLhNPoVEVHR4d";
  final dateController = TextEditingController();

  Future getState() async {
    http.Response response = await http.get(
      Uri.parse(
        api,
      ),
    );
    var result = jsonDecode(response.body);
    setState(() {
      this.date = result['date'];
      this.explanation = result['explanation'];
      this.url = result['url'];
      this.title = result['title'];
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getState();
  }

  @override
  Widget build(BuildContext context) {
    String getData = api + "&date=${dateController.text}";
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Astronomy Picture of the Day",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Valo',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      hintText: DateTime.now().toString().split(" ")[0],
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onTap: () async {
                      var date = await showDatePicker(
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendar,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.fromSwatch(
                                primarySwatch: Colors.deepPurple,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        },
                      );
                      dateController.text = date.toString().split(" ")[0];
                      if (date == null) {
                        dateController.text =
                            DateTime.now().toString().split(" ")[0];
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      api = api + "&date=${dateController.text}";
                      print(api);
                      getState();
                      api =
                          "https://api.nasa.gov/planetary/apod?api_key=mopXvZZHOffYJrDNbbtIINbzAz0oLhNPoVEVHR4d";
                    },
                    child: const Text("Submit"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  url != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    color: Colors.white,
                                    minHeight: double.infinity,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(
                          width: 300,
                          height: 250,
                          child: const Text("null"),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    date != null
                        ? DateFormat.yMMMMEEEEd().format(DateTime.parse(date))
                        : "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "Loading..",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      ReadMoreText(
                        explanation ?? "",
                        trimLines: 4,
                        colorClickableText: Colors.pink,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
