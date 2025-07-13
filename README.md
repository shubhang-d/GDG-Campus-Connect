# GDG Campus Connect

**GDG Campus Connect** is a comprehensive, mobile-first community application designed to be the central digital hub for the "GDG on campus GLAU" student group. This app solves the problem of fragmented communication and disconnected collaboration by providing a unified platform for members to connect, share ideas, and build amazing projects together.

## The Problem

Student tech communities, while full of talent, often suffer from a lack of a central ecosystem. This leads to:
*   **Siloed Talent:** It's difficult to find peers with specific skills for collaboration.
*   **Scattered Communication:** Important announcements and discussions get lost across multiple platforms like WhatsApp and Discord.
*   **Hindered Collaboration:** A lack of structure makes it hard to propose projects and form teams efficiently.
*   **Innovation Bottleneck:** Students struggle to move from a general interest to a concrete, actionable project idea.

## The Solution

This application directly addresses these challenges by creating a single, integrated platform with features designed to foster a thriving, collaborative community.

### Key Features

*   **👥 Member Directory & Peer Finder:**
    *   A searchable and filterable directory of all community members.
    *   Rich user profiles showcasing skills, interests, bio, and active projects.
    *   Instantly find collaborators with specific expertise (e.g., "Find all members skilled in Flutter").

*   **💡 Structured Projects Hub:**
    *   A central board to browse all community projects.
    *   Members can propose new projects with detailed problem statements and required skills.
    *   A "Request to Join" system streamlines team formation.
    *   Track project status: "Recruiting," "In Progress," or "Completed."

*   **💬 Integrated Real-time Chat:**
    *   A **global "Community Chat"** for announcements and group discussions.
    *   **Direct one-on-one messaging** to facilitate private conversations.
    *   **Push notifications** for new messages ensure timely communication and keep the community engaged.

*   **🤖 AI-Powered Idea Generator:**
    *   Powered by the **Google Gemini API**, this feature helps spark creativity.
    *   Users can input keywords (e.g., "campus, health, data") to generate structured project ideas.
    *   With a single tap, an AI-generated idea can be converted into a new project on the platform, ready for members to join.

## Technology Stack

This project is built from the ground up using Google's powerful and scalable developer ecosystem.

| Component              | Technology                                                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Mobile Framework**   | ⚛️ **Flutter** - For building a high-quality, natively compiled app for both iOS and Android.                 |
| **Architecture**       | 🧩 **GetX** - For state, dependency, and route management in a clean and efficient way.                        |
| **Backend & Database** | 🔥 **Firebase Suite**:                                                                                         |
|                        |    • **Firebase Authentication** - Secure "Sign in with Google".                               |
|                        |    • **Cloud Firestore** - Real-time NoSQL database for all dynamic app data.                   |
|                        |    • **Firebase Storage** - For user-generated content like profile pictures.                   |
|                        |    • **Cloud Functions** - Serverless backend for notifications and secure API calls.           |
|                        |    • **Firebase Cloud Messaging (FCM)** - For push notifications.                               |
|                        |    • **App Check** - To protect backend resources from abuse.                                   |
| **AI Integration**     | ✨ **Google Gemini API** (`gemini-1.5-flash`) - To power the AI Project Idea Generator.                         |

## Project Structure

The project follows a clean, feature-first architecture to ensure scalability and maintainability.


## Getting Started

To run this project locally, you will need to have a Firebase project set up.

### Prerequisites

*   Flutter SDK installed.
*   A Firebase project created on the [Firebase Console](https://console.firebase.google.com/).
*   The Firebase CLI installed (`npm install -g firebase-tools`).
*   A Google Gemini API key from [Google AI Studio](https://makersuite.google.com/).

### Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/gdg-campus-connect.git
    cd gdg-campus-connect
    ```

2.  **Configure Firebase for Flutter:**
    *   Use the FlutterFire CLI to connect your app to your Firebase project.
        ```bash
        flutterfire configure
        ```
    *   This will generate a `lib/firebase_options.dart` file (which is included in `.gitignore`).

3.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Set up Firebase Functions (Backend):**
    *   Navigate to the functions directory:
        ```bash
        cd functions
        ```
    *   Install backend dependencies:
        ```bash
        npm install
        ```
    *   **Securely set your Gemini API key** using the Firebase CLI (do not hardcode it!):
        ```bash
        firebase functions:secrets:set GEMINI_API_KEY
        ```
        (Paste your key when prompted).
    *   Deploy the functions to your project:
        ```bash
        cd ..
        firebase deploy --only functions
        ```
        *(Note: The first deployment of a 2nd Gen function may require enabling APIs or permissions in your Google Cloud project.)*

5.  **Set up App Check:**
    *   Run the app on a device/emulator.
    *   Look for the App Check debug token in your run console.
    *   Go to your Firebase Console -> App Check -> Apps, and add the debug token.

6.  **Run the App:**
    ```bash
    flutter run
    ```

## Future Scope

*   Project progress tracking with milestones.
*   A dedicated Events tab with RSVP functionality.
*   Rich text and image sharing in chat.
*   User-to-user skill endorsements.

---

Feel free to contribute to this project by submitting a pull request. For major changes, please open an issue first to discuss what you would like to change.
