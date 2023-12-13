import 'package:flutter/material.dart';

import '../utils/constants/styles.dart';
import '../utils/services/datetime_formatter.dart';
import 'date_check_box.dart';
import 'selection_check_box.dart';

class DateTimeSelectionView extends StatefulWidget {
  DateTimeSelectionView({
    this.dateTitle,
    this.timeTitle,
    this.dateSelections,
    this.timeSelections,
    this.onDateSelected,
    this.onTimeSelected,
    this.selectedDate,
    this.selectedTime,
    this.interval,
  });

  final String? dateTitle;
  final String? timeTitle;
  final List<dynamic>? dateSelections;
  final List<dynamic>? timeSelections;
  final Function(String)? onDateSelected;
  final Function(String)? onTimeSelected;
  final String? selectedDate;
  final String? selectedTime;
  final int? interval;

  @override
  _DateTimeSelectionViewState createState() => _DateTimeSelectionViewState();
}

class _DateTimeSelectionViewState extends State<DateTimeSelectionView> {
  showTimeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.timeTitle!,
                      style: kTitleTextStyle,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      List<dynamic> times = widget.timeSelections!;

                      return SelectionCheckBox(
                        onPressed: () {
                          widget.onTimeSelected!(times[index]);
                        },
                        isSelected: (widget.selectedTime == times[index]),
                        label: widget.interval != null
                            ? '${times[index]} - ${DatetimeFormatter().getStrTimeAfterMinute(time: times[index], interval: widget.interval!)}'
                            : '${times[index]}',
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: widget.timeSelections!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          widget.dateTitle!,
          style: kAddressTextStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          height: 40,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> dateData = widget.dateSelections![index];
              String date = dateData.keys.first;
              return DateCheckBox(
                onPressed: () {
                  widget.onDateSelected!(date);
                },
                isSelected: (widget.selectedDate == date),
                date: date,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10.0);
            },
            itemCount: widget.dateSelections!.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          widget.timeTitle!,
          style: kAddressTextStyle,
        ),
        GestureDetector(
            onTap: () {
              showTimeBottomSheet();
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.interval != null
                        ? '${widget.selectedTime} - ${DatetimeFormatter().getStrTimeAfterMinute(time: widget.selectedTime!, interval: widget.interval!)}'
                        : '${widget.selectedTime}',
                    style: kDetailsTextStyle,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showTimeBottomSheet();
                    },
                    child: Container(
                        width: 35.0,
                        height: 35.0,
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          "images/ic_calendar.png",
                        )),
                  )
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.calendar_today,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     showTimeBottomSheet();
                  //   },
                  // )
                ],
              ),
            )),
      ],
    );
  }
}
