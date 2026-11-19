import 'package:flutter/material.dart';

class Famille extends StatelessWidget {
  const Famille({super.key});

  @override
  Widget build(BuildContext context) {
   
    final List<Map<String, String>> members = [
      {
        'name': 'WANI MUZURO David',
        'relation': 'Père',
        'profession': 'Ir Agronome',
        'image': 'assets/dad.jpg',
      },
      {
        'name': 'AZONYE LUMAGO Myriam',
        'relation': 'Mère',
        'profession': 'Infirmière/Entrepreneuse',
        'image': 'assets/mom.jpg',
      },
      {
        'name': 'AYIKO WANI Alain',
        'relation': 'Frère',
        'profession': 'Dr en Médecine',
        'image': 'assets/dr.jpg',
      },
    {
        'name': 'ARIYE WANI Gracia',
        'relation': 'Soeur',
        'profession': 'Ir en Informatique',
        'image': 'assets/gaga.jpg',
      },
      {
        'name': 'Rehema WANI',
        'relation': 'Soeur',
        'profession': 'Coutirière',
        'image': 'assets/rr.jpg',
      },
      {
        'name': 'Shammah WANI',
        'relation': 'Soeur',
        'profession': 'Entrepreneuse',
        'image': 'assets/apata.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ma Famille',
          style: TextStyle(color: Colors.white, 
          fontWeight: FontWeight.bold,
          fontSize: 30
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Color.fromARGB(255, 3, 12, 90),
                    // Pour afficher une image locale :
                    backgroundImage: AssetImage(member['image']!),
                    onBackgroundImageError: (exception, stackTrace) {
                    debugPrint('Erreur image ${member['image']} : $exception');
                  },
                    //child: Icon(Icons.person, size: 34, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name']!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 3, 12, 90),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lien : ${member['relation']!}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Profession : ${member['profession']!}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}