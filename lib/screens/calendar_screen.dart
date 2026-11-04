import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const Color _blue = Color(0xFF315FEA);
  static const Color _navy = Color(0xFF14243A);
  static const Color _background = Color(0xFFF4F7FC);
  static const Color _mutedText = Color(0xFF68768A);
  static const Color _border = Color(0xFFE2E8F0);

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekDays = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _changeMonth(int amount) {
    final newMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + amount,
    );

    setState(() {
      _focusedMonth = newMonth;
      _selectedDate = DateTime(
        newMonth.year,
        newMonth.month,
        1,
      );
    });
  }

  void _goToToday() {
    final today = DateTime.now();

    setState(() {
      _focusedMonth = DateTime(today.year, today.month);
      _selectedDate = today;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;

    final startingWeekday = firstDayOfMonth.weekday % 7;

    final usedCells = startingWeekday + daysInMonth;
    final totalCells = ((usedCells + 6) ~/ 7) * 7;

    return Container(
      color: _background,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCalendarCard(
                    daysInMonth: daysInMonth,
                    startingWeekday: startingWeekday,
                    totalCells: totalCells,
                  ),
                  const SizedBox(height: 20),
                  _buildSelectedDateCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard({
    required int daysInMonth,
    required int startingWeekday,
    required int totalCells,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D14243A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[_focusedMonth.month - 1]} '
                  '${_focusedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: _goToToday,
            child: const Text('Today'),
          ),
          const SizedBox(height: 18),
          Row(
            children: _weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: _mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - startingWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                _focusedMonth.year,
                _focusedMonth.month,
                dayNumber,
              );

              final isSelected = _isSameDay(
                date,
                _selectedDate,
              );

              final isToday = _isSameDay(
                date,
                DateTime.now(),
              );

              return Padding(
                padding: const EdgeInsets.all(3),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: _blue,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : _navy,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_available_outlined,
                color: _blue,
              ),
              SizedBox(width: 10),
              Text(
                'Appointments',
                style: TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_monthNames[_selectedDate.month - 1]} '
            '${_selectedDate.day}, ${_selectedDate.year}',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: _mutedText,
                  size: 32,
                ),
                SizedBox(height: 10),
                Text(
                  'No appointments scheduled',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Appointments for this date will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}