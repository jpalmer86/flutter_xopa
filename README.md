# Xopa App

The Xopa app is an app for collaborating with creators.

## Project Structure

The app is written in the Dart language with the Flutter framework. See https://flutter.dev for more info about Flutter.

Here is a basic layout of the project files:

- `pubspec.yaml` -- Contains information about the Flutter version and project dependencies.
- `lib/main.dart` -- The main entry point for the app.
- `lib/api-config.dart` -- Contains configuration information for connecting to the backend API.
- `lib/theme.dart` -- Contains theming information such as colors and widget styles.
- `lib/pages/` -- The pages directory contains all the pages and blocs for the app.
- `lib/common/` -- The common directory contains all widgets that are used at multiple points throughout the app. (i.e. branded widgets)
- `lib/repository/` -- Contains all code for connecting to the backend API.
- `test/` -- Contains all code unit tests.
- `ios/` -- Contains iOS-specific project code.
- `android/` -- Contains Android-specific project code.

## Pages

Splash Screen

- Shows the apps icon and name while the app loads

Login/Signup Page

- Login page takes in a username/email and password
- Signup page takes in a username/email, password, and name, and requires that users
check a box stating that they have read the linked terms of service and privacy policy.
- After signing up, the user is taken to the Interest Selection Page.

Interest Selection Page

- A list of possible interests is shown and users are allowed to select one to many of them.

Profile

- A profile image, short bio, and the user’s name are shown.
- A button to open a chat stream with the user is shown.
- If the user is viewing their own page, options for editing their bio and profile picture are
shown.
- Scrolling down reveals the user’s Portfolio Page

Portfolio Page

- A grid of selected images from Instagram is shown.
- The user who owns the portfolio will be shown a button that allows them to select the
images from Instagram they would like to display on their portfolio or link their Instagram account if it is not already linked.

Collaboration Discovery Page

- Shows a list of collaboration opportunities sorted by category.

Collaboration List Page

- Shows a list of currently open collaborations

Chat List Page

- Shows a list of currently open chat messages.
- Allows users to archive/delete chats and create new chats.
 Page

Chat Page

- Shows messages between all members of the selected chat.
