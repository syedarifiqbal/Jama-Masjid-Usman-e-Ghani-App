import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usman_e_ghani/models/expense.dart';
import 'package:usman_e_ghani/services/api_service.dart';
import 'package:usman_e_ghani/widgets/expense_card.dart';
import 'package:usman_e_ghani/widgets/expense_card2.dart';
import 'package:usman_e_ghani/widgets/navigation_drawer.dart';
import 'package:usman_e_ghani/widgets/transaction_card.dart';
import '../helpers/common.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  DateTime _fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _toDate = DateTime.now();
  List<List<Expense>> _tabData = [[], []];
  List<String> _tabTitles = ['Expenses', 'Income'];
  List<bool> _tabLoading = [false, false];
  late TabController _tabController;
  int _actionedItem = 0;
  late SharedPreferences _prefs;
  bool? loggedIn = false;
  bool? isAdmin = false;
  int? authID;

  Future<void> _fetchData(int tabIndex) async {
    setState(() => _tabLoading[tabIndex] = true);
    // Convert selected dates to formatted strings
    String formattedFromDate = DateFormat('yyyy-MM-dd').format(_fromDate);
    String formattedToDate = DateFormat('yyyy-MM-dd').format(_toDate);

    // Construct API URL with query parameters for from and to dates
    String apiUrl =
        '/transactions?from=$formattedFromDate&to=$formattedToDate&type=${tabIndex + 1}';
    print(apiUrl);
    // Perform API call to fetch filtered expenses
    // var response = await http.get(Uri.parse(apiUrl));
    Response response = await ApiService(context).get(apiUrl);

    if (response.statusCode == 200) {
      setState(() {
        _tabData[tabIndex] = List<Expense>.from(
          json.decode(response.body).map((x) => Expense.fromJson(x)),
        );
        _tabLoading[tabIndex] = false;
      });
    } else {
      print("error while fetching transactions");
      setState(() => _tabLoading[tabIndex] = false);
    }
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      loggedIn = prefs.getBool("loggedIn");
      isAdmin = prefs.getBool("isAdmin");
      authID = prefs.getInt("id");
    });

    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fetchData(_tabController.index);
      }
    });

    _fetchData(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _approveTransaction(int? ID) async {
    if (ID == null) return;
    _tabLoading = [_tabController.index == 0, _tabController.index == 1];
    Response res = await ApiService(context)
        .put('/transactions/${ID}/approve', {"body": "nothing"});
    _tabLoading = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) => _showDatePicker(context, value == 'From'),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'From',
                  child: Text('From'),
                ),
                PopupMenuItem<String>(
                  value: 'To',
                  child: Text('To'),
                ),
              ],
            ),
          ],
          title: Text(
            'Transactions ${formatDate(dateString: _fromDate.toString(), format: 'dd/MM/yy')} - ${formatDate(dateString: _toDate.toString(), format: 'dd/MM/yy')}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabTitles
                .map((title) => Tab(
                      text: title,
                    ))
                .toList(),
          ),
        ),
        // drawer: const navigation_drawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabView(0),
            _buildTabView(1),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Open expense record screen on click
            _openExpenseRecordScreen();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = pickedDate;
        } else {
          _toDate = pickedDate;
        }
      });

      // Fetch expenses data based on updated date range
      _fetchData(_tabController.index);
    }
  }

  void _openExpenseRecordScreen() {
    Navigator.pushNamed(context, '/recordExpense');
  }

  void _showBottomSheet(BuildContext context) {
    Expense _selectedExpense = _tabData[_tabController.index][_actionedItem];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              if (loggedIn == true &&
                  isAdmin == true &&
                  _selectedExpense.owner.id != authID)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete Transaction'),
                  onTap: () {
                    // Handle delete transaction action
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Transaction'),
                onTap: () {
                  // Handle edit transaction action
                  Navigator.pop(context);
                },
              ),
              if (loggedIn == true &&
                  isAdmin == true &&
                  _selectedExpense.owner.id != authID)
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Approve'),
                  onTap: () {
                    // Handle share transaction action
                    Navigator.pop(context);
                    _approveTransaction(_selectedExpense.id);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabView(int tabIndex) {
    return RefreshIndicator(
      onRefresh: () => _fetchData(tabIndex),
      child: _tabLoading[tabIndex]
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       ElevatedButton(
                //         onPressed: () => _showDatePicker(context, true),
                //         child: const Text('From Date'),
                //       ),
                //       ElevatedButton(
                //         onPressed: () => _showDatePicker(context, false),
                //         child: const Text('To Date'),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tabData[tabIndex].length,
                    itemBuilder: (BuildContext context, int index) {
                      Expense _expense = _tabData[tabIndex][index];
                      // return ExpenseCard2(
                      //   date: _expense.transaction_date,
                      //   description: _expense.description,
                      //   amount: _expense.amount,
                      //   owner: _expense.owner,
                      // );
                      return TransactionCard(
                        date: _expense.transaction_date,
                        description: _expense.description,
                        amount: _expense.amount,
                        owner: _expense.owner,
                        approver: _expense.approver,
                        iconColor: Colors.green,
                        transactionIcon: Icons.check,
                        onTap: () {
                          _actionedItem = index;
                          _showBottomSheet(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
