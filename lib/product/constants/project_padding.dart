import 'package:flutter/widgets.dart';

final class ProjectPadding extends EdgeInsets {
  const ProjectPadding.allSmall() : super.all(8);
  const ProjectPadding.allMedium() : super.all(16);
  const ProjectPadding.allLarge() : super.all(24);

  const ProjectPadding.horizontalMedium() : super.symmetric(horizontal: 16);
  const ProjectPadding.horizontalLarge() : super.symmetric(horizontal: 24);

  const ProjectPadding.verticalSmall() : super.symmetric(vertical: 8);
  const ProjectPadding.verticalMedium() : super.symmetric(vertical: 16);
  const ProjectPadding.verticalLarge() : super.symmetric(vertical: 24);
}
