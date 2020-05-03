import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//this class enables user to add transactions

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  DateTime selectedDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return; //return stops code execution
    }

    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );

//closes bottom sheet
    Navigator.of(context).pop();
  }

  //Future are classes that enables us to build objects that will give us values in the future

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      //then is called when future results to a value (user provide a value
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),

                // onChanged: (value) {
                //   titleInput = value;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                // onChanged: (value) => amountInput = value ,
              ),
              Container(
                height: 70,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Text(selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}'),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ]),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.black,
                onPressed: submitData,
              ),
            ]),
      ),
    );
  }
}
