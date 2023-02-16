import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hacker_news/story.dart';
import 'package:hacker_news/service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Story> _stories = <Story>[];

  @override
  void initState() {
    super.initState();
    _populateTopStories();
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  void _navigateToShowCommentsPage(BuildContext context, int index) async {
    final story = _stories[index];
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    debugPrint("$comments");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CommentListPage(story: story, comments: comments)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hacker News"),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemCount: _stories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  _navigateToShowCommentsPage(context, index);
                },
                title: Text(_stories[index].title,
                    style: const TextStyle(fontSize: 18)),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("${_stories[index].commentIds.length}",
                          style: const TextStyle(color: Colors.white)),
                    )),
              ),
            );
          },
        ));
  }
}
