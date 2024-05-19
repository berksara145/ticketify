import 'package:flutter/material.dart';

class ShowReportPage extends StatefulWidget {
  final List<Map<String, dynamic>> reportData;

  const ShowReportPage({Key? key, required this.reportData}) : super(key: key);

  @override
  _ShowReportPageState createState() => _ShowReportPageState();
}

class _ShowReportPageState extends State<ShowReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: ListView.builder(
        itemCount: widget.reportData.length,
        itemBuilder: (context, index) {
          final report = widget.reportData[index];
          return ListTile(
            title: Text(report['event_name'] ?? ''),
            subtitle: Text('Total Revenue: \$${report['total_revenue']}'),
          );
        },
      ),
    );
  }
}
