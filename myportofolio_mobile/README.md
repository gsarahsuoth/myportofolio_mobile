# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Assignment 7

1. A widget tree in Flutter is a hierarchical structure of interconnected widgets that defines your app's layout and user interface. Parent-child relationships work through encapsulation, where parent widgets contain and manage one or more child widgets, passing layout constraints, styles, and data down the tree to determine how and where those children render on the screen.
2. StatelessWidget: The base class for widgets that do not maintain mutable state. It is used to define static UI components whose appearance depends solely on configuration data (MyHomePage, InfoCard, and ItemCard).

Scaffold: Implements the standard Material Design visual layout structure. It provides the framework for the screen, holding major structural elements like the AppBar and the body.

AppBar: A top app bar component that displays the application title ('MyPortfolio') and applies primary theme coloring.

Text: Displays a string of text with customizable styling (used for titles, headings, labels, and button text).

Padding: Applies uniform or directional inner spacing (padding) around its child widget.

Column: A flex layout widget that arranges its children vertically from top to bottom.

Row: A flex layout widget that arranges its children horizontally from left to right (used to layout the three InfoCard widgets side by side).

Center: Centers its child widget horizontally and vertically within the available space.

SizedBox: A box with a specified width or height, primarily used here to create vertical spacing gaps between UI elements.

GridView.count: A scrollable grid layout widget with a fixed number of columns (crossAxisCount: 3) used to render the action buttons neatly.

Card: A Material Design card panel featuring rounded corners and an elevation shadow (used to display NPM, Name, and Class).

Container: A multi-purpose wrapper widget used to apply padding, sizing constraints, and structural styling.

Material: A foundational Material Design surface widget that provides background color (item.color) and acts as a base for touch effects.

InkWell: Wraps a widget to make it interactive, adding a visual ripple (ink splash) animation when the user taps on it via onTap.

Icon: Renders a graphical icon based on a provided IconData reference (such as folders and plus symbols).

SnackBar: A lightweight notification banner that slides up from the bottom of the screen to show the interactive pressed message.
3. The MaterialApp widget is a convenience widget in Flutter that wraps a number of widgets that are commonly required for Material Design applications. It serves as the root of my application, building upon basic low-level widgets (like WidgetsApp) to configure core features such as application-wide routing, localization, navigation, themes, and titles. This widget is commonly used as the root widget:

- Establishes Material Design Infrastructure
Most Flutter apps follow the Material Design guidelines. MaterialApp sets up essential visual and structural standards across the entire app, such as default fonts, ink splashes, and color palettes.

- Centralized Configuration
It acts as a single control center where we can define global properties like theme, darkTheme, title, and initial routing (home, routes), eliminating the need to configure these settings repeatedly on every individual screen.

- Enables Navigation and Overlays
It automatically wires up the Navigator and HeroController, which are crucial for managing page routes, screen transitions, and global overlays like ScaffoldMessenger (used for displaying SnackBars) and dialogs. Without MaterialApp (or its Cupertino equivalent), core UI features like app bars, drawers, and SnackBars will not function properly because they rely on the Material design context it provides.
4. Stateless Widget:
A StatelessWidget is a widget that cannot change its state once it is built. All the values and properties it receives (final fields) are fixed when the widget is created. If I want to change what a StatelessWidget displays, the parent widget must rebuild it with new data. It does not possess a mutable state object or a method like setState(). I used this in my InfoCard, ItemCard, and MyHomePage (in its static layout form) as they are stateless because they simply display data passed down from initialization. A StatelessWidget should be chosen whenever the user interface component is static and its appearance depends solely on the initial configuration parameters passed to it (e.g. Headers, static icons, text labels, structural layout containers, or display-only cards (like my portfolio's education cards or info cards) that do not need to change dynamically based on user interaction or internal logic.)

Stateful Widget:
A StatefulWidget is a widget that can maintain and modify internal state over its lifespan. It consists of two classes: the widget class itself (which is immutable) and a separate State class that stores mutable variables. When data changes inside the State class, calling setState() tells Flutter to redraw the widget tree and reflect the new updates on the screen. Stateful widget will be used in a form with input fields, a like/heart button that toggles colors when clicked, a counter, or a dropdown menu. A StatefulWidget should be chosen whenever the user interface component is static and its appearance depends solely on the initial configuration parameters passed to it.
5. BuildContext is a handle to the location of a widget within the widget tree. It's responsible for tree traversal (Since widgets don't store direct references to their parents or grandparents, Flutter uses the BuildContext to walk up the widget tree until it finds the nearest instance of that ancestor), managing state and scopes (If we try to use a BuildContext that doesn't have the required ancestor above it, Flutter will throw a runtime error), rebuilding control (It ties a specific widget's lifecycle and UI updates to the element tree, ensuring Flutter knows which exact part of the UI needs to be redrawn when state changes.)
6. Hot reload works by injecting updated source code directly into the running Dart Virtual Machine (VM), allowing Flutter to rebuild the widget tree in under a second while preserving the app's current state (such as text entered in forms or active navigation tabs). In contrast, hot restart destroys the existing state completely and re-executes the app from the main() function, taking slightly longer to reset the app back to its initial launch screen without requiring a full native rebuild.

We cannot rely on hot reload and must instead perform a hot restart whenever we modify code that is only evaluated once at startup or affects underlying data structures—such as changes to main(), initState(), global or static variables, enum definitions, or class hierarchies. Additionally, if we add new assets/dependencies in pubspec.yaml or modify platform-specific native code (Java/Kotlin on Android or Swift/Objective-C on iOS), even a hot restart is insufficient, and we must perform a full restart to recompile the native application package.