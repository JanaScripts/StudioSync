import 'package:flutter/material.dart';
import 'studio_detail.dart';

class AddInstrumentsPage extends StatefulWidget {
  final Studio studio;

  AddInstrumentsPage({required this.studio});

  @override
  _AddInstrumentsPageState createState() => _AddInstrumentsPageState();
}

class _AddInstrumentsPageState extends State<AddInstrumentsPage> {
  int guitarCableCount = 0;
  int micCount = 0;

  int get totalAmount => (guitarCableCount * 30) + (micCount * 50);

  List<String> selectedAddOns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('StudioSync', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.studio.imagePath,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Add ons',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildItemCard(
                        imagePath: 'assets/cable.jpg',
                        title: 'Guitar Cables',
                        price: 30,
                        quantity: guitarCableCount,
                        onAdd: () => setState(() => guitarCableCount++),
                        onRemove: () {
                          if (guitarCableCount > 0) {
                            setState(() => guitarCableCount--);
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      _buildItemCard(
                        imagePath: 'assets/microphone.jpg',
                        title: 'Microphones',
                        price: 50,
                        quantity: micCount,
                        onAdd: () => setState(() => micCount++),
                        onRemove: () {
                          if (micCount > 0) {
                            setState(() => micCount--);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Quantity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  if (guitarCableCount > 0)
                    Text("• Guitar Cables ($guitarCableCount)", style: TextStyle(fontSize: 16)),
                  if (micCount > 0)
                    Text("• Microphones ($micCount)", style: TextStyle(fontSize: 16)),
                  if (guitarCableCount == 0 && micCount == 0)
                    Text("• ", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("₱ $totalAmount/hr", style: TextStyle(fontSize: 24)),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        List<String> selectedAddOnsList = [];
                        if (guitarCableCount > 0) selectedAddOnsList.add('Guitar Cables x$guitarCableCount');
                        if (micCount > 0) selectedAddOnsList.add('Microphones x$micCount');

                        Navigator.pop(context, selectedAddOnsList);
                      },
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String imagePath,
    required String title,
    required int price,
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 60),
          Text(title, style: TextStyle(fontSize: 14)),
          Text('₱$price/hr', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.grey[800]),
                onPressed: quantity > 0 ? onRemove : null,
              ),
              Text('$quantity', style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.grey[800]),
                onPressed: onAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
