import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports/model/teams.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key});

  List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('free-nba.p.rapidapi.com', '/teams'));
    var jsonData = jsonDecode(response.body);
    // Handle the response

    for (var eachTeam in jsonData['data']){
      final team = Team(
          abbreviation: eachTeam['abbreviation'],
          city: eachTeam['city']
      );
      teams.add(team);
    }
    print(teams.length);
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: FutureBuilder(
         future: getTeams(),
         builder: (context, snapshot) {
           // if done loading, then show data
           if (snapshot.connectionState == ConnectionState.done) {
             return ListView.builder(
               itemCount: teams.length,
               itemBuilder: (context, index) {
                 return ListTile(
                   title: Text(teams[index].abbreviation),
                 );
               },
             );
           } else {
             // if it's still loading
             return Center(
               child: CircularProgressIndicator(),
             );
           }
         },
       ),
     );
   }
}