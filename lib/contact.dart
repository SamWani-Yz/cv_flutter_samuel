import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
  // On retire les espaces pour que le numéro soit propre
  final cleanNumber = phoneNumber.replaceAll(' ', '');
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: cleanNumber,
  );

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de lancer l\'appel sur cet appareil')),
      );
    }
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Contact',
          style: TextStyle(color: Colors.white, 
          fontWeight: FontWeight.bold,
          fontSize: 30
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildContactCard(
            icon: Icons.phone,
            title: 'Téléphone',
            subtitle: '+243 813 564 373',
            onTap: () => _makePhoneCall(context, '+243 813 564 373'),
          ),
          _buildContactCard(
            icon: Icons.email,
            title: 'E-mail',
            subtitle: 'juzdeevynwanisam@gmail.com',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-mail : juzdeevynwanisam@gmail.com')),
              );
            },
          ),
          _buildContactCard(
            icon: Icons.location_on,
            title: 'Adresse',
            subtitle: 'Goma, Nord-Kivu, République Démocratique du Congo',
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              'Réseaux sociaux',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 3, 12, 90),
              ),
            ),
          ),
          _buildContactCard(
            icon: Icons.code,
            title: 'GitHub',
            subtitle: 'https://github.com/dashboard',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil GitHub : github.com/ton-profil')),
              );
            },
          ),
          _buildContactCard(
            icon: Icons.work,
            title: 'LinkedIn',
            subtitle: 'linkedin.com/in/juzdeevynwanisam@gmail.com',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil LinkedIn : linkedin.com/in/ton-profil')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 3, 12, 90),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 12, 90),
          ),
        ),
        subtitle: Text(subtitle),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }
}