import 'package:flutter/material.dart';

class SchoolLevelCard extends StatelessWidget {
  final String level;
  final VoidCallback? onTap;

  const SchoolLevelCard({
    super.key,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.lightBlueAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.lightBlue.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏫', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 12),
                Text(
                  level,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 