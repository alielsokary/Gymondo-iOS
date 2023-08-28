# Gymondo-iOS

[![CI-iOS](https://github.com/alielsokary/Gymondo-iOS/actions/workflows/CI-iOS.yml/badge.svg)](https://github.com/alielsokary/Gymondo-iOS/actions/workflows/CI-iOS.yml)
[![CI-macOS](https://github.com/alielsokary/Gymondo-iOS/actions/workflows/CI-macOS.yml/badge.svg)](https://github.com/alielsokary/Gymondo-iOS/actions/workflows/CI-macOS.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/681d6d9924fe4735bd3490f84377e3c1)](https://app.codacy.com/gh/alielsokary/Gymondo-iOS/dashboard)

## Usage

```bash
cd Gymondo-iOS/GymondoApp
open GymondoApp.xcworkspace
```

## Structure
```
.
├── Gymondo #	macOS Target Contains Platform Agnostic Logic
│   │	├── Models # App Entity
│   │	├── ViewModels  
│   │	├── Exercise Service
│   │	├── Networking
│   │	├── Extensions
├── GymondoTests
│   │	├── ViewModels   
│   │	├── Exercise API   
│   │	├── Helpers
├── GymondoAPIEndToEndTests
├── GymondoiOS
│   │	├── Coordinator 
│   │	├── Scenes 
│   │	│   ├── Exercise List 
│   │	│   │	│	├── Coordinator 
│   │	│   │	│	├── View
│   │	│   ├── Exercise Details 
│   │	│   │	│	├── Coordinator 
│   │	│   │	│	├── View
│   │	│   ├── Storyboard
│   │	├── Extensions 
├── GymondoiOSTests
│   │	├── Helpers 
├── GymondoAPP # iOS App
│   │	├── SceneDelegate  # Composition Root
```

## Architecture 
The project is designed with the MVVM-C Architectural design pattern.

## Tests
The projects contain several test plans as follows:
| Test Plan| Run |
|--|--|
| `Gymondo`| Run Gymondo macOS Platform agnostic tests  |
| `GymondoiOS`| Run iOS Specific Tests  |
| `GymondoAPIEndToEndTests`| Hit the network and validate the API response  |
| `CI_macOS`| Run macOS framework tests and EndToEndTests  |
| `CI_iOS`| Run macOS, iOS framework tests, and EndToEndTests  |

## SwiftLint
The Project contains SwiftLint [nested  configurations](https://github.com/realm/SwiftLint#nested-configurations) to separate test and production rules.
