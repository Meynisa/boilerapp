# Paruh Waktu App Core

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

## Paruh Waktu Features:

* Splash
* Login
* Home
* Theme
* Unit Testing
* Validation

## Upcoming Features:

* Shimmer Placeholder
* Connectivity Support
* Offline Data Storage
* Background Fetch Support
* Dependency Injection
* Fabric (Crashlytics) Crash Reporting

## Libraries & Tools Used

* [Connectivity] (https://pub.dev/packages/connectivity)
* [Dependency Injection] (https://github.com/google/inject.dart)
* [Json Serialization] (https://github.com/dart-lang/json_serializable)
* [Data Persistent] (https://pub.dev/packages/shared_preferences)
* [Unit Testing] (https://pub.dev/packages/test)
* [Currency Formatting] (https://pub.dev/packages/flutter_money_formatter)
* [Shimmer Placeholder] (https://pub.dev/packages/shimmer#-installing-tab-)


## Folder Structure
Here is the core folder structure which flutter provides.

```
paruhwaktu-app-core/
|- android
|- assets
|- ios
|- lib
|- test

```

Here is the folder structure we have been using in this project. We divided by feature

```
lib/
|- auth/
   |- data
   |- models
   |- screens
   |- services
|- history/
   |- data
   |- models
   |- screens
   |- services
|- home/
   |- data
   |- models
   |- screens
   |- services
|- profile/
   |- data
   |- models
   |- screens
   |- services
|- workspace/
   |- data
   |- models
   |- screens
   |- services
|- utils/
   |- constants
   |- widgets
|- main.dart

```

1. auth - Contains all the feature application of authentication (login, register, forgot password, etc)
2. history - Contains all the feature application of history menu
3. home - Contains all the feature application of dashboard menu
4. profile - Contains all the feature application of profile setting (change password, edit profile, etc)
5. workspace - Contains all the feature application of workspace (chat, detail chat, etc)
6. utils - All the application utility

```
a. constants - All the application constants are defined in this directory (strings, theme, colors, style)
b. widgets - Contains the common widgets for your applications (Reusable widgets)
```

7. data - Contains response data layer of project includes directories for network

```
   |- data
      |- login_response
```

8. services - Contains api provider that called in every feature

```
    |- services
       |- login_presentr
```

9. models - Contains content model in every feature

```
   |- models
      |- login_form_model
```

10. screens - Contains all the ui of your project, contains sub directory for each screen.

```
   |- screens
      |- login_screens
```

## How To Use

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/ivosights/paruhwaktu-app-core
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

## How To Use Unit Testing

**Step 1:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter test
```

If testing passed, it will show "All tests passed!" message