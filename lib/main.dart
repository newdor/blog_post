//Blog-post app is written in Dart for Flutter using Visual Studio Code
//Android Studio was used to emulate a device 
//There is a text input widget
//Posts are saved in a scrollable list view
//Each post displays the author, thumb-up button, and a like counter
//TechWithTim Tutorial# 1-6
//Dart is a typed language like Java

import 'package:flutter/material.dart';

void main() { //Entry point of the app
  runApp(MyApp());
}

class Post {
  String body;
  String author;
  int likes = 0;
  bool userLiked = false;

  Post(this.body, this.author); //Constructor which has to be passed a body and author.

  void likePost() { //This method reverses the user's like. 
    this.userLiked = !this.userLiked; //If once liked and clickded again it will be unliked and vice versa.
    if(this.userLiked) { //Likes counter
      this.likes += 1;
    } else {
      this.likes -= 1;
    }
  }
}

class MyApp extends StatelessWidget {
  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( //Sets up the actual app and define a homepage for it
      title: 'Newshas App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity, //Adapts to different OS
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget { //Shorthand stful
  @override //Stateful widget has two classes.
  _MyHomePageState createState() => _MyHomePageState(); //This class handles the states and rendering.
}

class _MyHomePageState extends State<MyHomePage> { 
  List<Post> posts = []; //Empty list of posts

  void newPost(String text) {
    this.setState(() { //Changing the state of this widget.
      posts.add(new Post(text, "Newsha")); //body and author
      //This updates the posts and that value passes to PostList in the build method.
    });
  }

  @override
  Widget build(BuildContext context) { //build method
    return Scaffold( //Scaffold widget sets up the basic structure of a page
        appBar: AppBar(title: Text('Blog Post')), //Title bar
        body: Column(children: <Widget>[ //children takes a list of widgets.
          Expanded(child: PostList(this.posts)), 
          //Expanded takes up the entire screen
          TextInputWidget(this.newPost)
        ]));
  }
}

class TextInputWidget extends StatefulWidget { //This class handles the constructor.
  final Function(String) callback; //callback is a mandatory parameter passed whenever this constructor is created.

  TextInputWidget(this.callback); //Creates a constructor which takes callback method as parameter.

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> { //This class handles the states, like dispose and click.
  final controller = TextEditingController(); //controller object helps us modify the text input.

  @override //This is an override from the parent class.
  void dispose() { //When this widget is done we need to clean it up to not use any space in the memory.
    super.dispose();
    controller.dispose();
  }

void click() {
  widget.callback(controller.text);
  controller.clear();
  FocusScope.of(context).unfocus(); //Unfocus the text field (Collapses the virtual keyboard.)
}

  @override
  Widget build(BuildContext context) {
    return 
      TextField(
        controller: this.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.message), 
          labelText: "Type a message:", 
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            splashColor: Colors.pinkAccent,
            tooltip: "Post message", //What the button means.
            onPressed: this.click, //Calls click method.
            )));
  }
}

class  PostList extends StatefulWidget { //stfl
  final List<Post> listItems; //Saves the posts in a list like in MyHomePage

  PostList(this.listItems); //Constructor

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
void like(Function callBack) { // like method updates the state of the like widget on likePost method.
    this.setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length, //How many items in the list
      //listItems is a variable not a widget.
      itemBuilder: (context, index) {
        var post = this.widget.listItems[index]; //Iterates through the list
        return Card( //Card is a block which handles the formatting of the page look (tiles, padding, ..).
          child: Row(children: <Widget>[ //This row displays the text and author
        Expanded( //Takes up the whole row
            child: ListTile( //ListTile has title, subtitle, ...
          title: Text(post.body),
          subtitle: Text(post.author),
        )),
        Row(
          children: <Widget>[
              Container(
                child: 
                    Text(post.likes.toString(), style: TextStyle(fontSize: 20)), //Increases fontsize.
                    //Displays the number of likes as String.
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              ), //LeftTopRightBottom
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () => this.like(post.likePost), //Call on likePost method
                color: post.userLiked ? Colors.pink : Colors.grey) //Condensed if statement
            ],
          )
        ]));
      },
    );
  }
}
