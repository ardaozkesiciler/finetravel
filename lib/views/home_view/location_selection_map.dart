import 'package:finetravel/services/location_service.dart';
import 'package:flutter/material.dart';

class LocationSelectionMap extends StatefulWidget {
  const LocationSelectionMap({super.key});

  @override
  State<LocationSelectionMap> createState() => _LocationSelectionMapState();
}

class _LocationSelectionMapState extends State<LocationSelectionMap> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isProcessing = false;
  String? _statusMessage;

  final Map<String, UserLocation> _cityDatabase = {
    'istanbul': UserLocation(latitude: 41.0082, longitude: 28.9784, cityName: 'Istanbul'),
    'london': UserLocation(latitude: 51.5074, longitude: -0.1278, cityName: 'London'),
    'paris': UserLocation(latitude: 48.8566, longitude: 2.3522, cityName: 'Paris'),
    'tokyo': UserLocation(latitude: 35.6762, longitude: 139.6503, cityName: 'Tokyo'),
    'new york': UserLocation(latitude: 40.7128, longitude: -74.0060, cityName: 'New York'),
    'dubai': UserLocation(latitude: 25.2048, longitude: 55.2708, cityName: 'Dubai'),
    'rome': UserLocation(latitude: 41.9028, longitude: 12.4964, cityName: 'Rome'),
  };

  void _processLocation() async {
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'ANALYZING GLOBAL COORDINATES...';
    });

    await Future.delayed(const Duration(seconds: 2));

    UserLocation? matchedLocation;
    for (var key in _cityDatabase.keys) {
      if (input.contains(key)) {
        matchedLocation = _cityDatabase[key];
        break;
      }
    }

    if (matchedLocation != null) {
      setState(() {
        _statusMessage = 'TARGET ACQUIRED: ${matchedLocation!.cityName?.toUpperCase()}';
      });
      await Future.delayed(const Duration(seconds: 1));
      LocationService().setManualLocation(
        matchedLocation!.latitude,
        matchedLocation!.longitude,
        matchedLocation!.cityName!,
      );
      if (mounted) Navigator.pop(context);
    } else {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'COORDINATES NOT FOUND. PLEASE TRY ANOTHER SECTOR.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      appBar: AppBar(
        title: const Text('LOCATION COMMAND', style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blue.withOpacity(0.05), Colors.transparent],
            radius: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.satellite_alt, color: Colors.blue, size: 48),
            const SizedBox(height: 24),
            const Text(
              'WHERE ARE YOU\nEXPLORING FROM?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your city name or sector coordinates to calibrate your discovery feed.',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              enabled: !_isProcessing,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                hintText: 'e.g. Istanbul, London, Tokyo...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onSubmitted: (_) => _processLocation(),
            ),
            const SizedBox(height: 24),
            if (_statusMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    if (_isProcessing)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                      )
                    else
                      const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.blue.withOpacity(0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'CALIBRATE LOCATION',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
