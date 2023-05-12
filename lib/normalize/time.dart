String nomarlizeTime(int time) {
  final now = DateTime.now().millisecondsSinceEpoch;

  final differece = now - time;

  if (differece < 3600000) {
    return '방금';
  } else if (differece < 24 * 3600000) {
    return '오늘';
  } else if (differece < 48 * 3600000) {
    return '어제';
  } else if (differece < 72 * 3600000) {
    return '그저께';
  } else if (differece < 30 * 24 * 3600000) {
    return '${differece ~/ (24 * 3600000)}일 전';
  } else if (differece < 365 * 24 * 3600000) {
    return '${differece ~/ (30 * 24 * 3600000)}개월 전';
  } else {
    return '${differece ~/ (365 * 24 * 3600000)}년 전';
  }
}
