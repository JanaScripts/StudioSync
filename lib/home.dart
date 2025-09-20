import 'package:flutter/material.dart';
import 'studio_detail.dart';
import 'account.dart';
import 'booking_history.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void onImageTap(BuildContext context, int index) {

    late final Studio studio;

    switch (index) {
      case 0:
        studio = Studio(
          name: 'Rehearsal Studio 1',
          description: 'Perfect for bands and solo practice sessions. Rehearsal Studio 1 offers a well-equipped and sound-treated environment.',
          imagePath: 'assets/studio1.jpg',
          equipment:
          '• Drum Set\n• Electric Guitar\n• Bass Guitar\n• Keyboard\n• Microphones\n• PA system\n• Acoustic panels\n• Air-conditioned',
          price: '₱ 450.00/hr',
          maxHead: 'Max 7 head',
        );
        break;
      case 1:
        studio = Studio(
          name: 'Rehearsal Studio 2',
          description: 'Ideal for smaller band setups and jam sessions. Rehearsal Studio 2 provides a cozy and acoustically balanced room with essential gear.',
          imagePath: 'assets/studio2.jpg',
          equipment:
          '• 1 Drum Set (4-piece)\n• 1 Electric Guitar\n• 1 Bass Guitar\n• 1 Keyboard (49 keys) with stand\n• 2 Microphones with adjustable stands\n• Basic PA system with mixer\n• Acoustic wall treatment\n• Ventilated with ceiling fan',
          price: '₱ 300.00/hr',
          maxHead: 'Max 5 head',
        );
        break;
      case 2:
        studio = Studio(
          name: 'Rehearsal Studio 3',
          description: 'Designed for solo artists and duos. Rehearsal Studio 3 offers all key instruments in a soundproof environment.',
          imagePath: 'assets/studio3.jpg',
          equipment:
          '• Electronic Drum Kit\n• 1 Electric or Acoustic Guitar\n• 1 Bass Guitar\n• 1 Keyboard (61 keys) with stand\n• 1 Microphone with adjustable stand\n• Compact PA speaker\n• Sound panels for vocal clarity\n• Air-conditioned and quiet',
          price: '₱ 400.00/hr',
          maxHead: 'Max 3 head',
        );
        break;
      case 3:
        studio = Studio(
          name: 'Rehearsal Studio 4',
          description: 'Spacious and geared for full band practices. Rehearsal Studio 4 features high-end equipment and excellent acoustics.',
          imagePath: 'assets/studio4.jpg',
          equipment:
          '• 1 Drum Set (5-piece) with upgraded cymbals\n• 2 Electric Guitars\n• 1 Bass Guitar\n• 1 Synthesizer Keyboard with stand\n• 3 Microphones with premium stands\n• Full PA system with subwoofer\n• Bass traps and acoustic wall treatment\n• Fully air-conditioned',
          price: '₱ 500.00/hr',
          maxHead: 'Max 10 head',
        );
        break;
      case 4:
        studio = Studio(
          name: 'Rehearsal Studio 5',
          description: 'Meant for vocal groups and acoustic sets. Rehearsal Studio 5 offers simplicity and excellent vocal clarity.',
          imagePath: 'assets/studio5.jpg',
          equipment:
          '• 1 Digital Piano\n• 4 Microphones with adjustable stands\n• Lightweight PA system\n• Guitar and ukulele stand\n• Foldable chairs and music stands\n• Treated walls for vocals\n• Comfort cooling with fan',
          price: '₱ 400.00/hr',
          maxHead: 'Max 5 head',
        );
        break;
      case 5:
        studio = Studio(
          name: 'Rehearsal Studio 6',
          description: 'A premium rehearsal space built for recording sessions and high-level rehearsals.',
          imagePath: 'assets/studio6.jpg',
          equipment:
          '• High-end Drum Kit (6-piece) with cymbals and throne\n• 3 Electric Guitars\n• 1 Bass Guitar\n• 2 Keyboards (61 and 88 keys) with premium stand\n• 4 Microphones with shock mounts\n• Professional-grade mixer and studio monitors\n• Full acoustic treatment\n• Fully air-conditioned',
          price: '₱ 600.00/hr',
          maxHead: 'Max 12 head',
        );
        break;
    }

    // Navigate to the StudioDetail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudioDetailPage(
          studio: studio,
          username: widget.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: SideMenu(username: widget.username),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: openSideMenu,
        ),
        title: Text('StudioSync', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rehearsal Studios',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.80,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onImageTap(context, index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/studio${index + 1}.jpg',
                              height: 175,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Rehearsal Studio ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final String username;

  const SideMenu({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[850],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Role: ${username == 'admin' ? 'Admin' : 'User'}',
                    style: TextStyle(color: Colors.grey[400])),
                SizedBox(height: 8),
                Text('bio', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
          ListTile(
            title: Text('Account', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage(username: username)),
              );
            },
          ),
          ListTile(
            title:
            Text('Booking History', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingHistoryPage(username: username),
                ),
              );
            },

          ),
        ],
      ),
    );
  }
}
