import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FoodBeverageItem {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  FoodBeverageItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  // Convert FoodBeverageItem to a Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create FoodBeverageItem from a Map
  factory FoodBeverageItem.fromMap(Map<String, dynamic> map) {
    return FoodBeverageItem(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
    );
  }
}

class AddFoodOrBeveragePage extends StatelessWidget {
  const AddFoodOrBeveragePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food or Beverage'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Food/Beverage Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: nameController,
                                label: 'Name of Food/Beverage',
                                hint: 'Enter name',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: quantityController,
                                label: 'Quantity',
                                hint: 'Enter quantity',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: priceController,
                                label: 'Price',
                                hint: 'Enter price',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: imageUrlController,
                                label: 'Image Link',
                                hint: 'Enter image URL',
                                keyboardType: TextInputType.url,
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.save),
                                label: const Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    isDesktop ? 200 : double.infinity,
                                    50,
                                  ),
                                ),
                                onPressed: () async {
                                  final String name = nameController.text;
                                  final int quantity =
                                      int.tryParse(quantityController.text) ??
                                          0;
                                  final double price =
                                      double.tryParse(priceController.text) ??
                                          0.0;
                                  final String imageUrl =
                                      imageUrlController.text;

                                  if (name.isNotEmpty && imageUrl.isNotEmpty) {
                                    final newItem = FoodBeverageItem(
                                      name: name,
                                      quantity: quantity,
                                      price: price,
                                      imageUrl: imageUrl,
                                    );

                                    final box = await Hive.openBox<Map>(
                                        'food_beverage_items');
                                    box.add(newItem.toMap());

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Item saved successfully!')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please fill all required fields.')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isDesktop) ...[
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.restaurant_menu,
                                  size: 120,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Add delicious food or refreshing beverages to your POS system.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
