class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Exercise', isDone: false ),
      ToDo(id: '02', todoText: 'Drink water', isDone: false ),
      ToDo(id: '02', todoText: 'Eat healthy', isDone: false ),

    ];
  }
  factory ToDo.mapping(Map<String,dynamic>json){
    return ToDo(
        id:json['id'],
        todoText: json['todoText'],
        isDone: json['isDone']
    );
  }
  Map<String,dynamic> toJson(id,title,isDone){
    return{
      'id':id,
      'todoText':title,
      'isDone':isDone
    };
  }
  static ToDo fromJson(Map<String, dynamic> json){
return ToDo(
  id:json['id'],
  todoText: json['todoText'],
  isDone: json['isDone']
);
  }
  @override
  String toString() {
    // TODO: implement toString
    return "ToDo(id:$id, todoText:$todoText, isDone:$isDone)";
  }
}