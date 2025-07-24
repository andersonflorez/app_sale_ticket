import 'package:app_sale_tickets/src/controller/reports_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsController>().fetchTickets(dateRange!);
    });
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: dateRange,
    );
    if (picked != null) {
      setState(() => dateRange = picked);
      context.read<ReportsController>().fetchTickets(dateRange!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes de Ventas')),
      body: Consumer<ReportsController>(
        builder: (context, controller, child) {
          final tickets = controller.tickets;
          final dateFormat = DateFormat('yyyy-MM-dd');

          // Agrupación por día
          final Map<String, int> unitsPerDay = {};
          final Map<String, double> pricePerDay = {};
          for (final t in tickets) {
            final day = dateFormat.format(t.dateSale);
            unitsPerDay[day] = (unitsPerDay[day] ?? 0) + 1;
            pricePerDay[day] = (pricePerDay[day] ?? 0) + (t.locality.price);
          }

          // Agrupación por localidad
          final Map<String, Map<String, int>> unitsPerDayLocality = {};
          final Map<String, Map<String, double>> pricePerDayLocality = {};
          for (final t in tickets) {
            final loc = t.locality.name;
            final day = dateFormat.format(t.dateSale);
            unitsPerDayLocality.putIfAbsent(loc, () => {});
            unitsPerDayLocality[loc]![day] =
                (unitsPerDayLocality[loc]![day] ?? 0) + 1;

            pricePerDayLocality.putIfAbsent(loc, () => {});
            pricePerDayLocality[loc]![day] =
                (pricePerDayLocality[loc]![day] ?? 0) + (t.locality.price);
          }

          final totalUnits = tickets.length;
          final totalPrice = tickets.fold<double>(
            0,
            (sum, t) => sum + (t.locality.price),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    'Filtrar por fecha: ${dateFormat.format(dateRange!.start)} - ${dateFormat.format(dateRange!.end)}',
                  ),
                  onPressed: _pickDateRange,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tickets por día (Unidades)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: unitsPerDay.entries
                          .map(
                            (e) => BarChartGroupData(
                              x: dateFormat.parse(e.key).millisecondsSinceEpoch,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.toDouble(),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt(),
                                );
                                return Text(
                                  DateFormat('dd/MM').format(date),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(),
                          leftTitles: const AxisTitles()),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Tickets por día (Donaciones)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: pricePerDay.entries
                          .map(
                            (e) => BarChartGroupData(
                              x: dateFormat.parse(e.key).millisecondsSinceEpoch,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt(),
                                );
                                return Text(
                                  DateFormat('dd/MM').format(date),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(),
                          topTitles: const AxisTitles()),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Ventas por Localidad (Unidades)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: unitsPerDayLocality.entries
                          .map(
                            (e) => LineChartBarData(
                              spots: e.value.entries
                                  .map((e) => FlSpot(
                                      dateFormat
                                          .parse(e.key)
                                          .millisecondsSinceEpoch
                                          .toDouble(),
                                      e.value.toDouble()))
                                  .toList(),
                              isCurved: true,
                              color: e.key == 'GENERAL'
                                  ? Colors.amber
                                  : Colors.red,
                              barWidth: 3,
                            ),
                          )
                          .toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt());
                              return Text(DateFormat('dd/MM').format(date),
                                  style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                    ),
                  ),
                ),
                /* SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: unitsPerLocality.entries
                          .map(
                            (e) => BarChartGroupData(
                              x: unitsPerLocality.keys.toList().indexOf(e.key),
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.toDouble(),
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                final loc =
                                    unitsPerLocality.keys.elementAt(idx);
                                return Text(
                                  loc,
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles()),
                    ),
                  ),
                ),
               */
                const SizedBox(height: 24),
                const Text(
                  'Tabla de Totales',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                /*   DataTable(
                  columns: const [
                    DataColumn(label: Text('Localidad')),
                    DataColumn(label: Text('Unidades')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: unitsPerLocality.keys.map((loc) {
                    return DataRow(
                      cells: [
                        DataCell(Text(loc)),
                        DataCell(Text(unitsPerLocality[loc].toString())),
                        DataCell(
                          Text(
                            pricePerLocality[loc]?.toStringAsFixed(2) ?? '0',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
               */
                const SizedBox(height: 24),
                Text(
                  'Total Unidades: $totalUnits',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total : ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
