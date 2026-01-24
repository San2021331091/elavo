import 'package:elavo/pages/recipe_list.dart';
import 'package:flutter/material.dart';
import 'package:elavo/widget/support_widget.dart';
import 'package:dio/dio.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  Future<List<dynamic>> fetchCategories() async {
    final dio = Dio();

    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/categories.php',
    );

    return response.data['categories'];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'Explore Recipe Categories',
              style: AppWidget.boldfieldTextStyle(color: Colors.yellowAccent,fontSize: 19.0),
            ),
          ),
          SizedBox(
            height: 220,
            child: FutureBuilder<List<dynamic>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading categories'));
                }

                final categories = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return CategoryItem(
                      image: category['strCategoryThumb'],
                      title: category['strCategory'],
                      leftMargin: index == 0 ? 20 : 0,
                      rightMargin: 40,
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

class CategoryItem extends StatelessWidget {
  final String image;
  final String title;
  final double leftMargin;
  final double rightMargin;

  const CategoryItem({
    super.key,
    required this.image,
    required this.title,
    this.leftMargin = 0,
    this.rightMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.35;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeList(categoryName: title),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style:
                  AppWidget.lightfieldTextStyle(color: Colors.yellow.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
