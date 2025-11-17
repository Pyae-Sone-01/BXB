extension NumSignExtension on num {
  /// Returns '+num' if positive, '=' if zero, or the number as string if negative
  String withSignPrefix({
    bool withoutPlusSign = false,
    bool withoutSpace = false,
  }) {
    if (this > 0) {
      if (withoutSpace) {
        return !withoutPlusSign ? '+$this' : "$this";
      } else {
        return !withoutPlusSign ? ' + $this' : "$this";
      }
    } else if (this == 0) {
      return withoutSpace ? '=' : ' = ';
    } else {
      return withoutSpace ? '-${abs()}' : ' - ${abs()}';
    }
  }

  String get toPricing {
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final str = toStringAsFixed(truncateToDouble() == this ? 0 : 2);
    final parts = str.split('.');
    final integerPart = parts[0].replaceAllMapped(reg, (Match m) => '${m[1]},');
    if (parts.length > 1 && int.parse(parts[1]) != 0) {
      return '$integerPart.${parts[1]} Ks';
    }

    return '$integerPart Ks';
  }
}
