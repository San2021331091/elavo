import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elavo/pages/myrecipe_page.dart';
import 'package:elavo/widget/support_widget.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _uploadedImageUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  bool _loading = false;
  bool _uploadingImage = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt,color:Colors.green),
              title: Text(
                "Take Photo",
                style: AppWidget.lightfieldTextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,color: Colors.red,),
              title: Text(
                "Choose from Gallery",
                style: AppWidget.lightfieldTextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _uploadToImgbb(File image) async {
    try {
      setState(() => _uploadingImage = true);
      final apiKey = dotenv.env['IMGBB_API_KEY'];
      if (apiKey == null) throw Exception("IMGBB_API_KEY not found in .env");

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final dio = Dio();
      final response = await dio.post(
        'https://api.imgbb.com/1/upload',
        queryParameters: {'key': apiKey},
        data: FormData.fromMap({'image': base64Image}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data']['url'];
      } else {
        throw Exception("Image upload failed");
      }
    } catch (e) {
      print("ImgBB upload error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image upload failed: $e")));
      return null;
    } finally {
      setState(() => _uploadingImage = false);
    }
  }

  Future<void> _saveRecipe() async {
    final name = _nameController.text.trim();
    final details = _detailsController.text.trim();
    if (name.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and details are required")),
      );
      return;
    }

    if (_selectedImage == null && _uploadedImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }

    setState(() => _loading = true);

    try {
      if (_selectedImage != null && _uploadedImageUrl == null) {
        final uploadedUrl = await _uploadToImgbb(_selectedImage!);
        if (uploadedUrl == null) throw Exception("Image upload failed");
        setState(() => _uploadedImageUrl = uploadedUrl);
      }

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      await Supabase.instance.client.from('recipes').insert({
        'user_id': userId,
        'name': _nameController.text,
        'details': _detailsController.text,
        'image_url': _uploadedImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe saved successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyRecipePage()),
      );
    } catch (e) {
      print("Save recipe error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save recipe: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
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
              "Add Recipe",
              style: AppWidget.boldfieldTextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
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
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            image: _uploadedImageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(_uploadedImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : _selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              (_selectedImage == null &&
                                  _uploadedImageUrl == null)
                              ? const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Recipe Name",
                      style: AppWidget.boldfieldTextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Enter recipe name",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Recipe Details",
                      style: AppWidget.boldfieldTextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _detailsController,
                      hintText: "Enter recipe details",
                      maxLines: 11,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            109,
                            11,
                            4,
                          ),
                        ),
                        onPressed: _loading || _uploadingImage
                            ? null
                            : _saveRecipe,
                        child: _loading || _uploadingImage
                            ? const CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                            : Text(
                                "Save Recipe",
                                style: AppWidget.lightfieldTextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
