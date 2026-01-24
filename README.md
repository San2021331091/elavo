# Elavo

**Elavo** is a recipe project made using **Flutter** and **Firebase**. It allows users to explore, add, and manage recipes seamlessly with a modern mobile interface.
---

## Features
- Browse a variety of recipes from **TheMealDB API**.
- Add, edit, and delete your own recipes using **Supabase** for backend storage.
- Upload images for recipes using the device camera or gallery.
- Environment-based configuration using `.env` files.
- Modern, responsive UI with Flutter's Material Design.
---


## Screenshots

Here are some screenshots of the app:
<style>
  .screenshot-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 14px;
    margin-top: 16px;
  }

  .screenshot-grid figure {
    text-align: center;
    margin: 0;
  }

  .screenshot-grid img {
    width: 100%;
    height: auto;
    border-radius: 8px;
    border: 1px solid #e1e1e1;
    box-shadow: 0 2px 5px rgba(0,0,0,0.08);
  }

  .screenshot-grid figcaption {
    margin-top: 6px;
    font-size: 13px;
    color: #555;
  }
</style>

<div class="screenshot-grid">
  <figure>
    <img src="screenshots/splash.png" alt="Splash Screen">
    <figcaption>Splash Screen</figcaption>
  </figure>

  <figure>
    <img src="screenshots/homepage.png" alt="Home Screen">
    <figcaption>Home Screen</figcaption>
  </figure>

  <figure>
    <img src="screenshots/recipesection.png" alt="Recipe Details">
    <figcaption>Recipe Details</figcaption>
  </figure>

  <figure>
    <img src="screenshots/addrecipe.png" alt="Add Recipe">
    <figcaption>Add Recipe</figcaption>
  </figure>

  <figure>
    <img src="screenshots/myrecipe.png" alt="My Recipe">
    <figcaption>My Recipe</figcaption>
  </figure>

  <figure>
    <img src="screenshots/search.png" alt="Search Recipe">
    <figcaption>Search</figcaption>
  </figure>

  <figure>
    <img src="screenshots/categorysection.png" alt="Recipe Category">
    <figcaption>Category</figcaption>
  </figure>

  <figure>
    <img src="screenshots/login.png" alt="Login">
    <figcaption>Login</figcaption>
  </figure>

  <figure>
    <img src="screenshots/register.png" alt="Register">
    <figcaption>Register</figcaption>
  </figure>

  <figure>
    <img src="screenshots/profile.png" alt="Profile">
    <figcaption>Profile</figcaption>
  </figure>
</div>

  

> Replace the filenames with your actual images inside the `screenshots/` folder.

---

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) >= 3.8.1
- Dart SDK >= 3.8.1
- Firebase project (for authentication and database)
- Supabase account (for managing recipe details)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/elavo.git
cd elavo
````

2. Install dependencies:

```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your environment variables:

```env
IMGBB_API_KEY=your_imgbb_api_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Run the app:

```bash
flutter run
```
---

## Dependencies

* **Flutter SDK**: Core framework for building the app.
* **cupertino_icons**: iOS-style icons.
* **supabase_flutter**: Backend service for creating and managing recipe details.
* **flutter_dotenv**: Environment variable support.
* **image_picker**: Upload images from camera or gallery.
* **dio**: HTTP client for API requests.
* **TheMealDB API**: Provides recipe data to display in the app.

---

## Project Structure

```
lib/
 ├─ main.dart          # App entry point
 ├─ pages/           # All screens (home, recipe detail, add recipe)
 ├─ widgets/           # Reusable widgets
 ├─ services/          # API and Supabase integration
         
```
---

## Usage

1. Browse recipes from **TheMealDB API** on the home screen.
2. Add your own recipes with details stored in **Supabase**.
3. Edit or delete your recipes anytime.
4. Upload images for your recipes using your device camera or gallery.

---

## License

This project is open-source and available under the MIT License.


