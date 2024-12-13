class AlertMessage {
  int? id;
  String? title;
  String? message;

  AlertMessage({this.message, this.title, this.id});

  factory AlertMessage.fromJson(Map<String, dynamic> json) {
    String? title = json['title'];
    String? message = json['message'];
    int? id = json['id'];
    return AlertMessage(title: title, message: message, id: id);
  }

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (message != null) 'message': message,
    if (id != null) 'id': id,
  };
}
