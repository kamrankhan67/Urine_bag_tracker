import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerRecievedView extends StatefulWidget {
  const PackagerRecievedView({super.key, required this.packagerName});
  final String packagerName;

  @override
  State<PackagerRecievedView> createState() => _PackagerRecievedViewState();
}

class _PackagerRecievedViewState extends State<PackagerRecievedView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Packaging")
            .doc(widget.packagerName)
            .collection("Received")
            .orderBy(
              'Date',
              descending: true,
            ) // Assuming Date is a string or timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading receipt records"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No receipt history found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final ds = snapshot.data!.docs[index];
              return _receiptCard(ds, theme);
            },
          );
        },
      ),
    );
  }

  Widget _receiptCard(DocumentSnapshot ds, ThemeData theme) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    final date = data["Date"] ?? "No Date";
    final cartons = data["Received_carton"] ?? 0;
    final boxes = data["Received_box"] ?? 0;
    final pieces = data["Received_pieces"] ?? 0;
    final status = data["Status"] ?? "N/A";

    final isPaid = status.toString().toLowerCase() == "paid";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Received Date",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            Row(
              children: [
                _miniMetric(
                  "Cartons",
                  "$cartons",
                  Icons.inventory_2_outlined,
                  theme,
                ),
                _miniMetric("Boxes", "$boxes", Icons.grid_view_rounded, theme),
                _miniMetric(
                  "Pieces",
                  "$pieces",
                  Icons.category_outlined,
                  theme,
                ),
              ],
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _editReceived(context, ds.id),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text("Edit Record"),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniMetric(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  void _editReceived(BuildContext context, String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Received")
        .doc(id)
        .get();

    if (!ds.exists) return;
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _EditReceivedModal(doc: ds, packagerName: widget.packagerName),
    );
  }
}

class _EditReceivedModal extends StatefulWidget {
  final DocumentSnapshot doc;
  final String packagerName;

  const _EditReceivedModal({required this.doc, required this.packagerName});

  @override
  State<_EditReceivedModal> createState() => _EditReceivedModalState();
}

class _EditReceivedModalState extends State<_EditReceivedModal> {
  late TextEditingController dateController;
  late TextEditingController cartonController;
  late TextEditingController statusController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.doc.data() as Map<String, dynamic>? ?? {};
    dateController = TextEditingController(text: data["Date"] ?? "");
    cartonController = TextEditingController(
      text: (data["Received_carton"] ?? 0).toString(),
    );
    statusController = TextEditingController(text: data["Status"] ?? "");
  }

  @override
  void dispose() {
    dateController.dispose();
    cartonController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int BOX_MULTIPLIER = 48;
    const int PIECE_MULTIPLIER = 144;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Edit Receipt Info",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: "Date",
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cartonController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Cartons",
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: statusController,
            decoration: const InputDecoration(
              labelText: "Status (Paid/Unpaid)",
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 32),
          AddButton(
            isLoading: _isLoading,
            text: "Update Record",
            fn: () async {
              setState(() => _isLoading = true);
              try {
                final data = widget.doc.data() as Map<String, dynamic>? ?? {};
                int newCartons = int.tryParse(cartonController.text) ?? 0;
                int oldCartons = data["Received_carton"] ?? 0;
                int newBoxes = newCartons * BOX_MULTIPLIER;
                int oldBoxes = data["Received_box"] ?? 0;
                int newPieces = newCartons * PIECE_MULTIPLIER;
                int oldPieces = data["Received_pieces"] ?? 0;

                await FirebaseFirestore.instance
                    .collection("Packaging")
                    .doc(widget.packagerName)
                    .collection("Received")
                    .doc(widget.doc.id)
                    .update({
                      "Date": dateController.text,
                      "Received_carton": newCartons,
                      "Received_box": newBoxes,
                      "Received_pieces": newPieces,
                      "Status": statusController.text,
                    });
                var readyBagsData = await FirebaseFirestore.instance
                    .collection("Extras")
                    .doc("Ready Bags")
                    .get();
                int oldReadyCartons = await readyBagsData["Ready Cartons"];
                int oldReadyPieces = await readyBagsData["Ready Pieces"];
                int difference = newCartons - oldCartons;
                print("Ready Bags $oldReadyPieces");

                await FirebaseFirestore.instance
                    .collection("Extras")
                    .doc("Ready Bags")
                    .update({
                      "Ready Cartons": FieldValue.increment(
                        difference,
                      ),
                      "Ready Pieces": FieldValue.increment(
                        difference*144,
                      ),
                    });
                await FirebaseFirestore.instance
                    .collection("Packaging")
                    .doc(widget.packagerName)
                    .update({
                      "Received Carton": FieldValue.increment(
                        newCartons - oldCartons,
                      ),
                      "Boxes": FieldValue.increment(newBoxes - oldBoxes),
                      "Pieces": FieldValue.increment(newPieces - oldPieces),
                    });

                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
          ),
        ],
      ),
    );
  }
}
