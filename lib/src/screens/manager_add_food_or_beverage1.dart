import 'package:flutter/material.dart';

class AddFoodOrBeveragePage extends StatelessWidget {
  const AddFoodOrBeveragePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food or Beverage'),
      ),
      body: Center(
        child: Padding(
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
                                label: 'Name of Food/Beverage',
                                hint: 'Enter name',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: 'Quantity',
                                hint: 'Enter quantity',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: 'Price',
                                hint: 'Enter price',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
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
                                onPressed: () {
                                  // Save logic goes here
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
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
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
