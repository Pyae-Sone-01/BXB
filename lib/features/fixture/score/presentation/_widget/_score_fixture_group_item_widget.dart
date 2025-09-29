part of '../score_screen.dart';

class _FixtureGroupItemWidget extends StatelessWidget {
  final LeagueFixtures fixture;

  const _FixtureGroupItemWidget({
    required this.fixture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          listTileTheme: const ListTileThemeData(
            dense: true,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(vertical: -2),
          ),
        ),
        child: ExpansionTile(
          dense: true,
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            fixture.league ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppResources.colors.neutral800,
              fontSize: 14,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppResources.colors.blue200,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ...?fixture.fixtures?.map(
                    (e) => Column(
                      children: [
                        FixtureRow(
                          key: ValueKey(e.id),
                          data: e,
                        ),
                        const Gap(20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FixtureRow extends StatelessWidget {
  final FixtureItem data;

  const FixtureRow({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Match Time : ${data.matchDateAndTime?.toReadableDateTime() ?? ''}",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppResources.colors.neutral800),
        ),
        const Gap(10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _buildDecorator(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      data.homeTeam ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: AppResources.colors.blue500,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(5),
              _buildDecorator(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text((data.homeTeamScore == null &&
                            data.awayTeamScore == null)
                        ? "V"
                        : "${data.homeTeamScore} - ${data.awayTeamScore}"),
                  ),
                  backgroundColor: Colors.white),
              const Gap(5),
              Expanded(
                flex: 4,
                child: _buildDecorator(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      data.awayTeam ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: AppResources.colors.blue500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecorator(
      {required Widget child, required Color backgroundColor}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
