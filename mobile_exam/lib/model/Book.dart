
class Book {

  int id;
  String title;
  String status;
  String studentName;
  int pages;
  int usedCount;

  Book(this.title, this.status, this.studentName, this.pages, this.usedCount);
  Book.withId(this.id, this.title, this.status, this.studentName, this.pages, this.usedCount);

  factory Book.fromJson(Map<String, dynamic> json){
    return Book.withId(
        json['id'] as int,
        json['title'] as String,
        json['status'] as String,
        json['student'] as String,
        json['pages'] as int,
        json['usedCount'] as int
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "status": status,
    "student": studentName,
    "pages": pages,
    "usedCount": usedCount
  };
}