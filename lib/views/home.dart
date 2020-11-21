import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app_vite/models/recipe_model.dart';
import 'package:recipe_app_vite/secrets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>();

  TextEditingController textEditingController = new TextEditingController();

  getRecipes(query) async {
    var url =
        "https://api.edamam.com/search?q=$query&app_id=cbe99236&app_key=$appKey";
    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);

      recipes.add(recipeModel);
    });
  }

  Widget recipeGrid() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 25, crossAxisSpacing: 30, crossAxisCount: 2),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeTile(
              imgUrl: recipes[index].image,
              label: recipes[index].label,
              recipeDetailsUrl: recipes[index].url,
              source: recipes[index].source);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 24, right: 16, left: 16),
        child: Column(
          children: [
            Text(
              "What would you like to eat today?",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
                child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(hintText: "enter"),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                    onTap: () {
                      getRecipes(textEditingController.text);
                    },
                    child: Icon(Icons.search))
              ],
            )),
            recipeGrid()
          ],
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, recipeDetailsUrl;
  RecipeTile(
      {@required this.imgUrl,
      @required this.label,
      @required this.recipeDetailsUrl,
      @required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Column(
          children: [Text(label), Text(source)],
        ),
        Image.network(imgUrl)
      ]),
    );
  }
}
