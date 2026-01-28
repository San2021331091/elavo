import 'package:elavo/pages/recipe_page.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RecipeList extends StatefulWidget {
  final String? categoryName;
  final String? areaName;
  final String? ingredientName;

  const RecipeList({super.key, this.categoryName, this.areaName, this.ingredientName});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late Future<List<dynamic>> mealsFuture;

  @override
  void initState() {
    super.initState();
    mealsFuture = fetchMeals();
  }

  // 🔹 Fetch meals dynamically based on category, region, or ingredient
  Future<List<dynamic>> fetchMeals() async {
    final dio = Dio();
    String url;

    if (widget.categoryName != null) {
      url = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}';
    } else if (widget.areaName != null) {
      url = 'https://www.themealdb.com/api/json/v1/1/filter.php?a=${widget.areaName}';
    } else if (widget.ingredientName != null) {
      url = 'https://www.themealdb.com/api/json/v1/1/filter.php?i=${widget.ingredientName}';
    } else {
      return [];
    }

    final response = await dio.get(url);
    return response.data['meals'] ?? [];
  }

  // 🔹 Dynamic AppBar title
  String get pageTitle {
    if (widget.categoryName != null) {
      return widget.categoryName!;
    } else if (widget.areaName != null) {
      return "${widget.areaName} Recipes";
    } else if (widget.ingredientName != null) {
      return "Recipes with ${widget.ingredientName}";
    }
    return "Recipes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: AppWidget.boldfieldTextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 🌈 Background Gradient
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

          // 📄 Recipe Content
          FutureBuilder<List<dynamic>>(
            future: mealsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return const Center(
                  child: Text(
                    "Failed to load recipes",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final meals = snapshot.data!;

              if (meals.isEmpty) {
                return const Center(
                  child: Text(
                    "No recipes found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];

                  return Card(
                    color: Colors.white10,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          meal['strMealThumb'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        meal['strMeal'],
                        style: AppWidget.boldfieldTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white70,
                        size: 18,
                      ),
                      onTap: () async {
                        final dio = Dio();
                        final response = await dio.get(
                          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${meal['idMeal']}',
                        );

                        final fullMeal = response.data['meals'][0];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipePage(meal: fullMeal),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
