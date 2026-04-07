**MealBytes** is an iOS nutrition tracking app built with SwiftUI. It helps users monitor their diet, maintain a calorie diary, track macronutrients, and achieve their dietary goals.

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat&logo=swift)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-26.0+-blue?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-brightgreen?style=flat)](https://developer.apple.com/documentation/swiftui)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-yellow?style=flat&logo=firebase)](https://firebase.google.com)

---

## ✨ Key Features

| Feature | Description |
|---------|----------|
| **📖 Smart Food Diary** | Log meals by category (breakfast, lunch, dinner, snacks) with an interactive calendar. |
| **🔍 Advanced Food Search** | Integration with **FatSecret API** to search through an extensive food database and instantly retrieve nutritional data. |
| **⭐ Favorites System** | Save frequently used foods to bookmarks for quick access. |
| **🎯 Goal Setting & Tracking** | Set personalized daily calorie and macronutrient goals (protein, fat, carbs). |
| **👤 Secure Account** | Full authentication system (registration, login, password reset) powered by **Firebase Auth**. |
| **🌙 Personalization** | Support for light/dark theme and goal display customization. |
| **☁️ Data Synchronization** | All your data is securely stored in **Cloud Firestore** and accessible across all devices. |

---

## 📸 Interface Screenshots


<img width="200" src="https://github.com/user-attachments/assets/b43942a0-fd62-4bcd-9264-ef58fce76b2a" />
<img width="200" src="https://github.com/user-attachments/assets/f3a16a15-e0a5-4343-a083-d2f407e5c797" />
<img width="200" src="https://github.com/user-attachments/assets/f0cf98af-5940-4ad2-b792-eabc28a1294a" />
<img width="200" src="https://github.com/user-attachments/assets/f890d9e0-4af5-4cf1-a898-676617747c3b" />

---

## 🏗 Architecture & Structure

Built using **MVVM** pattern for clean separation of concerns.

## 🔧 Setup and Launch

1) https://platform.fatsecret.com Registration

2) https://platform.fatsecret.com/my-account/api-key Generate your API key. Copy **Client ID** and **Client Secret**. The toggle **REST API OAuth 2.0 Credentials** must be enabled.

3) In project **MealBytes** find file **TokenManager.swift** and change **clientID** and **clientSecret** to yours:
    ```swift
    private let clientID = "Your_clientID"
    private let clientSecret = "Your_clientSecret"
    ```

4) https://platform.fatsecret.com/my-account/ip-restrictions Add your IP address to the whitelist and push button **Save Updates** (note that this may take some time, usually 20-30 minutes, but the website states it can take up to 24 hours).
