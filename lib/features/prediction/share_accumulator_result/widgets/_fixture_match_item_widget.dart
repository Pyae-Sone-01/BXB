part of '../share_accumulator_result_screen.dart';

class _FixtureMatchItemWidget extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String predictionSide;
  final String predicitonType;
  final String score;
  final String statusString;
  final int? handicapValue;
  final int? handicapPrice;
  final bool isHomeTeamUpper;
  final bool isWon;
  const _FixtureMatchItemWidget(
      {required this.homeTeam,
      required this.awayTeam,
      required this.predictionSide,
      required this.score,
      required this.statusString,
      required this.handicapValue,
      required this.handicapPrice,
      required this.isWon,
      required this.predicitonType,
      required this.isHomeTeamUpper});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: isWon
            ? Colors.green.shade100.withAlpha(50)
            : Colors.red.shade100.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: isWon ? Colors.greenAccent : Colors.redAccent),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          children: [
                        TextSpan(text: homeTeam),
                        if (predicitonType == "body" && isHomeTeamUpper)
                          TextSpan(
                            text:
                                " (${handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${handicapPrice?.withSignPrefix(withoutSpace: true)})",
                            style: TextStyle(color: Colors.blueAccent.shade100),
                          )
                      ])),
                  const Text(
                    "Vs",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          children: [
                        TextSpan(text: awayTeam),
                        if (predicitonType == "body" && !isHomeTeamUpper)
                          TextSpan(
                            text:
                                " (${handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${handicapPrice?.withSignPrefix(withoutSpace: true)})",
                            style: TextStyle(color: Colors.blueAccent.shade100),
                          )
                      ])),
                ],
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isWon
                          ? Colors.greenAccent.shade100.withAlpha(100)
                          : Colors.redAccent.shade100.withAlpha(100)),
                  child: Row(
                    children: [
                      if (isWon) ...const [
                        Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.green,
                        ),
                        Gap(5),
                      ],
                      Text(
                        statusString,
                        style: TextStyle(
                            fontSize: 12,
                            color: isWon ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                score,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              if (predicitonType == "goal_total")
                RichText(
                  text: TextSpan(
                      text: predictionSide,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text:
                                "  (${handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${handicapPrice?.withSignPrefix(withoutSpace: true)})",
                            style: TextStyle(color: Colors.deepPurpleAccent))
                      ]),
                )
            ],
          )
        ],
      ),
    );
  }
}
