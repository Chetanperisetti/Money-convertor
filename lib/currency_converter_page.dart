import 'package:flutter/material.dart';
import 'package:money_converter/database/database_helper.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});
  @override
  State createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  TextEditingController inputcontroller = TextEditingController();
  String result = "0";
  List<Map<String, dynamic>> history = [];

  void intiState() {
    super.initState();
    loadHistory();
  }

  void conversion() async {
    try {
      double input = double.parse(inputcontroller.text);
      double conversionRate = 84.67;
      String converted = (input * conversionRate).toString();
      setState(() {
        result = converted;
      });
      await DBHelper.insertData(inputcontroller.text, converted);
      loadHistory();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  void loadHistory() async {
    List<Map<String, dynamic>> data = await DBHelper.getData();
    setState(() {
      history = data;
    });
  }

  void clearHistory() async {
    await DBHelper.clearData();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Converter'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (clearHistory),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: inputcontroller,
              decoration: InputDecoration(
                hintText: "Enter amount in USD",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: conversion,
              child: Text('Convert to INR'),
            ),
            SizedBox(height: 16),
            Text(
              "Result : INR $result",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      title: Text("USD ${item['input']}=INR ${item['result']}"),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
