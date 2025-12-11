
# 🚀 Jenkins CI/CD Pipeline - Checkpoint Demo v1.0

A beginner-friendly Jenkins pipeline with code quality checks (ESLint). This is a **checkpoint demo** to validate the CI/CD setup before adding Docker and advanced features.

---

## 📋 Overview

This pipeline demonstrates a **5-stage CI/CD workflow**:

| Stage | Purpose | Tool |
|-------|---------|------|
| 📥 **Checkout** | Clone code from Git repository | Git |
| 🔍 **Code-Check** | Run static code analysis | ESLint (Node.js) |
| 🏗️ **Build** | Build the project | npm (placeholder) |
| 🧪 **Test** | Run unit tests | Jest (placeholder) |
| 📊 **Post Actions** | Success/Failure notifications | Jenkins |

---

## 🎯 What This Checkpoint Includes

✅ **Jenkinsfile** with structured pipeline  
✅ **Code quality checks** using ESLint  
✅ **Error handling** - pipeline stops on lint failures  
✅ **Docker support** - runs lint in Node.js Alpine container  
✅ **Clear console output** - timestamps and emojis for readability  
✅ **Reusable structure** - easy to extend for other languages  

---

## 📦 Prerequisites

### Local Setup
- **Jenkins** running on port 3737 (Docker container)
- **Docker** installed and running
- **Git** configured
- **Node.js** (optional, for local testing)

### Repository Requirements
- **package.json** - Node.js project file
- **package-lock.json** - Optional but recommended
- **.eslintrc.json** - ESLint configuration

---

## 🚀 Quick Start

### Step 1: Clone the Repository
```bash
git clone https://github.com/O37mousa/my-ci-pipeline.git
cd my-ci-pipeline
```

### Step 2: Install Dependencies Locally (Optional)
```bash
npm install
```

### Step 3: Test Lint Locally (Optional)
```bash
npm run lint
```

### Step 4: Configure Jenkins Job

1. **Go to Jenkins:** `http://localhost:3737`
2. **Login:** Use your Jenkins credentials
3. **Create New Job:**
   - Click "New Item"
   - Enter job name: `my-ci-pipeline-checkpoint`
   - Select "Pipeline"
   - Click "OK"

4. **Configure Pipeline:**
   - Scroll to "Pipeline" section
   - Select "Pipeline script from SCM"
   - Choose Git
   - Enter Repository URL: `https://github.com/O37mousa/my-ci-pipeline.git`
   - Branch: `*/demo` (or your branch)
   - Script Path: `Jenkinsfile`

5. **Save & Build:**
   - Click "Save"
   - Click "Build Now"
   - Watch the pipeline execute

---

## 📊 Pipeline Stages Explained

### Stage 1: 📥 Checkout
**Purpose:** Clone code from repository  
**What happens:**
- Fetches latest code from Git
- Extracts commit hash and message
- Displays commit information

**Success Output:**
```
✅ Code checked out successfully
   Commit: 5eb6935
   Message: Refactor Jenkinsfile stages and structure
```

---

### Stage 2: 🔍 Code-Check (Lint)
**Purpose:** Validate code quality using ESLint  
**What happens:**
1. **Install dependencies:** `npm ci` or `npm install`
2. **Run ESLint:** `npm run lint`
3. **Validate output:** 
   - If errors found → Stop pipeline, display errors
   - If no errors → Continue to next stage

**Success Output:**
```
✅ Code quality check PASSED
```

**Failure Output:**
```
❌ ESLint found issues!
❌ Code quality check FAILED. Please fix the issues above and retry.
```

---

### Stage 3: 🏗️ Build
**Purpose:** Build the project (placeholder)  
**What happens:** Currently a placeholder for future implementation

---

### Stage 4: 🧪 Test
**Purpose:** Run unit tests (placeholder)  
**What happens:** Currently a placeholder for future implementation

---

## 🔧 Customization Guide

### For Node.js Projects (Current Setup)
The pipeline uses **ESLint** by default. To customize:

#### Option A: Use npm scripts
Edit `package.json`:
```json
{
  "scripts": {
    "lint": "eslint . --fix",
    "lint:check": "eslint .",
    "test": "jest",
    "build": "webpack"
  }
}
```

Then in Jenkinsfile, change:
```groovy
npm run lint
```

To any script you want:
```groovy
npm run lint:check
npm run test
npm run build
```

#### Option B: Modify ESLint rules
Edit `.eslintrc.json`:
```json
{
  "extends": "eslint:recommended",
  "rules": {
    "no-console": "off",
    "semi": ["error", "always"]
  }
}
```

---

### For Python Projects
Update Jenkinsfile `code-check` stage:

```groovy
stage('🔍 Code-Check (Lint)') {
  agent { docker { image 'python:3.11-slim' } }
  steps {
    script {
      sh '''
        set -e
        pip install flake8
        flake8 . --count --statistics
      '''
    }
  }
}
```

---

### For Java Projects (Maven)
Update Jenkinsfile `code-check` stage:

```groovy
stage('🔍 Code-Check (Lint)') {
  agent any
  steps {
    script {
      sh '''
        set -e
        mvn checkstyle:check
      '''
    }
  }
}
```

---

### For Go Projects
Update Jenkinsfile `code-check` stage:

```groovy
stage('🔍 Code-Check (Lint)') {
  agent { docker { image 'golang:1.21-alpine' } }
  steps {
    script {
      sh '''
        set -e
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        golangci-lint run ./...
      '''
    }
  }
}
```

---

## 📁 Project Structure

```
ci-pipeline/
├── Jenkinsfile              # Pipeline definition
├── package.json             # Node.js dependencies
├── package-lock.json        # Locked dependency versions
├── .eslintrc.json          # ESLint configuration
├── README.md               # This file
├── CHECKPOINT.md           # Checkpoint details (new)
├── src/                    # Source code directory
│   └── index.js
└── .git/                   # Git repository
```

---

## ✅ Validation Checklist

Before considering this checkpoint complete, verify:

- [ ] Jenkins is running on port 3737
- [ ] Job created in Jenkins
- [ ] Repository URL configured correctly
- [ ] Branch selected matches your repo
- [ ] First build executed successfully
- [ ] Code-check stage ran
- [ ] Console output shows timestamps
- [ ] Lint passed without errors
- [ ] All 4 stages completed

---

## 🐛 Troubleshooting

### Build Fails with "docker: not found"
**Solution:** Jenkins container needs Docker socket access
```bash
docker stop jenkins-lts
docker rm jenkins-lts
sudo chmod 666 /var/run/docker.sock
docker run -d --name jenkins-lts -p 3737:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  jenkins/jenkins:lts
```

### "npm: command not found"
**Solution:** Node.js Docker image isn't running. Check Jenkinsfile Stage 2:
```groovy
agent { docker { image 'node:20-alpine' } }
```

### ESLint errors not showing
**Solution:** Ensure `.eslintrc.json` exists and is valid
```bash
cat .eslintrc.json
```

### Git clone fails
**Solution:** Check repository URL and credentials
```bash
git ls-remote https://github.com/O37mousa/my-ci-pipeline.git
```

---

## 📝 Notes for Client

✅ **Checkpoint Status:** READY FOR DEMO  
✅ **Stages Implemented:** 2 (Checkout + Code-Check)  
✅ **Stages Planned:** 2 (Build + Test)  
✅ **Docker Support:** Yes (Alpine Node.js)  
✅ **Error Handling:** Yes (stops on lint failure)  

### Next Steps (Phase 2):
- Add Docker build stage
- Add Docker push to registry
- Add deployment stage
- Add Slack notifications
- Add test coverage reports

---

## 📞 Support

For issues or questions:
1. Check Jenkins logs: `docker logs jenkins-lts`
2. Review Jenkinsfile syntax
3. Verify ESLint configuration
4. Test locally: `npm run lint`

---

## 📄 License

This project is part of the DevOps learning curriculum.

---

**Last Updated:** December 11, 2025  
**Version:** 1.0.0 (Checkpoint)  
**Status:** ✅ Ready for Demo
