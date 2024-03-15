import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/gifs_repository.dart';
import 'package:flutter_application_1/views/trend_detail_view.dart';


class TrendView extends StatefulWidget {
  const TrendView({Key? key, required this.title});

  final String title;

  @override
  State<TrendView> createState() => _TrendViewState();
}

class _TrendViewState extends State<TrendView> {
  final GifsRepository _repository = GifsRepository(); // Créez une instance du repository

  List<String> terms = []; // Initialisez la liste des gifs

  @override
  void initState() {
    super.initState();
    fetchTrends(); // Appelez la fonction pour récupérer les gifs lors de l'initialisation de l'état
  }

  Future<void> fetchTrends() async {
    // Récupérez les gifs à partir du repository
    List<String> fetchedGifs = await _repository.fetchTrends();
    setState(() {
      terms = fetchedGifs; // Mettez à jour la liste des gifs dans l'état
    });
  }

  void _goToDetail(String term) {
    // Naviguez vers la vue de détail
    _repository.clearCacheValue("search_pos");
    Navigator.push(context, MaterialPageRoute(builder: (_ /*context*/) => TrendDetailView(title: "Detail - $term", term: term, isCategory: false)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Ajoutez une marge de 15 pixels au-dessus de la ListView
          child: ListView.builder(
            itemCount: terms.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _goToDetail(terms[index]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      terms[index],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}