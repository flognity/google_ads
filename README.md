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
```

Add the AdMob App ID to the app's android/app/src/main/AndroidManifest.xml file 
```
 <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

Update your app's ios/Runner/Info.plist file to add two keys:
- A GADApplicationIdentifier key with a string value of your AdMob app ID.
- A SKAdNetworkItems key with Google's SKAdNetworkIdentifier value of cstr6suwn9.skadnetwork.
```
<key>GADApplicationIdentifier</key>
<string>YOUR-APP-ID</string>
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
import './util/google_ads/ad_state.dart';
import './util/google_ads/user_messaging_platform.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

## License
MIT License

Copyright (c) 2021 flognity