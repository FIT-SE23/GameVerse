import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final bool isRequired;
  
  const FeedbackDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.isRequired = true,
  });
  
  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _feedbackController = TextEditingController();
  
  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.content),
            const SizedBox(height: 24),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: widget.isRequired ? 'Feedback (required)' : 'Feedback (optional)',
                hintText: 'Enter your feedback here',
                border: const OutlineInputBorder(),
                filled: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.isRequired && _feedbackController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please provide feedback'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop(_feedbackController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(widget.confirmLabel),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getButtonColor(String label) {
    switch (label.toLowerCase()) {
      case 'approve':
        return Colors.green;
      case 'reject':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}