import 'package:flutter/material.dart';

class CommunityServicePage extends StatefulWidget {
  @override
  _CommunityServicePageState createState() => _CommunityServicePageState();
}

class _CommunityServicePageState extends State<CommunityServicePage> {
  String selectedTerm = '2024-2025'; // Kỳ học mặc định

  // Danh sách hoạt động
  final List<Map<String, String>> activities = [
    {
      "name": "Spring Boot Workshop 131",
      "description": "A hands-on workshop on Spring Boot development.",
      "startDate": "3/10/2025",
      "endDate": "4/20/2025",
      "location": "Khu A",
      "points": "20",
      "term": "2024-2025"
    },
    {
      "name": "Tình nguyện Mùa Hè Xanh",
      "description": "Chương trình tình nguyện giúp đỡ cộng đồng.",
      "startDate": "6/15/2025",
      "endDate": "7/30/2025",
      "location": "Miền Tây",
      "points": "20",
      "term": "2024-2025"
    },
    {
      "name": "Hiến Máu Nhân Đạo",
      "description": "Chương trình hiến máu tình nguyện cứu người.",
      "startDate": "5/10/2025",
      "endDate": "5/10/2025",
      "location": "Trường ĐH ABC",
      "points": "15",
      "term": "2024-2025"
    },
    {
      "name": "Dọn Dẹp Môi Trường",
      "description": "Thu gom rác thải, bảo vệ môi trường sống.",
      "startDate": "4/22/2025",
      "endDate": "4/22/2025",
      "location": "Công viên XYZ",
      "points": "20",
      "term": "2024-2025"
    },
    {
      "name": "Dạy Học Miễn Phí",
      "description": "Hỗ trợ dạy học miễn phí cho trẻ em khó khăn.",
      "startDate": "8/5/2025",
      "endDate": "12/5/2025",
      "location": "Nhà Văn Hóa",
      "points": "20",
      "term": "2024-2025"
    },
    {
      "name": "Hackathon 2023",
      "description": "Cuộc thi lập trình dành cho sinh viên.",
      "startDate": "10/10/2023",
      "endDate": "10/12/2023",
      "location": "Trường ĐH XYZ",
      "points": "25",
      "term": "2023-2024"
    },
    {
      "name": "Tình nguyện Đông 2023",
      "description": "Chương trình tình nguyện mùa đông.",
      "startDate": "12/1/2023",
      "endDate": "12/20/2023",
      "location": "Miền Bắc",
      "points": "25",
      "term": "2023-2024"
    },
    {
      "name": "Hiến Máu Nhân Đạo 2022",
      "description": "Chương trình hiến máu tình nguyện năm 2022.",
      "startDate": "5/10/2022",
      "endDate": "5/10/2022",
      "location": "Trường ĐH DEF",
      "points": "15",
      "term": "2022-2023"
    },
  ];

  // Lọc hoạt động theo kỳ học đã chọn
  List<Map<String, String>> get filteredActivities {
    return activities.where((activity) => activity["term"] == selectedTerm).toList();
  }

  // Tính tổng điểm của các hoạt động trong kỳ học đã chọn
  int get totalPoints {
    return filteredActivities.fold(0, (sum, activity) => sum + int.parse(activity["points"]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Phục vụ cộng đồng",
          style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown chọn kỳ học
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chọn kỳ học:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedTerm,
                  items: [
                    '2021-2022', '2022-2023', '2023-2024', '2024-2025', '2025-2026'
                  ]
                      .map((term) => DropdownMenuItem(value: term, child: Text(term)))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTerm = newValue!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Hiển thị điểm phục vụ cộng đồng
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Điểm phục vụ cộng đồng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("$totalPoints/100", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tiêu đề danh sách hoạt động
            Text("Danh sách hoạt động", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),

            const SizedBox(height: 20),

            // Danh sách hoạt động đã lọc
            Expanded(
              child: ListView.builder(
                itemCount: filteredActivities.length, // Số lượng hoạt động đã lọc
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var activity = filteredActivities[index];
                  return ActivityCard(activity: activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget riêng cho mỗi card hoạt động
class ActivityCard extends StatelessWidget {
  final Map<String, String> activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity["name"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(activity["description"]!, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📅 ${activity["startDate"]} - ${activity["endDate"]}"),
                Text("📍 ${activity["location"]}"),
              ],
            ),
            const SizedBox(height: 10),
            Text("⭐ Điểm: ${activity["points"]}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}