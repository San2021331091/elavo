import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:elavo/pages/recipe_list.dart';
import 'package:elavo/widget/support_widget.dart';

class IngredientDropdown extends StatefulWidget {
  const IngredientDropdown({super.key});

  @override
  State<IngredientDropdown> createState() => _IngredientDropdownState();
}

class _IngredientDropdownState extends State<IngredientDropdown> {
  String? selectedIngredient;
  List<String> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/list.php?i=list',
      );

      final data = response.data['meals'] as List;

      setState(() {
        ingredients = data.map((e) => e['strIngredient'].toString()).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Ingredient load error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Recipes by Ingredient',
            style: AppWidget.boldfieldTextStyle(
              color: Colors.yellowAccent,
              fontSize: 19.0,
            ),
          ),
          const SizedBox(height: 10),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.yellowAccent),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedIngredient,
                      hint: const Text(
                        "Select Ingredient",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.red,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.yellow),
                      isExpanded: true,
                      items: ingredients.map((ingredient) {
                        return DropdownMenuItem(
                          value: ingredient,
                          child: Text(
                            ingredient,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() => selectedIngredient = value);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeList(ingredientName: value),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
