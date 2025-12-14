# Todo MVVM App – CodeNicely Flutter Assignment

A complete **Todo Management Application** built with **Flutter**, strictly following **MVVM architecture** and **GetX** for state management, routing, and dependency injection.

Submitted for **CodeNicely Software Services LLP – Flutter Developer Shortlisting Assignment**.

## 📸 Screenshots

> Create a folder named `screenshots/` in your project root and place the images there.

| Login Screen | Register Screen | Todo List | Add Todo | Edit Todo |
|--------------|-----------------|------------------------|
| ![Login](screenshots/login.png) | ![Register](screenshots/register.png) | ![Todo List](screenshots/todo_list.png) | ![Add Todo](screenshots/add_todo.png) | ![Edit Todo](screenshots/edit_todo.png) |

## 🚀 Features Implemented

### Required Features (All Completed) ✅
- **User Authentication**
  - Register & Login with email + password
  - Session persistence using Hive
  - Auto-login on app restart (persistent logged-in state)
  - **Logout clears everything** (session + all Todo data + app state reset)
- **Full Todo CRUD**
  - Add, Edit, Delete, View Todos
  - Toggle completion (Pending ↔ Completed)
  - Fields: Title, Description (optional), Created/Updated Date, Status
- **Local Database**
  - **Hive** used for fast, lightweight persistence
  - Todos and user session persist across app restarts
- **Strict MVVM Architecture**
  - No business logic in UI
  - Clean separation: Model → ViewModel → View → Repository
- **GetX Integration**
  - State management (Rx observables)
  - Routing (GetX routes)
  - Dependency Injection (Bindings)
- **Clean & Scalable Folder Structure**

### Bonus Enhancements (Extra Points) ✨
- **Search** Todos by title or description
- **Filter** by status (All / Pending / Completed)
- **Dark Mode** with theme toggle & persistent preference (saved in Hive)
- **Custom Modern Snackbar** (success, error, warning, info)
- **Form Validation** with real-time user feedback
- **Password Visibility Toggle**
- **Beautiful Empty State** with illustration
- **Polished Modern UI** (cards, shadows, consistent design)
- **Error Handling** throughout the app

## 📂 Project Structure

lib/
├── core/
│   ├── controllers/      # ThemeController
│   ├── utils/            # Custom Snackbar
│   ├── theme/            # AppTheme (light/dark)
│   ├── constant.dart
│   └── hive_init.dart
├── features/
│   ├── auth/
│   │   ├── controllers/  # AuthController
│   │   ├── models/       # User model + Hive adapter
│   │   ├── repositories/ # AuthRepository
│   │   └── views/        # LoginView, RegisterView
│   └── todo/
│       ├── controllers/  # TodoController
│       ├── models/       # Todo model + Hive adapter
│       ├── repositories/ # TodoRepository
│       └── views/        # TodoListView, AddTodoView, EditTodoView
├── routes/
│   └── app_pages.dart    # Routes, initial route logic, bindings
├── main.dart



## 🛠 Tech Stack

- **Flutter** – UI framework
- **GetX** – State, routing, DI
- **Hive** – Local NoSQL database
- **hive_flutter** – Hive integration
- **uuid** – Unique ID generation
- **path_provider** – App documents directory

## ⚙️ How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/todo_mvvm_app.git

2.  cd todo_mvvm_app

3.   flutter pub get

4.   flutter run
