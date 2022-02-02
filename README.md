# Arc Assessments iOS Library

### Swift Package Manager

This Github Repo should be included in your application as a swift package by following the instructions [here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

### Sample App

The Sample App shows how you can launch the assessments and read the results.  It also 

### Sample App Assets
#### Colors

Many assets for the library are included as resources in the Swift Package; however, the 'Colors' group was left out so that they can be customized for each app.

If the library crashes looking for an unresolved UIColor, you must copy the 'Colors' group in the Sample App's Assets into your application.  You can change the colors to match your app's UI. 

#### Fonts

The assessments library uses the 'Roboto' font pack.  These are included as resources in the library; however, you must call this code from your AppDelegate to manualy load the fonts into the system.

`FontLoader.configurePackageUI()`

#### Localization

A localization asset is included in the library's resources. The language used in the assessments, is *NOT* the iOS device language.  You must set the language of the assessments by showing the user a list of languages to selected, by looking at the default iOS device language and selecting that, or by hard-coding it in your app.

To set the language the library uses, to the default iOS device language, use this code:

`
	let locale = Locale.current
	Arc.shared.setLocalization(country: locale.regionCode,
                               language: locale.languageCode)
`


Setting up and Building Projects
================================

To the best of knowledge, getting these applications to build should require pretty minimal setup on your part. Once you've got the projects cloned, all that you should need to change are build settings like the Bundle Identifier and Team for iOS.


Changing Dev/QA/Production Settings
-----------------------------


The iOS projects keep some build-specific settings in an enum that implements the `ArcEnvironment` protocol. This file is usually named something like "XXEnvironment.swift".

To toggle between different build settings, you can change the `environment` property located at the beginning of AppDelegate.swift. 


Application Structure
=====================

Although they achieve it in very different ways, both iOS and Android projects are built with the same ideas in mind: a core project contains all of the basic functionality, and each application is built by customizing certain core classes. 


Before I start describing these different classes, I want to make note that many of these objects are actually enumerations. Swift has a _very_ lenient idea of what an enum is. This allows for the creation of enums that can have additional properties or methods, and even implement protocols (as many of these are doing).

**ArcEnvironment**

The `ArcEnvironment` protocol contains many different configuration settings that handle participant authentication, test cycle schedule, among others.

In each application, this protocol is implemented by an enum, named something like "XXEnvironment". Different cases exist for different build configurations (dev, qa, production, etc). These types control the value of some properties, such as the `baseUrl`, `crashReporterApiKey`, `isDebug` values. This protocol also contains a number of settings that generally would apply to any build configuration, such as `arcStartDays`, `authenticationStyle`, `scheduleStyle`.


**State**

The `State` protocol contains two methods to be implemented, `viewForState()` and `surveyTypeForState()`. 

Again, this protocol is implemented by an enum, named something like "XXState". The enumerated cases represent the different possible application states (welcome, auth, schedule, chronotype, wake, gridTest, etc etc).

**Phase**

The `Phase` protocol itself is mostly a collection of methods meant to return different `PhasePeriod` objects, which are simply objects that implement the `Phase` protocol. 

Again, this protocol is implemented by an enum, named something like "XXPhase". This enum typically contains only three cases: none, baseline, and active. These different phases represent differences between certain test cycles. For instance, the first test cycle for EXR, known as the baseline cycle, contains an extra test session, and technically runs for 8 days instead of 7.

**AppNavigationController**

The primary function of the `AppNavigationController` class is to decide, given a current State, what State the application should navigate to next, through the `nextAvailableState()` method. It also provides access to different default States through methods like `defaultAuth()`, `defaultAbout()`, etc.

**Arc**

The `Arc` class is used as a singleton object, accessed through `Arc.shared`. It provides access to different controller objects, and is used to store the current state of the application through properties like `currentStudy`, `availableTestSession`, `currentTestSession`, and `currentState`.

The most important part of the `Arc` class is the `nextAvailableState()` method, which is called any time the application is opened, and any time the current state of the application has finished. For example, it's called whenever the participant reaches the end of a survey, or finishes updating their wake/sleep schedule.


