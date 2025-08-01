# Interactive Data Science Sandbox: An ML Learning Playground

A desktop application providing an intuitive, visual playground for exploring fundamental Machine Learning (ML) concepts through interactive data analysis and algorithm visualization.

---

### Project Artifacts

*   **Backend API Documentation (Live):** [Live Backend Docs](https://interactive-data-sandbox.onrender.com/api/v1/docs)
*   **Frontend Desktop App:** As this is a desktop application, a live web demo is not applicable. Please see the video demo below for a full walkthrough.
*   **Source Code:** [Interactive Data SandBox](https://github.com/AmeyPacharkar1896/interactive_data_sandbox)

---

### 15-Second Demo

![Sentry In Action GIF](https://github.com/user-attachments/assets/52bb2285-e26e-4f96-aeaa-5cb81fbdac1e)

---

### Problem Statement

Understanding complex Machine Learning algorithms often requires diving deep into code and mathematical theory, which can be a barrier for students, enthusiasts, and even experienced professionals seeking quick visual insights. Traditional static visualizations or command-line outputs lack the interactive "what-if" scenarios crucial for intuitive learning.

This project solves this by providing a hands-on, interactive environment where users can directly manipulate data and model parameters, instantly observing how these changes impact visualizations and metrics, thereby demystifying ML concepts through direct engagement.

---

### Tech Stack & Architecture

This application comprises a Flutter desktop frontend communicating with a Python FastAPI backend API.

#### Frontend (Desktop Application):

*   **Framework:** Flutter (`^1.0.0`)
*   **State Management:** `flutter_bloc` & `equatable`
*   **Charting:** `fl_chart` (`1.0.0`)
*   **Networking:** `http`
*   **File Picker:** `file_picker`

**Justification:**
*   **Flutter:** Chosen for its exceptional ability to build high-performance, natively compiled desktop applications from a single codebase, leveraging existing mobile development skills. Its rich UI toolkit allows for beautiful, custom designs and smooth animations critical for an interactive data visualization tool.
*   **flutter_bloc:** Selected for its robust, predictable state management pattern, ensuring clear separation of concerns (UI, Business Logic, Data) and making the complex asynchronous data flows (file upload, API calls) manageable and testable.
*   **fl_chart:** Provides powerful, flexible charting capabilities essential for dynamic data visualizations, allowing for deep customization needed for ML plots.

#### Backend (API Service):

*   **Language:** Python (`3.10+`)
*   **Web Framework:** FastAPI (`0.111.0`)
*   **Data Manipulation:** Pandas (`2.2.2`)
*   **Machine Learning:** Scikit-learn (`1.5.0`)
*   **ASGI Server:** Uvicorn (`0.30.1`)

**Justification:**
*   **Python:** The industry standard for data science and machine learning due to its vast ecosystem of libraries and strong community support.
*   **FastAPI:** Chosen for building the RESTful API due to its modern asynchronous capabilities (high performance), automatic Pydantic-based data validation (ensuring robust API contracts), and auto-generated interactive API documentation (Swagger UI/ReDoc), significantly boosting developer productivity.
*   **Pandas & Scikit-learn:** The definitive libraries for data handling and classical ML algorithms in Python, providing battle-tested and efficient implementations for data processing, EDA, and K-Means.

---

### Architecture Diagram

**(INSTRUCTION: Replace this code block with an embedded image of your architecture diagram.)**
```
+--------------------------+          HTTP/REST API           +--------------------------+
|                          | <------------------------------> |                          |
|  Flutter Desktop Client  |                                  |   FastAPI Backend Service  |
|       (Frontend)         |                                  |        (Backend)         |
|                          |                                  |                          |
+------------+-------------+                                  +------------+-------------+
             ^                                                              |
             | (User Interaction:                                           | (Data Processing & ML:
             |  File Upload, Param Selection)                               |  Pandas, Scikit-learn)
             |                                                              |
             +--------------------------------------------------------------+
```
**Description:** The Flutter desktop application serves as the interactive client, sending user-initiated requests (CSV upload, feature selection, ML algorithm execution) to the FastAPI backend via RESTful API calls. The Python backend processes these requests using Pandas for data manipulation and Scikit-learn for machine learning computations, returning structured JSON results back to the frontend for dynamic visualization. Data is stored in-memory on the backend for the MVP.

---

### Key Features & Functionality (MVP)

*   **CSV Data Upload:** Intuitive UI to upload CSV files, displaying basic raw data (first 5 rows with horizontal scroll) and inferred column information (name, data type tags).
*   **Interactive Scatter Plot:** Allows selection of any two numerical features for dynamic scatter plot generation with real-time updates, custom axis labels, and tooltip on hover.
*   **K-Means Clustering:** Integrates K-Means unsupervised learning. Users can adjust the number of clusters (k) via a slider and instantly visualize data points colored by their assigned clusters, with cluster centroids highlighted.
*   **Clustering Evaluation:** Displays key K-Means metrics including Inertia and Silhouette Score to help assess clustering quality.
*   **Modular & Clean UI:** Features a modern, card-based, two-panel layout with tabbed views for organized data and plot display, adhering to Flutter's best practices.

---

### Challenges & Solutions

#### **Solving Flutter's RenderFlex Overflow: A Deep Dive into Layout Constraints**
*   **Description:** A common Flutter layout issue where widgets with flexible sizing (`Expanded`) are placed within parents (`Column` in a `SingleChildScrollView`) that provide unbounded constraints, leading to visual overflow and rendering errors.
*   **Solution:** Systematically restructured the main screen to ensure that `Expanded` widgets always had a bounded parent. This involved carefully nesting `Columns` and `Rows`, and refactoring child widgets to handle their own internal scrolling (`ListView.builder`, `SingleChildScrollView`) while remaining flexible to their parent's bounded constraints.

#### **Taming Dependency Hell: Pinning Versions and Rewriting for Breaking API Changes**
*   **Description:** Integrating the `fl_chart` library proved highly challenging due to frequent API breaking changes between minor versions. This led to persistent compilation errors regarding missing parameters and type mismatches.
*   **Solution:** After multiple debugging attempts, the solution involved explicitly pinning the `fl_chart` dependency to a specific version (`1.0.0`) in `pubspec.yaml`. Subsequently, the plotting code was meticulously rewritten to conform exactly to the new API, including changes to `SideTitles.getTitlesWidget`, `ScatterSpot.dotPainter`, and `ScatterTouchTooltipData.getTooltipItems`.

#### **Debugging Across the Stack: Hardening JSON Deserialization Between Python and Dart**
*   **Description:** Faced recurring `422 Unprocessable Entity` errors from FastAPI and `type 'Null' is not a subtype of type 'String'` exceptions in Flutter, traced to minor but critical inconsistencies like `snake_case` vs. `camelCase` keys and unexpected `null` values.
*   **Solution:** Implemented robust debugging by inspecting raw request/response payloads. The `toJson()` methods in Flutter's request models were explicitly set to output `snake_case` keys. Crucially, all `fromJson()` factory constructors in Flutter's response models were hardened with null-aware (`?.`) and null-coalescing (`??`) operators to provide default fallbacks and prevent runtime type errors.

---

### Setup and Installation (Local Development)

Follow these steps to get the Interactive Data Science Sandbox running on your local machine.

#### Prerequisites
*   **Git:** For cloning the repository.
*   **Python 3.10+:** Recommended to use Anaconda/Miniconda for environment management.
*   **Flutter SDK:** Install Flutter for your operating system.
*   **IDE:** VS Code with Flutter and Python extensions is recommended.

#### Steps
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/AmeyPacharkar1896/interactive_data_sandbox.git
    cd interactive_data_sandbox
    ```

2.  **Backend Setup (FastAPI):**
    ```bash
    cd backend
    python -m venv venv                # Create a virtual environment
    .\venv\Scripts\activate            # Activate on Windows
    # source venv/bin/activate         # Activate on macOS/Linux
    pip install -r requirements.txt    # Install dependencies
    python -m uvicorn app.main:app --reload  # Run the backend server
    ```
    *(Keep this terminal running. The API will be at `http://127.0.0.1:8000` and interactive docs at `http://1227.0.0.1:8000/api/v1/docs`.)*

3.  **Frontend Setup (Flutter Desktop):**
    ```bash
    cd ../frontend
    flutter config --enable-windows-desktop  # Enable for your platform (windows, macos, linux)
    flutter clean                      # Clean previous builds
    flutter pub get                    # Get Flutter dependencies
    flutter run -d windows             # Run the Flutter desktop app (replace 'windows' with 'macos' or 'linux')
    ```

---

### Code Quality & Future Work

*   **Modular Architecture:** The project adheres to a "module-first" architecture for both frontend (Flutter) and backend (FastAPI), ensuring clear separation of concerns.
*   **BLoC State Management (Flutter):** Utilizes `flutter_bloc` for robust, predictable, and testable state management, separating UI from business logic.
*   **Testing (Future Work):** This MVP primarily focused on core functionality. Future iterations will include a `/tests` directory with unit and integration tests for both frontend BLoCs and backend API endpoints to ensure robustness and maintainability.
