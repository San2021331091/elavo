import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elavo/widget/support_widget.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _recipes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() => _loading = true);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      final data =
          await supabase.from('recipes').select().eq('user_id', userId)
              as List<dynamic>;

      setState(
        () => _recipes = data.map((e) => e as Map<String, dynamic>).toList(),
      );
    } catch (e) {
      debugPrint("Fetch recipes error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fetch recipes: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteRecipe(String id) async {
    try {
      await supabase.from('recipes').delete().eq('id', id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Recipe deleted")));
      _fetchRecipes();
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
    }
  }

  Future<void> _updateRecipe(Map<String, dynamic> recipe) async {
    // Show dialog to update name/details
    final nameController = TextEditingController(
      text: recipe['name'] as String? ?? '',
    );
    final detailsController = TextEditingController(
      text: recipe['details'] as String? ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.red,
        title: Text(
          "Update Recipe",
          style: AppWidget.boldfieldTextStyle(color: Colors.yellow),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                style: AppWidget.lightfieldTextStyle(color: Colors.yellow),
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: AppWidget.boldfieldTextStyle(color: Colors.white,fontSize: 22.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                style: AppWidget.lightfieldTextStyle(color: Colors.yellow),
                controller: detailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Details",
                  labelStyle: AppWidget.boldfieldTextStyle(color: Colors.white,fontSize: 22.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppWidget.lightfieldTextStyle(color: Colors.yellow),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            onPressed: () async {
              final name = nameController.text.trim();
              final details = detailsController.text.trim();
              if (name.isEmpty || details.isEmpty) return;

              try {
                await supabase
                    .from('recipes')
                    .update({'name': name, 'details': details})
                    .eq('id', recipe['id']);

                Navigator.pop(context);
                _fetchRecipes();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Recipe updated")));
              } catch (e) {
                debugPrint("Update error: $e");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Failed to update: $e")));
              }
            },
            child: Text(
              "Update",
              style: AppWidget.lightfieldTextStyle(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe['image_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe['image_url'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: Colors.white24,
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              recipe['name'] ?? '',
              style: AppWidget.boldfieldTextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              recipe['details'] ?? '',
              style: AppWidget.lightfieldTextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _updateRecipe(recipe),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteRecipe(recipe['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "My Recipes",
              style: AppWidget.boldfieldTextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
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
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _recipes.isEmpty
            ? const Center(
                child: Text(
                  "No recipes found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : RefreshIndicator(
                onRefresh: _fetchRecipes,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _recipes.length,
                  itemBuilder: (_, index) => _buildRecipeCard(_recipes[index]),
                ),
              ),
      ),
    );
  }
}
