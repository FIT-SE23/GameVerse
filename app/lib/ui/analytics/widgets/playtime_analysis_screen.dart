import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:gameverse/ui/analytics/view_model/playtime_analysis_viewmodel.dart';

class PlaytimeAnalysisScreen extends StatefulWidget {
  const PlaytimeAnalysisScreen({super.key});

  @override
  State<PlaytimeAnalysisScreen> createState() => _PlaytimeAnalysisScreenState();
}

class _PlaytimeAnalysisScreenState extends State<PlaytimeAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaytimeAnalysisViewModel>(context, listen: false).fetchPlaytimeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Playtime Analysis'),
      ),
      body: Consumer<PlaytimeAnalysisViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state == AnalysisState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (viewModel.state == AnalysisState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${viewModel.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchPlaytimeData(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeFrameSelector(context, viewModel),
                  const SizedBox(height: 24),
                  _buildPlaytimeChart(context, viewModel),
                  const SizedBox(height: 32),
                  _buildPlaytimeSummary(context, viewModel),
                  const SizedBox(height: 32),
                  _buildAiAnalysisSection(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeFrameSelector(BuildContext context, PlaytimeAnalysisViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _timeFrameButton(
              context,
              'Daily',
              AnalysisTimeFrame.daily,
              viewModel,
            ),
            _timeFrameButton(
              context,
              'Weekly',
              AnalysisTimeFrame.weekly,
              viewModel,
            ),
            _timeFrameButton(
              context,
              'Monthly',
              AnalysisTimeFrame.monthly,
              viewModel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeFrameButton(
    BuildContext context,
    String label,
    AnalysisTimeFrame timeFrame,
    PlaytimeAnalysisViewModel viewModel,
  ) {
    final isSelected = viewModel.timeFrame == timeFrame;
    final theme = Theme.of(context);
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => viewModel.setTimeFrame(timeFrame),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            elevation: isSelected ? 2 : 0,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildPlaytimeChart(BuildContext context, PlaytimeAnalysisViewModel viewModel) {
    if (viewModel.playtimeByDay.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'No playtime data available for the selected period.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Sort data by date
    final sortedData = viewModel.playtimeByDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Convert data for chart
    final List<BarChartGroupData> barGroups = [];
    final List<String> dates = [];

    for (int i = 0; i < sortedData.length; i++) {
      final entry = sortedData[i];
      final hours = entry.value.inMinutes / 60.0;
      
      dates.add(_formatDateForDisplay(entry.key));
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: hours,
              color: _getBarColor(context, hours),
              width: 18,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Playtime',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _getChartSubtitle(viewModel.timeFrame),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value >= dates.length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                dates[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: barGroups,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Hours Played')),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaytimeSummary(BuildContext context, PlaytimeAnalysisViewModel viewModel) {
    // Calculate summary statistics
    final totalDuration = viewModel.playtimeByDay.values
        .fold(Duration.zero, (prev, curr) => prev + curr);
    final totalHours = totalDuration.inMinutes / 60.0;
    
    final avgDailyHours = viewModel.playtimeByDay.isEmpty
        ? 0.0
        : totalHours / viewModel.playtimeByDay.length;
    
    Duration? longestSession;
    
    for (var session in viewModel.playtimeSessions) {
      if (session.end != null) {
        final sessionDuration = session.end!.difference(session.begin);
        if (longestSession == null || sessionDuration > longestSession) {
          longestSession = sessionDuration;
        }
      }
    }
    
    final longestHours = longestSession?.inMinutes.toDouble() ?? 0.0 / 60.0;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playtime Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              'Total Play Time',
              '${totalHours.toStringAsFixed(4)} hours',
              Icons.timer,
            ),
            const Divider(),
            _buildSummaryRow(
              context,
              'Average Daily Play',
              '${avgDailyHours.toStringAsFixed(4)} hours',
              Icons.calendar_today,
            ),
            const Divider(),
            _buildSummaryRow(
              context,
              'Longest Session',
              '${longestHours.toStringAsFixed(4)} hours',
              Icons.hourglass_full,
            ),
            const Divider(),
            _buildSummaryRow(
              context,
              'Total Sessions',
              '${viewModel.playtimeSessions.length}',
              Icons.gamepad,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAnalysisSection(BuildContext context, PlaytimeAnalysisViewModel viewModel) {
    final theme = Theme.of(context);
    
    // If we haven't run AI analysis yet
    if (viewModel.aiAnalysis.isEmpty && viewModel.state != AnalysisState.loading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'AI Playtime Analysis',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Get personalized insights about your gaming habits and recommendations for healthier gaming.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.analyzePlaytimeWithAI(),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Analyze My Playtime'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show loading if analyzing
    if (viewModel.state == AnalysisState.loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text('Analyzing your playtime data...'),
              SizedBox(height: 8),
              Text(
                'Our AI is preparing personalized insights for you.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show analysis results
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, size: 28),
                const SizedBox(width: 8),
                Text(
                  'AI Playtime Analysis',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            
            // Analysis Section
            const SizedBox(height: 8),
            Text(
              'Analysis',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(viewModel.aiAnalysis),
            
            const SizedBox(height: 24),
            
            // Recommendations Section
            Text(
              'Recommendations',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(viewModel.aiAdvice),
            
            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () => viewModel.analyzePlaytimeWithAI(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Analysis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateForDisplay(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      
      // For daily view, show the hour
      if (date.day == DateTime.now().day) {
        return 'Today';
      }
      if (date.day == DateTime.now().subtract(const Duration(days: 1)).day) {
        return 'Yesterday';
      }
      
      // Otherwise show short date
      return DateFormat('MM/dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getChartSubtitle(AnalysisTimeFrame timeFrame) {
    switch (timeFrame) {
      case AnalysisTimeFrame.daily:
        return 'Last 24 hours';
      case AnalysisTimeFrame.weekly:
        return 'Last 7 days';
      case AnalysisTimeFrame.monthly:
        return 'Last 30 days';
    }
  }

  Color _getBarColor(BuildContext context, double hours) {
    final theme = Theme.of(context);
    
    // Color coding based on hours played
    if (hours < 2) {
      return theme.colorScheme.primary;
    } else if (hours < 4) {
      return theme.colorScheme.secondary;
    } else if (hours < 6) {
      return Colors.orange;
    } else {
      return theme.colorScheme.error;
    }
  }
}