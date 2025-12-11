# 🖥️ Terminal Commands Reference - Complete Guide

This file contains every command you need to run to set up and test the checkpoint.

---

## 📍 Working Directory

All commands assume you're in this directory:
```bash
cd "c:\System\Mousa\DEPI - DevOps\Freelancing\Kafil Gigs\ci-pipeline"
```

Or in WSL:
```bash
cd /mnt/c/System/Mousa/DEPI\ -\ DevOps/Freelancing/Kafil\ Gigs/ci-pipeline
```

---

## 🔧 Phase 0: Jenkins Setup (One-time)

### Start Jenkins Container
```bash
docker run -d --name jenkins-lts \
  -p 3737:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  jenkins/jenkins:lts
```

### Wait for Jenkins to Start
```bash
sleep 30
```

### Get Initial Admin Password
```bash
docker exec jenkins-lts cat /var/jenkins_home/secrets/initialAdminPassword
```

### Access Jenkins
Open browser: `http://localhost:3737`

---

## 🧪 Phase 1: Local Testing (Before Jenkins)

### Check Node.js and npm versions
```bash
node --version
npm --version
```

### Install Dependencies
```bash
npm install
```

Or if package-lock.json exists:
```bash
npm ci
```

### Run ESLint Locally
```bash
npm run lint
```

Expected output (success):
```
✅ 0 problems found
```

### Run ESLint with Fix (Optional)
```bash
npm run lint -- --fix
```

---

## 📦 Phase 2: Check Project Files

### List all files
```bash
ls -la
```

Expected files:
```
Jenkinsfile
README.md
CHECKPOINT.md
COMMANDS.md (this file)
package.json
package-lock.json
.eslintrc.json
src/
node_modules/
.git/
```

### View Jenkinsfile
```bash
cat Jenkinsfile
```

### View package.json
```bash
cat package.json
```

### View ESLint config
```bash
cat .eslintrc.json
```

### View README
```bash
cat README.md
```

Or open in editor:
```bash
code README.md
```

---

## 🚀 Phase 3: Jenkins Configuration

### Step 1: Access Jenkins Web UI
```
URL: http://localhost:3737
Username: admin
Password: [from initialAdminPassword]
```

### Step 2: Create New Job (Scripted)

If Jenkins CLI available:
```bash
java -jar jenkins-cli.jar -s http://localhost:3737 \
  create-job my-ci-pipeline-checkpoint \
  < job-config.xml
```

### Step 2: Create New Job (Manual)
1. Click "New Item"
2. Job name: `my-ci-pipeline-checkpoint`
3. Select: "Pipeline"
4. Click "OK"

### Step 3: Configure Pipeline

In Pipeline section:
```
Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/O37mousa/my-ci-pipeline.git
Branch: */demo
Script Path: Jenkinsfile
```

### Step 4: Save Job
Click "Save" button

---

## ▶️ Phase 4: Build & Test

### Trigger Build Manually
```bash
curl -X POST http://localhost:3737/job/my-ci-pipeline-checkpoint/build \
  --user admin:[your-password]
```

Or click "Build Now" in Jenkins UI

### Monitor Build Logs
In Jenkins UI:
1. Click job name
2. Click latest build number
3. Click "Console Output"
4. Watch real-time logs

### Stream Logs from Jenkins Container
```bash
docker logs -f jenkins-lts | grep -i "code-check"
```

### Get Build Status
```bash
curl -s http://localhost:3737/job/my-ci-pipeline-checkpoint/lastBuild/api/json | grep result
```

---

## 🔍 Phase 5: Verification & Validation

### Verify Git Repository
```bash
git status
git log --oneline -5
git branch -a
```

### Verify package.json Scripts
```bash
npm run
```

Expected output shows:
```
lint
  eslint .
```

### Verify ESLint Installation
```bash
npx eslint --version
```

### Verify Docker is Accessible
```bash
docker ps
docker images | grep node
```

### Verify Jenkins Container
```bash
docker ps | grep jenkins
```

### View Jenkins Environment
```bash
docker exec jenkins-lts env | grep -i jenkins
```

---

## 🐛 Phase 6: Troubleshooting Commands

### Check Jenkins Logs
```bash
docker logs jenkins-lts
```

### Check Last 50 Lines
```bash
docker logs --tail 50 jenkins-lts
```

### Check Docker Socket
```bash
ls -l /var/run/docker.sock
```

### Fix Docker Socket Permissions (if needed)
```bash
sudo chmod 666 /var/run/docker.sock
```

### Restart Jenkins
```bash
docker restart jenkins-lts
```

### Stop Jenkins
```bash
docker stop jenkins-lts
```

### Remove Jenkins Container
```bash
docker rm jenkins-lts
```

### Remove Jenkins Volume (DANGEROUS - deletes all data)
```bash
docker volume rm jenkins_home
```

### Check Disk Space
```bash
docker system df
```

### Clean up Docker (removes unused resources)
```bash
docker system prune -a
```

---

## 📊 Phase 7: Pipeline Testing Scenarios

### Scenario 1: Successful Pipeline Run
**Steps:**
1. Run: `npm run lint` locally (should pass)
2. Push code to `demo` branch
3. Trigger Jenkins build
4. **Expected:** All 4 stages complete, marked SUCCESS

**Command to check:**
```bash
npm run lint
```

### Scenario 2: Test Lint Failure
**Steps:**
1. Add intentional error to src/index.js:
   ```javascript
   const unusedVar = 123;  // Will trigger "no-unused-vars"
   ```
2. Push code
3. Trigger Jenkins build
4. **Expected:** Code-check stage fails, displays error

**Command to simulate:**
```bash
echo "const unused = 123;" >> src/index.js
npm run lint
```

**To revert:**
```bash
git checkout src/index.js
```

### Scenario 3: Missing Dependencies
**Steps:**
1. Delete package-lock.json
2. Trigger build
3. **Expected:** npm install runs, then lint succeeds

**Command to simulate:**
```bash
rm package-lock.json
git checkout package-lock.json
```

---

## 📈 Phase 8: Monitoring & Statistics

### Get Build History
```bash
curl -s http://localhost:3737/job/my-ci-pipeline-checkpoint/api/json | grep -A 5 builds
```

### Count Total Builds
```bash
curl -s http://localhost:3737/job/my-ci-pipeline-checkpoint/api/json | grep '"number"' | wc -l
```

### Get Last Build Duration
```bash
curl -s http://localhost:3737/job/my-ci-pipeline-checkpoint/lastBuild/api/json | grep duration
```

### Export Build Logs
```bash
curl -s http://localhost:3737/job/my-ci-pipeline-checkpoint/lastBuild/consoleText > build.log
cat build.log
```

---

## 🎯 Phase 9: Demo Preparation

### Create Demo Script
```bash
cat > demo.sh << 'EOF'
#!/bin/bash
echo "=== Demo: Jenkins CI Pipeline ==="
echo ""
echo "1. Check current directory"
pwd
echo ""
echo "2. Show Jenkinsfile"
head -20 Jenkinsfile
echo ""
echo "3. Show package.json"
cat package.json
echo ""
echo "4. Run local lint check"
npm run lint
echo ""
echo "5. Jenkins UI: http://localhost:3737"
EOF

chmod +x demo.sh
./demo.sh
```

### Test All Commands in Sequence
```bash
# Run this complete demo test
node --version && \
npm --version && \
npm list eslint && \
npm run lint && \
cat .eslintrc.json && \
docker ps | grep jenkins && \
echo "✅ All checks passed!"
```

---

## 🔐 Phase 10: Security Commands

### Check for Sensitive Data
```bash
grep -r "password\|secret\|token" . --exclude-dir=node_modules
```

### Verify .gitignore
```bash
cat .gitignore
```

### Check Git Status
```bash
git status
```

### Verify No Uncommitted Secrets
```bash
git diff --cached
```

---

## 📝 Phase 11: Documentation Validation

### Verify README exists and has content
```bash
wc -l README.md
head -50 README.md
```

### Verify CHECKPOINT.md exists
```bash
wc -l CHECKPOINT.md
```

### Verify all required files
```bash
for file in Jenkinsfile README.md CHECKPOINT.md package.json .eslintrc.json; do
  if [ -f "$file" ]; then
    echo "✅ $file exists"
  else
    echo "❌ $file MISSING"
  fi
done
```

---

## 🎬 Quick Demo Checklist

Run these commands in order to verify everything before presenting:

```bash
# 1. Navigate to directory
cd "c:\System\Mousa\DEPI - DevOps\Freelancing\Kafil Gigs\ci-pipeline"

# 2. Check files exist
ls -la Jenkinsfile README.md CHECKPOINT.md package.json .eslintrc.json

# 3. Verify Jenkins is running
docker ps | grep jenkins

# 4. Test npm locally
npm run lint

# 5. Check git status
git status
git log -1

# 6. Show Jenkins URL
echo "Jenkins: http://localhost:3737"

# 7. Verify job exists
curl -s http://localhost:3737/api/json | grep jobs
```

**Expected output:** All files exist, Jenkins running, npm lint passes, git clean

---

## 💡 Pro Tips

### Faster Builds
```bash
npm ci --prefer-offline --no-audit
```

### Skip Optional Dependencies
```bash
npm install --no-optional
```

### Clean npm Cache (if having issues)
```bash
npm cache clean --force
```

### Rebuild Node Modules
```bash
rm -rf node_modules package-lock.json
npm install
```

### Use npm Scripts Shorthand
```bash
npm run lint   # full form
npm lint       # shorthand (if defined as "lint")
```

---

## 🔄 Update Commands

### Update Jenkinsfile After Changes
```bash
git add Jenkinsfile
git commit -m "Update Jenkinsfile: add new stage"
git push origin demo
```

### Trigger Jenkins Build After Push
Jenkins will auto-trigger if webhook configured, or manually:
```bash
curl -X POST http://localhost:3737/job/my-ci-pipeline-checkpoint/build
```

### Reload Jenkins Configuration
```bash
docker exec jenkins-lts curl -X POST http://localhost:8080/reload
```

---

## 📊 Useful One-Liners

```bash
# Show only errors from ESLint
npm run lint 2>&1 | grep "error"

# Count lint issues
npm run lint 2>&1 | grep -c "error"

# Run lint and save output
npm run lint > lint-report.txt 2>&1

# Watch file changes and run lint
npx nodemon --exec "npm run lint" src/

# Run multiple checks
npm run lint && npm test

# Generate HTML report (if configured)
npm run lint -- --format html > lint-report.html
```

---

## ✅ Final Validation

Before presenting to client, run:

```bash
#!/bin/bash

echo "🔍 Validating checkpoint..."
echo ""

# Check 1: Files exist
echo "✓ Checking files..."
for file in Jenkinsfile README.md CHECKPOINT.md package.json .eslintrc.json; do
  [ -f "$file" ] && echo "  ✅ $file" || echo "  ❌ $file MISSING"
done

# Check 2: Dependencies installed
echo "✓ Checking dependencies..."
npm list eslint > /dev/null 2>&1 && echo "  ✅ ESLint installed" || echo "  ❌ ESLint missing"

# Check 3: Lint passes
echo "✓ Running lint check..."
npm run lint > /dev/null 2>&1 && echo "  ✅ Lint passed" || echo "  ❌ Lint failed"

# Check 4: Jenkins running
echo "✓ Checking Jenkins..."
docker ps | grep jenkins > /dev/null && echo "  ✅ Jenkins running" || echo "  ❌ Jenkins not running"

# Check 5: Git clean
echo "✓ Checking git status..."
[ -z "$(git status --porcelain)" ] && echo "  ✅ Git clean" || echo "  ⚠️ Uncommitted changes"

echo ""
echo "✅ Checkpoint validation complete!"
```

Save as `validate.sh` and run:
```bash
chmod +x validate.sh
./validate.sh
```

---

**Reference created: December 11, 2025**  
**For: Jenkins CI/CD Pipeline Checkpoint v1.0**
