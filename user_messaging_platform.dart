import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart';

class UserConsentWrapper extends StatefulWidget {
  final Widget child;
  const UserConsentWrapper({required this.child, Key? key}) : super(key: key);
  @override
  State<UserConsentWrapper> createState() => _UserConsentWrapperState();
}

class _UserConsentWrapperState extends State<UserConsentWrapper> {
  // Using a field to access the plugin makes access less verbose and allows
  // replacing it with a mock for testing.
  final _ump = UserMessagingPlatform.instance;

  // Only applicable to iOS.
  TrackingAuthorizationStatus? _trackingAuthorizationStatus;

  // The latest consent info.
  ConsentInformation? _consentInformation;

  // Settings for ConsentRequestParameters
  bool _tagAsUnderAgeOfConsent = false;
  bool _debugSettings = true;
  String? _testDeviceId;
  DebugGeography _debugGeography = DebugGeography.EEA;

  @override
  void initState() {
    // Load the current `TrackingAuthorizationStatus`.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _loadTrackingAuthorizationStatus();
    }

    // Load the latest `ConsentInformation`. This will always work but does
    // not request the latest info from the UMP backend.
    _loadConsentInfo();
    _requestConsentInfoUpdate();
    _showConsentForm();

    super.initState();
  }

  Future<void> _loadTrackingAuthorizationStatus() {
    return _ump.getTrackingAuthorizationStatus().then((status) {
      setState(() {
        _trackingAuthorizationStatus = status;
      });
    });
  }

  Future<void> _loadConsentInfo() {
    return _ump.getConsentInfo().then((info) {
      setState(() {
        _consentInformation = info;
      });
    });
  }

  Future<void> _requestConsentInfoUpdate() {
    return _ump
        .requestConsentInfoUpdate(_buildConsentRequestParameters())
        .then((info) {
      setState(() {
        _consentInformation = info;
      });
    });
  }

  Future<void> _showConsentForm() {
    return _ump.showConsentForm().then((info) {
      setState(() {
        _consentInformation = info;
      });
    });
  }

  ConsentRequestParameters _buildConsentRequestParameters() {
    final parameters = ConsentRequestParameters(
      tagForUnderAgeOfConsent: _tagAsUnderAgeOfConsent,
      debugSettings: _debugSettings
          ? ConsentDebugSettings(
              geography: _debugGeography,
              testDeviceIds: _testDeviceId == null ? null : [_testDeviceId!],
            )
          : null,
    );
    return parameters;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
