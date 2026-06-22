import 'package:flutter/material.dart';
// import 'dart:math' show cos, sin, pi;

class DiaryEntry {
  final DateTime date; // 일기 날짜
  final String content; // 일기 본문
  final String? imagePath; // 이미지 경로

  const DiaryEntry({required this.date, required this.content, this.imagePath});
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<DiaryEntry> _entries = [
    DiaryEntry(
      date: DateTime.now(),
      content:
          '오늘의 일기는 오늘이 나를 맑음은 없어 달렴이 안정히 아능어 알으라고, 랑함 수! 안나는 전록의 제험이 않이하고 일기에어서 기보할이 아기 살아요. 돈다고 소오리 자심을 언한 인간의 엄으로 하아고 라는 일기하고 징착하고 벌게 보아요.',
      imagePath: null,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      content: '그제일 괄리하는 돠어들이 안령한 글째한 경락에 어찰하이다 동부멀하이 횔살했고에요...',
      imagePath: null,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 2)),
      content: '그제일 과랄하는 작확을 부어들아 닮꺼한 공양에 칡아라있데 본작학이 일기하고에요...',
      imagePath: null,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 3)),
      content: '그제일 괄리하는 차물을 파이들아 닮꺼한 경락에 어찰하이다 등부멀하이 얼이하고에요...',
      imagePath: null,
    ),
    DiaryEntry(
      date: DateTime.now().subtract(const Duration(days: 4)),
      content: '그요일 파장하른 모있습이 안당한 글쩌한 경락에나 어이있다 논부멀하이 깔이했고에요...',
      imagePath: null,
    ),
  ];

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final w = weekdays[date.weekday - 1];
    return '$y.$m.$d\n${w}요일';
  }

  void _onWriteDiary() {
    setState(() {
      _entries.insert(
        0,
        DiaryEntry(
          date: DateTime.now(),
          content: '새로 작성한 일기입니다. 일기 작성 화면 구현 후 교체 예정.',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayEntry = _entries.firstWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
      orElse: () => _entries.first,
    );
    final pastEntries = _entries.where((e) => e != todayEntry).toList();

    return CustomScrollView(
      slivers: [
        // ── 전체 패딩 래퍼 ─────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ElevatedButton(
                onPressed: _onWriteDiary,
                child: const Text('일기 작성하기'),
              ),
              const SizedBox(height: 24),
              const Text(
                '오늘의 일기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TodayDiaryCard(
                entry: todayEntry,
                dateText: _formatDate(todayEntry.date),
              ),
              const SizedBox(height: 20),
              const DashedDivider(),
              const SizedBox(height: 20),
              const Text(
                '과거 일기 기록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverList.builder(
            itemCount: pastEntries.length,
            itemBuilder: (context, index) {
              final entry = pastEntries[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PastDiaryCard(
                  entry: entry,
                  dateText: _formatDate(entry.date),
                ),
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class TodayDiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final String dateText;

  const TodayDiaryCard({
    super.key,
    required this.entry,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: entry.imagePath != null
                    ? Image.asset(
                        entry.imagePath!,
                        width: 100,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : _ImagePlaceholder(width: 100, height: 90),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            entry.content,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.6,
            ),

            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}

class PastDiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final String dateText;

  const PastDiaryCard({super.key, required this.entry, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 좌측: 이미지 ─────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: entry.imagePath != null
              ? Image.asset(
                  entry.imagePath!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                )
              : _ImagePlaceholder(width: 70, height: 70),
        ),

        const SizedBox(width: 12),

        // ── 우측: 날짜 + 미리보기 ────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 (한 줄, 줄바꿈 없이 표시)
              Text(
                dateText.replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              // 본문 미리보기 (최대 2줄)
              Text(
                entry.content,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 1,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

class _ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const _ImagePlaceholder({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 28),
    );
  }
}
