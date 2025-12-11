#!/bin/bash

###############################################################################
#
# CI Pipeline Checkpoint Validation Script
# 
# This script validates that all components are in place and working
# before presenting the checkpoint to the client.
#
# Usage: bash validate-checkpoint.sh
#
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

###############################################################################
# Functions
###############################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_check() {
    echo -ne "$1 ... "
    ((TOTAL_CHECKS++))
}

print_pass() {
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASSED_CHECKS++))
}

print_fail() {
    echo -e "${RED}❌ FAIL${NC}"
    ((FAILED_CHECKS++))
    if [ -n "$1" ]; then
        echo -e "${RED}   Error: $1${NC}"
    fi
}

print_warn() {
    echo -e "${YELLOW}⚠️ WARN${NC}"
    if [ -n "$1" ]; then
        echo -e "${YELLOW}   Warning: $1${NC}"
    fi
}

###############################################################################
# Check 1: File Structure
###############################################################################

print_header "1️⃣ Checking File Structure"

# Check required files
REQUIRED_FILES=(
    "Jenkinsfile"
    "package.json"
    "package-lock.json"
    ".eslintrc.json"
    "README.md"
    "CHECKPOINT.md"
    "COMMANDS.md"
    "src"
)

for file in "${REQUIRED_FILES[@]}"; do
    print_check "File exists: $file"
    if [ -e "$file" ]; then
        print_pass
    else
        print_fail "Missing file: $file"
    fi
done

###############################################################################
# Check 2: File Content Validation
###############################################################################

print_header "2️⃣ Checking File Content"

# Check Jenkinsfile has required stages
print_check "Jenkinsfile has 'pipeline' keyword"
if grep -q "^pipeline" Jenkinsfile; then
    print_pass
else
    print_fail "Jenkinsfile doesn't start with 'pipeline'"
fi

print_check "Jenkinsfile has 'Checkout' stage"
if grep -q "stage.*Checkout" Jenkinsfile; then
    print_pass
else
    print_fail "Missing Checkout stage"
fi

print_check "Jenkinsfile has 'code-check' stage"
if grep -q "stage.*code-check\|stage.*Code-Check" Jenkinsfile; then
    print_pass
else
    print_fail "Missing code-check stage"
fi

print_check "Jenkinsfile has 'Build' stage"
if grep -q "stage.*Build" Jenkinsfile; then
    print_pass
else
    print_fail "Missing Build stage"
fi

print_check "Jenkinsfile has 'Test' stage"
if grep -q "stage.*Test" Jenkinsfile; then
    print_pass
else
    print_fail "Missing Test stage"
fi

print_check "Jenkinsfile has Docker agent configuration"
if grep -q "agent.*docker" Jenkinsfile; then
    print_pass
else
    print_fail "Missing Docker agent configuration"
fi

# Check package.json structure
print_check "package.json has valid JSON"
if jq empty package.json 2>/dev/null; then
    print_pass
else
    print_fail "package.json is not valid JSON"
fi

print_check "package.json has 'lint' script"
if jq -e '.scripts.lint' package.json > /dev/null 2>&1; then
    print_pass
else
    print_fail "Missing 'lint' script in package.json"
fi

print_check "package.json has ESLint dependency"
if jq -e '.devDependencies.eslint' package.json > /dev/null 2>&1; then
    print_pass
else
    print_fail "ESLint not in devDependencies"
fi

# Check ESLint config
print_check ".eslintrc.json has valid JSON"
if jq empty .eslintrc.json 2>/dev/null; then
    print_pass
else
    print_fail ".eslintrc.json is not valid JSON"
fi

print_check ".eslintrc.json has 'extends' field"
if jq -e '.extends' .eslintrc.json > /dev/null 2>&1; then
    print_pass
else
    print_fail "Missing 'extends' field in .eslintrc.json"
fi

# Check README
print_check "README.md exists and has content"
if [ -s README.md ]; then
    print_pass
else
    print_fail "README.md is empty"
fi

print_check "README.md has 'code-check' or 'Code-Check' section"
if grep -q -i "code.check\|code-check" README.md; then
    print_pass
else
    print_fail "README doesn't document code-check stage"
fi

print_check "README.md has customization examples"
if grep -q -i "python\|java\|golang" README.md; then
    print_pass
else
    print_fail "README lacks customization examples"
fi

# Check CHECKPOINT.md
print_check "CHECKPOINT.md exists and has content"
if [ -s CHECKPOINT.md ]; then
    print_pass
else
    print_fail "CHECKPOINT.md is empty"
fi

###############################################################################
# Check 3: Dependencies
###############################################################################

print_header "3️⃣ Checking Dependencies"

print_check "npm is installed"
if command -v npm &> /dev/null; then
    print_pass
    npm_version=$(npm --version)
    echo "   Version: $npm_version"
else
    print_fail "npm not found in PATH"
fi

print_check "Node.js is installed"
if command -v node &> /dev/null; then
    print_pass
    node_version=$(node --version)
    echo "   Version: $node_version"
else
    print_fail "Node.js not found in PATH"
fi

print_check "node_modules directory exists"
if [ -d "node_modules" ]; then
    print_pass
    echo "   Size: $(du -sh node_modules 2>/dev/null | cut -f1)"
else
    print_fail "node_modules not found - run 'npm install'"
fi

print_check "ESLint is installed"
if [ -d "node_modules/eslint" ]; then
    print_pass
    eslint_version=$(npx eslint --version 2>/dev/null || echo "unknown")
    echo "   Version: $eslint_version"
else
    print_fail "ESLint not installed - run 'npm install'"
fi

###############################################################################
# Check 4: Linting
###############################################################################

print_header "4️⃣ Checking Code Quality"

print_check "npm lint script runs successfully"
if npm run lint > /dev/null 2>&1; then
    print_pass
    echo "   No lint errors found ✓"
else
    print_fail "npm run lint failed - see errors above"
fi

###############################################################################
# Check 5: Git Status
###############################################################################

print_header "5️⃣ Checking Git Status"

print_check "Git repository exists"
if [ -d ".git" ]; then
    print_pass
else
    print_fail "Not a git repository"
fi

print_check "Git is installed"
if command -v git &> /dev/null; then
    print_pass
else
    print_fail "Git not found in PATH"
fi

print_check "Git status is clean"
if [ -z "$(git status --porcelain)" ]; then
    print_pass
else
    print_warn "Uncommitted changes detected"
    git status --short | head -5
fi

print_check "Origin remote is configured"
if git remote get-url origin > /dev/null 2>&1; then
    print_pass
    echo "   Remote: $(git remote get-url origin)"
else
    print_fail "No origin remote configured"
fi

###############################################################################
# Check 6: Docker Setup
###############################################################################

print_header "6️⃣ Checking Docker Setup"

print_check "Docker is installed"
if command -v docker &> /dev/null; then
    print_pass
    docker_version=$(docker --version)
    echo "   $docker_version"
else
    print_fail "Docker not found in PATH"
fi

print_check "Docker daemon is running"
if docker ps > /dev/null 2>&1; then
    print_pass
else
    print_fail "Docker daemon is not running"
fi

print_check "Jenkins container is running"
if docker ps | grep -q "jenkins"; then
    print_pass
    jenkins_port=$(docker ps | grep jenkins | grep -o "0\.0\.0\.0:[0-9]*" | cut -d: -f2)
    echo "   Port: $jenkins_port"
else
    print_warn "Jenkins container not running"
fi

print_check "Node.js Docker image exists"
if docker images | grep -q "node.*alpine\|node.*20"; then
    print_pass
    docker images | grep "node" | head -1 | awk '{print "   Image:", $1":"$2}'
else
    print_warn "Node.js Alpine image not found locally (will be pulled at build time)"
fi

print_check "Docker socket accessible"
if [ -S "/var/run/docker.sock" ]; then
    print_pass
    socket_perms=$(ls -l /var/run/docker.sock | awk '{print $1, $3, $4}')
    echo "   Permissions: $socket_perms"
else
    print_fail "Docker socket not found"
fi

###############################################################################
# Check 7: Jenkins Configuration
###############################################################################

print_header "7️⃣ Checking Jenkins Configuration"

print_check "Jenkins is accessible on port 3737"
if timeout 2 bash -c "echo >/dev/tcp/localhost/3737" 2>/dev/null; then
    print_pass
else
    print_warn "Jenkins not accessible on port 3737"
fi

print_check "Jenkins home volume exists"
if docker volume ls | grep -q "jenkins_home"; then
    print_pass
    echo "   Volume: jenkins_home"
else
    print_warn "jenkins_home volume not found"
fi

###############################################################################
# Check 8: Summary Report
###############################################################################

print_header "📊 Validation Summary"

echo "Total Checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$FAILED_CHECKS${NC}"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "🎉 Checkpoint is ready for client presentation!"
    echo ""
    echo "Next steps:"
    echo "1. Review CHECKPOINT.md for demo details"
    echo "2. Open Jenkins at http://localhost:3737"
    echo "3. Trigger a build to verify end-to-end"
    echo "4. Present to client with confidence!"
    exit 0
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}❌ SOME CHECKS FAILED${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo "Please fix the issues above before presenting."
    exit 1
fi
