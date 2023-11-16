# NimbleApp

## Introduction

This app was built for a test challenge. Features are:
* Login with the Nimble API.
* Saves token to Keychain.
* Retrieves a list of surveys and show them in a page view.
* Logout from the app using Nimble API.

## Getting Started

### Prerequisites

To get started with NimbleApp, you will need the following:

* A Mac with Xcode 14.2 or later
* An iOS device with iOS 12.4 or later

### Installation

To install NimbleApp, follow these steps:

1. Clone this repository to your local machine.
2. Open the NimbleApp.xcodeproj file in Xcode.
3. Choose an iOS Simulator or connect your iOS device to your mac.
4. Run the NimbleApp project in Xcode.

## Usage

Once NimbleApp is installed, you can launch it on your iOS device. The app will start with a simple home screen. From there, you can navigate to the other features of the app using the navigation bar at the bottom of the screen.

The app is gonna start in the Login screen, here you need to input your email and password to get access to the app. If you succeed you get to the main screen, is a survey page visor with responses to left and right swipes gestures to navigate the different surveys. Pressing the start survey button only gets you to an empty view controller.

If you press the profile image you are gonna see an alert to logout.

## License

NimbleApp is licensed under the MIT License. You can find the full license text in the LICENSE file in the root directory of this repository.
