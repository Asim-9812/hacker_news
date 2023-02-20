import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hacker_news/story.dart';
import 'package:hacker_news/service.dart';
import 'package:intl/intl.dart';
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
            var millis = _stories[index].time;
            var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
            var d12 = DateFormat('hh:mm a').format(dt);
            var url= Uri.parse(_stories[index].url);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw "Could not launch $url";
                  }
                },
                leading: Text( '${1+ index}'),
                title: Text(_stories[index].title,
                    style: const TextStyle(fontSize: 18)),
                subtitle: InkWell(
                  onTap:(){
                    _navigateToShowCommentsPage(context, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("${_stories[index].commentIds.length} comments | ${d12.toString()}",
                        style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ));
          },
        ));
  }
}
