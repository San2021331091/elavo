import 'package:elavo/pages/recipe_page.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RecipeList extends StatefulWidget {
  final String categoryName;

  const RecipeList({super.key, required this.categoryName});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  Future<List<dynamic>> fetchMeals() async {
    final dio = Dio();
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}',
    );

    return response.data['meals'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
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

          // 📄 Content
          FutureBuilder<List<dynamic>>(
            future: fetchMeals(),
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

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];

                  return Card(
                    color: Colors.white.withOpacity(0.12),
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
