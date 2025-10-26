.PHONY: help dev prod build-dev build-prod up-dev up-prod down-dev down-prod logs-dev logs-prod clean restart-dev restart-prod

# Variables
PROJECT_NAME = mynextjs-app
DEV_CONTAINER = mynextjs-dev
PROD_CONTAINER = mynextjs-prod

# Default target
help:
	@echo "=========================================="
	@echo "  $(PROJECT_NAME) - Makefile Commands"
	@echo "=========================================="
	@echo ""
	@echo "Development:"
	@echo "  make dev          - Run development server"
	@echo "  make build-dev    - Build development image"
	@echo "  make up-dev       - Start development container"
	@echo "  make down-dev     - Stop development container"
	@echo "  make logs-dev     - View development logs"
	@echo "  make restart-dev  - Restart development container"
	@echo ""
	@echo "Production:"
	@echo "  make prod         - Run production server"
	@echo "  make build-prod   - Build production image"
	@echo "  make up-prod      - Start production container"
	@echo "  make down-prod    - Stop production container"
	@echo "  make logs-prod    - View production logs"
	@echo "  make restart-prod - Restart production container"
	@echo ""
	@echo "Kubernetes (MicroK8s):"
	@echo "  make k8s-deploy        - Deploy to Kubernetes"
	@echo "  make k8s-delete        - Delete Kubernetes resources"
	@echo "  make k8s-status        - Show Kubernetes status"
	@echo "  make k8s-logs          - View Kubernetes logs"
	@echo "  make k8s-port-forward  - Port forward to localhost:3000"
	@echo "  make k8s-scale         - Scale deployment (use REPLICAS=N)"
	@echo "  make k8s-stop          - Stop all pods (scale to 0)"
	@echo "  make k8s-start         - Start pods (scale to 3)"
	@echo ""
	@echo "General:"
	@echo "  make clean        - Remove all containers and images"
	@echo "  make ps           - Show running containers"
	@echo "  make shell-dev    - Access development container shell"
	@echo "  make shell-prod   - Access production container shell"
	@echo ""

# ==========================================
# Development Commands
# ==========================================

dev: down-dev
	@echo "🚀 Starting development server..."
	docker compose --profile dev up --build

build-dev:
	@echo "🏗️  Building development image..."
	docker compose --profile dev build

up-dev:
	@echo "▶️  Starting development container in background..."
	docker compose --profile dev up -d

down-dev:
	@echo "⏹️  Stopping development container..."
	docker compose --profile dev down

logs-dev:
	@echo "📋 Viewing development logs..."
	docker compose --profile dev logs -f

restart-dev:
	@echo "🔄 Restarting development container..."
	docker compose --profile dev restart

shell-dev:
	@echo "🐚 Accessing development container shell..."
	docker exec -it $(DEV_CONTAINER) sh

# ==========================================
# Production Commands
# ==========================================

prod: down-prod
	@echo "🚀 Starting production server..."
	docker compose --profile prod up --build

build-prod:
	@echo "🏗️  Building production image..."
	docker compose --profile prod build --no-cache

up-prod:
	@echo "▶️  Starting production container in background..."
	docker compose --profile prod up -d

down-prod:
	@echo "⏹️  Stopping production container..."
	docker compose --profile prod down

logs-prod:
	@echo "📋 Viewing production logs..."
	docker compose --profile prod logs -f

restart-prod:
	@echo "🔄 Restarting production container..."
	docker compose --profile prod restart

shell-prod:
	@echo "🐚 Accessing production container shell..."
	docker exec -it $(PROD_CONTAINER) sh

# ==========================================
# Kubernetes Commands (MicroK8s)
# ==========================================

k8s-deploy:
	@echo "☸️  Deploying to Kubernetes..."
	microk8s kubectl apply -f k8s-deployment.yaml

k8s-delete:
	@echo "🗑️  Deleting Kubernetes resources..."
	microk8s kubectl delete -f k8s-deployment.yaml

k8s-status:
	@echo "📊 Kubernetes status..."
	microk8s kubectl get pods,svc,ingress -n mynextjs-app

k8s-logs:
	@echo "📋 Kubernetes logs..."
	microk8s kubectl logs -f deployment/mynextjs-app -n mynextjs-app

k8s-port-forward:
	@echo "🔌 Port forwarding to localhost:3000..."
	microk8s kubectl port-forward svc/mynextjs-service 3000:80 -n mynextjs-app

k8s-scale:
	@echo "⚖️  Scaling deployment to $(REPLICAS) replicas..."
	microk8s kubectl scale deployment mynextjs-app --replicas=$(REPLICAS) -n mynextjs-app

k8s-stop:
	@echo "⏹️  Stopping all pods (scaling to 0)..."
	microk8s kubectl scale deployment mynextjs-app --replicas=0 -n mynextjs-app

k8s-start:
	@echo "▶️  Starting pods (scaling to 3)..."
	microk8s kubectl scale deployment mynextjs-app --replicas=3 -n mynextjs-app

# ==========================================
# Docker Image Commands
# ==========================================

build-image:
	@echo "🏗️  Building Docker image for Kubernetes..."
	docker build --target production -t $(PROJECT_NAME):latest .

tag-image:
	@echo "🏷️  Tagging image..."
	docker tag $(PROJECT_NAME):latest $(REGISTRY)/$(PROJECT_NAME):$(TAG)

push-image:
	@echo "📤 Pushing image to registry..."
	docker push $(REGISTRY)/$(PROJECT_NAME):$(TAG)

# ==========================================
# General Commands
# ==========================================

ps:
	@echo "📦 Running containers..."
	docker compose ps

clean:
	@echo "🧹 Cleaning up containers and images..."
	docker compose --profile dev down -v
	docker compose --profile prod down -v
	docker rmi $(PROJECT_NAME):latest || true
	docker system prune -f

clean-all:
	@echo "🧹 Deep cleaning (removing all unused Docker resources)..."
	docker compose --profile dev down -v
	docker compose --profile prod down -v
	docker system prune -af --volumes

install:
	@echo "📦 Installing dependencies..."
	pnpm install

test:
	@echo "🧪 Running tests..."
	pnpm test

lint:
	@echo "🔍 Running linter..."
	pnpm lint

format:
	@echo "✨ Formatting code..."
	pnpm format

# ==========================================
# Quick Commands
# ==========================================

# Start development with one command
start: dev

# Stop everything
stop:
	@echo "⏹️  Stopping all containers..."
	docker compose --profile dev down
	docker compose --profile prod down

# Restart everything
restart: stop start
