import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  final Map<String, dynamic> meal;

  const RecipePage({super.key, required this.meal});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool isLiked = false;

  void _showLikeMenu() async {
    final selected = await showMenu(
      context: context,
      color: const Color.fromARGB(255, 97, 9, 2),
      position: const RelativeRect.fromLTRB(300, 90, 20, 0),
      items:  [
        PopupMenuItem(value: 'favorite', child: Text("❤️ Add to Favorites",style: AppWidget.lightfieldTextStyle(color: Colors.white),)),

        PopupMenuItem(value: 'cancel', child: Text("❌ Cancel",style: AppWidget.lightfieldTextStyle(color: Colors.white ),)),
      ],
    );

    if (selected == 'favorite') {
      setState(() => isLiked = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Added to favorites ❤️")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract ingredients
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = widget.meal['strIngredient$i'];
      final measure = widget.meal['strMeasure$i'];
      if (ingredient != null &&
          ingredient.isNotEmpty &&
          measure != null &&
          measure.isNotEmpty) {
        ingredients.add("$ingredient - $measure");
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                // 🍔 Image
                Stack(
                  children: [
                    Image.network(
                      widget.meal['strMealThumb'] ?? '',
                      width: double.infinity,
                      height: 380,
                      fit: BoxFit.cover,
                    ),

                    // ⬅️ Back Button
                    Positioned(
                      top: 40,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.red,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // ❤️ Like Button
                    Positioned(
                      top: 40,
                      right: 20,
                      child: GestureDetector(
                        onTap: _showLikeMenu,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.red,
                          child: Icon(
                            isLiked ? Icons.favorite_border : Icons.favorite_border_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    // ❌ NO COLOR HERE
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.meal['strMeal'] ?? "Unknown Meal",
                        style: AppWidget.boldfieldTextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 10),

                      if (widget.meal['strCategory'] != null)
                        Text(
                          "Category: ${widget.meal['strCategory']}",
                          style: AppWidget.boldfieldTextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                      if (widget.meal['strArea'] != null)
                        Text(
                          "Cuisine: ${widget.meal['strArea']}",
                          style: AppWidget.boldfieldTextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                      const SizedBox(height: 12),

                      Text(
                        "Instructions",
                        style: AppWidget.boldfieldTextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),

                      Text(
                        widget.meal['strInstructions'] ??
                            "No instructions available",
                        style: AppWidget.lightfieldTextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (ingredients.isNotEmpty) ...[
                        Text(
                          "Ingredients",
                          style: AppWidget.boldfieldTextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...ingredients.map(
                          (i) => Text(
                            "• $i",
                            style: AppWidget.lightfieldTextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
