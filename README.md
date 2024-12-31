# Github Repos

This is a Flutter project that adheres to the principles of Clean Architecture.  This project utilizes the BLoC state management pattern, GetIt for dependency injection, and Freezed for code generation.

## Project Overview

This project demonstrates a practical implementation of Clean Architecture in Flutter by showcasing a GitHub repository search feature. It allows users to search for Flutter/Dart repositories on GitHub and displays the results in a list.

### Key Features:
- Search GitHub repositories with Flutter/Dart as the primary language
- Display repository details including name, description, and star count
- Implement pagination for loading more results
- Utilize Clean Architecture for separation of concerns
- Employ BLoC pattern for state management

## Project Structure

The project follows a well-defined directory structure to keep your code organized and maintainable. Here's an overview of the key directories:

- **Src**: The main source code directory.

    - **Common**: Contains common files such as API endpoints, constants, exceptions, colors, screen sizes, and enums.

    - **Data**: Responsible for data handling.

        - **Datasource**: Data sources, such as the GitHub API client.

        - **Model**: Data models that represent GitHub repositories.

        - **Repository**: Data repositories, which abstract the GitHub API data source.

    - **Domain**: Contains the core business logic.

        - **Entity**: Business entities like GitHubRepo.

        - **Repository**: Interfaces that define how GitHub data is accessed.

        - **Usecase**: Use cases for searching GitHub repositories.

    - **Presentation**: Handles the user interface and interaction.

        - **Bloc**: BLoC classes responsible for managing the state of the GitHub repository search.

        - **Page**: Flutter pages for displaying the search interface and results.

        - **Widget**: Reusable UI components for displaying repository items.

    - **Utilities**: Helper classes and utilities for the application.

- **Injection.dart**: Dependency injection setup using GetIt.

- **Main.dart**: The entry point of the Flutter application.
