
// import 'dart:async';
// import 'dart:io';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// void main() {
//   runApp(const Ex12App());
// }

// class Ex12App extends StatelessWidget {
//   const Ex12App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ex12',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.indigo,
//         ),
//         useMaterial3: true,
//       ),
//       home: const UtilityHome(),
//     );
//   }
// }

// class UtilityHome extends StatefulWidget {
//   const UtilityHome({super.key});

//   @override
//   State<UtilityHome> createState() => _UtilityHomeState();
// }

// class _UtilityHomeState extends State<UtilityHome> {
//   final ImagePicker picker = ImagePicker();

//   XFile? selectedImage;
//   AccelerometerEvent? accelerometer;
//   Position? position;

//   String locationMessage = 'Location not fetched yet.';
//   String deviceInfo = 'Press the button to read device information.';
//   bool shaken = false;

//   DateTime? lastShake;
//   StreamSubscription<AccelerometerEvent>? sensorSubscription;

//   final List<Map<String, dynamic>> campusLocations = [
//     {
//       'name': 'Main Gate',
//       'lat': 22.3039,
//       'lon': 70.8022,
//     },
//     {
//       'name': 'Library',
//       'lat': 22.3045,
//       'lon': 70.8030,
//     },
//     {
//       'name': 'College Office',
//       'lat': 22.3032,
//       'lon': 70.8015,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     startAccelerometer();
//   }

//   @override
//   void dispose() {
//     sensorSubscription?.cancel();
//     super.dispose();
//   }

//   // Camera and gallery
//   Future<void> selectImage(ImageSource source) async {
//     try {
//       if (source == ImageSource.camera) {
//         final status = await Permission.camera.request();

//         if (!status.isGranted) {
//           showMessage('Camera permission denied.');
//           return;
//         }
//       }

//       final XFile? image = await picker.pickImage(
//         source: source,
//         imageQuality: 85,
//       );

//       if (image != null && mounted) {
//         setState(() {
//           selectedImage = image;
//         });
//       }
//     } catch (e) {
//       showMessage('Unable to select image: $e');
//     }
//   }

//   // Accelerometer stream and shake detection
//   void startAccelerometer() {
//     sensorSubscription = accelerometerEventStream().listen(
//       (event) {
//         final magnitude = math.sqrt(
//           event.x * event.x +
//           event.y * event.y +
//           event.z * event.z,
//         );

//         final now = DateTime.now();

//         if (magnitude > 18 &&
//             (lastShake == null ||
//              now.difference(lastShake!) >
//                  const Duration(seconds: 2))) {
//           lastShake = now;

//           if (mounted) {
//             setState(() {
//               shaken = true;
//             });
//           }

//           Future.delayed(const Duration(seconds: 3), () {
//             if (mounted) {
//               setState(() {
//                 shaken = false;
//               });
//             }
//           });
//         }

//         if (mounted) {
//           setState(() {
//             accelerometer = event;
//           });
//         }
//       },
//       onError: (error) {
//         showMessage('Sensor data unavailable.');
//       },
//     );
//   }

//   // Get current GPS location
//   Future<void> getCurrentLocation() async {
//     setState(() {
//       locationMessage = 'Getting current location...';
//     });

//     try {
//       bool serviceEnabled =
//           await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         setState(() {
//           locationMessage =
//               'GPS is disabled. Please enable location services.';
//         });
//         return;
//       }

//       LocationPermission permission =
//           await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied) {
//         setState(() {
//           locationMessage = 'Location permission denied.';
//         });
//         return;
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           locationMessage =
//               'Location permission permanently denied. Open app settings.';
//         });
//         return;
//       }

//       final currentPosition =
//           await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           timeLimit: Duration(seconds: 20),
//         ),
//       );

//       if (!mounted) return;

//       setState(() {
//         position = currentPosition;
//         locationMessage =
//             'Location obtained successfully at '
//             '${DateTime.now().toLocal()}';
//       });
//     } catch (e) {
//       setState(() {
//         locationMessage = 'Error getting location: $e';
//       });
//     }
//   }

//   // Read device information
//   Future<void> getDeviceInfo() async {
//     try {
//       final info = await DeviceInfoPlugin().deviceInfo;

//       if (!mounted) return;

//       setState(() {
//         deviceInfo = info.data.entries
//             .take(15)
//             .map((entry) => '${entry.key}: ${entry.value}')
//             .join('\n');
//       });
//     } catch (e) {
//       setState(() {
//         deviceInfo = 'Unable to read device information: $e';
//       });
//     }
//   }

//   // Calculate distance to a campus location
//   double? calculateDistance(double lat, double lon) {
//     if (position == null) return null;

//     return Geolocator.distanceBetween(
//       position!.latitude,
//       position!.longitude,
//       lat,
//       lon,
//     );
//   }

//   void showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   Widget sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 18, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 19,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ex12 - Device Utility App'),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // 1. Camera and Gallery
//           sectionTitle('1. Profile Photo'),

//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 65,
//                     backgroundColor: Colors.indigo.shade100,
//                     backgroundImage: selectedImage != null
//                         ? FileImage(File(selectedImage!.path))
//                         : null,
//                     child: selectedImage == null
//                         ? const Icon(
//                             Icons.person,
//                             size: 65,
//                           )
//                         : null,
//                   ),
//                   const SizedBox(height: 15),
//                   Wrap(
//                     alignment: WrapAlignment.center,
//                     spacing: 8,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () =>
//                             selectImage(ImageSource.camera),
//                         icon: const Icon(Icons.camera_alt),
//                         label: const Text('Camera'),
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: () =>
//                             selectImage(ImageSource.gallery),
//                         icon: const Icon(Icons.photo_library),
//                         label: const Text('Gallery'),
//                       ),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         selectedImage = null;
//                       });
//                     },
//                     child: const Text('Remove Photo'),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 2. Accelerometer
//           sectionTitle('2. Accelerometer Sensor'),

//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     accelerometer == null
//                         ? 'Waiting for sensor data...'
//                         : 'X: ${accelerometer!.x.toStringAsFixed(2)} m/s²\n'
//                           'Y: ${accelerometer!.y.toStringAsFixed(2)} m/s²\n'
//                           'Z: ${accelerometer!.z.toStringAsFixed(2)} m/s²',
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     shaken
//                         ? 'Device Shake Detected!'
//                         : 'Shake your device to test.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: shaken ? Colors.deepOrange : Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 3. GPS location
//           sectionTitle('3. Current GPS Location'),

//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(locationMessage),
//                   if (position != null) ...[
//                     const SizedBox(height: 10),
//                     Text(
//                       'Latitude: ${position!.latitude.toStringAsFixed(6)}',
//                     ),
//                     Text(
//                       'Longitude: ${position!.longitude.toStringAsFixed(6)}',
//                     ),
//                     Text(
//                       'Accuracy: ${position!.accuracy.toStringAsFixed(1)} m',
//                     ),
//                     Text(
//                       'Timestamp: ${position!.timestamp.toLocal()}',
//                     ),
//                   ],
//                   const SizedBox(height: 12),
//                   ElevatedButton.icon(
//                     onPressed: getCurrentLocation,
//                     icon: const Icon(Icons.my_location),
//                     label: const Text('Get Location'),
//                   ),
//                   TextButton(
//                     onPressed: Geolocator.openAppSettings,
//                     child: const Text('Open App Settings'),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 4. Campus distances
//           sectionTitle('4. Campus Locations and Distance'),

//           const Text(
//             'Example coordinates are provided. Replace them '
//             'with your actual campus coordinates.',
//           ),

//           Card(
//             child: Column(
//               children: campusLocations.map((place) {
//                 final distance = calculateDistance(
//                   place['lat'] as double,
//                   place['lon'] as double,
//                 );

//                 return ListTile(
//                   leading: const Icon(
//                     Icons.location_on,
//                     color: Colors.indigo,
//                   ),
//                   title: Text(place['name'] as String),
//                   subtitle: Text(
//                     'Lat: ${place['lat']}, Lon: ${place['lon']}',
//                   ),
//                   trailing: Text(
//                     distance == null
//                         ? '--'
//                         : distance < 1000
//                             ? '${distance.toStringAsFixed(0)} m'
//                             : '${(distance / 1000).toStringAsFixed(2)} km',
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//           // 5. Device information
//           sectionTitle('5. Device Information'),

//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: getDeviceInfo,
//                     icon: const Icon(Icons.phone_android),
//                     label: const Text('Read Device Information'),
//                   ),
//                   const SizedBox(height: 12),
//                   SelectableText(deviceInfo),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 24),
//           const Center(
//             child: Text(
//               'Experiment 12 - Flutter Mobile Device Utility',
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const DeviceUtilityApp());
}

class DeviceUtilityApp extends StatelessWidget {
  const DeviceUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Utility App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Utility App'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_android,
              size: 85,
              color: Colors.indigo,
            ),
            const SizedBox(height: 16),
            const Text(
              'Post-Experiment Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.account_circle),
                label: const Text('Task 1: Profile Photo'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePhotoScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.memory),
                label: const Text('Task 4: Device Information'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DeviceInformationScreen(),
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

// ======================================================
// POST-TASK 1: PROFILE PHOTO
// ======================================================

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() =>
      _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _image;
  bool _loading = false;
  String _message = 'Choose or capture your profile photo';

  Future<void> _selectImage(ImageSource source) async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _message = 'Opening image source...';
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (!mounted) return;

      if (pickedFile == null) {
        setState(() {
          _message = 'Image selection cancelled';
        });
        return;
      }

      setState(() {
        _image = File(pickedFile.path);
        _message = 'Profile photo updated successfully!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message =
            'Unable to open camera or gallery. Check device permissions.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Photo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.person,
                size: 45,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.indigo.shade100,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : null,
                child: _image == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 60,
                        color: Colors.indigo,
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Photo'),
                  onPressed: _loading
                      ? null
                      : () => _selectImage(ImageSource.camera),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select from Gallery'),
                  onPressed: _loading
                      ? null
                      : () => _selectImage(ImageSource.gallery),
                ),
              ),
              if (_image != null)
                TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove Photo'),
                  onPressed: () {
                    setState(() {
                      _image = null;
                      _message = 'Choose or capture your profile photo';
                    });
                  },
                ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// POST-TASK 4: DEVICE INFORMATION AND SENSOR READINGS
// ======================================================

class DeviceInformationScreen extends StatefulWidget {
  const DeviceInformationScreen({super.key});

  @override
  State<DeviceInformationScreen> createState() =>
      _DeviceInformationScreenState();
}

class _DeviceInformationScreenState
    extends State<DeviceInformationScreen> {
  StreamSubscription<AccelerometerEvent>? _subscription;

  bool _loading = false;
  String _manufacturer = 'Not loaded';
  String _model = 'Not loaded';
  String _brand = 'Not loaded';
  String _androidVersion = 'Not loaded';
  String _sdkVersion = 'Not loaded';
  String _deviceName = 'Not loaded';
  String _error = '';

  double _x = 0;
  double _y = 0;
  double _z = 0;

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    _readDeviceInfo();
  }

  void _startAccelerometer() {
    try {
      _subscription = accelerometerEventStream(
        samplingPeriod: SensorInterval.normalInterval,
      ).listen(
        (AccelerometerEvent event) {
          if (!mounted) return;

          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
        },
        onError: (Object error) {
          if (!mounted) return;
          setState(() {
            _error = 'Accelerometer unavailable: $error';
          });
        },
      );
    } catch (e) {
      _error = 'Unable to start sensor: $e';
    }
  }

  Future<void> _readDeviceInfo() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final plugin = DeviceInfoPlugin();
      final info = await plugin.androidInfo;

      if (!mounted) return;

      setState(() {
        _manufacturer = info.manufacturer;
        _model = info.model;
        _brand = info.brand;
        _androidVersion = info.version.release;
        _sdkVersion = info.version.sdkInt.toString();
        _deviceName = info.device;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not read device information: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _sensorTile(String label, double value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        '${value.toStringAsFixed(2)} m/s²',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
        actions: [
          IconButton(
            tooltip: 'Refresh device information',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _readDeviceInfo,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Device Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  if (_loading)
                    const LinearProgressIndicator(),
                  _infoTile(
                    'Manufacturer',
                    _manufacturer,
                    Icons.factory,
                  ),
                  _infoTile(
                    'Model',
                    _model,
                    Icons.smartphone,
                  ),
                  _infoTile(
                    'Brand',
                    _brand,
                    Icons.phone_android,
                  ),
                  _infoTile(
                    'Android Version',
                    _androidVersion,
                    Icons.android,
                  ),
                  _infoTile(
                    'SDK Version',
                    _sdkVersion,
                    Icons.settings,
                  ),
                  _infoTile(
                    'Device Name',
                    _deviceName,
                    Icons.devices,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Read Device Information'),
                      onPressed: _loading ? null : _readDeviceInfo,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Accelerometer Readings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Move your phone to see the readings change.',
                  ),
                  const Divider(),
                  _sensorTile('X-axis', _x),
                  _sensorTile('Y-axis', _y),
                  _sensorTile('Z-axis', _z),
                ],
              ),
            ),
          ),
          if (_error.isNotEmpty)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
