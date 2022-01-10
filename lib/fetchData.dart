import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}

class PostDisplayed extends StatefulWidget {
  const PostDisplayed({Key? key}) : super(key: key);

  @override
  _PostDisplayedState createState() => _PostDisplayedState();
}

class _PostDisplayedState extends State<PostDisplayed> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Кейс 3.2'),
        ),
        body: Center(
            child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                  const Align(alignment: Alignment.topLeft,child: Text('Title:',style: TextStyle(fontSize: 25),)),
                  Text(snapshot.data!.title),
                  Container(margin: const EdgeInsets.only(top: 20),child: const Align(alignment: Alignment.topLeft,child: Text('Body:',style: TextStyle(fontSize: 25),))),
                  Text(snapshot.data!.body)
                ]),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
