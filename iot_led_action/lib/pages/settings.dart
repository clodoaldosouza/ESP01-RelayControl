import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Settings extends StatefulWidget {
  final Function(String) onIpSaved;
  const Settings({super.key, required this.onIpSaved});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    final savedIp = await StorageService.loadIp();
    if (savedIp != null) {
      _ipController.text = savedIp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(labelText: 'IP Address'),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final ip = _ipController.text.trim();
                if (ip.isNotEmpty) {
                  widget.onIpSaved(ip);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save IP'),
            ),
          ],
        ),
      ),
    );
  }
}
