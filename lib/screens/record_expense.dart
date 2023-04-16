import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:usman_e_ghani/helpers/common.dart';
import 'package:usman_e_ghani/models/transaction_type.dart';
import '../models/category.dart';

import '../services/api_service.dart';

class RecordExpenseScreen extends StatefulWidget {
  const RecordExpenseScreen({Key? key});

  @override
  _RecordExpenseScreenState createState() => _RecordExpenseScreenState();
}

class _RecordExpenseScreenState extends State<RecordExpenseScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _date;
  List<Category> _categories = [];
  Category? _selectedCategory; // Currently selected category
  List<TransactionType> _types = [];
  TransactionType? _selectedType; // Currently selected type

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTransactionType();
  }

  void _fetchCategories() async {
    // Fetch categories from API
    var response = await new ApiService(context).get('/categories');
    if (response.statusCode == 200) {
      // Parse response and update _categories list
      setState(() {
        _categories = List<Category>.from(
          json.decode(response.body).map((x) => Category.fromJson(x)),
        );
      });
    } else {
      // Handle API error, e.g., show error message
    }
  }

  void _fetchTransactionType() async {
    // Fetch categories from API
    var response = await new ApiService(context).get('/transaction-types');
    if (response.statusCode == 200) {
      // Parse response and update _categories list
      setState(() {
        _types = List<TransactionType>.from(
          json.decode(response.body).map((x) => TransactionType.fromJson(x)),
        );
      });
    } else {
      // Handle API error, e.g., show error message
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            formatDate(dateString: pickedDate.toString(), format: 'dd/MM/yyyy');
      });
      _date =
          formatDate(dateString: pickedDate.toString(), format: 'yyyy-MM-dd');
    }
  }

  void _postExpense() async {
    if (_formKey.currentState!.validate()) {
      String description = _descriptionController.text;
      String amount = _amountController.text;
      String date = _dateController.text;

      // Perform API call to post expense with selected category
      var response = await ApiService(context).post(
        '/transactions',
        {
          'transaction_date': _date,
          'description': description,
          'amount': amount,
          'date': date,
          'category_id': _selectedCategory!.id,
          'transaction_type_id': _selectedType!.id,
        },
      );

      if (response.statusCode == 201) {
        showToast(jsonDecode(response.body)['message']);
        Navigator.pop(context);
      } else {
        print(response.body);
        showToast("Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
              TextFormField(
                controller: _amountController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  try {
                    double.parse(value);
                  } catch (e) {
                    return 'Amount must be numeric values!';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintMaxLines: 4,
                ),
              ),
              DropdownButtonFormField<TransactionType>(
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                ),
                items: _types.map((type) {
                  return DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _postExpense,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
