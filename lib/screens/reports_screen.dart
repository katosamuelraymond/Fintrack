import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  // Calculate totals for pie chart
  Map<String, double> getChartData() {
    double totalIncome = dummyTransactions
        .where((t) => t.category == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    double totalExpenses = dummyTransactions
        .where((t) => t.category == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return {'Income': totalIncome, 'Expenses': totalExpenses};
  }

  // Get colors for pie chart segments
  List<Color> getChartColors() {
    return [
      Colors.green, // Income color
      Colors.red, // Expenses color
    ];
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> chartData = getChartData();
    List<Color> chartColors = getChartColors();
    double total = chartData.values.fold(0.0, (sum, value) => sum + value);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Financial Reports',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pie Chart Card
              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Income vs Expenses',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Custom Pie Chart - FIXED
                      Container(
                        height: 200,
                        child: CustomPaint(
                          size: const Size(200, 200),
                          painter: PieChartPainter(
                            data: chartData,
                            colors: chartColors,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Legend
                      _buildLegend(chartData, chartColors),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Details Card
              Card(
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Financial Summary',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryItem(
                        'Total Income',
                        chartData['Income']!,
                        Colors.green,
                      ),
                      _buildSummaryItem(
                        'Total Expenses',
                        chartData['Expenses']!,
                        Colors.red,
                      ),
                      _buildSummaryItem(
                        'Net Balance',
                        chartData['Income']! - chartData['Expenses']!,
                        (chartData['Income']! - chartData['Expenses']!) >= 0
                            ? Colors.blue
                            : Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      _buildPercentageItem(
                        'Income %',
                        (chartData['Income']! / total) * 100,
                      ),
                      _buildPercentageItem(
                        'Expenses %',
                        (chartData['Expenses']! / total) * 100,
                      ),
                    ],
                  ),
                ),
              ),

              // Add extra space at bottom to prevent overflow
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Map<String, double> data, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: data.entries.map((entry) {
        int index = data.keys.toList().indexOf(entry.key);
        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Text(
                  'UGX ${entry.value.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: colors[index],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          Text(
            'UGX ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageItem(String title, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Pie Chart Painter - FIXED
class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  PieChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5; // Fixed: Use a percentage of the available size

    double total = data.values.fold(0.0, (sum, value) => sum + value);
    
    // If total is 0, show an empty circle
    if (total == 0) {
      final emptyPaint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, emptyPaint);
      return;
    }

    double startAngle = -90 * (3.14159 / 180); // Start from top

    int index = 0;
    for (var entry in data.entries) {
      double sweepAngle = (entry.value / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = colors[index]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
      index++;
    }

    // Draw center circle for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius / 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}