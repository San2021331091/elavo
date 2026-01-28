import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:elavo/pages/recipe_list.dart';
import 'package:elavo/widget/support_widget.dart';

class RegionDropdown extends StatefulWidget {
  const RegionDropdown({super.key});

  @override
  State<RegionDropdown> createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  String? selectedRegion;
  List<String> regions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/list.php?a=list',
      );

      final data = response.data['meals'] as List;

      setState(() {
        regions = data.map((e) => e['strArea'].toString()).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Region load error: $e");
      isLoading = false;
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
            'Explore Recipes by Region',
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
                      value: selectedRegion,
                      hint: const Text(
                        "Select Region",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.red,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.yellow),
                      isExpanded: true,
                      items: regions.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(
                            region,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() => selectedRegion = value);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeList(areaName: value),
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
