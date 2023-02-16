

class Comment {
  String text = "";
  final int commentId;
  Story? story;
  Comment({required this.commentId,required this.text});

  factory Comment.fromJSON(Map<String,dynamic> json) {
    return Comment(
        commentId: json["id"],
        text: json["text"]
    );
  }

}

class Story {

  final String title;
  final String url;
  List<int> commentIds = <int>[];

  Story({required this.title,required this.url,required this.commentIds});

  factory Story.fromJSON(Map<String,dynamic> json) {
    return Story(
        title: json["title"]??'',
        url: json["url"]??'',
        commentIds: json["kids"] == null ? <int>[] : json["kids"].cast<int>()
    );
  }

}