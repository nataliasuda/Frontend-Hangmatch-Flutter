import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hangmatch/screens/vote.dart';

class SearchingLocation extends StatefulWidget {
  final String sessionId;
  final double locationRadius;

  const SearchingLocation({
    super.key,
    required this.sessionId,
    required this.locationRadius,
  });

  @override
  State<SearchingLocation> createState() => _SearchingLocationState();
}

class _SearchingLocationState extends State<SearchingLocation> {
  bool _isLoading = true;
  String _statusMessage = 'Requesting location access...';
  double? _userLat;
  double? _userLng;
  bool _showAllowButton = false;

  @override
  void initState() {
    super.initState();
    _requestLocationAndSearch();
  }

  Future<void> _requestLocationAndSearch() async {
    try {
      setState(() {
        _isLoading = true;
        _showAllowButton = false;
        _statusMessage = 'Checking location services...';
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showAllowButton = true;
            _statusMessage =
                'Location services are disabled. Please enable GPS to find events near you.';
          });
        }
        return;
      }

      setState(() => _statusMessage = 'Checking location permissions...');
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        setState(() => _statusMessage = 'Requesting location access...');
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _showAllowButton = true;
              _statusMessage =
                  'Location permission is required to find events near you. Please allow location access.';
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showAllowButton = true;
            _statusMessage =
                'Location permission is permanently denied. Please enable it in app settings to continue.';
          });
        }
        return;
      }

      setState(() => _statusMessage = 'Getting your current location...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _userLat = position.latitude;
        _userLng = position.longitude;
        _statusMessage =
            'Searching for events within ${widget.locationRadius}km...';
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VoteScreen(
                  sessionId: widget.sessionId,
                  userLat: _userLat!,
                  userLng: _userLng!,
                  locationRadius: widget.locationRadius,
                ),
          ),
        );
      }
    } catch (e) {
      print('Error in location search: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAllowButton = true;
          _statusMessage = 'Error getting location: ${e.toString()}';
        });
      }
    }
  }

  void _onAllowPressed() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        await Future.delayed(const Duration(seconds: 1));
        _retryLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();

        await Future.delayed(const Duration(seconds: 1));
        _retryLocation();
        return;
      }

      _retryLocation();
    } catch (e) {
      print('Error opening settings: $e');
      _retryLocation();
    }
  }

  void _retryLocation() {
    setState(() {
      _isLoading = true;
      _showAllowButton = false;
      _statusMessage = 'Checking location...';
    });
    _requestLocationAndSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 80,
                  height: 100,
                ),
                const SizedBox(height: 40),

                Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (_isLoading) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ] else if (_showAllowButton) ...[
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _onAllowPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ALLOW LOCATION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        child: const Text(
                          'Maybe Later',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
