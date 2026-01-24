import 'package:elavo/pages/add_recipe.dart'; 
import 'package:elavo/widget/category_list.dart';
import 'package:elavo/widget/home_header.dart';
import 'package:elavo/widget/search_bar_widget.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:elavo/widget/trending_food_list.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 231, 18, 3),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                SearchBarWidget(),
                SizedBox(height: 20),
                CategoriesList(),
                SizedBox(height: 20),
                TrendingFoodList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
