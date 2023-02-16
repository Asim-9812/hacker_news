

import 'package:flutter/material.dart';
import 'package:hacker_news/story.dart';

class CommentListPage extends StatelessWidget {

  final List<Comment> comments;
  final Story story;

  CommentListPage({required this.story,required this.comments});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text(story.title),
            backgroundColor: Colors.black

        ),
        body: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context,index) {
            return ListTile(
                leading: Container(
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,

                    child: Text("${1+index}",style: const TextStyle(fontSize: 22,color: Colors.black))),
                title: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(comments[index].text,style: const TextStyle(fontSize: 18)),
                )
            );
          },
        )
    );

  }

}