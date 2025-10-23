#!/bin/bash

# AutoBrain Repository Setup Script
# This script creates the complete AutoBrain monorepo structure

set -e

echo "🚀 Setting up AutoBrain repository..."

# Clone the repository
REPO_URL="https://github.com/Balu-ak/Copilot-test.git"
BRANCH_NAME="feature/autobrain-init"

# Check if directory exists
if [ -d "Copilot-test" ]; then
    echo "⚠️  Directory 'Copilot-test' already exists. Please remove it or choose a different location."
    exit 1
fi

echo "📦 Cloning repository..."
git clone $REPO_URL
cd Copilot-test

echo "🌿 Creating new branch..."
git checkout -b $BRANCH_NAME

echo "📁 Creating directory structure..."
mkdir -p apps/web/app/chat/\[id\]
mkdir -p apps/api
mkdir -p apps/workers
mkdir -p packages/orchestrator/tools
mkdir -p packages/shared
mkdir -p packages/clients
mkdir -p infra/docker
mkdir -p infra/k8s/helm
mkdir -p infra/terraform
mkdir -p .github/workflows
mkdir -p scripts

echo "📝 Creating files..."

# ============================================
# ROOT FILES
# ============================================

cat > README.md << 'EOF'
# AutoBrain – Autonomous Knowledge Assistant for Teams

A production-grade AI assistant that learns from company docs, email, and Slack; answers questions; summarizes updates; and performs delegated tasks.

## 🚀 Features

- **RAG Pipeline**: Semantic search over Google Drive, Slack, Gmail, and uploaded documents
- **Multi-Agent Workflows**: Router, Retriever, Synthesizer, and Action agents powered by LangGraph
- **Enterprise Security**: Row-level security, PII redaction, audit logging, RBAC
- **Integrations**: Slack, Gmail, Google Drive/Docs, Jira
- **Production Ready**: Kubernetes deployment, CI/CD, observability (Prometheus, Grafana, Sentry)

## 🏗️ Architecture

```
┌───────────────┐     Web/Auth     ┌──────────────────────────┐
│  Next.js App  │◀────────────────▶│  Clerk/Auth.js           │
└─────▲─────────┘                  └──────────────────────────┘
      │ REST/WebSocket                                  
      ▼                                                    
┌─────────────────────────┐  Pub/Sub  ┌─────────────────────────┐
│  API Gateway (FastAPI)  │◀────────▶│  Worker(s) (Celery)     │
│  /chat /ingest /actions │          │  Ingest/Index/Actions   │
└──────────┬──────────────┘           └──────────┬──────────────┘
           │                                      │
     ┌─────▼─────┐                          ┌─────▼──────┐
     │ Postgres  │                          │ Vector DB  │
     │ (state)   │                          │ (Weaviate) │
     └─────┬─────┘                          └─────┬──────┘
           │                                       │
     ┌─────▼───────────────────────────────┐      │
     │  LangGraph Orchestrator             │      │
     │  (agents, tools, guardrails)        │      │
     └─────────────────────────────────────┘      │
```

## 📦 Tech Stack

- **Frontend**: Next.js 14 (App Router), Tailwind CSS, Clerk
- **Backend**: FastAPI (Python 3.11), PostgreSQL, Redis
- **LLM**: OpenAI GPT-4o / Anthropic Claude 3.5 / Google Gemini
- **Vector DB**: Weaviate (self-hosted) or Pinecone (managed)
- **Orchestration**: LangGraph for multi-agent workflows
- **Infrastructure**: Docker, Kubernetes (EKS/GKE), Terraform
- **CI/CD**: GitHub Actions
- **Observability**: Prometheus, Grafana, Sentry, OpenTelemetry

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Node.js 20+
- Python 3.11+
- Kubernetes cluster (for production)

### Local Development

1. **Clone the repository**
```bash
git clone https://github.com/Balu-ak/Copilot-test.git
cd Copilot-test
```

2. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your API keys and configuration
```

3. **Start the development stack**
```bash
docker-compose up -d
```

4. **Bootstrap the environment**
```bash
chmod +x scripts/dev_bootstrap.sh
./scripts/dev_bootstrap.sh
```

5. **Seed demo data**
```bash
chmod +x scripts/seed_demo.sh
./scripts/seed_demo.sh
```

6. **Access the application**
- Frontend: http://localhost:3000
- API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- Weaviate: http://localhost:8080

## 📁 Project Structure

```
autobrain/
├── apps/
│   ├── web/           # Next.js 14 frontend
│   ├── api/           # FastAPI backend
│   └── workers/       # Celery workers for ingestion
├── packages/
│   ├── orchestrator/  # LangGraph multi-agent system
│   ├── clients/       # Typed API clients
│   └── shared/        # Shared utilities and types
├── infra/
│   ├── docker/        # Docker configurations
│   ├── k8s/           # Kubernetes manifests
│   ├── terraform/     # Infrastructure as code
│   └── github/        # GitHub Actions workflows
└── scripts/           # Development and deployment scripts
```

## 🔐 Security & Compliance

- **Authentication**: Clerk/Auth.js with JWT tokens
- **Authorization**: Row-level security (RLS) and RBAC
- **Data Privacy**: PII detection and redaction
- **Audit Logging**: All agent actions logged
- **Secrets Management**: Vault/AWS Secrets Manager

## 📊 Key Endpoints

### API Endpoints

- `POST /auth/verify` - Verify authentication token
- `POST /chat/query` - Query with streaming response
- `POST /ingest/url` - Ingest document from URL
- `POST /ingest/slack/events` - Slack events webhook
- `POST /actions/execute` - Execute delegated actions
- `GET /conversations/:id/stream` - Stream conversation updates

## 🧪 Testing

```bash
# API tests
cd apps/api
pytest

# Frontend tests
cd apps/web
npm test

# Integration tests
npm run test:integration
```

## 🚢 Deployment

### Kubernetes Deployment

```bash
# Deploy with Helm
helm upgrade --install autobrain infra/k8s/helm \
  --set image.tag=latest \
  --namespace autobrain \
  --create-namespace
```

### Terraform Infrastructure

```bash
cd infra/terraform
terraform init
terraform plan
terraform apply
```

## 🛠️ Development

### Install Dependencies

**Frontend:**
```bash
cd apps/web
npm install
npm run dev
```

**Backend:**
```bash
cd apps/api
pip install -r requirements.txt
uvicorn main:app --reload
```

**Workers:**
```bash
cd apps/workers
pip install -r requirements.txt
celery -A celery_app worker --loglevel=info
```

## 🤝 Contributing

Contributions are welcome! Please read our Contributing Guidelines first.

## 📝 License

MIT License - see LICENSE file for details.

## 📧 Support

For issues and questions:
- Create a [GitHub Issue](https://github.com/Balu-ak/Copilot-test/issues)
- Contact: support@autobrain.dev

---

**Built with ❤️ by the AutoBrain Team**

Last Updated: 2025-10-23
EOF

cat > .env.example << 'EOF'
# ==============================================
# AutoBrain Environment Configuration
# ==============================================

# -----------------
# General
# -----------------
NODE_ENV=development
API_SECRET_KEY=change_me_in_production
LOG_LEVEL=info

# -----------------
# Web/Frontend
# -----------------
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxxxx
CLERK_SECRET_KEY=sk_test_xxxxx
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000

# -----------------
# Database
# -----------------
DATABASE_URL=postgresql+psycopg://user:pass@postgres:5432/autobrain
POSTGRES_USER=user
POSTGRES_PASSWORD=pass
POSTGRES_DB=autobrain

# -----------------
# Redis
# -----------------
REDIS_URL=redis://redis:6379/0

# -----------------
# Object Storage (S3/GCS)
# -----------------
OBJECT_STORE_BUCKET=autobrain-dev
OBJECT_STORE_REGION=us-east-1
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# -----------------
# LLM Providers
# -----------------
# Choose: openai | anthropic | google
LLM_PROVIDER=openai

OPENAI_API_KEY=sk-xxxxx
OPENAI_MODEL=gpt-4o

ANTHROPIC_API_KEY=sk-ant-xxxxx
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022

GOOGLE_API_KEY=xxxxx
GOOGLE_MODEL=gemini-1.5-pro

# -----------------
# Vector Database
# -----------------
# Weaviate (self-hosted)
WEAVIATE_URL=http://weaviate:8080
WEAVIATE_API_KEY=

# Pinecone (managed)
PINECONE_API_KEY=
PINECONE_ENVIRONMENT=us-west1-gcp
PINECONE_INDEX=autobrain-dev

# Choose: weaviate | pinecone
VECTOR_DB_PROVIDER=weaviate

# -----------------
# Embedding Configuration
# -----------------
EMBEDDING_MODEL=text-embedding-3-small
EMBEDDING_DIMENSION=1536
CHUNK_SIZE=1000
CHUNK_OVERLAP=200

# -----------------
# Slack Integration
# -----------------
SLACK_BOT_TOKEN=xoxb-xxxxx
SLACK_SIGNING_SECRET=xxxxx
SLACK_APP_TOKEN=xapp-xxxxx

# -----------------
# Google OAuth & APIs
# -----------------
GOOGLE_OAUTH_CLIENT_ID=xxxxx.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=xxxxx
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8000/auth/google/callback
GMAIL_SERVICE_ACCOUNT_JSON_BASE64=

# -----------------
# Jira Integration
# -----------------
JIRA_BASE_URL=https://your-company.atlassian.net
JIRA_EMAIL=your-email@company.com
JIRA_API_TOKEN=xxxxx

# -----------------
# Celery/Workers
# -----------------
CELERY_BROKER_URL=redis://redis:6379/0
CELERY_RESULT_BACKEND=redis://redis:6379/0

# -----------------
# Observability
# -----------------
SENTRY_DSN=https://xxxxx@sentry.io/xxxxx
OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
PROMETHEUS_MULTIPROC_DIR=/tmp/prometheus

# -----------------
# Security & Secrets
# -----------------
VAULT_ADDR=http://vault:8200
VAULT_TOKEN=xxxxx
JWT_SECRET=change_me_in_production
ENCRYPTION_KEY=change_me_in_production

# -----------------
# Feature Flags
# -----------------
ENABLE_PII_REDACTION=true
ENABLE_AUDIT_LOGGING=true
ENABLE_RATE_LIMITING=true
MAX_REQUESTS_PER_MINUTE=60

# -----------------
# Development
# -----------------
DEBUG=true
RELOAD=true
EOF

cat > .gitignore << 'EOF'
# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
.next/
out/
build/
dist/
*.log

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv/
pip-log.txt
pip-delete-this-directory.txt
.pytest_cache/
.coverage
htmlcov/
*.egg-info/
.eggs/

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Docker
*.dockerignore
.docker/

# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Logs
logs/
*.log

# Database
*.db
*.sqlite
*.sqlite3

# Secrets
secrets/
*.pem
*.key
*.crt

# OS
Thumbs.db
.DS_Store

# Temporary files
tmp/
temp/
*.tmp

# Build artifacts
*.tar.gz
*.zip
EOF

cat > docker-compose.yml << 'EOF'
version: '3.9'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: autobrain-postgres
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-pass}
      POSTGRES_DB: ${POSTGRES_DB:-autobrain}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-user}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - autobrain-network

  # Redis Cache & Queue
  redis:
    image: redis:7-alpine
    container_name: autobrain-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    networks:
      - autobrain-network

  # Weaviate Vector Database
  weaviate:
    image: semitechnologies/weaviate:1.25.6
    container_name: autobrain-weaviate
    environment:
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
      PERSISTENCE_DATA_PATH: '/var/lib/weaviate'
      DEFAULT_VECTORIZER_MODULE: 'none'
      ENABLE_MODULES: 'text2vec-openai,text2vec-cohere,text2vec-huggingface'
      CLUSTER_HOSTNAME: 'node1'
    ports:
      - "8080:8080"
    volumes:
      - weaviate_data:/var/lib/weaviate
    networks:
      - autobrain-network

  # FastAPI Backend
  api:
    build:
      context: ./apps/api
      dockerfile: Dockerfile
    container_name: autobrain-api
    env_file:
      - .env
    ports:
      - "8000:8000"
    volumes:
      - ./apps/api:/app
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      weaviate:
        condition: service_started
    command: uvicorn main:app --host 0.0.0.0 --port 8000 --reload
    networks:
      - autobrain-network

  # Next.js Frontend
  web:
    build:
      context: ./apps/web
      dockerfile: Dockerfile
    container_name: autobrain-web
    env_file:
      - .env
    ports:
      - "3000:3000"
    volumes:
      - ./apps/web:/app
      - /app/node_modules
      - /app/.next
    depends_on:
      - api
    command: npm run dev
    networks:
      - autobrain-network

  # Celery Workers
  workers:
    build:
      context: ./apps/workers
      dockerfile: Dockerfile
    container_name: autobrain-workers
    env_file:
      - .env
    volumes:
      - ./apps/workers:/app
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      weaviate:
        condition: service_started
    command: celery -A celery_app worker --loglevel=info
    networks:
      - autobrain-network

  # Celery Beat (Scheduler)
  celery-beat:
    build:
      context: ./apps/workers
      dockerfile: Dockerfile
    container_name: autobrain-celery-beat
    env_file:
      - .env
    volumes:
      - ./apps/workers:/app
    depends_on:
      - redis
    command: celery -A celery_app beat --loglevel=info
    networks:
      - autobrain-network

volumes:
  postgres_data:
  redis_data:
  weaviate_data:

networks:
  autobrain-network:
    driver: bridge
EOF

# ============================================
# FRONTEND FILES
# ============================================

cat > apps/web/package.json << 'EOF'
{
  "name": "@autobrain/web",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.2.3",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "@clerk/nextjs": "^5.0.0",
    "@tanstack/react-query": "^5.28.4",
    "axios": "^1.6.8",
    "clsx": "^2.1.0",
    "tailwind-merge": "^2.2.2",
    "swr": "^2.2.5",
    "react-markdown": "^9.0.1",
    "react-syntax-highlighter": "^15.5.0",
    "lucide-react": "^0.363.0",
    "sonner": "^1.4.41",
    "zustand": "^4.5.2"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "@types/react-syntax-highlighter": "^15.5.11",
    "autoprefixer": "^10.4.19",
    "eslint": "^8",
    "eslint-config-next": "14.2.3",
    "postcss": "^8.4.38",
    "tailwindcss": "^3.4.1",
    "typescript": "^5",
    "@tailwindcss/typography": "^0.5.10"
  }
}
EOF

cat > apps/web/app/layout.tsx << 'EOF'
import { ClerkProvider } from '@clerk/nextjs'
import { Inter } from 'next/font/google'
import './globals.css'
import { Toaster } from 'sonner'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'AutoBrain - Autonomous Knowledge Assistant',
  description: 'AI-powered knowledge assistant for teams',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body className={inter.className}>
          {children}
          <Toaster position="top-right" />
        </body>
      </html>
    </ClerkProvider>
  )
}
EOF

cat > apps/web/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

body {
  color: rgb(var(--foreground-rgb));
  background: linear-gradient(
      to bottom,
      transparent,
      rgb(var(--background-end-rgb))
    )
    rgb(var(--background-start-rgb));
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
EOF

cat > apps/web/app/page.tsx << 'EOF'
'use client'

import { useUser } from '@clerk/nextjs'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'
import { MessageSquare, Upload, Settings, TrendingUp } from 'lucide-react'

export default function Dashboard() {
  const { user, isLoaded } = useUser()
  const router = useRouter()

  useEffect(() => {
    if (isLoaded && !user) {
      router.push('/sign-in')
    }
  }, [user, isLoaded, router])

  if (!isLoaded || !user) {
    return (
      <div className="flex h-screen items-center justify-center">
        <div className="h-32 w-32 animate-spin rounded-full border-b-2 border-t-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="border-b bg-white/50 backdrop-blur-sm dark:bg-gray-900/50">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex h-16 items-center justify-between">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-blue-600">AutoBrain</h1>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600 dark:text-gray-300">
                {user.emailAddresses[0].emailAddress}
              </span>
              <button
                onClick={() => router.push('/settings')}
                className="rounded-lg p-2 hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <Settings className="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 dark:text-white">
            Welcome back, {user.firstName || 'User'}!
          </h2>
          <p className="mt-2 text-gray-600 dark:text-gray-400">
            What would you like to do today?
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {/* Chat Card */}
          <button
            onClick={() => router.push('/chat/new')}
            className="group rounded-xl border border-gray-200 bg-white p-6 shadow-sm transition-all hover:border-blue-500 hover:shadow-lg dark:border-gray-700 dark:bg-gray-800"
          >
            <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100 dark:bg-blue-900">
              <MessageSquare className="h-6 w-6 text-blue-600 dark:text-blue-400" />
            </div>
            <h3 className="mb-2 text-lg font-semibold text-gray-900 dark:text-white">
              Ask a Question
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">
              Query your knowledge base with AI-powered search and answers
            </p>
          </button>

          {/* Ingest Card */}
          <button
            onClick={() => router.push('/ingest')}
            className="group rounded-xl border border-gray-200 bg-white p-6 shadow-sm transition-all hover:border-green-500 hover:shadow-lg dark:border-gray-700 dark:bg-gray-800"
          >
            <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-green-100 dark:bg-green-900">
              <Upload className="h-6 w-6 text-green-600 dark:text-green-400" />
            </div>
            <h3 className="mb-2 text-lg font-semibold text-gray-900 dark:text-white">
              Ingest Documents
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">
              Connect Slack, Google Drive, or upload files to expand your knowledge base
            </p>
          </button>

          {/* Analytics Card */}
          <button
            onClick={() => router.push('/analytics')}
            className="group rounded-xl border border-gray-200 bg-white p-6 shadow-sm transition-all hover:border-purple-500 hover:shadow-lg dark:border-gray-700 dark:bg-gray-800"
          >
            <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-purple-100 dark:bg-purple-900">
              <TrendingUp className="h-6 w-6 text-purple-600 dark:text-purple-400" />
            </div>
            <h3 className="mb-2 text-lg font-semibold text-gray-900 dark:text-white">
              View Analytics
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">
              Track usage, popular queries, and system performance
            </p>
          </button>
        </div>

        {/* Recent Conversations */}
        <div className="mt-12">
          <h3 className="mb-4 text-xl font-bold text-gray-900 dark:text-white">
            Recent Conversations
          </h3>
          <div className="rounded-xl border border-gray-200 bg-white p-6 dark:border-gray-700 dark:bg-gray-800">
            <p className="text-center text-gray-500 dark:text-gray-400">
              No recent conversations. Start a new chat to get started!
            </p>
          </div>
        </div>
      </main>
    </div>
  )
}
EOF

cat > "apps/web/app/chat/[id]/page.tsx" << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'
import { useUser } from '@clerk/nextjs'
import { Send, Loader2, FileText, ExternalLink } from 'lucide-react'
import ReactMarkdown from 'react-markdown'
import { toast } from 'sonner'

interface Message {
  id: string
  role: 'user' | 'assistant'
  content: string
  sources?: Array<{
    title: string
    uri: string
    snippet: string
  }>
  createdAt: Date
}

export default function ChatPage({ params }: { params: { id: string } }) {
  const { user } = useUser()
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const messagesEndRef = useRef<HTMLDivElement>(null)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!input.trim() || isLoading) return

    const userMessage: Message = {
      id: Date.now().toString(),
      role: 'user',
      content: input,
      createdAt: new Date(),
    }

    setMessages((prev) => [...prev, userMessage])
    setInput('')
    setIsLoading(true)

    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}/chat/query`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          conversation_id: params.id,
          message: input,
          org_id: user?.organizationMemberships[0]?.organization.id,
        }),
      })

      if (!response.ok) throw new Error('Failed to get response')

      const data = await response.json()

      const assistantMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: data.answer,
        sources: data.sources,
        createdAt: new Date(),
      }

      setMessages((prev) => [...prev, assistantMessage])
    } catch (error) {
      console.error('Error:', error)
      toast.error('Failed to get response. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="flex h-screen flex-col bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <div className="border-b bg-white px-6 py-4 dark:bg-gray-800">
        <h1 className="text-xl font-semibold text-gray-900 dark:text-white">
          Chat with AutoBrain
        </h1>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-6 py-4">
        <div className="mx-auto max-w-3xl space-y-6">
          {messages.length === 0 && (
            <div className="text-center text-gray-500 dark:text-gray-400">
              <p className="text-lg">Start a conversation with AutoBrain</p>
              <p className="mt-2 text-sm">
                Ask questions about your documents, Slack, or email
              </p>
            </div>
          )}

          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${
                message.role === 'user' ? 'justify-end' : 'justify-start'
              }`}
            >
              <div
                className={`max-w-[80%] rounded-lg px-4 py-3 ${
                  message.role === 'user'
                    ? 'bg-blue-600 text-white'
                    : 'bg-white text-gray-900 shadow-sm dark:bg-gray-800 dark:text-white'
                }`}
              >
                <ReactMarkdown className="prose prose-sm dark:prose-invert">
                  {message.content}
                </ReactMarkdown>

                {/* Sources */}
                {message.sources && message.sources.length > 0 && (
                  <div className="mt-4 space-y-2 border-t pt-3 dark:border-gray-700">
                    <p className="text-xs font-semibold uppercase text-gray-500 dark:text-gray-400">
                      Sources
                    </p>
                    {message.sources.map((source, idx) => (
                      <a
                        key={idx}
                        href={source.uri}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-start gap-2 rounded border p-2 hover:bg-gray-50 dark:border-gray-700 dark:hover:bg-gray-700"
                      >
                        <FileText className="mt-1 h-4 w-4 flex-shrink-0 text-blue-600" />
                        <div className="flex-1">
                          <p className="text-sm font-medium">{source.title}</p>
                          <p className="text-xs text-gray-600 dark:text-gray-400">
                            {source.snippet}
                          </p>
                        </div>
                        <ExternalLink className="h-4 w-4 flex-shrink-0 text-gray-400" />
                      </a>
                    ))}
                  </div>
                )}
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="flex justify-start">
              <div className="rounded-lg bg-white px-4 py-3 shadow-sm dark:bg-gray-800">
                <Loader2 className="h-5 w-5 animate-spin text-blue-600" />
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>
      </div>

      {/* Input */}
      <div className="border-t bg-white px-6 py-4 dark:bg-gray-800">
        <form onSubmit={handleSubmit} className="mx-auto max-w-3xl">
          <div className="flex gap-2">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Ask a question..."
              disabled={isLoading}
              className="flex-1 rounded-lg border border-gray-300 px-4 py-2 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100 dark:border-gray-600 dark:bg-gray-700 dark:text-white dark:focus:border-blue-400"
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              className="rounded-lg bg-blue-600 px-4 py-2 text-white transition-colors hover:bg-blue-700 disabled:bg-gray-300 dark:disabled:bg-gray-600"
            >
              {isLoading ? (
                <Loader2 className="h-5 w-5 animate-spin" />
              ) : (
                <Send className="h-5 w-5" />
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
EOF

cat > apps/web/tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic':
          'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
      },
      typography: {
        DEFAULT: {
          css: {
            maxWidth: 'none',
            color: 'inherit',
            a: {
              color: '#3b82f6',
              '&:hover': {
                color: '#2563eb',
              },
            },
          },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
  darkMode: 'class',
}
EOF

cat > apps/web/next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['avatars.githubusercontent.com', 'img.clerk.com'],
  },
  env: {
    NEXT_PUBLIC_API_BASE_URL: process.env.NEXT_PUBLIC_API_BASE_URL,
  },
}

module.exports = nextConfig
EOF

cat > apps/web/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

cat > apps/web/Dockerfile << 'EOF'
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000

CMD ["node", "server.js"]
EOF

# ============================================
# BACKEND API FILES
# ============================================

cat > apps/api/main.py << 'EOF'
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from typing import Optional, List
import os
from datetime import datetime
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="AutoBrain API",
    description="Autonomous Knowledge Assistant API",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class ChatRequest(BaseModel):
    conversation_id: Optional[str] = None
    message: str
    org_id: str
    tools: List[str] = []

class ChatResponse(BaseModel):
    answer: str
    sources: List[dict] = []
    conversation_id: str

class IngestURLRequest(BaseModel):
    url: str
    org_id: str
    source: str = "upload"

class IngestResponse(BaseModel):
    job_id: str
    status: str
    message: str

class ActionRequest(BaseModel):
    action_type: str
    org_id: str
    parameters: dict

# Health check
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "service": "autobrain-api"
    }

# Authentication endpoint
@app.post("/auth/verify")
async def verify_auth(token: str):
    """Verify Clerk/Auth.js token and upsert user/org"""
    try:
        # TODO: Implement actual token verification
        logger.info(f"Verifying token: {token[:10]}...")
        return {
            "user_id": "user_123",
            "org_id": "org_123",
            "roles": ["member"]
        }
    except Exception as e:
        logger.error(f"Auth verification failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )

# Chat endpoint
@app.post("/chat/query", response_model=ChatResponse)
async def chat_query(req: ChatRequest):
    """
    Query the knowledge base with streaming support
    """
    try:
        logger.info(f"Chat query from org {req.org_id}: {req.message}")
        
        # TODO: Implement actual LangGraph orchestration
        # This is a placeholder response
        response = ChatResponse(
            answer=f"This is a placeholder response to: {req.message}",
            sources=[
                {
                    "title": "Example Document",
                    "uri": "https://example.com/doc",
                    "snippet": "This is an example snippet from the source..."
                }
            ],
            conversation_id=req.conversation_id or f"conv_{datetime.utcnow().timestamp()}"
        )
        
        return response
    except Exception as e:
        logger.error(f"Chat query failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to process query: {str(e)}"
        )

# Ingest endpoint
@app.post("/ingest/url", response_model=IngestResponse)
async def ingest_url(req: IngestURLRequest):
    """
    Enqueue document for ingestion from URL
    """
    try:
        logger.info(f"Ingesting URL for org {req.org_id}: {req.url}")
        
        # TODO: Enqueue actual ingestion job
        job_id = f"job_{datetime.utcnow().timestamp()}"
        
        return IngestResponse(
            job_id=job_id,
            status="queued",
            message=f"Document ingestion queued: {req.url}"
        )
    except Exception as e:
        logger.error(f"Ingest failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to ingest document: {str(e)}"
        )

# Slack events endpoint
@app.post("/ingest/slack/events")
async def slack_events(payload: dict):
    """
    Handle Slack Events API callbacks
    """
    try:
        # Handle URL verification challenge
        if payload.get("type") == "url_verification":
            return {"challenge": payload["challenge"]}
        
        # Handle actual events
        event = payload.get("event", {})
        logger.info(f"Slack event: {event.get('type')}")
        
        # TODO: Enqueue Slack message for indexing
        
        return {"status": "ok"}
    except Exception as e:
        logger.error(f"Slack event handling failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to handle Slack event: {str(e)}"
        )

# Actions endpoint
@app.post("/actions/execute")
async def execute_action(req: ActionRequest):
    """
    Execute delegated actions (email, Slack, Jira, etc.)
    """
    try:
        logger.info(f"Executing action {req.action_type} for org {req.org_id}")
        
        # TODO: Implement actual action execution
        
        return {
            "status": "success",
            "action_type": req.action_type,
            "result": "Action executed successfully"
        }
    except Exception as e:
        logger.error(f"Action execution failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute action: {str(e)}"
        )

# Conversation stream endpoint
@app.get("/conversations/{conversation_id}/stream")
async def stream_conversation(conversation_id: str):
    """
    Stream conversation updates via Server-Sent Events
    """
    async def event_generator():
        # TODO: Implement actual SSE streaming
        yield f"data: {{'type': 'connected', 'conversation_id': '{conversation_id}'}}\n\n"
    
    return StreamingResponse(event_generator(), media_type="text/event-stream")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
EOF

cat > apps/api/requirements.txt << 'EOF'
fastapi==0.110.0
uvicorn[standard]==0.27.1
pydantic==2.6.3
pydantic-settings==2.2.1
sqlalchemy==2.0.28
psycopg2-binary==2.9.9
alembic==1.13.1
redis==5.0.2
celery==5.3.6
openai==1.13.3
anthropic==0.18.1
google-generativeai==0.3.2
langchain==0.1.11
langgraph==0.0.26
langchain-openai==0.0.8
langchain-anthropic==0.1.1
weaviate-client==4.5.1
pinecone-client==3.1.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.9
aiohttp==3.9.3
httpx==0.27.0
tenacity==8.2.3
pydantic-core==2.16.3
python-dotenv==1.0.1
sentry-sdk==1.40.6
prometheus-client==0.20.0
opentelemetry-api==1.23.0
opentelemetry-sdk==1.23.0
opentelemetry-instrumentation-fastapi==0.44b0
EOF

cat > apps/api/pyproject.toml << 'EOF'
[tool.poetry]
name = "autobrain-api"
version = "1.0.0"
description = "AutoBrain FastAPI Backend"
authors = ["AutoBrain Team"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.110.0"
uvicorn = {extras = ["standard"], version = "^0.27.1"}
pydantic = "^2.6.3"
sqlalchemy = "^2.0.28"
psycopg2-binary = "^2.9.9"
alembic = "^1.13.1"
redis = "^5.0.2"
celery = "^5.3.6"
openai = "^1.13.3"
anthropic = "^0.18.1"
langchain = "^0.1.11"
langgraph = "^0.0.26"

[tool.poetry.dev-dependencies]
pytest = "^8.0.2"
pytest-asyncio = "^0.23.5"
pytest-cov = "^4.1.0"
black = "^24.2.0"
ruff = "^0.3.0"
mypy = "^1.8.0"

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"

[tool.black]
line-length = 100
target-version = ['py311']

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
EOF

cat > apps/api/database.py << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:pass@postgres:5432/autobrain")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOF

cat > apps/api/models.py << 'EOF'
from sqlalchemy import Column, String, DateTime, Integer, Text, JSON, ForeignKey, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from database import Base

class Organization(Base):
    __tablename__ = "organizations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    users = relationship("User", back_populates="organization")
    documents = relationship("Document", back_populates="organization")

class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String, unique=True, nullable=False)
    org_id = Column(UUID(as_uuid=True), ForeignKey("organizations.id", ondelete="CASCADE"))
    role = Column(String, default="member")
    created_at = Column(DateTime, default=datetime.utcnow)
    
    organization = relationship("Organization", back_populates="users")

class Document(Base):
    __tablename__ = "documents"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    org_id = Column(UUID(as_uuid=True), ForeignKey("organizations.id", ondelete="CASCADE"))
    source = Column(String)  # 'slack', 'gdrive', 'gmail', 'upload'
    uri = Column(Text)
    title = Column(Text)
    mime_type = Column(String)
    hash = Column(String)
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    organization = relationship("Organization", back_populates="documents")
    chunks = relationship("Chunk", back_populates="document")

class Chunk(Base):
    __tablename__ = "chunks"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    doc_id = Column(UUID(as_uuid=True), ForeignKey("documents.id", ondelete="CASCADE"))
    org_id = Column(UUID(as_uuid=True), ForeignKey("organizations.id", ondelete="CASCADE"))
    chunk_index = Column(Integer)
    text = Column(Text)
    tokens = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    document = relationship("Document", back_populates="chunks")

class Conversation(Base):
    __tablename__ = "conversations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    org_id = Column(UUID(as_uuid=True), ForeignKey("organizations.id", ondelete="CASCADE"))
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    title = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    messages = relationship("Message", back_populates="conversation")

class Message(Base):
    __tablename__ = "messages"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    conversation_id = Column(UUID(as_uuid=True), ForeignKey("conversations.id", ondelete="CASCADE"))
    role = Column(Enum('user', 'assistant', 'tool', name='message_role'))
    content = Column(JSON)
    tokens = Column(Integer)
    tool_calls = Column(JSON)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    conversation = relationship("Conversation", back_populates="messages")

class ToolInvocation(Base):
    __tablename__ = "tool_invocations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    conversation_id = Column(UUID(as_uuid=True), ForeignKey("conversations.id"))
    agent = Column(String)
    tool = Column(String)
    input = Column(JSON)
    output = Column(JSON)
    latency_ms = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)
EOF

cat > apps/api/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')"

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# ============================================
# WORKERS FILES
# ============================================

cat > apps/workers/celery_app.py << 'EOF'
from celery import Celery
import os

REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")

app = Celery(
    "autobrain-workers",
    broker=REDIS_URL,
    backend=REDIS_URL,
    include=["indexer", "tasks"]
)

app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="UTC",
    enable_utc=True,
    task_track_started=True,
    task_time_limit=3600,
    task_soft_time_limit=3000,
)

if __name__ == "__main__":
    app.start()
EOF

cat > apps/workers/indexer.py << 'EOF'
from celery_app import app
from typing import Dict, List
import logging
import os

logger = logging.getLogger(__name__)

@app.task(bind=True, max_retries=3)
def index_document(self, doc: Dict):
    """
    Index a document: chunk, embed, and store in vector DB
    """
    try:
        logger.info(f"Indexing document: {doc.get('id')}")
        
        # TODO: Implement actual chunking logic
        chunks = chunk_document(doc)
        
        # TODO: Implement actual embedding logic
        vectors = embed_chunks(chunks)
        
        # TODO: Implement actual vector DB upsert
        upsert_vectors(vectors, doc.get('org_id'))
        
        logger.info(f"Successfully indexed document: {doc.get('id')}")
        return {"status": "success", "doc_id": doc.get('id'), "chunks": len(chunks)}
        
    except Exception as e:
        logger.error(f"Failed to index document {doc.get('id')}: {str(e)}")
        raise self.retry(exc=e, countdown=60 * (2 ** self.request.retries))

def chunk_document(doc: Dict) -> List[Dict]:
    """
    Chunk document into smaller pieces
    """
    # Placeholder implementation
    content = doc.get('content', '')
    chunk_size = 1000
    overlap = 200
    
    chunks = []
    for i in range(0, len(content), chunk_size - overlap):
        chunk_text = content[i:i + chunk_size]
        chunks.append({
            'text': chunk_text,
            'index': len(chunks),
            'doc_id': doc.get('id'),
        })
    
    return chunks

def embed_chunks(chunks: List[Dict]) -> List[Dict]:
    """
    Generate embeddings for chunks
    """
    # TODO: Implement actual embedding with OpenAI/etc
    vectors = []
    for chunk in chunks:
        vectors.append({
            'id': f"{chunk['doc_id']}_{chunk['index']}",
            'values': [0.0] * 1536,  # Placeholder embedding
            'metadata': {
                'text': chunk['text'],
                'doc_id': chunk['doc_id'],
                'chunk_index': chunk['index'],
            }
        })
    return vectors

def upsert_vectors(vectors: List[Dict], org_id: str):
    """
    Upsert vectors to vector database
    """
    # TODO: Implement actual Weaviate/Pinecone upsert
    logger.info(f"Upserting {len(vectors)} vectors for org {org_id}")
    pass

@app.task
def process_slack_message(message: Dict):
    """
    Process and index a Slack message
    """
    try:
        logger.info(f"Processing Slack message: {message.get('ts')}")
        # TODO: Implement Slack message processing
        return {"status": "success"}
    except Exception as e:
        logger.error(f"Failed to process Slack message: {str(e)}")
        raise

@app.task
def sync_google_drive(org_id: str, folder_id: str):
    """
    Sync documents from Google Drive
    """
    try:
        logger.info(f"Syncing Google Drive folder {folder_id} for org {org_id}")
        # TODO: Implement Google Drive sync
        return {"status": "success"}
    except Exception as e:
        logger.error(f"Failed to sync Google Drive: {str(e)}")
        raise
EOF

cat > apps/workers/requirements.txt << 'EOF'
celery==5.3.6
redis==5.0.2
sqlalchemy==2.0.28
psycopg2-binary==2.9.9
openai==1.13.3
langchain==0.1.11
weaviate-client==4.5.1
pinecone-client==3.1.0
python-dotenv==1.0.1
requests==2.31.0
beautifulsoup4==4.12.3
markdown==3.5.2
EOF

cat > apps/workers/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Run Celery worker
CMD ["celery", "-A", "celery_app", "worker", "--loglevel=info", "--concurrency=4"]
EOF

# ============================================
# ORCHESTRATOR FILES
# ============================================

cat > packages/orchestrator/graph.py << 'EOF'
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage
import operator

class GraphState(TypedDict):
    """State of the agent graph"""
    messages: Annotated[Sequence[BaseMessage], operator.add]
    context: dict
    route: str
    retrieved_docs: list
    answer: str
    sources: list
    actions: list

def create_graph():
    """Create the multi-agent orchestration graph"""
    
    from nodes import router, retrieve, synthesize, action
    
    workflow = StateGraph(GraphState)
    
    # Add nodes
    workflow.add_node("router", router)
    workflow.add_node("retrieve", retrieve)
    workflow.add_node("synthesize", synthesize)
    workflow.add_node("action", action)
    
    # Define edges
    workflow.set_entry_point("router")
    
    # Conditional routing
    def route_decision(state: GraphState) -> str:
        route = state.get("route", "qa")
        if route == "qa":
            return "retrieve"
        elif route == "summarize":
            return "synthesize"
        elif route == "action":
            return "action"
        else:
            return "retrieve"
    
    workflow.add_conditional_edges(