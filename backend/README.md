# StudyAi - Backend API Server

High-performance Node.js, Express, and TypeScript backend powered by Prisma ORM, Google Gemini AI, and Supabase Vector for RAG (Retrieval-Augmented Generation).

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```
Fill in the following variables:
- `PORT`: Server port (default `3000`)
- `DATABASE_URL`: PostgreSQL connection string (Supabase transaction pooler)
- `DIRECT_URL`: Direct PostgreSQL connection string (Supabase session pooler for migrations)
- `GOOGLE_GENERATIVE_AI_API_KEY`: API Key from Google AI Studio
- `SUPABASE_URL`: Supabase project URL
- `SUPABASE_SERVICE_ROLE_KEY`: Supabase service role secret

### 3. Database & Vector Setup
```bash
# Generate Prisma Client
npm run prisma:generate

# Push schema changes to Supabase
npm run prisma:push

# Configure pgvector extensions and index
npx ts-node scripts/setup_vector.ts
```

### 4. Run Development Server
```bash
npm run dev
```

## 🛠️ Available Scripts

- `npm run dev` - Start server with auto-reload via `ts-node-dev`
- `npm run build` - Compile TypeScript to `dist/`
- `npm start` - Run compiled server from `dist/index.js`
- `npm run prisma:generate` - Generate Prisma Client
- `npm run prisma:push` - Synchronize schema directly with database

## 🧠 AI Architecture

The backend features a multi-agent system:
- **Tutor Agent**: Explains concepts and provides Socratic coaching.
- **RAG Service**: Handles semantic search over uploaded document chunks using `pgvector`.
- **Quiz Agent**: Generates structured multiple-choice quizzes with explanations.
- **Planner Agent**: Schedules adaptive study sessions.
- **Flashcard Agent**: Produces flashcards with spaced repetition intervals.