import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _SearchingLocationState extends State<SearchingLocation>
    with SingleTickerProviderStateMixin {
  String _statusMessage = 'Requesting location access...';
  double? _userLat;
  double? _userLng;
  bool _showAllowButton = false;

  late AnimationController _animationController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _requestLocationAndSearch();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationAndSearch() async {
    try {
      setState(() {
        _showAllowButton = false;
        _statusMessage = 'Checking location services...';
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _showAllowButton = true;
            _statusMessage =
                'Location services are disabled. Please enable GPS to continue.';
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
              _showAllowButton = true;
              _statusMessage =
                  'Location permission is required. Please allow access.';
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _showAllowButton = true;
            _statusMessage =
                'Location permission permanently denied. Enable it in settings.';
          });
        }
        return;
      }

      setState(() => _statusMessage = 'Getting your current location...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      );

      _userLat = position.latitude;
      _userLng = position.longitude;

      setState(() {
        _statusMessage =
            'Searching for events within ${widget.locationRadius} km...';
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

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
    } catch (e) {
      if (mounted) {
        setState(() {
          _showAllowButton = true;
          _statusMessage = 'Error getting location: $e';
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
    } catch (_) {
      _retryLocation();
    }
  }

  void _retryLocation() {
    setState(() {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulse.value,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1A1A),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.purpleAccent,
                          width: 2,
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/logo.svg",
                        width: 42,
                        height: 42,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (_showAllowButton) ...[
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'ALLOW LOCATION',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: const Text(
                    'Maybe later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
