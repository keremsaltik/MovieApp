# MovieApp

![MovieApp Demo GIF]([Link-to-your-GIF-or-Screenshot])

## About This Project

Hello! This is **MovieApp**, an iOS app I built to practice and show my skills in modern iOS development. I made it using SwiftUI and The Movie Database (TMDB) API.

With this app, you can find new movies, search for any movie you like, and keep a personal watchlist. My main goal was to build a complete app from start to finish, focusing on clean code and a good user experience.

This project was a big learning journey for me, and I'm happy to share it.

---

## Features

-   **Find Movies:** See lists like Top Rated and Popular movies. You can also browse by genre (like Drama or Comedy).
-   **Search:** A simple search bar to find any movie. The list grows as you scroll down (infinite scroll).
-   **Login:** You can log in with your TMDB account. The app securely saves your session using the device's **Keychain**.
-   **Watchlist:** Add movies to your personal watchlist with a single tap on the bookmark icon.
-   **Movie Details:** See more information about a movie, like its poster, summary, rating, and more.
-   **Profile:** A page to see your username and your saved watchlist.

---

## How I Built It (Technical Details)

I focused on using modern and standard technologies for this project.

-   **UI:** **SwiftUI** for everything.
-   **Architecture:** **MVVM**. I separated the Views, ViewModels (the logic), and Models (the data).
-   **Networking:** I used `async/await` to get data from the API. I created a `NetworkService` to manage all API calls.
-   **Navigation:** I used `NavigationStack` with a `Route` enum. This helps to manage all screen transitions from one central place.
-   **Image Loading:** I used the **SDWebImageSwiftUI** library to load images from the network. It also caches them, so the app feels faster.

---

## How to Run the Project

1.  Clone this repository.
2.  Open the project in Xcode.
3.  Go to the `Core/Constants.swift` file.
4.  You will see a line `static let apiKey = "YOUR_TMDB_API_KEY"`. Replace the placeholder with your own TMDB API key.
5.  Build and run (`Cmd + R`).

---

## What I Learned

Building this app was a great challenge. The hardest part was fixing the navigation bugs and making sure the data from the API correctly matched my `Codable` models. I learned a lot about debugging and how important a clean architecture is.

I'm proud of how it turned out. Thanks for checking it out!
