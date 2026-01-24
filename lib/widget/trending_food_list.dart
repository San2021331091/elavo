import 'package:elavo/pages/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:elavo/widget/support_widget.dart';


class TrendingFoodList extends StatefulWidget {
  const TrendingFoodList({super.key});

  @override
  State<TrendingFoodList> createState() => _TrendingFoodListState();
}

class _TrendingFoodListState extends State<TrendingFoodList> {
  // Fetch 10 random meals for trending list
  Future<List<dynamic>> fetchTrendingMeals() async {
    final dio = Dio();
    List<dynamic> meals = [];

    for (int i = 0; i < 10; i++) {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/random.php',
      );
      meals.add(response.data['meals'][0]);
    }

    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'Trending Recipes',
              style: AppWidget.boldfieldTextStyle(
                color: Colors.yellowAccent,
                fontSize: 18.0,
              ),
            ),
          ),
          // Horizontal list of meals
          SizedBox(
            height: 320,
            child: FutureBuilder<List<dynamic>>(
              future: fetchTrendingMeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                    child: Text("Failed to load trending recipes"),
                  );
                }

                final meals = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];

                    return GestureDetector(
                      onTap: () async {
                        final dio = Dio();

                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );

                        try {
                          final response = await dio.get(
                            'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${meal['idMeal']}',
                          );

                          final fullMeal = response.data['meals'][0];

                          Navigator.pop(context); // Close loader

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipePage(meal: fullMeal),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context); // Close loader

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to load recipe")),
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                meal['strMealThumb'],
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: Text(
                                meal['strMeal'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppWidget.lightfieldTextStyle(
                                  color: Colors.yellow.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
