# Flutter Turnkey Template

## Overview

This template is a starter kit for quickly setting up a Turnkey-powered React Native Expo app. It simplifies the process of building authentication flows and handling backend integration, making it much easier and faster to develop secure apps. Connecting your frontend to a backend for authentication can be cumbersome, but this template streamlines the setup so you can focus on building cool features.

It includes authentication options such as:

- Passkey Authentication

- OTP Authentication (Email/SMS)

- OAuth Authentication (Google, Apple)

## Why Do You Need a Backend?

Turnkey requires authentication requests (sign-up/login) to be validated (stamped) using your root user API key-pair. Since this key-pair must remain private, it cannot be used directly in the frontend. Instead, authentication requests must be processed and stamped through a backend server before being forwarded to Turnkey.

> **Note**: While this template provides an **example-server** for a quickstart, it is intended as a reference implementation. You will eventually need to set up your own backend to properly integrate with your infrastructure.

## Installation

### 1. Install Mason

This template is uses [`mason`](https://github.com/felangel/mason) - a tool that enable developers to create and consume reusable dart templates. You must install `mason` globally in your system before you can use this template.

Run the following to install `mason` globally in your system:

```shell
dart pub global activate mason_cli
```

To allow the `mason` command to be used across your system, you may need to add the following to your shell's config file (.zshrc, .bashrc, .bash_profile, etc.):

```shell
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 2. Install the Template

Navigate to the director you want to create the template in and run the following to initialize `mason`:

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

When prompted, enter a name for your project:

```shell
? Please enter your app name. (myturnkeyapp)
```
