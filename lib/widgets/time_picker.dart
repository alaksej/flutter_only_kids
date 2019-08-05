import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final List<TimeOfDay> timeSlots;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  const TimePicker({
    Key key,
    this.timeSlots = const <TimeOfDay>[],
    this.selectedTime,
    this.selectTime,
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

  bool isSelected(TimeOfDay time) {
    return selectedTime != null && time.hour == selectedTime.hour && time.minute == selectedTime.minute;
  }

  Color slotColor(BuildContext context, TimeOfDay slot) {
    return isSelected(slot) ? Theme.of(context).accentColor : Theme.of(context).scaffoldBackgroundColor;
  }

  Widget _buildTimeSlot(BuildContext context, TimeOfDay slot) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: slotColor(context, slot),
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        radius: 0,
        onTap: !isSelected(slot)
            ? () {
                selectTime(slot);
              }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isSelected(slot)
                ? Text(
                    slot.format(context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: Theme.of(context).textTheme.subhead.fontSize,
                    ),
                  )
                : Text(
                    slot.format(context),
                  ),
          ],
        ),
      ),
    );
  }
}
