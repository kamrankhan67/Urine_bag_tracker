import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/pages/packager/packagerDeliverView.dart';
import 'package:urine_bag/pages/packager/packagerReceivedView.dart';

class PackagerDetail extends StatelessWidget {
  const PackagerDetail({super.key, required this.packagerData});
  final DocumentSnapshot packagerData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = packagerData.data() as Map<String, dynamic>? ?? {};

    /// 🔹 Create filtered delivered data
    final deliveredData = Map<String, dynamic>.from(data)
      ..remove("Expected Carton")
      ..remove("Received Carton")
      ..remove("Boxes")
      ..remove("Pieces")
      ..remove("createdAt");

    final receivedData = {
      "Carton": data["Received Carton"] ?? 0,
      "Boxes": data["Boxes"] ?? 0,
      "Pieces": data["Pieces"] ?? 0,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(packagerData.id),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// 🟢 DELIVERED SECTION (Current Stock with Packager)
            _buildSectionHeader(context, "Inventory with Partner", Icons.outbox_rounded),
            const SizedBox(height: 16),
            _buildMetricGrid(deliveredData, theme),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: _infoTile(
                "Total Expected Cartons", 
                "${data["Expected Carton"] ?? 0}", 
                Icons.inventory_2_outlined,
                theme.colorScheme.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PackagerDetailView(packagerName: packagerData.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_rounded),
                  label: const Text("View Delivery History"),
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            /// 🔵 RECEIVED SECTION (Returned Stock)
            _buildSectionHeader(context, "Returned / Received", Icons.move_to_inbox_rounded),
            const SizedBox(height: 16),
            _buildMetricGrid(receivedData, theme),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PackagerRecievedView(packagerName: packagerData.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.assignment_return_outlined),
                  label: const Text("View Receipt History"),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMetricGrid(Map<String, dynamic> metrics, ThemeData theme) {
    final keys = metrics.keys.toList();
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final value = metrics[key] ?? 0;
        final label = key.replaceAll("_", " ");

        return Container(
          padding: const EdgeInsets.all(12),
          
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "$value",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
