import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'DatabaseService.dart';
import '../model/todo.dart';
import '../login.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _reference = FirebaseFirestore.instance.collection('todos');
  var UID = AuthServices.UID;
  late Stream<QuerySnapshot> stream =_reference.where("userID", isEqualTo: UID).snapshots();
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final name = AuthServices.NAME;
  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // for (ToDo todoo in _foundToDo.reversed)
                      //   ToDoItem(
                      //     todo: todoo,
                      //     onToDoChanged: _handleToDoChange,
                      //     onDeleteItem: _deleteToDoItem,
                      //   ),
                      StreamBuilder<QuerySnapshot>(
                        stream: stream,
                        builder: (BuildContext contex, AsyncSnapshot snapshot){
                          if (snapshot.hasError) {
                            return Center(child: Text('Some error occurred ${snapshot.error}'));
                          }
                          if(snapshot.hasData){
                            QuerySnapshot querySnapshot = snapshot.data;
                            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                            List<Map> items = documents.map((e) => e.data() as Map).toList();
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {


                                return ToDoItem(todo: ToDo.mapping(items[index] as Map<String,dynamic>), onToDoChanged: _handleToDoChange, onDeleteItem: _deleteToDoItem);
                              },
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    updateToDo(todo.id,todo.isDone);
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
    deleteToDo(id);
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
    createToDo(toDo, UID);
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        IconButton(onPressed: ()async {
          await SessionManager().set("isLoggedIn", false);
          await SessionManager().set("UID", "");
          AuthServices().SignOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyLogin()));
        }, icon: new Icon(Icons.logout_sharp,color: Colors.redAccent,)),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpeg'),
          ),
        ),
      ]),
    );
  }
}

Future createToDo(text,uid) async {
  final todo = FirebaseFirestore.instance.collection("todos").doc();
  final obj = {
    "id":todo.id,
    "todoText":text,
    "isDone":false,
    "userID":uid
  };
  await todo.set(obj);
}
Future deleteToDo(id) async {
  final todo = FirebaseFirestore.instance.collection("todos").doc(id);
  await todo.delete();
}
Future updateToDo(id,updatedWorkDone) async {
  final todo = FirebaseFirestore.instance.collection("todos").doc(id);
  await todo.update({
    "isDone":updatedWorkDone
  });
}