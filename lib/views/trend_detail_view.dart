import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/entities/detail.dart';
import 'package:flutter_application_1/repositories/gifs_repository.dart';


class TrendDetailView extends StatefulWidget {
  const TrendDetailView({Key? key, required this.title, required this.term, this.isCategory = false});

  final String title;
  final String term;
  final bool isCategory;

  @override
  State<TrendDetailView> createState() => _TrendDetailViewState();
}

class _TrendDetailViewState extends State<TrendDetailView> {
  final GifsRepository _repository = GifsRepository(); 

  List<Detail> gifs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSearch();
    gifs.clear();
  }

  void fetchSearch() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      
      List<Detail> fetchedGifs = await _repository.fetchSearch(widget.term, widget.isCategory);
      setState(() {
        gifs.addAll(fetchedGifs);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchSearch();
            return true;
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: const Color.fromARGB(0, 0, 0, 0),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: gifs[index].url,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                childCount: gifs.length,
              ),
            ),
            SliverToBoxAdapter(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}