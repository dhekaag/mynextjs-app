# 🚀 CI/CD Pipeline Documentation

## 📋 Alur CI/CD

```
Developer push ke branch main
          ↓
GitHub Actions trigger otomatis
          ↓
Build Docker image (production)
          ↓
Push image ke GHCR (GitHub Container Registry)
          ↓
[MANUAL] Deploy ke Kubernetes
          ↓
Aplikasi Next.js running di cluster
```

---

## 🔄 Workflows yang Tersedia

### 1. **CI/CD Pipeline** (`.github/workflows/deploy.yaml`)

**Trigger:** Otomatis saat push ke branch `main`

**Jobs:**

#### Job 1: Build and Push

- ✅ Checkout kode
- ✅ Setup Docker Buildx
- ✅ Login ke GHCR
- ✅ Build Docker image (production)
- ✅ Push ke GitHub Container Registry
- ✅ Multi-platform: `linux/amd64`, `linux/arm64`

**Tags yang dibuat:**

- `latest` - Image terbaru
- `<commit-sha>` - Berdasarkan commit hash
- `main` - Branch name

#### Job 2: Deploy to Kubernetes (Optional)

- ⚠️ Hanya jalan jika commit message mengandung `[deploy]`
- ⚠️ Atau trigger manual via workflow_dispatch
- ⚠️ Memerlukan `KUBECONFIG` secret

---

### 2. **Manual Deploy** (`.github/workflows/manual-deploy.yaml`)

**Trigger:** Manual via GitHub UI

**Cara menggunakan:**

1. Go to **Actions** tab
2. Select **Manual Deploy to Kubernetes**
3. Click **Run workflow**
4. Pilih:
   - Image tag (default: latest)
   - Environment (production/staging)
5. Click **Run workflow**

---

## 🔐 Setup Secrets

### Required Secrets

#### 1. **GITHUB_TOKEN**

- ✅ Otomatis tersedia (no action needed)
- Digunakan untuk push ke GHCR

#### 2. **KUBECONFIG** (Optional - untuk auto deploy)

**Cara setup:**

```bash
# 1. Encode kubeconfig file
cat ~/.kube/config | base64 > kubeconfig-base64.txt

# Atau untuk MicroK8s
microk8s config | base64 > kubeconfig-base64.txt
```

**Di GitHub:**

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `KUBECONFIG`
4. Value: Paste isi `kubeconfig-base64.txt`
5. Click **Add secret**

---

## 📦 Menggunakan Image dari GHCR

### Pull Image

```bash
# Login ke GHCR (gunakan GitHub Personal Access Token)
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull latest image
docker pull ghcr.io/<username>/<repo>/mynextjs-app:latest

# Pull specific commit
docker pull ghcr.io/<username>/<repo>/mynextjs-app:<sha>
```

### Deploy ke Kubernetes

#### **MicroK8s:**

```bash
# 1. Pull image dari GHCR
docker pull ghcr.io/<username>/<repo>/mynextjs-app:latest

# 2. Tag untuk local
docker tag ghcr.io/<username>/<repo>/mynextjs-app:latest mynextjs-app:latest

# 3. Save & transfer ke MicroK8s
docker save mynextjs-app:latest -o /tmp/mynextjs-app.tar
multipass transfer /tmp/mynextjs-app.tar microk8s-vm:/tmp/
microk8s ctr image import /tmp/mynextjs-app.tar

# 4. Restart deployment
microk8s kubectl rollout restart deployment/mynextjs-app -n mynextjs-app

# 5. Verify
microk8s kubectl get pods -n mynextjs-app
```

#### **Standard Kubernetes:**

```bash
# Update image di deployment
kubectl set image deployment/mynextjs-app \
  mynextjs-app=ghcr.io/<username>/<repo>/mynextjs-app:latest \
  -n mynextjs-app

# Verify rollout
kubectl rollout status deployment/mynextjs-app -n mynextjs-app
```

---

## 🎯 Deployment Scenarios

### Scenario 1: Auto Build Only (Default)

```bash
# Push ke main
git add .
git commit -m "feat: add new feature"
git push origin main
```

**Hasil:**

- ✅ Build Docker image
- ✅ Push ke GHCR
- ❌ Deploy ke K8s (manual)

---

### Scenario 2: Auto Build + Auto Deploy

```bash
# Push dengan [deploy] tag
git add .
git commit -m "feat: add feature [deploy]"
git push origin main
```

**Hasil:**

- ✅ Build Docker image
- ✅ Push ke GHCR
- ✅ Deploy ke K8s (jika KUBECONFIG tersedia)

---

### Scenario 3: Manual Deploy

1. Go to **Actions** tab
2. Select **Manual Deploy to Kubernetes**
3. Click **Run workflow**
4. Choose image tag & environment
5. Click **Run workflow**

---

## 📊 Monitoring Workflow

### Cek Status

```bash
# Via GitHub CLI
gh run list --workflow=deploy.yaml

# Watch latest run
gh run watch
```

### View Logs

```bash
# Via GitHub CLI
gh run view --log

# Atau di GitHub UI:
# Actions → Select workflow run → Click on job
```

---

## 🐛 Troubleshooting

### Build Gagal

**Error:** `failed to solve`

**Solusi:**

```bash
# Test build locally
docker build --target production -t test .

# Check Dockerfile syntax
docker build --no-cache -t test .
```

---

### Push ke GHCR Gagal

**Error:** `denied: permission_denied`

**Solusi:**

- Pastikan `packages: write` permission ada di workflow
- Check repository settings → Actions → General
- Enable "Read and write permissions"

---

### Deploy ke K8s Gagal

**Error:** `The connection to the server was refused`

**Solusi:**

1. Verify KUBECONFIG secret
2. Test kubeconfig locally:

```bash
echo "$KUBECONFIG_BASE64" | base64 -d > test-config
kubectl --kubeconfig=test-config get nodes
```

---

### Image Pull Error di K8s

**Error:** `ImagePullBackOff`

**Solusi MicroK8s:**

```bash
# Pull dan import manual
docker pull ghcr.io/<username>/<repo>/mynextjs-app:latest
docker save ghcr.io/<username>/<repo>/mynextjs-app:latest -o /tmp/app.tar
multipass transfer /tmp/app.tar microk8s-vm:/tmp/
microk8s ctr image import /tmp/app.tar
```

**Solusi Standard K8s:**

```bash
# Create image pull secret
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<username> \
  --docker-password=<github-token> \
  -n mynextjs-app

# Add to deployment
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "ghcr-secret"}]}' \
  -n mynextjs-app
```

---

## 📈 Best Practices

### 1. **Branch Strategy**

- `main` - Production releases
- `develop` - Development (optional)
- `feature/*` - Feature branches

### 2. **Commit Messages**

- Use conventional commits: `feat:`, `fix:`, `docs:`
- Add `[deploy]` untuk trigger auto-deploy
- Add `[skip ci]` untuk skip workflow

### 3. **Versioning**

```bash
# Create release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 4. **Security**

- Never commit secrets
- Use GitHub Secrets
- Rotate tokens regularly
- Use least privilege principle

---

## 🔗 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GHCR Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Kubernetes Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

---

## 📞 Support

Jika ada masalah:

1. Check workflow logs di Actions tab
2. Verify secrets configuration
3. Test locally first
4. Review this documentation

Happy deploying! 🚀
