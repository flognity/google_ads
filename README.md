# google_ads
Google Ads for flutter projects with AdMob

## How to install
This repository is meant to be a included as a submodule of flutter apps.
Just navigate to your `lib` directory and add the submodule where you would like. E.g.
```
cd lib
cd util
git submodule add https://github.com/flognity/google_ads.git
git submodule update --init --recursive
```
## Prerequisites 
You must have linked your google Funding Choices account to your Admob account.

## How to install
Include the packages in your `pubspec.yaml` dependencies
```
user_messaging_platform: ^1.1.0
google_mobile_ads: ^0.13.5
provider: ^6.0.0
flutter_config: ^2.0.0
```

Add new ignore entries to your `.gitignore` file to exclude those files from version control:
```
.env
**/ios/Flutter/tmp.xcconfig
```

Then create a `.env` file in your root directory if your application. In your `.env` file, specify the API keys from AdMob:
```
GOOGLE_ADS_APPID=ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
ADUNITID_ANDROID_BANNER_01=ca-app-pub-3940256099942544/6300978111
ADUNITID_IOS_BANNER_01=ca-app-pub-3940256099942544/2934735716
```

You need to manually apply a plugin to your app, from `android/app/build.gradle`:
Right below `apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"` add the following line:
```
apply from: project(':flutter_config').projectDir.getPath() + "/dotenv.gradle"
```

Add the Google Ads App ID to the app's android/app/src/main/AndroidManifest.xml file via your stored .env variable: 
```
       <meta-data
           android:name="com.google.android.gms.ads.APPLICATION_ID"
           android:value="@string/GOOGLE_ADS_APPID" />
```

For iOS follow the instructions from https://github.com/ByneappLLC/flutter_config/blob/master/doc/IOS.md

Update your app's ios/Runner/Info.plist file to add two keys:
- A GADApplicationIdentifier key with a string value of your AdMob app ID.
- A SKAdNetworkItems key with Google's SKAdNetworkIdentifier value of cstr6suwn9.skadnetwork.
```
<key>GADApplicationIdentifier</key>
<string>${GOOGLE_ADS_APPID}</string>
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
    </dict>
  </array>
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

Initialize the Mobile Ads SDK before the App is run, by placing the initializer before the runApp instruction. Wrap your App in the UserConsentWrapper to include the user consent form:
```
import './models/ad_state.dart';
import './util/google_ads/user_messaging_platform.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  
  final Future<InitializationStatus> initFuture =
      MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => UserConsentWrapper(
        child: YourMaterialApp(),
      ),
    ),
  );
}
```

Example for the `models/ad_state.dart`:
```
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  /// iOS test unit IDs can be found here:
  /// https://developers.google.com/admob/ios/test-ads?hl=en-GB
  /// Android test unit IDs can be found here:
  /// https://developers.google.com/admob/android/test-ads?hl=en-GB#enable_test_devices
  String get bannerAdUnitId => Platform.isAndroid
      ? FlutterConfig.get(
          'ADUNITID_ANDROID_BANNER_01') //Android Banner Test unit ID
      : FlutterConfig.get(
          'ADUNITID_IOS_BANNER_01'); //iOS Banner Test unit ID

  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}

```

## License
MIT License

Copyright (c) 2021 flognity