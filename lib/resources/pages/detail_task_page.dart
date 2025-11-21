import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DetailTaskPage extends StatefulWidget {
  static const path = '/detail-task';

  const DetailTaskPage({super.key});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  // Data task yang diterima dari halaman sebelumnya
  Map<String, dynamic>? task;

  @override
  void initState() {
    super.initState();
    // Ambil data task dari route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        setState(() {
          task = args;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika task null, tampilkan loading
    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    bool isCompleted = task!['isCompleted'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showToastNotification(
                context,
                title: "Edit",
                description: "Edit feature akan dibuat di sesi berikutnya",
                style: ToastNotificationStyleType.info,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showToastNotification(
                context,
                title: "Delete",
                description: "Delete feature akan dibuat di sesi berikutnya",
                style: ToastNotificationStyleType.warning,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['description'] ?? 'No description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Created date
            const Text(
              'Created At',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['createdAt'] ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Toggle complete button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showToastNotification(
                    context,
                    title: "Toggle Status",
                    description: "Status update akan dibuat di sesi berikutnya (dengan Controller)",
                    style: ToastNotificationStyleType.info,
                  );
                },
                icon: Icon(isCompleted ? Icons.undo : Icons.check),
                label: Text(
                  isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
