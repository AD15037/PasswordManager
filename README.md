# Password Manager

A secure and intuitive iOS password manager application built with SwiftUI and SwiftData. This app allows users to safely store, manage, and generate strong passwords for their various accounts.

## Features

- **Secure Storage**: Passwords are encrypted using AES encryption before being stored locally using SwiftData.
- **Add & Edit Accounts**: Easily add new password entries or update existing ones.
- **Password Strength Meter**: Real-time visual feedback on the strength of your passwords as you type.
- **Search Functionality**: Quickly find accounts by searching for account names or usernames.
- **Clean UI**: A modern, clean user interface built with SwiftUI.

## Requirements

- **iOS**: 17.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+

## Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/AD15037/PasswordManager.git
    cd PasswordManager
    ```

2.  **Open the project:**
    Open the `PasswordManager.xcodeproj` file in Xcode.

3.  **Build and Run:**
    - Select your target simulator or connected iOS device.
    - Press `Cmd + R` or click the **Run** button in the Xcode toolbar.

## Usage

1.  **Home Screen**: Displays a list of your stored accounts. Use the search bar to filter the list.
2.  **Add Password**: Tap the floating "+" button in the bottom right corner to open the "Add New Account" sheet.
3.  **Enter Details**: Fill in the Account Name, Username/Email, and Password. Watch the strength meter to ensure your password is secure.
4.  **Save**: Tap "Add New Account" to save the entry.
5.  **View/Edit**: Tap on any password item in the list to view its details. From there, you can edit or delete the entry.

## Architecture & Tech Stack

- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Architecture Pattern**: MVVM (Model-View-ViewModel)
- **Encryption**: AES (via CryptoKit)
