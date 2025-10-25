# 🔧 Setup Guide - CI/CD with GitHub Actions# 🔧 GitHub Actions Setup Guide

## 📋 Overview## 📝 Setup Repository Variables & Secrets

Panduan ini menjelaskan cara setup CI/CD untuk aplikasi Next.js menggunakan GitHub Actions, Docker, dan Kubernetes.Untuk mengaktifkan auto-deploy ke Kubernetes, Anda perlu setup variables dan secrets berikut:

---

## 🎯 Alur CI/CD## 1️⃣ Repository Variables

`````### **ENABLE_K8S_DEPLOY**

Developer push ke branch main

          ↓Variable ini mengontrol apakah auto-deploy ke Kubernetes akan dijalankan atau tidak.

GitHub Actions auto-trigger

          ↓**Setup:**

Job 1: Build and Push Docker Image1. Go to repository **Settings**

  ├─ Checkout kode2. Click **Secrets and variables** → **Actions**

  ├─ Build Docker image (production)3. Click tab **Variables**

  └─ Push ke GitHub Container Registry (GHCR)4. Click **New repository variable**

          ↓5. Name: `ENABLE_K8S_DEPLOY`

Job 2: Deploy to Kubernetes (Optional)6. Value: `true` (untuk enable) atau `false` (untuk disable)

  ├─ Setup kubectl7. Click **Add variable**

  ├─ Configure kubeconfig

  ├─ Update deployment**Default behavior:**

  └─ Verify rollout- Jika tidak diset atau `false`: Hanya build & push ke GHCR, **tidak** deploy ke K8s

          ↓- Jika diset `true`: Build, push, **DAN** auto-deploy ke K8s

Aplikasi running di Kubernetes cluster

```---



---## 2️⃣ Repository Secrets



## 🚀 Quick Start### **KUBECONFIG** (Required untuk auto-deploy)



### Minimal Setup (Build Only)Secret ini berisi konfigurasi kubeconfig yang di-encode base64.



**No setup required!** Push ke branch `main` akan otomatis:**Setup untuk MicroK8s:**

- ✅ Build Docker image

- ✅ Push ke GHCR di `ghcr.io/<username>/<repo>/mynextjs-app:latest````bash

# 1. Generate kubeconfig dari MicroK8s

```bashmicrok8s config > kubeconfig.yaml

git push origin main

```# 2. Encode ke base64

cat kubeconfig.yaml | base64 > kubeconfig-base64.txt

Image dapat di-pull:

```bash# 3. Copy isi file kubeconfig-base64.txt

docker pull ghcr.io/<username>/<repo>/mynextjs-app:latestcat kubeconfig-base64.txt

`````

---**Setup untuk Standard Kubernetes:**

## 🔐 Setup Repository Variables & Secrets```bash

# 1. Copy existing kubeconfig

### 1️⃣ Enable Auto-Deploy (Optional)cat ~/.kube/config > kubeconfig.yaml

Untuk mengaktifkan auto-deploy ke Kubernetes, setup repository variable berikut:# 2. Encode ke base64

cat kubeconfig.yaml | base64 > kubeconfig-base64.txt

#### **ENABLE_K8S_DEPLOY**

# 3. Copy isi file kubeconfig-base64.txt

**Cara Setup:**cat kubeconfig-base64.txt

1. Go to repository **Settings**```

2. Click **Secrets and variables** → **Actions**

3. Click tab **Variables\*\***Di GitHub:\*\*

4. Click **New repository variable**1. Go to repository **Settings**

5. Input:2. Click **Secrets and variables** → **Actions**

   - **Name:** `ENABLE_K8S_DEPLOY`3. Click tab **Secrets**

   - **Value:** `true`4. Click **New repository secret**

6. Click **Add variable**5. Name: `KUBECONFIG`

7. Value: Paste isi `kubeconfig-base64.txt`

**Behavior:**7. Click **Add secret**

- `false` atau tidak diset → Build & push only (manual deploy)

- `true` → Build, push, **dan** auto-deploy ke K8s---

---## 🚀 Deployment Scenarios

### 2️⃣ Setup Kubeconfig Secret (Required untuk auto-deploy)### Scenario 1: Build Only (No Auto-Deploy)

#### **KUBECONFIG\*\***Setup:\*\*

- `ENABLE_K8S_DEPLOY` = `false` atau tidak diset

Secret ini berisi kubeconfig yang di-encode base64.- `KUBECONFIG` = tidak perlu

#### **Untuk MicroK8s:\*\***Behavior:\*\*

````

```bashPush to main → Build → Push to GHCR → ✅ Done

# 1. Generate kubeconfig                                     → Manual deploy instructions shown

microk8s config > kubeconfig.yaml```



# 2. Encode ke base64---

cat kubeconfig.yaml | base64 > kubeconfig-base64.txt

### Scenario 2: Auto-Deploy to Kubernetes

# 3. Copy isi file

cat kubeconfig-base64.txt**Setup:**

# Atau di macOS:- `ENABLE_K8S_DEPLOY` = `true`

cat kubeconfig-base64.txt | pbcopy- `KUBECONFIG` = ✅ configured

````

**Behavior:**

#### **Untuk Standard Kubernetes:**```

Push to main → Build → Push to GHCR → Deploy to K8s → ✅ Done

`bash`

# 1. Export kubeconfig

cat ~/.kube/config > kubeconfig.yaml**Trigger auto-deploy:**

````bash

# 2. Encode ke base64# Option 1: Any push to main (if ENABLE_K8S_DEPLOY=true)

cat kubeconfig.yaml | base64 > kubeconfig-base64.txtgit push origin main



# 3. Copy isi file# Option 2: Push with [deploy] tag

cat kubeconfig-base64.txtgit commit -m "feat: new feature [deploy]"

```git push origin main

````

#### **Setup di GitHub:**

---

1. Go to repository **Settings**

2. Click **Secrets and variables** → **Actions**### Scenario 3: Manual Deploy via GitHub UI

3. Click tab **Secrets**

4. Click **New repository secret\*\***Setup:\*\*

5. Input:- `KUBECONFIG` = ✅ configured

   - **Name:** `KUBECONFIG`- `ENABLE_K8S_DEPLOY` = any value (not used for manual deploy)

   - **Value:** Paste isi `kubeconfig-base64.txt`

6. Click **Add secret\*\***Steps:\*\*

7. Go to **Actions** tab

---2. Select **Manual Deploy to Kubernetes**

3. Click **Run workflow**

## 🎮 Deployment Scenarios4. Choose:

- Image tag (default: latest)

### Scenario 1: Build Only (Default) - Environment (production/staging)

5. Click **Run workflow**

**Setup:**

- `ENABLE_K8S_DEPLOY` = tidak diset atau `false`---

**Workflow:**## 🔐 Security Best Practices

`````

git add .### 1. **Kubeconfig Security**

git commit -m "feat: add new feature"- ✅ Use service account dengan minimal permissions

git push origin main- ✅ Jangan commit kubeconfig ke git

```- ✅ Rotate kubeconfig secara berkala

- ✅ Gunakan namespace-specific service account

**Result:**

- ✅ Build Docker image### 2. **Create Limited Service Account**

- ✅ Push ke GHCR

- 📋 Manual deployment instructions ditampilkan```bash

# Create service account

---kubectl create serviceaccount github-actions -n mynextjs-app



### Scenario 2: Auto-Deploy to Kubernetes# Create role

cat <<EOF | kubectl apply -f -

**Setup:**apiVersion: rbac.authorization.k8s.io/v1

- `ENABLE_K8S_DEPLOY` = `true`kind: Role

- `KUBECONFIG` = ✅ configuredmetadata:

  name: github-actions-role

**Workflow:**  namespace: mynextjs-app

```bashrules:

# Option 1: Regular push- apiGroups: ["apps"]

git push origin main  resources: ["deployments"]

  verbs: ["get", "list", "watch", "update", "patch"]

# Option 2: Dengan tag [deploy]- apiGroups: [""]

git commit -m "feat: new feature [deploy]"  resources: ["pods"]

git push origin main  verbs: ["get", "list", "watch"]

```EOF



**Result:**# Create role binding

- ✅ Build Docker imagekubectl create rolebinding github-actions-binding \

- ✅ Push ke GHCR  --role=github-actions-role \

- ✅ Auto-deploy ke Kubernetes  --serviceaccount=mynextjs-app:github-actions \

- ✅ Wait for rollout completion  -n mynextjs-app



---# Get token (K8s 1.24+)

kubectl create token github-actions -n mynextjs-app --duration=8760h

### Scenario 3: Manual Deploy via GitHub UI

# Create kubeconfig dengan token

**Setup:**# (Gunakan token dan cluster info untuk membuat kubeconfig)

- `KUBECONFIG` = ✅ configured```



**Steps:**---

1. Go to **Actions** tab di GitHub

2. Select workflow **Manual Deploy to Kubernetes**## 📊 Workflow Status

3. Click **Run workflow**

4. Fill inputs:### Cek Status Workflow

   - **Image tag:** `latest` (atau tag lainnya)

   - **Environment:** `production` atau `staging````bash

5. Click **Run workflow**# Via GitHub CLI

gh run list --workflow=deploy.yaml

**Result:**

- ✅ Pull image dari GHCR# Watch latest run

- ✅ Update Kubernetes deploymentgh run watch

- ✅ Verify rollout status```



---### View Logs



## 📦 Manual Deployment (tanpa GitHub Actions)```bash

# Via GitHub CLI

### Pull Image dari GHCRgh run view --log



```bash# Specific job

# 1. Login ke GHCR (gunakan GitHub Personal Access Token)gh run view <run-id> --job <job-id> --log

echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin```



# 2. Pull image---

docker pull ghcr.io/<username>/<repo>/mynextjs-app:latest

```## 🐛 Troubleshooting



### Deploy ke MicroK8s### Error: "KUBECONFIG not found"



```bash**Solusi:**

# 1. Pull image1. Verify secret name: `KUBECONFIG` (case-sensitive)

docker pull ghcr.io/dhekaag/mynextjs-app/mynextjs-app:latest2. Re-encode kubeconfig:

```bash

# 2. Tag untuk localcat kubeconfig.yaml | base64 -w 0 > kubeconfig-base64.txt

docker tag ghcr.io/dhekaag/mynextjs-app/mynextjs-app:latest mynextjs-app:latest```

3. Update secret di GitHub

# 3. Save image ke tar

docker save mynextjs-app:latest -o /tmp/mynextjs-app.tar---



# 4. Transfer ke MicroK8s VM### Error: "The connection to the server was refused"

multipass transfer /tmp/mynextjs-app.tar microk8s-vm:/tmp/

**Solusi:**

# 5. Import ke MicroK8s1. Test kubeconfig locally:

microk8s ctr image import /tmp/mynextjs-app.tar```bash

echo "$KUBECONFIG_BASE64" | base64 -d > test-config

# 6. Restart deploymentkubectl --kubeconfig=test-config get nodes

microk8s kubectl rollout restart deployment/mynextjs-app -n mynextjs-app```

2. Pastikan cluster accessible dari internet

# 7. Verify3. Check firewall rules

microk8s kubectl get pods -n mynextjs-app

```---



### Deploy ke Standard Kubernetes### Error: "deployment not found"



```bash**Solusi:**

# 1. Update image di deployment1. Pastikan deployment sudah ada:

kubectl set image deployment/mynextjs-app \```bash

  mynextjs-app=ghcr.io/dhekaag/mynextjs-app/mynextjs-app:latest \kubectl get deployment mynextjs-app -n mynextjs-app

  -n mynextjs-app```

2. Jika belum ada, deploy manual dulu:

# 2. Verify rollout```bash

kubectl rollout status deployment/mynextjs-app -n mynextjs-appkubectl apply -f k8s-deployment.yaml

`````

# 3. Check pods

kubectl get pods -n mynextjs-app---

````

## 📝 Example Workflow Run

---

**With Auto-Deploy Enabled:**

## 🔒 Security Best Practices```

✅ Build and Push

### 1. Create Limited Service Account  └─ 📥 Checkout repository

  └─ 🔧 Set up Docker Buildx

Jangan gunakan admin kubeconfig! Buat service account dengan minimal permissions:  └─ 🔐 Login to GHCR

  └─ 🏷️ Extract Docker metadata

```bash  └─ 🏗️ Build and Push Docker image

# 1. Create service account  └─ 📊 Output image information

kubectl create serviceaccount github-actions -n mynextjs-app

✅ Deploy to Kubernetes

# 2. Create role (minimal permissions)  └─ 📥 Checkout repository

cat <<EOF | kubectl apply -f -  └─ ⚙️ Setup kubectl

apiVersion: rbac.authorization.k8s.io/v1  └─ 🔐 Configure Kubernetes cluster

kind: Role  └─ 🔄 Update Kubernetes deployment

metadata:  └─ 📊 Deployment summary

  name: github-actions-deployer```

  namespace: mynextjs-app

rules:**Without Auto-Deploy:**

- apiGroups: ["apps"]```

  resources: ["deployments"]✅ Build and Push

  verbs: ["get", "list", "patch", "update"]  └─ 📥 Checkout repository

- apiGroups: [""]  └─ 🔧 Set up Docker Buildx

  resources: ["pods"]  └─ 🔐 Login to GHCR

  verbs: ["get", "list"]  └─ 🏷️ Extract Docker metadata

- apiGroups: ["apps"]  └─ 🏗️ Build and Push Docker image

  resources: ["deployments/status"]  └─ 📊 Output image information

  verbs: ["get"]

EOF⏭️ Deploy to Kubernetes (Skipped)

  └─ 📝 Manual deployment instructions

# 3. Create role binding```

kubectl create rolebinding github-actions-deployer-binding \

  --role=github-actions-deployer \---

  --serviceaccount=mynextjs-app:github-actions \

  -n mynextjs-app## 🔗 Related Documentation



# 4. Get service account token (K8s 1.24+)- [CI-CD-GUIDE.md](./.github/CI-CD-GUIDE.md) - Panduan lengkap CI/CD

kubectl create token github-actions -n mynextjs-app --duration=87600h- [WORKFLOWS.md](./.github/WORKFLOWS.md) - Dokumentasi workflows

- [README-DEPLOYMENT.md](../README-DEPLOYMENT.md) - Panduan deployment

# 5. Create kubeconfig dengan token tersebut

```---



### 2. Rotate Secrets Regularly## 💡 Quick Start



```bash**Untuk quick start tanpa auto-deploy:**

# Generate new token every 3-6 months1. Push ke main branch

kubectl create token github-actions -n mynextjs-app --duration=87600h2. Image akan di-build dan push ke GHCR

3. Deploy manual mengikuti instructions di workflow summary

# Update KUBECONFIG secret di GitHub

```**Untuk enable auto-deploy:**

1. Setup `ENABLE_K8S_DEPLOY` = `true`

### 3. Use Environment Protection Rules2. Setup `KUBECONFIG` secret

3. Push ke main branch

Setup environment protection di GitHub:4. Workflow akan auto-deploy ke K8s



1. Go to **Settings** → **Environments**Happy deploying! 🚀

2. Create environment: `production`
3. Add protection rules:
   - ✅ Required reviewers
   - ✅ Wait timer
   - ✅ Deployment branches (main only)

---

## 📊 Monitoring & Debugging

### Check Workflow Status

```bash
# Via GitHub CLI
gh run list --workflow=deploy.yaml

# Watch latest run
gh run watch

# View specific run
gh run view <run-id>
````

### View Workflow Logs

```bash
# Latest run
gh run view --log

# Specific job
gh run view <run-id> --job <job-id> --log
```

### Check Deployment in Kubernetes

```bash
# Get pods
kubectl get pods -n mynextjs-app

# Check deployment status
kubectl get deployment mynextjs-app -n mynextjs-app

# View logs
kubectl logs -f deployment/mynextjs-app -n mynextjs-app

# Describe pod (untuk troubleshooting)
kubectl describe pod <pod-name> -n mynextjs-app

# Check events
kubectl get events -n mynextjs-app --sort-by='.lastTimestamp'
```

---

## 🐛 Troubleshooting

### Error: "failed to push to registry"

**Penyebab:** Permissions tidak cukup untuk push ke GHCR

**Solusi:**

1. Go to **Settings** → **Actions** → **General**
2. Scroll ke **Workflow permissions**
3. Select **Read and write permissions**
4. Click **Save**

---

### Error: "ImagePullBackOff" di Kubernetes

**Penyebab:** Image tidak bisa di-pull dari GHCR (biasanya image private)

**Solusi untuk MicroK8s:**

```bash
# Import image manual (lihat section Manual Deployment)
docker pull ghcr.io/<username>/<repo>/mynextjs-app:latest
docker save ghcr.io/<username>/<repo>/mynextjs-app:latest -o /tmp/app.tar
multipass transfer /tmp/app.tar microk8s-vm:/tmp/
microk8s ctr image import /tmp/app.tar
```

**Solusi untuk Standard K8s:**

```bash
# Create image pull secret
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<github-token> \
  -n mynextjs-app

# Patch service account
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "ghcr-secret"}]}' \
  -n mynextjs-app
```

---

### Error: "The connection to the server was refused"

**Penyebab:** Kubeconfig tidak valid atau cluster tidak accessible

**Solusi:**

1. Test kubeconfig locally:

```bash
echo "$KUBECONFIG_BASE64" | base64 -d > test-config
kubectl --kubeconfig=test-config get nodes
```

2. Pastikan cluster accessible dari internet
3. Check firewall/security group rules

---

### Error: "deployment not found"

**Penyebab:** Deployment belum ada di cluster

**Solusi:**

```bash
# Deploy manual pertama kali
kubectl apply -f k8s-deployment.yaml

# Verify
kubectl get deployment -n mynextjs-app
```

---

## 📚 Related Documentation

- [CI-CD-GUIDE.md](./CI-CD-GUIDE.md) - Panduan lengkap CI/CD workflows
- [WORKFLOWS.md](./WORKFLOWS.md) - Dokumentasi semua workflows
- [README-DEPLOYMENT.md](../README-DEPLOYMENT.md) - Panduan deployment lengkap
- [README.md](../README.md) - Project README

---

## ✅ Checklist Setup

### Basic Setup (Build Only)

- [ ] Repository sudah public/private di GitHub
- [ ] Code sudah di push ke branch `main`
- [ ] Workflow permissions: **Read and write**

### Advanced Setup (Auto-Deploy)

- [ ] Variable `ENABLE_K8S_DEPLOY` = `true`
- [ ] Secret `KUBECONFIG` sudah di-setup
- [ ] Deployment sudah ada di Kubernetes
- [ ] Test deploy manual berhasil

### Production Ready

- [ ] Service account dengan limited permissions
- [ ] Environment protection rules enabled
- [ ] Image pull secret configured (jika repo private)
- [ ] Monitoring & logging setup
- [ ] Backup & disaster recovery plan

---

## 🎓 Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [GHCR Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

## 💡 Tips & Tricks

### 1. Test Locally Before Push

```bash
# Build image locally
docker build --target production -t test .

# Run locally
docker run -p 3000:3000 test

# Test di browser: http://localhost:3000
```

### 2. Use Conventional Commits

```bash
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"
git commit -m "docs: update README"
git commit -m "chore: update dependencies"
```

### 3. Create Git Tags for Releases

```bash
# Create release tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Image akan otomatis tagged dengan version
```

### 4. Monitor Resource Usage

```bash
# Check resource usage
kubectl top pods -n mynextjs-app
kubectl top nodes

# Adjust resources di k8s-deployment.yaml jika perlu
```

---

## 📞 Need Help?

1. Check [Troubleshooting](#-troubleshooting) section
2. Review workflow logs di GitHub Actions
3. Check Kubernetes logs: `kubectl logs -f deployment/mynextjs-app -n mynextjs-app`
4. Create issue di repository

---

**Happy Deploying! 🚀**

---

_Last updated: October 25, 2025_
