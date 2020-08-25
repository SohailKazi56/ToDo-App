import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String userInput = "";

  createtodostask()  {
    
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(userInput);

    Map<String, String> todos = { "todoTitle" : userInput };
 
    documentReference.set(todos).whenComplete((){
      print("$userInput created");
    });
    }

  deletetodostask(item){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(item);
    documentReference.delete().whenComplete((){
      print("deleted");
    });
  }

  void showAlertDialog(){
    showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    onChanged: (String value){
                      userInput = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.red[900],
                      textColor: Colors.white,
                      splashColor: Colors.redAccent,
                      onPressed: (){
                        createtodostask();
                        Navigator.of(context).pop();
                      },
                      child: Text("ADD"),
                    ),
                  )
                ],
              ),
            )
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text("ToDo Tasks",style: TextStyle(fontFamily: "Raleway",fontSize: 24),),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAlertDialog,
        splashColor: Colors.redAccent,
        backgroundColor: Colors.red[900],
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 38,
        ),
      ),
      
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(), builder: (context, snapshots) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshots.data.docs.length,
          itemBuilder: (context,  index){
            DocumentSnapshot documentSnapshot = snapshots.data.docs[index];
            return Dismissible(
              onDismissed: (direction){
                deletetodostask(documentSnapshot.data()["todoTitle"]);
              },
              key: Key(documentSnapshot.data()["todoTitle"]),
                child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                elevation: 10,
                child: ListTile(
                  
                  title: Text(documentSnapshot.data()["todoTitle"]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,color: Colors.red[900],size: 30,),
                    onPressed: (){
                      setState(() {
                      deletetodostask(documentSnapshot.data()["todoTitle"]);
                      });
                    }
                  ),
                ),
              )
            );
          },
        );

      })
    );
  }
}