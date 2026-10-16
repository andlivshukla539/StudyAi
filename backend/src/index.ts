import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import chatRouter from './routes/chat';
import authRouter from './routes/auth';
import userRouter from './routes/users';
import quizRoutes from './routes/quiz';
import flashcardRoutes from './routes/flashcard';
import studyRoutes from './routes/study';
import { prisma } from './utils/db.util';


const app = express();
const port = Number(process.env.PORT) || 3000;

// Middleware
app.use(cors());
app.use(express.json());

import documentsRouter from './routes/documents';
import { authenticate } from './middleware/auth.middleware';

// Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/users', authenticate, userRouter);
app.use('/api/v1/chat', authenticate, chatRouter);
app.use('/api/v1/documents', authenticate, documentsRouter);
app.use('/api/v1/quizzes', authenticate, quizRoutes);
app.use('/api/v1/flashcards', authenticate, flashcardRoutes);
app.use('/api/v1/study', authenticate, studyRoutes);

// Fast ping — no DB, no auth, instant response for client warm-up
app.get('/ping', (_req, res) => {
  res.status(200).send('pong');
});

// Health check — warms DB connection pool
app.get('/health', async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ status: 'ok', db: 'connected', environment: process.env.NODE_ENV });
  } catch {
    res.status(503).json({ status: 'degraded', db: 'disconnected' });
  }
});

// Eagerly warm DB connection pool on startup (eliminates first-query cold start)
async function startServer() {
  try {
    await prisma.$connect();
    console.log('[db]: Prisma connected and connection pool warmed');
  } catch (e) {
    console.warn('[db]: Initial connection failed, will retry on first request:', e);
  }

  app.listen(port, '0.0.0.0', () => {
    console.log(`[server]: Server is running at http://0.0.0.0:${port}`);
  });
}

startServer();
