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
    return Container(
      child: GridView.count(
        crossAxisCount: 5,
        children: _buildTimeSlots(context),
      ),
    );
  }

  List<Widget> _buildTimeSlots(
    BuildContext context,
  ) {
    return timeSlots
        .map((slot) => isSelected(slot) ? _buildSelectedTimeSlot(context, slot) : _buildTimeSlot(context, slot))
        .toList();
  }

  bool isSelected(TimeOfDay time) {
    return selectedTime != null && time.hour == selectedTime.hour && time.minute == selectedTime.minute;
  }

  Widget _buildSelectedTimeSlot(BuildContext context, TimeOfDay slot) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            slot.format(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: Theme.of(context).textTheme.subhead.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(BuildContext context, TimeOfDay slot) {
    return InkWell(
      onTap: () {
        selectTime(slot);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(slot.format(context)),
        ],
      ),
    );
  }
}
