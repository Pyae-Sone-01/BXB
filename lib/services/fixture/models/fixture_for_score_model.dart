class FixtureForScoreModel {
  final List<List<LeagueFixtures>>? yesterday;
  final List<List<LeagueFixtures>>? today;

  FixtureForScoreModel({this.yesterday, this.today});

  factory FixtureForScoreModel.fromJson(Map<String, dynamic> json) {
    return FixtureForScoreModel(
      yesterday: json.containsKey('yesterday')
          ? (json['yesterday'] as List)
              .map((outer) => (outer as List)
                  .map((e) => LeagueFixtures.fromJson(e))
                  .toList())
              .toList()
          : null,
      today: json.containsKey('today')
          ? (json['today'] as List)
              .map((outer) => (outer as List)
                  .map((e) => LeagueFixtures.fromJson(e))
                  .toList())
              .toList()
          : null,
    );
  }
}

class LeagueFixtures {
  final String? league;
  final List<FixtureItem>? fixtures;

  LeagueFixtures({this.league, this.fixtures});

  factory LeagueFixtures.fromJson(Map<String, dynamic> json) {
    return LeagueFixtures(
      league: json.containsKey('league') ? json['league'] : null,
      fixtures: json.containsKey('fixtures')
          ? (json['fixtures'] as List)
              .map((e) => FixtureItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class FixtureItem {
  final int? id;
  final String? homeTeam;
  final String? awayTeam;
  final String? matchDateAndTime;
  final int? fixtureStatus;
  final int? homeTeamScore;
  final int? awayTeamScore;

  FixtureItem({
    this.id,
    this.homeTeam,
    this.awayTeam,
    this.matchDateAndTime,
    this.fixtureStatus,
    this.homeTeamScore,
    this.awayTeamScore,
  });

  factory FixtureItem.fromJson(Map<String, dynamic> json) {
    return FixtureItem(
      id: json.containsKey('id') ? json['id'] : null,
      homeTeam: json.containsKey('home_team') ? json['home_team'] : null,
      awayTeam: json.containsKey('away_team') ? json['away_team'] : null,
      matchDateAndTime: json.containsKey('match_date_and_time')
          ? json['match_date_and_time']
          : null,
      fixtureStatus:
          json.containsKey('fixture_status') ? json['fixture_status'] : null,
      homeTeamScore:
          json.containsKey('home_team_score') ? json['home_team_score'] : null,
      awayTeamScore:
          json.containsKey('away_team_score') ? json['away_team_score'] : null,
    );
  }
}
