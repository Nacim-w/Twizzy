extension DoubleExtensions on double {
  /// Whether the double can "fill" the [number].
  ///
  /// For example: If a rating has 2.5 stars, and we are building the 3rd of
  /// 5 stars, we can check if 2.5.canFill(3), and since 2.5 + .5 is = 3,
  /// this returns true, so the 3rd star in the 5 star system gets filled as
  /// well, however star 4 will not get filled because 2.5 + .5 is 3 and 3 is
  /// not >= 4.
  bool canFill(int number) {
    return truncate() >= number || (this + .5).truncate() >= number;
  }
}
