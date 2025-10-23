#!/bin/bash

# Fixed AutoBrain Setup Script - Complete
set -e

echo "🚀 Setting up AutoBrain repository..."

# Configuration
REPO_URL="https://github.com/Balu-ak/Copilot-test.git"
BRANCH_NAME="feature/autobrain-init"

# Check if directory exists
if [ -d "Copilot-test" ]; then
    echo "⚠️  Directory 'Copilot-test' already exists. Removing it..."
    rm -rf Copilot-test
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
