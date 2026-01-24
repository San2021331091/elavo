import 'package:elavo/pages/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:elavo/widget/support_widget.dart';


class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();
  bool _loading = false;
  List<dynamic> _results = [];

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await _dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php',
        queryParameters: {'s': query},
      );

      final meals = response.data['meals'] ?? [];
      setState(() {
        _results = meals;
      });
    } catch (e) {
      setState(() {
        _results = [];
      });
      print("Error searching meals: $e");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _navigateToRecipe(String mealName) async {
    // Fetch the specific recipe details
    try {
      final response = await _dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php',
        queryParameters: {'s': mealName},
      );

      final meals = response.data['meals'];
      if (meals != null && meals.isNotEmpty) {
        final meal = meals[0]; // take the first match

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipePage(
              meal: meal, // Pass meal data to the RecipePage
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Meal not found!")),
        );
      }
    } catch (e) {
      print("Error fetching meal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch meal!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 241, 6, 84), AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for food...",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: _searchMeals,
                ),
              ),
              _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon:
                          const Icon(Icons.search_outlined, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _navigateToRecipe(_controller.text);
                        }
                      },
                    ),
            ],
          ),
        ),
        // Dropdown list
        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final meal = _results[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      meal['strMealThumb'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    meal['strMeal'],
                    style: AppWidget.lightfieldTextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _controller.text = meal['strMeal'];
                    setState(() {
                      _results = [];
                    });
                    _navigateToRecipe(meal['strMeal']);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
