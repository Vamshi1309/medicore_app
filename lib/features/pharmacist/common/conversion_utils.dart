String getInitials(String name) {
  final cleanName = name.trim();

  if (cleanName.isEmpty) {
    return '';
  }

  final parts = cleanName.split(RegExp(r'\s+'));

  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String formatDispenseDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String formatDispenseTime(DateTime date) {
  final hour = date.hour;
  final minute = date.minute;
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;

  return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
}