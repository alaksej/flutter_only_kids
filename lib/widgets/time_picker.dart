import 'package:flutter/material.dart';
import 'package:only_kids/models/time_slot.dart';

class TimePicker extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final TimeSlot selected;
  final ValueChanged<TimeSlot> select;

  const TimePicker({
    Key key,
    this.timeSlots = const <TimeSlot>[],
    this.selected,
    this.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: orientation == Orientation.portrait ? 5 : 10,
      children: _buildTimeSlots(context),
    );
  }

  List<Widget> _buildTimeSlots(
    BuildContext context,
  ) {
    return timeSlots.map((slot) => _buildTimeSlot(context, slot)).toList();
  }

  bool isSelected(TimeSlot slot) {
    return selected != null && slot.equals(selected);
  }

  Widget _buildTimeSlot(BuildContext context, TimeSlot slot) {
    final themeData = Theme.of(context);
    final slotBgColor = isSelected(slot) ? themeData.accentColor : themeData.scaffoldBackgroundColor;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: slotBgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        radius: 0,
        onTap: slot.isSelectable
            ? () {
                select(slot);
              }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isSelected(slot)
                ? Text(
                    slot.timeOfDay.format(context),
                    style: TextStyle(
                      color: themeData.colorScheme.onSecondary,
                      fontSize: themeData.textTheme.subhead.fontSize,
                    ),
                  )
                : slot.isSelectable
                    ? Text(
                        slot.timeOfDay.format(context),
                      )
                    : Text(
                        slot.timeOfDay.format(context),
                        style: TextStyle(
                          color: themeData.disabledColor,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
