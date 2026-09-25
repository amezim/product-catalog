# Product Catalog Application

A responsive product catalog application featuring integration with the DummyJSON REST API, server-side pagination, debounced API search and robust offline/error handling.

---

## Dependencies

* **Framework:** Flutter (Dart 3+)
* **State Management:** `ChangeNotifier` with `ListenableBuilder`
* **Networking:** `APIServices` via `http` package
* **Data Sources:** DummyJSON Products API (`https://dummyjson.com/products`)

---

## Architecture and Technical Decisions

This application uses **Model-Controller-Service** architecture which is an extended version of Model-View-Controller architecture to separate several components into not only user interfaces, data structure and business logics but also network requests. The architecture is chosen due to its maintainability, ensuring that any changes can be handled easier without affecting the UI rendering.

* **Model Layer (`models/product.dart`):** Defines data structure and JSON parsing logic
* **Controller Layer (`controller/menu_controller.dart`):**  Manages state transitions, search state, pagination and network states (success, loading, empty and error)
* **Service Layer (`services/api_services.dart`, `services/debouncer.dart`):** Handles HTTP requests from the REST API and timer debouncing for query limiting
* **View Layer (`pages/menu_page.dart`, `pages/product_details_page.dart`):**  Contains user interfaces focused on rendering state changes and user interactions

---

## Note on AI Usage

In accordance with the assessment guidelines, AI assistance was utilized strictly for research and guidance purposes only. AI tools were referenced minimally in this project to consult on some concepts that I had not previously used to, specifically providing technical guidance on the **integration of REST API** and **managing complex network states**. Others including core code, business logic and UI components were built through manual research and I retain full understanding and accountability for every component in this repository

---

## How to Run the App 

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.0.0` or higher)
* [Dart SDK](https://dart.dev/get-dart) (`v3.0.0` or higher)
* Android Studio or VS Code with Flutter extensions installed
* An Emulator or a physically connected mobile device

### Step-by-Step Setup

1. **Clone the Repository:** Download the project files and navigate into the root directory
   
   git clone [https://github.com/amezim/product_catalog.git](https://github.com/amezim/product_catalog.git)
   cd product_catalog

2. **Install Dependencies:** Download all required Flutter and Dart packages
    
    flutter pub get

3. **Verify Device Connection:** Ensure the emulator or physical device is recognized

    flutter devices

4. **Run the Application:** Build and launch the app on your selected device 

    flutter run
