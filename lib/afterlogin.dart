import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget {

  @override
  _AferloginState createState() => _AferloginState();
}

class _AferloginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: Text('DashBoard'),
      ) ,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(

            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            dataRowHeight: 20.0,
            columns: [
              DataColumn(label: Text('Patient id')),
              DataColumn(label: Text('Body Temperature')),
              DataColumn(label: Text('HeartRate')),
              DataColumn(label: Text('Sp02')),
              DataColumn(label: Text('Time')),

            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Text('1')),
                  DataCell(Text('37')),
                  DataCell(Text('88')),
                  DataCell(Text('98')),
                  DataCell(Text('12:00')),

                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
