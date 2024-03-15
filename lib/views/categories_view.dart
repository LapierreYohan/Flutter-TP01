import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/detail.dart';
import 'package:flutter_application_1/repositories/gifs_repository.dart';
import 'package:flutter_application_1/views/trend_detail_view.dart';


class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key, required this.title});

  final String title;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final GifsRepository _repository = GifsRepository(); // Créez une instance du repository

  List<Detail> categories = []; // Initialisez la liste des gifs

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Appelez la fonction pour récupérer les gifs lors de l'initialisation de l'état
  }

  Future<void> fetchCategories() async {
    // Récupérez les gifs à partir du repository
    List<Detail> fetchedCategories = await _repository.fetchCategory();
    setState(() {
      categories = fetchedCategories; // Mettez à jour la liste des gifs dans l'état
    });
  }

  void _goToDetail(Detail category) {
    _repository.clearCacheValue("search_pos");
    // Naviguez vers la vue de détail
    Navigator.push(context, MaterialPageRoute(builder: (_ /*context*/) => TrendDetailView(title: "Detail - ${category.description}", term: category.description ?? "", isCategory: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _goToDetail(categories[index]);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: categories[index].url,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      categories[index].description ?? "",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}