import 'package:flutter/material.dart';
import 'dart:async';
import '../pages/settings.dart';
import '../services/device_service.dart';
import '../services/storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String ipAddress = '';
  bool isOn = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  void _showConnectionError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: Text(
          'Impossible to connect to the device at "$ipAddress". Please check the IP address and your network connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadIp() async {
    final savedIp = await StorageService.loadIp();
    if (savedIp != null) {
      setState(() {
        ipAddress = savedIp;
      });
      final status = await DeviceService.getRelayStatus(savedIp);
      if (status != null) {
        setState(() {
          isOn = status;
        });
      }
    }
  }

  Future<void> _toggleDevice() async {
    if (ipAddress.isEmpty || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final success = await DeviceService
          .toggleDevice(ipAddress, isOn)
          .timeout(const Duration(minutes: 1));

      if (success) {
        final status = await DeviceService
            .getRelayStatus(ipAddress)
            .timeout(const Duration(seconds: 10));
        if (status != null) {
          setState(() {
            isOn = status;
          });
        }
      } else {
        _showConnectionError();
      }
    } on TimeoutException {
      _showConnectionError();
    } catch (e) {
      _showConnectionError();
    }

    setState(() {
      isLoading = false;
    });
  }

  void _updateIp(String newIp) {
    setState(() {
      ipAddress = newIp;
    });
    StorageService.saveIp(newIp);
    _loadIp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IOT Controller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Settings(onIpSaved: _updateIp),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(isOn ? Icons.power_off : Icons.power),
          label: Text(isLoading
              ? 'Sending...'
              : isOn
                  ? 'Turn Off Device'
                  : 'Turn On Device'),
          onPressed: isLoading ? null : _toggleDevice,
        ),
      ),
    );
  }
}
