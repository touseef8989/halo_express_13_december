class OrderForLaterModel {
  OrderForLaterModel._privateConstructor();
  static final OrderForLaterModel _instance =
      OrderForLaterModel._privateConstructor();

  factory OrderForLaterModel() {
    return _instance;
  }
  String? _selectedDate;
  String? _selectedTime;
  bool? _orderForLater = false;

  void setUserData({
    String? selectedDate,
    String? selectedTime,
    bool? orderForLater,
  }) {
    _selectedDate = selectedDate;
    _selectedTime = selectedTime;
    _orderForLater = orderForLater;
  }

  bool get orderForLater => _orderForLater!;

  String get selectedTime => _selectedTime!;

  String get selectedDate => _selectedDate!;

  void resetOrderForLaterData() {
    _selectedDate = null;
    _selectedTime = null;
    _orderForLater = false;
  }

  set selectedTime(String value) {
    _selectedTime = value;
  }

  set orderForLater(bool value) {
    _orderForLater = value;
  }

  set selectedDate(String value) {
    _selectedDate = value;
  }
}
