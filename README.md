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


<img width="200" src="https://github.com/user-attachments/assets/ce2f892f-b0fb-43a5-921a-5195cbb88f8f" />
<img width="200" src="https://github.com/user-attachments/assets/35bff27e-a952-40ff-976c-3f3712dcceab" />
<img width="200" src="https://github.com/user-attachments/assets/b42b251d-0a89-441f-b0eb-9a1dc02b4e19" />
<img width="200" src="https://github.com/user-attachments/assets/9464e928-a696-4f8e-ac03-7d2112562517" />

---

## 🏗 Architecture & Structure

Built using **MVVM** pattern for clean separation of concerns.

## 🔧 Setup and Launch

1) https://platform.fatsecret.com Registration

2) https://platform.fatsecret.com/my-account/api-key Select REST **API OAuth 2.0 Credentials**, copy **Client ID** and **Client Secret**

3) In the file **TokenManager.swift** change **clientID** and **clientSecret** to yours:
    ```swift
    private let clientID = "Your_clientID"
    private let clientSecret = "Your_clientSecret"
    ```

4) https://platform.fatsecret.com/my-account/ip-restrictions Add your IP address to the whitelist (note that this may take some time, usually 20-30 minutes, but the website states it can take up to 24 hours).
