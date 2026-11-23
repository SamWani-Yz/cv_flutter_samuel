import 'package:flutter/material.dart';
import 'apiService.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Famille extends StatefulWidget {
  const Famille({super.key});

  @override
  State<Famille> createState() => _FamilleState();
}

class _FamilleState extends State<Famille> {
  List<dynamic> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getMembres();
      if (!mounted) return;
      setState(() {
        _members = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _ouvrirFormulaireMembre({Map<String, dynamic>? membreExistant}) {
    final bool estModification = membreExistant != null;

    final nomController =
        TextEditingController(text: membreExistant?['nom']?.toString() ?? '');
    final postnomController = TextEditingController(
        text: membreExistant?['postnom']?.toString() ?? '');
    final prenomController =
        TextEditingController(text: membreExistant?['prenom']?.toString() ?? '');
    final lieuController = TextEditingController(
        text: membreExistant?['lieu_naissance']?.toString() ?? '');
    final dateController = TextEditingController(
        text: membreExistant?['date_naissance']?.toString() ?? '');
    final parenteController = TextEditingController(
        text: membreExistant?['parente']?.toString() ?? '');
    final ImagePicker picker = ImagePicker();
    XFile? imageChoisie;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                estModification ? 'Modifier un membre' : 'Ajouter un membre',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomController,
                      decoration: const InputDecoration(labelText: 'Nom *'),
                    ),
                    TextField(
                      controller: postnomController,
                      decoration: const InputDecoration(labelText: 'Postnom *'),
                    ),
                    TextField(
                      controller: prenomController,
                      decoration: const InputDecoration(labelText: 'Prénom *'),
                    ),
                    TextField(
                      controller: lieuController,
                      decoration: const InputDecoration(
                          labelText: 'Lieu de naissance *'),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance (AAAA-MM-JJ) *',
                      ),
                    ),
                    TextField(
                      controller: parenteController,
                      decoration: const InputDecoration(
                        labelText: 'Lien de parenté (ex: Père, Mère) *',
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final XFile? picked = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            imageChoisie = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text(
                        imageChoisie == null
                            ? 'Ajouter une image'
                            : 'Changer l\'image',
                      ),
                    ),
                    if (imageChoisie != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imageChoisie!.path),
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 12, 90),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final payload = {
                      'nom': nomController.text.trim(),
                      'postnom': postnomController.text.trim(),
                      'prenom': prenomController.text.trim(),
                      'lieu_naissance': lieuController.text.trim(),
                      'date_naissance': dateController.text.trim(),
                      'parente': parenteController.text.trim(),
                    };

                    try {
                      final int? membreId = estModification
                          ? int.tryParse(membreExistant['id'].toString())
                          : null;

                      final Map<String, dynamic> response = imageChoisie != null
                          ? await ApiService.saveMembreMultipart(
                              id: membreId,
                              fields: payload,
                              imagePath: imageChoisie!.path,
                            )
                          : (estModification
                              ? await ApiService.updateMembreJson(
                                  membreId!,
                                  payload,
                                )
                              : await ApiService.createMembreJson(payload));

                      if (!mounted) return;

                      if (response['success'] == true) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response['message']?.toString() ??
                                  (estModification
                                      ? 'Membre modifié'
                                      : 'Membre ajouté'),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _chargerMembres();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response['message']?.toString() ??
                                  'Données invalides',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur : $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(estModification ? 'Enregistrer' : 'Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _supprimerMembre(int id) async {
    try {
      final response = await ApiService.deleteMembre(id);
      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message']?.toString() ?? 'Membre supprimé',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _chargerMembres();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message']?.toString() ?? 'Suppression impossible',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> confirmerSuppression(int id, String nomMembre) async {
    final bool? confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Voulez-vous vraiment supprimer "$nomMembre" de la famille ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirme == true) {
      await _supprimerMembre(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ma Famille',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerMembres,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 3, 12, 90),
        foregroundColor: Colors.white,
        onPressed: () => _ouvrirFormulaireMembre(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _chargerMembres,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : _members.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun membre enregistré. Appuyez sur + pour ajouter.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> member =
                            Map<String, dynamic>.from(_members[index] as Map);

                        final String nomComplet =
                            '${member['nom'] ?? ''} ${member['postnom'] ?? ''} ${member['prenom'] ?? ''}'
                                .trim();
                        final String relation =
                            member['parente']?.toString() ?? '';
                        final String lieu =
                            member['lieu_naissance']?.toString() ?? '';
                        final String dateNaissance =
                            member['date_naissance']?.toString() ?? '';
                        final String? imageUrl =
                            member['image_url']?.toString();

                        final bool hasImageUrl =
                            imageUrl != null && imageUrl.isNotEmpty;

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
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 12, 90),
                                  backgroundImage: hasImageUrl
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  onBackgroundImageError: hasImageUrl
                                      ? (exception, stackTrace) {
                                          debugPrint(
                                              'Erreur image $imageUrl : $exception');
                                        }
                                      : null,
                                  child: !hasImageUrl
                                      ? const Icon(
                                          Icons.person,
                                          size: 34,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nomComplet,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 3, 12, 90),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lien : $relation',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Né(e) à $lieu • $dateNaissance',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 3, 12, 90),
                                      ),
                                      onPressed: () => _ouvrirFormulaireMembre(
                                        membreExistant: member,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        final id = int.tryParse(
                                            member['id']?.toString() ?? '');
                                        if (id != null) {
                                          confirmerSuppression(id, nomComplet);
                                        }
                                      },
                                    ),
                                  ],
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