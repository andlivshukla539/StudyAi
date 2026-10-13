<p align="center">
  <img src="img/appIcon.png" alt="StudyAi Logo" width="120" style="border-radius: 24px; box-shadow: 0 8px 24px rgba(0,0,0,0.15);" />
</p>

<h1 align="center">StudyAi - Intelligent Multi-Agent Study Companion</h1>

<p align="center">
  <strong>Your all-in-one AI study mentor powered by Google Gemini, Supabase Vector RAG, and Flutter.</strong>
</p>

<p align="center">
  <a href="#-key-features"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/Node.js-18+-339933?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/TypeScript-5.5-3178C6?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/Google_Gemini-AI-8E75B2?style=for-the-badge&logo=google&logoColor=white" alt="Gemini" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/Supabase-pgvector-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase" /></a>
  <a href="#-key-features"><img src="https://img.shields.io/badge/Prisma-ORM-2D3748?style=for-the-badge&logo=prisma&logoColor=white" alt="Prisma" /></a>
</p>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Screenshots & UI Showcase](#-screenshots--ui-showcase)
- [System Architecture](#-system-architecture)
- [Repository Structure](#-repository-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#1-backend-setup)
  - [Frontend Setup](#2-frontend-setup)
- [Environment Configuration & Security](#-environment-configuration--security)
- [API Overview](#-api-overview)
- [Documentation](#-documentation)
- [License](#-license)

---

## 🌟 Overview

**StudyAi** is an advanced AI-powered educational companion designed to transform how students and lifelong learners interact with study material. By pairing **Google Gemini** with a **pgvector-backed Retrieval-Augmented Generation (RAG)** pipeline and an intuitive cross-platform **Flutter** client, StudyAi delivers context-aware tutoring directly from uploaded textbooks and lecture notes.

### Why StudyAi?
- **Zero Hallucination with Document RAG**: Answers are grounded directly in your uploaded PDF materials with page-level citations.
- **Multi-Agent Orchestration**: Specialized AI agents handle tutoring, intelligent quiz generation, personalized study planning, and flashcards.
- **Clean Monorepo Architecture**: Clean separation of concerns with standalone `/frontend` and `/backend` directories.

---

## ✨ Key Features

| Feature | Description |
| :--- | :--- |
| 🤖 **Interactive AI Tutor** | Conversational tutor that adapts explanations to your learning level (Beginner, Intermediate, Advanced) with full LaTeX/Math formula rendering. |
| 📚 **Smart PDF RAG Engine** | Upload course PDFs, extract semantic chunks, generate embeddings, and query documents directly. |
| 🎯 **AI Quiz Generation** | Auto-generate multiple-choice quizzes from documents or topics with timer-based tests and performance analysis. |
| 🗓️ **Adaptive Study Planner** | AI-driven schedules tailored to your upcoming exam dates, daily workload, and study habits. |
| ⏱️ **Focus Timer & Analytics** | Integrated Pomodoro focus timer with study streak tracking and productivity analytics. |
| 🃏 **Smart Flashcards** | Spaced repetition flashcards automatically generated from weak quiz topics. |
| 🔒 **Enterprise-Grade Security** | Tenant-isolated vector search, JWT authentication, and zero credential leakage by design. |

---

## 📱 Screenshots & UI Showcase

<div align="center">

| Home Dashboard | AI Tutor Chat | Quiz Arena |
| :---: | :---: | :---: |
| <img src="img/homesc.jpg" width="260" alt="Home Screen"/> | <img src="img/aiTutor.jpg" width="260" alt="AI Tutor"/> | <img src="img/QuizScreen.jpg" width="260" alt="Quiz Screen"/> |

| Study Planner | Document Library | Quizzes & Progress |
| :---: | :---: | :---: |
| <img src="img/study_plan.jpg" width="260" alt="Study Plan"/> | <img src="img/doc.jpg" width="260" alt="Documents"/> | <img src="img/myquizess.jpg" width="260" alt="My Quizzes"/> |

</div>

---

## 🏗️ System Architecture

```mermaid
graph TD
    subgraph Frontend ["Flutter Mobile Client (frontend/)"]
        UI[Material 3 UI]
        Riverpod[Riverpod State Management]
        GoRouter[GoRouter Navigation]
        DioClient[Dio HTTP / SSE Client]
    end

    subgraph Backend ["Node.js + Express + TypeScript (backend/)"]
        API[Express API Gateway]
        Auth[JWT & Bcrypt Auth]
        Orchestrator[AI Study Orchestrator]
        Workers[Document Processing Queue]
    end

    subgraph AI_Services ["AI & Knowledge Layer"]
        IntentRouter[Intent Router]
        TutorAgent[Tutor Agent]
        QuizAgent[Quiz Agent]
        PlannerAgent[Planner Agent]
        FlashcardAgent[Flashcard Agent]
        Gemini[Google Gemini API]
    end

    subgraph Data_Layer ["Data & Storage"]
        Prisma[Prisma ORM]
        SupabaseDB[(PostgreSQL + pgvector)]
        Storage[(Supabase Storage)]
    end

    UI --> Riverpod
    Riverpod --> DioClient
    DioClient <-->|REST / SSE| API
    API --> Auth
    API --> Orchestrator
    API --> Workers
    Workers --> Storage
    Workers --> SupabaseDB

    Orchestrator --> IntentRouter
    IntentRouter --> TutorAgent
    IntentRouter --> QuizAgent
    IntentRouter --> PlannerAgent
    IntentRouter --> FlashcardAgent
    
    TutorAgent <--> Gemini
    QuizAgent <--> Gemini
    PlannerAgent <--> Gemini
    FlashcardAgent <--> Gemini

    Orchestrator <--> Prisma
    Prisma <--> SupabaseDB
```

---

## 📁 Repository Structure

```text
StudyAi/
├── frontend/                  # Flutter mobile & web client application
│   ├── android/              # Native Android configuration
│   ├── ios/                  # Native iOS configuration
│   ├── lib/                  # Dart source code
│   │   ├── core/             # Theme, network, routing, shared UI widgets
│   │   └── features/         # Feature modules (auth, chat, quiz, documents, study_plan)
│   ├── assets/               # Local images, icons, and fonts
│   └── pubspec.yaml          # Flutter dependencies and assets config
│
├── backend/                   # Node.js TypeScript API server
│   ├── src/
│   │   ├── ai/               # Multi-agent orchestrator, Gemini provider & RAG pipeline
│   │   │   ├── agents/       # Tutor, Quiz, Flashcard & Planner agents
│   │   │   ├── routers/      # Intent router
│   │   │   └── services/     # Embedding & RAG services
│   │   ├── routes/           # Express REST endpoints (auth, chat, docs, quiz, study)
│   │   ├── middleware/       # JWT auth & error handling middleware
│   │   ├── workers/          # Background document parsing & chunking worker
│   │   └── index.ts          # Server entry point
│   ├── prisma/
│   │   └── schema.prisma     # Prisma database models & pgvector schema
│   ├── scripts/              # Database migration, vector setup & test utilities
│   ├── .env.example          # Template for backend environment variables
│   └── package.json          # Node.js dependencies and scripts
│
├── docs/                      # Technical specifications & design documents
│   ├── AI_ARCHITECTURE.md    # Multi-agent and RAG technical details
│   ├── API_SPEC.md           # REST endpoint documentation
│   ├── DATABASE_DESIGN.md    # Database schema & entity relationships
│   ├── PROJECT_ARCHITECTURE.md # High-level architecture decisions
│   └── UI_DESIGN_SYSTEM.md   # Design tokens, typography & color system
│
├── img/                       # UI screenshots and application brand assets
├── .gitignore                 # Root gitignore preventing credential & build leaks
└── README.md                  # Project documentation (this file)
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** (v18.x or v20.x+) & **npm**
- **Flutter SDK** (v3.2.0 or higher) & **Dart SDK** (v3.2+)
- A **Supabase** account (PostgreSQL with `pgvector` extension)
- A **Google Gemini API Key** (obtainable via [Google AI Studio](https://aistudio.google.com/app/apikey))

---

### 1. Backend Setup

1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   ```
   Open `.env` and provide your credentials (see [Environment Configuration](#-environment-configuration--security)).

4. Set up the database and vector extension:
   ```bash
   npx prisma generate
   npx prisma db push
   npx ts-node scripts/setup_vector.ts
   ```

5. Start the backend development server:
   ```bash
   npm run dev
   ```
   The backend will be available at `http://localhost:3000`.

---

### 2. Frontend Setup

1. Navigate to the `frontend` folder:
   ```bash
   cd frontend
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run code generation (for Freezed & JSON serializable):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch the application:
   ```bash
   flutter run
   ```
   > **Note:** For physical devices or emulators, ensure the API base URL in `frontend/lib/core/network/dio_client.dart` matches your local machine's IP or tunnel URL.

---

## 🔐 Environment Configuration & Security

> **Security Assurance:** All `.env` files, private keys, certificates, service account credentials, and build caches are strictly ignored by `.gitignore` to prevent any credential leaks. Never commit your `.env` file to version control.

The backend requires the following configuration variables in `backend/.env`:

```env
# Server Configuration
PORT=3000

# Supabase PostgreSQL (pgvector enabled)
DATABASE_URL="postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres"

# Google Gemini API Key
GOOGLE_GENERATIVE_AI_API_KEY="your-gemini-api-key"

# Supabase Storage & Service Role
SUPABASE_URL="https://[PROJECT-REF].supabase.co"
SUPABASE_SERVICE_ROLE_KEY="your-supabase-service-role-key"
```

---

## 📡 API Overview

| Route | Method | Description |
| :--- | :---: | :--- |
| `/api/v1/auth/register` | `POST` | Register a new user account |
| `/api/v1/auth/login` | `POST` | Log in and receive JWT token |
| `/api/v1/users/me` | `GET` | Retrieve profile and stats |
| `/api/v1/chat` | `POST` | Chat with AI tutor (streaming SSE) |
| `/api/v1/documents` | `GET` / `POST` | Upload and list study materials |
| `/api/v1/quizzes/generate` | `POST` | Generate AI quizzes from topics/documents |
| `/api/v1/quizzes/:id/attempts`| `POST` | Submit quiz attempt and receive score |
| `/api/v1/flashcards/review` | `GET` | Get flashcards due for review |
| `/api/v1/study-plans` | `GET` / `POST` | Create or view personalized study schedules |

For full endpoint documentation, refer to [`docs/API_SPEC.md`](docs/API_SPEC.md).

---

## 📚 Documentation

Detailed architectural and design specifications can be found in the [`docs/`](docs/) directory:
- [AI Architecture & Agent Orchestration](docs/AI_ARCHITECTURE.md)
- [REST API Specifications](docs/API_SPEC.md)
- [Database Schema & Entity Design](docs/DATABASE_DESIGN.md)
- [System Architecture](docs/PROJECT_ARCHITECTURE.md)
- [Mobile UI Design System](docs/UI_DESIGN_SYSTEM.md)
- [Development Roadmap](docs/DEVELOPMENT_ROADMAP.md)

---

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
