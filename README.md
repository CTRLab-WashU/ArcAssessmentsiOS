# Arc Assessments iOS Library

### Swift Package Manager

This Github Repo should be included in your application as a swift package by following the instructions [here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

### Sample App

The Sample App shows how you can launch the assessments and read the results.  

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

Application Structure
=====================

Although they achieve it in very different ways, both iOS and Android projects are built with the same ideas in mind: a core project contains all of the basic functionality, and each application is built by customizing certain core classes. 


Before I start describing these different classes, I want to make note that many of these objects are actually enumerations. Swift has a _very_ lenient idea of what an enum is. This allows for the creation of enums that can have additional properties or methods, and even implement protocols (as many of these are doing).

**ArcEnvironment**

The `ArcEnvironment` protocol contains many different configuration settings that handle participant authentication, test cycle schedule, among others.

In each application, this protocol is implemented by an enum, named something like "XXEnvironment". Different cases exist for different build configurations (dev, qa, production, etc). These types control the value of some properties.

**State**

The `State` protocol contains two methods to be implemented, `viewForState()` and `surveyTypeForState()`. 

Again, this protocol is implemented by an enum, named something like "XXState". The enumerated cases represent the different possible application states (chronotype, wake, gridTest, etc etc).


**AppNavigationController**

The primary function of the `AppNavigationController` class is to decide, given a current State, what State the application should navigate to next, through the `nextAvailableState()` method. 

**Arc**

The `Arc` class is used as a singleton object, accessed through `Arc.shared`. It provides access to different controller objects, and is used to store the current state of the application through properties like `currentTestSession`, and `currentState`.

The most important part of the `Arc` class is the `nextAvailableState()` method, which is called any time the application is opened, and any time the current state of the application has finished. For example, it's called whenever the participant reaches the end of a survey, or finishes updating their wake/sleep schedule.


