part of '../dialog_manager.dart';

class _LeagueFilterBottomSheetWidget extends StatefulWidget {
  final List<LeagueModel> leagues;
  final Function(List<num> leagues) onApply;
  final List<num> selectedIds;
  const _LeagueFilterBottomSheetWidget(
      {super.key,
      required this.leagues,
      required this.onApply,
      required this.selectedIds});

  @override
  State<_LeagueFilterBottomSheetWidget> createState() =>
      _LeagueFilterBottomSheetWidgetState();
}

class _LeagueFilterBottomSheetWidgetState
    extends State<_LeagueFilterBottomSheetWidget> {
  late List<num> selected;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    selected = List<num>.from(widget.selectedIds);
    selectAll = false;
  }

  void _onSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      if (selectAll) {
        selected = widget.leagues.map((e) => e.id ?? -1).toList();
      } else {
        selected.clear();
      }
    });
  }

  void _onLeagueTap(int idx, bool? value) {
    setState(() {
      final id = widget.leagues[idx].id;
      if (id == null) return;
      if (value == true) {
        if (!selected.contains(id)) selected.add(id);
      } else {
        selected.remove(id);
      }
      selectAll = selected.length == widget.leagues.length;
    });
  }

  _onApply() {
    widget.onApply(selected);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.9;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leagues',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppResources.colors.neutral800,
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: _onSelectAll,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    'Select All',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppResources.colors.neutral800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: widget.leagues.length,
              separatorBuilder: (context, index) => Gap(10),
              itemBuilder: (context, i) {
                final id = widget.leagues[i].id;
                final checked = id != null && selected.contains(id);
                return GestureDetector(
                  onTap: () {
                    _onLeagueTap(i, !checked);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE4E9F2)),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: checked,
                          onChanged: (val) => _onLeagueTap(i, val),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.leagues[i].name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppResources.colors.neutral800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('Close'))),
              const Gap(5),
              Expanded(
                  child: ElevatedButton(
                onPressed: _onApply,
                child: Text("Apply"),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
