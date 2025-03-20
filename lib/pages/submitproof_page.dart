import 'package:flutter/material.dart';

class SubmitproofPage extends StatefulWidget {
  const SubmitproofPage({super.key});

  @override
  State<SubmitproofPage> createState() => _SubmitproofPageState();
}

class _SubmitproofPageState extends State<SubmitproofPage> {
  List<Map<String, String>> evidenceList = [
    {
      "date": "10-03-2025",
      "points": "30",
      "source": "https://doanthanhnien.vn",
      "status": "Đang chờ duyệt"
    },
    {
      "date": "10-03-2025",
      "points": "20",
      "source": "https://doanthanhnien.vn",
      "status": "Đang chờ duyệt"
    },
  ];

  void _showAddEvidenceDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController linkController = TextEditingController();
    TextEditingController pointsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm Minh Chứng Mới" , style: TextStyle(color: Colors.blue[900]),),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Tên minh chứng", nameController),
                _buildTextField("Ngày (dd-mm-yyyy)", dateController),
                _buildTextField("Link chứng từ", linkController),
                _buildTextField("Điểm", pointsController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("HỦY", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  evidenceList.add({
                    "date": dateController.text,
                    "points": pointsController.text,
                    "source": linkController.text,
                    "status": "Đang chờ duyệt",
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Minh chứng đã được thêm!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("SUBMIT", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gửi Minh Chứng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Những minh chứng về những hoạt động bạn đã tham gia hoặc thành tích bạn đạt được.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Nút thêm mới
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _showAddEvidenceDialog,
                icon: const Icon(Icons.add),
                label: const Text("Thêm mới"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Danh sách minh chứng có thể cuộn ngang & dọc
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 15,
                    columns: const [
                      DataColumn(label: Text("TT", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Thời điểm", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Điểm", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Nguồn", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Trạng thái", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: evidenceList
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text("${entry.key + 1}")),
                              DataCell(Text(entry.value["date"]!)),
                              DataCell(Text(entry.value["points"]!, style: const TextStyle(color: Colors.blue))),
                              DataCell(
                                SizedBox(
                                  width: 100, // Giới hạn chiều rộng
                                  child: Text(entry.value["source"]!,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(
                                Text(entry.value["status"]!, style: const TextStyle(color: Colors.orange)),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
