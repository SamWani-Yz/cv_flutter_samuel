import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mon Curriculum Vitae', style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold, fontSize: 30
        )
      ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Color.fromARGB(255, 3, 12, 90),
                    backgroundImage: AssetImage('assets/me.jpg'),
                    //child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'YABEZE WANI Samuel',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 12, 90)
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Étudiant en Réseaux Informatiques et Télécommunications',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 3, 12, 90)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionCard(
              title: 'Formation',
              content: '• Licence en Réseaux Informatiques et Télécommunications - ISIG Goma\n'
                  '• Diplôme d\'État - École secondaire',
            ),

            _buildSectionCard(
              title: 'Expériences',
              content: '• Stage académique chez Global Technologie/Goma\n'
                  '• Projets pratiques : Réseaux, bases de données et applications',
            ),

            _buildSectionCard(
              title: 'Compétences',
              content: 'Techniques : Réseaux informatiques, Flutter, C#, Git, bureautique\n'
                  'Linguistiques : '
                  '- Français, Courant \n'
                  '- Anglais, Intermédiaire \n'
                  '- Swahili, Courant \n'
                  '- Lingala, Courant \n'
            ),

            _buildSectionCard(
              title: 'Centres d\'intérêt',
              content: '• Nouvelles technologies et réseaux\n'
                  '• Développement d\'applications et lecture',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 3, 12, 90),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}