# Flutter Turnkey Template

## Overview

This template is a starter kit for quickly setting up a Turnkey-powered Flutter app. It simplifies the process of building authentication flows and handling backend integration, making it much easier and faster to develop secure apps. Connecting your frontend to a backend for authentication can be cumbersome, but this template streamlines the setup so you can focus on building cool features.

It includes authentication options such as:

- Passkey Authentication

- OTP Authentication (Email/SMS)

- OAuth Authentication (Google, Apple)

## Why Do You Need a Backend?

Turnkey requires authentication requests (sign-up/login) to be validated (stamped) using your root user API key-pair. Since this key-pair must remain private, it cannot be used directly in the frontend. Instead, authentication requests must be processed and stamped through a backend server before being forwarded to Turnkey.

> **Note:** While this template provides an **example api-server** for a quickstart, it is intended as a reference implementation. You will eventually need to set up your own backend to properly integrate with your infrastructure.

## Prerequisites

> **Note:** version numbers are approximated. Older or newer versions may or may not work correctly.

| Requirement    | Version  |
| -------------- | -------- |
| Flutter        | >= 3.0.0 |
| Dart           | >= 3.0.0 |
| Xcode          | >= 12.0  |
| Android Studio | >= 4.0   |
| Node.js        | >= 14.0  |

## Setup

### 1. Install Mason

This template uses [`mason`](https://github.com/felangel/mason) - a tool that enables developers to create and consume reusable dart templates. You must install `mason` globally in your system before you can use this template.

Run the following to install `mason` globally in your system:

```shell
dart pub global activate mason_cli
```

To allow the `mason` command to be used across your system, you may need to add the following to your shell's config file (.zshrc, .bashrc, .bash_profile, etc.):

```shell
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 2. Install the Template

Navigate to the directory you want to create the template in and run the following to initialize `mason`:

```shell
mason init
```

Now add the template:

```shell
mason add turnkey_flutter_template --git-url https://github.com/tkhq/flutter_template
```

### 3. Create the Template

Start the guided creation process using:

```shell
mason make turnkey_flutter_template
```

When prompted, enter a name for your project. This will also update your app's bundle identifier:

```shell
? Please enter your app name. (myturnkeyapp)
```

If you want to include Google OAuth login, you can optionally enter the redirect url scheme you want to add to your app.

```shell
? (Google OAuth Setup): Please enter your Google redirect scheme. (com.googleusercontent.apps.1234567890-abcdef)
```

If you want to include passkey authentication, you can optionally enter the id of your relying party (RP) server.

```shell
? (Passkey Setup): Please enter your Relying Party ID. (example.com)
```

You can also choose to include an example server written in Typescript to facilitate authentication requests to Turnkey. If you select `Yes`, the server will be included in [`./api-server`](./__brick__/api-server/) and the [`AuthRelayerProvider`](./__brick__/lib/providers/auth.dart) will be populated with the required http requests.

```shell
? Would you like to include an example Typescript backend in ./api-server? (Y/n)
```

### 4. Complete OAuth Setup (optional)

#### Sign in with Google

Signing in with Google uses the [openid_client](https://pub.dev/packages/openid_client) package which can be configured to authenticate using most OIDC providers.

Add your Google client ID to your `.env` file (you can use the [`.env.example`](./__brick__/.env.example) file as a template). This can be retrieved from your [Google Developer Console](https://console.cloud.google.com/).

```python
GOOGLE_CLIENT_ID="<YOUR_GOOGLE_CLIENT_ID>"
GOOGLE_REDIRECT_SCHEME="com.googleusercontent.apps.1234567890-abcdef"
```

> **Note:** Your Google redirect scheme will be automatically populated from [step 3](#3-create-the-template) and included in your [`Info.plist`](./__brick__/ios/Runner/Info.plist) and [`AndroidManifest.xml`](./__brick__/android/app/src/main/AndroidManifest.xml) files.
> **If you need to change this later, you must edit those files and update your `.env`.**

#### Sign in with Apple

Signing in with Apple leverages the [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple) packages. This allows Apple's native [Sign in With Apple SDK](https://developer.apple.com/documentation/signinwithapple) to be used in Flutter. On iOS, this will be configured automatically.

If you need Sign in with Apple to work on Android devices, there are extra steps required - including set up of a public proxy server to redirect to your app. See the [sign_in_with_apple instructions](https://pub.dev/packages/sign_in_with_apple#android) for more info.

### 5. Complete Passkey Setup (optional)

To allow passkeys to be registered on iOS and Android, you must set up an associated domain. This is your **relying party server.**

> **Note** The value you entered in [step 3](#3-create-the-template) should be the domain and TLD of your relying party server. Your [`.env.example`](./__brick__/.env.example), [Runner.entitlements](./__brick__/ios/Runner/Runner.entitlements) and [RunnerDebug.entitlements](./__brick__/ios/Runner/RunnerDebug.entitlements) files will all be autopopulated with this value. **If you need to change this later, you must edit those files.**

#### Relying Party Server Configuration

**For iOS**, configure your webserver to have the following route:

```
https://<yourdomain>/.well-known/apple-app-site-association
```

This will be the path to a JSON object with your team id and bundle identifier.

```json
{
  "applinks": {},
  "webcredentials": {
    "apps": ["XXXXXXXXXX.YYY.YYYYY.YYYYYYYYYYYYYY"]
  },
  "appclips": {}
}
```

**For Android**, configure your webserver to have the following route:

```
https://<yourdomain>/.well-known/assetlinks.json
```

This will be the path to a JSON object with the following information. (Note: replace `SHA_HEX_VALUE` with the SHA256 fingerprints of your Android signing certificate):

```json
[
  {
    "relation": ["delegate_permission/common.get_login_creds"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example",
      "sha256_cert_fingerprints": ["SHA_HEX_VALUE"]
    }
  }
]
```

For detailed instructions, refer to the [Turnkey Flutter Passkey Stamper README](/packages/passkey-stamper) or [Apple](https://developer.apple.com/documentation/xcode/supporting-associated-domains) and [Google's](https://developer.android.com/identity/sign-in/credential-manager#add-support-dal) respective instruction pages.

### 6. Finish Environment Variables Setup

Head to your `.env.example` file and fill in the rest of the environment variables you need.

Enter your Turnkey organization ID:

```py
ORGANIZATION_ID="<YOUR_ORGANIZATION_ID>"
```

If you selected `Yes` to create an example backend server in [step 3](#3-create-the-template), you also need to provide your API public and private key.

```py
TURNKEY_API_PUBLIC_KEY="<YOUR_TURNKEY_API_PUBLIC_KEY>"
TURNKEY_API_PRIVATE_KEY="<YOUR_TURNKEY_API_PRIVATE_KEY>"
```

You can also choose a port for your example backend server and set the URL your frontend will use. The default values should work fine:

```py
BACKEND_API_URL="http://localhost:3000" # This is the URL of your backend API server that the app will use to make requests to
BACKEND_API_PORT="3000"
```

> **Note** You can find your organization ID and create an API key-pair in the [Turnkey dashboard](https://app.turnkey.com/):

**Once you're ready, rename `.env.example` to `.env` so your project can recognize the file.**

## Running the Project

### Example Backend Server

If you selected `Yes` to create an example backend server in [step 3](#3-create-the-template), this is how to run it:

Navigate to the api-server directory and install the dependencies:

```bash
cd api-server
npm install
```

Build and Run the Backend Server

```bash
npm run build
npm start
```

### Flutter App

Navigate to the root directory of your Flutter project and install the dependencies:

```bash
flutter pub get
```

You can run the app on a connected device or emulator using the following command:

```bash
flutter run
```

You will be prompted to select a device to run the app on. You can also use the Flutter VSCode extension to run the app and select the device.

## Next Steps

Need more context on how to sign, manage wallets and update users using Turnkey's Flutter SDK? Checkout our fully featured [Flutter Demo App](https://github.com/tkhq/dart-sdk/tree/main/examples/flutter-demo-app).
