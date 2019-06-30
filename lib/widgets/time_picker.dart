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
    return timeSlots.map((slot) => _buildTimeSlot(context, slot)).toList();
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
          if (selectedTime != null && slot.hour == selectedTime.hour && slot.minute == selectedTime.minute)
            Text('Picked'),
        ],
      ),
    );
  }
}
