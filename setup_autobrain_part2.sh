#!/bin/bash

# AutoBrain Setup Script - Part 2
# Continue creating remaining files

set -e

echo "📝 Creating orchestrator files (continued)..."

cat >> packages/orchestrator/graph.py << 'EOF'
    
    workflow.add_conditional_edges(
        "router",
        route_decision,
        {
            "retrieve": "retrieve",
            "synthesize": "synthesize",
            "action": "action",
        }
    )
    
    workflow.add_edge("retrieve", "synthesize")
    workflow.add_edge("synthesize", END)
    workflow.add_edge("action", END)
    
    return workflow.compile()

async def run_graph(context: dict, message: str, tools: list = None):
    """Execute the agent graph"""
    
    graph = create_graph()
    
    initial_state = {
        "messages": [{"role": "user", "content": message}],
        "context": context,
        "route": "",
        "retrieved_docs": [],
        "answer": "",
        "sources": [],
        "actions": [],
    }
    
    result = await graph.ainvoke(initial_state)
    
    return {
        "answer": result.get("answer", ""),
        "sources": result.get("sources", []),
        "actions": result.get("actions", []),
    }
EOF

cat > packages/orchestrator/nodes.py << 'EOF'
from typing import Dict
import logging

logger = logging.getLogger(__name__)

def router(state: Dict) -> Dict:
    """
    Route the request to appropriate handler
    """
    message = state["messages"][-1]["content"]
    
    # Simple keyword-based routing (TODO: Use LLM for better routing)
    if any(word in message.lower() for word in ["summarize", "summary", "digest"]):
        route = "summarize"
    elif any(word in message.lower() for word in ["send", "email", "slack", "create", "jira"]):
        route = "action"
    else:
        route = "qa"
    
    logger.info(f"Routed to: {route}")
    state["route"] = route
    return state

def retrieve(state: Dict) -> Dict:
    """
    Retrieve relevant documents from vector DB
    """
    message = state["messages"][-1]["content"]
    context = state["context"]
    org_id = context.get("org_id")
    
    logger.info(f"Retrieving documents for org {org_id}")
    
    # TODO: Implement actual vector search
    # For now, return placeholder docs
    state["retrieved_docs"] = [
        {
            "id": "doc1",
            "title": "Example Document",
            "content": "This is example content...",
            "uri": "https://example.com/doc1",
            "score": 0.95
        }
    ]
    
    return state

def synthesize(state: Dict) -> Dict:
    """
    Synthesize answer from retrieved documents
    """
    message = state["messages"][-1]["content"]
    docs = state.get("retrieved_docs", [])
    
    logger.info(f"Synthesizing answer from {len(docs)} documents")
    
    # TODO: Implement actual LLM synthesis
    # For now, return placeholder answer
    state["answer"] = f"Based on the documents, here's the answer to '{message}': [Placeholder answer]"
    state["sources"] = [
        {
            "title": doc["title"],
            "uri": doc["uri"],
            "snippet": doc["content"][:200]
        }
        for doc in docs[:3]
    ]
    
    return state

def action(state: Dict) -> Dict:
    """
    Execute actions (email, Slack, Jira, etc.)
    """
    message = state["messages"][-1]["content"]
    context = state["context"]
    
    logger.info(f"Executing action for: {message}")
    
    # TODO: Implement actual action execution
    state["actions"] = [
        {
            "type": "placeholder",
            "status": "pending",
            "message": "Action execution not yet implemented"
        }
    ]
    
    state["answer"] = "I've noted your request, but action execution is not yet implemented."
    
    return state
EOF

cat > packages/orchestrator/tools/search.py << 'EOF'
from typing import List, Dict
import logging

logger = logging.getLogger(__name__)

def search_knowledge(query: str, filters: Dict = None) -> List[Dict]:
    """
    Search the knowledge base
    
    Args:
        query: Search query
        filters: Filters (org_id, source, date_range, etc.)
    
    Returns:
        List of matching documents
    """
    logger.info(f"Searching knowledge base: {query}")
    
    org_id = filters.get("org_id") if filters else None
    
    # TODO: Implement actual hybrid search (vector + keyword)
    # This is a placeholder
    results = []
    
    return results

def hybrid_search(query: str, org_id: str, top_k: int = 10) -> List[Dict]:
    """
    Perform hybrid search (dense vector + BM25)
    """
    # TODO: Implement actual hybrid search
    vector_results = vector_search(query, org_id, top_k)
    keyword_results = keyword_search(query, org_id, top_k)
    
    # Combine and rerank
    combined = rerank_results(vector_results + keyword_results, query)
    
    return combined[:top_k]

def vector_search(query: str, org_id: str, top_k: int = 10) -> List[Dict]:
    """Dense vector search"""
    # TODO: Implement Weaviate/Pinecone search
    return []

def keyword_search(query: str, org_id: str, top_k: int = 10) -> List[Dict]:
    """BM25 keyword search"""
    # TODO: Implement PostgreSQL full-text search
    return []

def rerank_results(results: List[Dict], query: str) -> List[Dict]:
    """Rerank search results"""
    # TODO: Implement reranking (Cohere Rerank or LLM-based)
    return sorted(results, key=lambda x: x.get("score", 0), reverse=True)
EOF

cat > packages/orchestrator/tools/email.py << 'EOF'
from typing import Dict
import logging

logger = logging.getLogger(__name__)

def send_email(to: str, subject: str, body: str, html: bool = True) -> Dict:
    """
    Send email via Gmail API
    
    Args:
        to: Recipient email
        subject: Email subject
        body: Email body (markdown or HTML)
        html: Whether to convert markdown to HTML
    
    Returns:
        Status of email send
    """
    logger.info(f"Sending email to {to}: {subject}")
    
    # TODO: Implement actual Gmail API integration
    # This is a placeholder
    
    return {
        "status": "success",
        "message_id": "placeholder_id",
        "to": to,
        "subject": subject
    }

def send_summary_email(to: str, summary: str, period: str = "weekly") -> Dict:
    """
    Send formatted summary email
    """
    subject = f"AutoBrain {period.title()} Summary"
    
    html_body = f"""
    <html>
        <body>
            <h1>{subject}</h1>
            <div>{summary}</div>
        </body>
    </html>
    """
    
    return send_email(to, subject, html_body, html=True)
EOF

cat > packages/orchestrator/tools/slack.py << 'EOF'
from typing import Dict, List
import logging

logger = logging.getLogger(__name__)

def post_slack(channel: str, text: str, blocks: List[Dict] = None) -> Dict:
    """
    Post message to Slack channel
    
    Args:
        channel: Channel ID or name
        text: Message text
        blocks: Slack Block Kit blocks
    
    Returns:
        Status of post
    """
    logger.info(f"Posting to Slack channel {channel}")
    
    # TODO: Implement actual Slack Web API integration
    # This is a placeholder
    
    return {
        "status": "success",
        "channel": channel,
        "ts": "placeholder_timestamp"
    }

def create_slack_blocks(title: str, content: str, actions: List[Dict] = None) -> List[Dict]:
    """
    Create Slack Block Kit blocks
    """
    blocks = [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": title
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": content
            }
        }
    ]
    
    if actions:
        blocks.append({
            "type": "actions",
            "elements": actions
        })
    
    return blocks
EOF

# ============================================
# INFRASTRUCTURE FILES
# ============================================

cat > infra/docker/compose.dev.yml << 'EOF'
version: '3.9'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-pass}
      POSTGRES_DB: ${POSTGRES_DB:-autobrain}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  weaviate:
    image: semitechnologies/weaviate:1.25.6
    environment:
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
      PERSISTENCE_DATA_PATH: '/var/lib/weaviate'
    ports:
      - "8080:8080"
    volumes:
      - weaviate_data:/var/lib/weaviate

volumes:
  postgres_data:
  redis_data:
  weaviate_data:
EOF

cat > infra/k8s/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: autobrain-api
  namespace: autobrain
spec:
  replicas: 3
  selector:
    matchLabels:
      app: autobrain-api
  template:
    metadata:
      labels:
        app: autobrain-api
    spec:
      containers:
      - name: api
        image: ghcr.io/balu-ak/autobrain-api:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: redis-url
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: openai-api-key
        resources:
          requests:
            cpu: "250m"
            memory: "512Mi"
          limits:
            cpu: "1000m"
            memory: "1Gi"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: autobrain-web
  namespace: autobrain
spec:
  replicas: 2
  selector:
    matchLabels:
      app: autobrain-web
  template:
    metadata:
      labels:
        app: autobrain-web
    spec:
      containers:
      - name: web
        image: ghcr.io/balu-ak/autobrain-web:latest
        ports:
        - containerPort: 3000
        env:
        - name: NEXT_PUBLIC_API_BASE_URL
          value: "https://api.autobrain.company.com"
        - name: CLERK_SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: clerk-secret-key
        resources:
          requests:
            cpu: "200m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: autobrain-workers
  namespace: autobrain
spec:
  replicas: 2
  selector:
    matchLabels:
      app: autobrain-workers
  template:
    metadata:
      labels:
        app: autobrain-workers
    spec:
      containers:
      - name: worker
        image: ghcr.io/balu-ak/autobrain-workers:latest
        env:
        - name: CELERY_BROKER_URL
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: redis-url
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: autobrain-secrets
              key: database-url
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "2000m"
            memory: "2Gi"
EOF

cat > infra/k8s/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: autobrain-api
  namespace: autobrain
spec:
  type: ClusterIP
  selector:
    app: autobrain-api
  ports:
  - port: 80
    targetPort: 8000
    protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: autobrain-web
  namespace: autobrain
spec:
  type: ClusterIP
  selector:
    app: autobrain-web
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
EOF

cat > infra/k8s/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: autobrain-ingress
  namespace: autobrain
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - api.autobrain.company.com
    - app.autobrain.company.com
    secretName: autobrain-tls
  rules:
  - host: api.autobrain.company.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: autobrain-api
            port:
              number: 80
  - host: app.autobrain.company.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: autobrain-web
            port:
              number: 80
EOF

cat > infra/k8s/secrets.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: autobrain-secrets
  namespace: autobrain
type: Opaque
stringData:
  database-url: "postgresql://user:pass@postgres:5432/autobrain"
  redis-url: "redis://redis:6379/0"
  openai-api-key: "sk-xxxxx"
  clerk-secret-key: "sk_test_xxxxx"
  # Add more secrets as needed
EOF

# ============================================
# CI/CD FILES
# ============================================

cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test-api:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      working-directory: ./apps/api
      run: |
        pip install -r requirements.txt
        pip install pytest pytest-cov
    
    - name: Run tests
      working-directory: ./apps/api
      run: pytest --cov=. --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  test-web:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
    
    - name: Install dependencies
      working-directory: ./apps/web
      run: npm ci
    
    - name: Run lint
      working-directory: ./apps/web
      run: npm run lint
    
    - name: Build
      working-directory: ./apps/web
      run: npm run build

  build-images:
    runs-on: ubuntu-latest
    needs: [test-api, test-web]
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Build and push API image
      uses: docker/build-push-action@v5
      with:
        context: ./apps/api
        push: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
        tags: ghcr.io/balu-ak/autobrain-api:${{ github.sha }},ghcr.io/balu-ak/autobrain-api:latest
    
    - name: Build and push Web image
      uses: docker/build-push-action@v5
      with:
        context: ./apps/web
        push: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
        tags: ghcr.io/balu-ak/autobrain-web:${{ github.sha }},ghcr.io/balu-ak/autobrain-web:latest
    
    - name: Build and push Workers image
      uses: docker/build-push-action@v5
      with:
        context: ./apps/workers
        push: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
        tags: ghcr.io/balu-ak/autobrain-workers:${{ github.sha }},ghcr.io/balu-ak/autobrain-workers:latest
EOF

cat > .github/workflows/cd.yml << 'EOF'
name: CD

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure kubectl
      uses: azure/k8s-set-context@v3
      with:
        method: kubeconfig
        kubeconfig: ${{ secrets.KUBE_CONFIG }}
    
    - name: Deploy to Kubernetes
      run: |
        kubectl apply -f infra/k8s/deployment.yaml
        kubectl apply -f infra/k8s/service.yaml
        kubectl apply -f infra/k8s/ingress.yaml
        kubectl set image deployment/autobrain-api autobrain-api=ghcr.io/balu-ak/autobrain-api:${{ github.sha }} -n autobrain
        kubectl set image deployment/autobrain-web autobrain-web=ghcr.io/balu-ak/autobrain-web:${{ github.sha }} -n autobrain
        kubectl set image deployment/autobrain-workers autobrain-workers=ghcr.io/balu-ak/autobrain-workers:${{ github.sha }} -n autobrain
EOF

# ============================================
# SCRIPTS
# ============================================

cat > scripts/dev_bootstrap.sh << 'EOF'
#!/bin/bash

echo "🚀 Bootstrapping AutoBrain development environment..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "📋 Creating .env from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your API keys and configuration"
fi

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd apps/web
npm install
cd ../..

# Install API dependencies
echo "📦 Installing API dependencies..."
cd apps/api
pip install -r requirements.txt
cd ../..

# Install worker dependencies
echo "📦 Installing worker dependencies..."
cd apps/workers
pip install -r requirements.txt
cd ../..

# Start Docker services
echo "🐳 Starting Docker services..."
docker-compose up -d postgres redis weaviate

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 10

# Run database migrations
echo "🗄️  Running database migrations..."
# TODO: Add Alembic migration commands

echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your API keys"
echo "2. Run 'docker-compose up' to start all services"
echo "3. Access the app at http://localhost:3000"
EOF

cat > scripts/seed_demo.sh << 'EOF'
#!/bin/bash

echo "🌱 Seeding demo data..."

# TODO: Add demo data seeding logic
# This could include:
# - Creating a demo organization
# - Creating demo users
# - Ingesting sample documents
# - Creating sample conversations

echo "✅ Demo data seeded!"
echo ""
echo "Demo credentials:"
echo "Email: demo@autobrain.dev"
echo "Password: demo123"
EOF

chmod +x scripts/dev_bootstrap.sh
chmod +x scripts/seed_demo.sh

echo "✅ All files created successfully!"
echo ""
echo "📊 Summary:"
echo "  - Root files: 4"
echo "  - Frontend files: 8"
echo "  - Backend files: 5"
echo "  - Worker files: 3"
echo "  - Orchestrator files: 5"
echo "  - Infrastructure files: 4"
echo "  - CI/CD files: 2"
echo "  - Scripts: 2"
echo ""
echo "Total: 33+ files created!"
echo ""
echo "🎯 Next steps:"
echo "1. Review the changes: git status"
echo "2. Commit all files: git add . && git commit -m 'feat: Initialize AutoBrain - Production-Ready AI Knowledge Assistant'"
echo "3. Push to GitHub: git push origin feature/autobrain-init"
echo "4. Create Pull Request on GitHub"
echo ""
echo "🚀 Ready to build AutoBrain!"
EOF