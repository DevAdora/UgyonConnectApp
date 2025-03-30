import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.grey),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TransactionCard(date: '01', month: 'April'),
          TransactionCard(date: '29', month: 'March'),
          TransactionCard(date: '01', month: 'April'),
          TransactionCard(date: '29', month: 'March'),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String date;
  final String month;

  const TransactionCard({
    super.key,
    required this.date,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text(
                    month,
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Bottles: 2 Small, 3 Medium, 1 Large',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('Points Earned: 15 pts', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('CO₂ Saved: 0.3 kg', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Status: Completed', style: TextStyle(fontSize: 14, color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
