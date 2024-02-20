import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/recipe_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Recipe extends StatefulWidget {
  final RecipeModel selectedRecipe;
  final void Function(RecipeModel)? addToFavorites; // Nullable function type

  const Recipe({
    Key? key,
    required this.selectedRecipe,
    this.addToFavorites, // Nullable parameter
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeState();
}

var count = 0;

class _RecipeState extends State<Recipe> {
  final ScrollController _scrollController = ScrollController();
  bool isFavorite = false; // Track the favorite state

  void _defaultAddToFavorites(RecipeModel recipe) {
    // Default function that does nothing
  }

  // Function to add recipe to favorites
  void _addToFavoritesFunction(RecipeModel recipe) {
    if (widget.addToFavorites != null) {
      widget.addToFavorites!(recipe);
    } else {
      // If the addToFavorites function is not provided, use the default function
      _defaultAddToFavorites(recipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            SizedBox.fromSize(
              size: const Size.fromHeight(300),
              child: Image.network(
                widget.selectedRecipe.image_url,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Add your favorite button functionality here
                  setState(() {
                    isFavorite = !isFavorite; // Toggle the favorite state
                  });
                  // Call addToFavorites function
                  _addToFavoritesFunction(widget.selectedRecipe);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 320, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedRecipe.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.selectedRecipe.author,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      launchUrlString(widget.selectedRecipe.url);
                    },
                    child: Text(
                      widget.selectedRecipe.url,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontStyle:
                            Theme.of(context).textTheme.bodySmall?.fontStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.selectedRecipe.description,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Ingredients:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  // Display Ingredients using Column

                  for (String ingredient in widget.selectedRecipe.ingredients)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '- $ingredient',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    'Instructions:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),

                  // Display Instructions using Column
                  for (String instruction in widget.selectedRecipe.method)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "${count++}. $instruction",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        backgroundColor: Theme.of(context).cardColor,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
