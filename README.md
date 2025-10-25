# My Next.js App

A modern Next.js application with multi-language typewriter effect, built with TypeScript, Tailwind CSS, and Framer Motion.

## ✨ Features

- 🎨 **Multi-Language Typewriter Effect** - Animated text in Indonesian, English, Japanese, and French
- 🎭 **Framer Motion Animations** - Smooth transitions and effects
- 🌓 **Dark Mode Support** - Automatic dark/light theme
- 📱 **Responsive Design** - Mobile-first approach
- 🐳 **Docker Ready** - Development and production containers
- ☸️ **Kubernetes Manifests** - Ready for K8s deployment
- 🚀 **CI/CD Pipeline** - Automated GitHub Actions workflows

## 🚀 Quick Start

### Development

```bash
# Install dependencies
pnpm install

# Run development server
pnpm dev

# Or using Docker
make dev
# or
docker compose --profile dev up
```

Open [http://localhost:3000](http://localhost:3000) with your browser.

### Production

```bash
# Build application
pnpm build

# Start production server
pnpm start

# Or using Docker
make prod
# or
docker compose --profile prod up
```

## 🐳 Docker Commands

```bash
# Development
make dev              # Build & run development
make up-dev           # Start in background
make logs-dev         # View logs
make down-dev         # Stop container

# Production
make prod             # Build & run production
make up-prod          # Start in background
make logs-prod        # View logs
make down-prod        # Stop container

# General
make help             # Show all commands
make clean            # Clean up containers
```

## ☸️ Kubernetes Deployment

```bash
# Build production image
make build-image

# Deploy to Kubernetes
make k8s-deploy

# Check status
make k8s-status

# View logs
make k8s-logs

# Port forward (localhost:3000)
make k8s-port-forward

# Delete deployment
make k8s-delete
```

See [README-DEPLOYMENT.md](./README-DEPLOYMENT.md) for detailed deployment guide.

## 📦 GitHub Container Registry

Images are automatically built and pushed to GHCR on every push to `main`:

```bash
# Pull latest image
docker pull ghcr.io/<username>/mynextjs-app/mynextjs-app:latest

# Run container
docker run -d -p 3000:3000 ghcr.io/<username>/mynextjs-app/mynextjs-app:latest
```

## 🔄 CI/CD Workflows

This project uses GitHub Actions for automated CI/CD:

- **CI/CD Pipeline** - Auto-build and push to GHCR on main branch
- **Build & Test** - Run tests and linting on PRs
- **Docker Release** - Multi-platform builds for releases

See [.github/WORKFLOWS.md](./.github/WORKFLOWS.md) for detailed workflow documentation.

## 🛠️ Tech Stack

- **Framework:** [Next.js 15](https://nextjs.org/)
- **Language:** [TypeScript](https://www.typescriptlang.org/)
- **Styling:** [Tailwind CSS](https://tailwindcss.com/)
- **Animation:** [Framer Motion](https://www.framer.com/motion/)
- **Package Manager:** [pnpm](https://pnpm.io/)
- **Containerization:** [Docker](https://www.docker.com/)
- **Orchestration:** [Kubernetes](https://kubernetes.io/)
- **CI/CD:** [GitHub Actions](https://github.com/features/actions)

## 📁 Project Structure

```
mynextjs-app/
├── .github/
│   ├── workflows/          # GitHub Actions workflows
│
├── app/
│   ├── page.tsx           # Main landing page
│   ├── layout.tsx         # Root layout
│   └── globals.css        # Global styles
├── components/
│   └── ui/
│       ├── multi-language-typewriter.tsx
│       └── typewriter-effect.tsx
├── lib/
│   └── utils.ts           # Utility functions
├── public/                # Static assets
├── .dockerignore
├── docker-compose.yml     # Docker Compose config
├── Dockerfile             # Multi-stage Dockerfile
├── k8s-deployment.yaml    # Kubernetes manifests
└── Makefile              # Make commands
```

## 🎯 Available Scripts

```bash
pnpm dev          # Start development server
pnpm build        # Build for production
pnpm start        # Start production server
pnpm lint         # Run ESLint
```

## 📝 Environment Variables

Create `.env.local` file for local development:

```env
NODE_ENV=development
NEXT_TELEMETRY_DISABLED=1
```

## 👨‍💻 Author

**Agung Dwi Kurniyanto**  
2210512007 - Cloud Computing Class
