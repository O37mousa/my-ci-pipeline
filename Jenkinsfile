/**
 * CI/CD Pipeline for Beginner Node.js Projects
 * 
 * This pipeline demonstrates:
 * - Code checkout from Git
 * - Static code analysis (ESLint)
 * - Build and Test stages
 * 
 * Author: DevOps Team
 * Version: 1.0.0
 */

pipeline {
  agent any

  options {
    timestamps()
    timeout(time: 20, unit: 'MINUTES')
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  environment {
    NODE_ENV = 'development'
    CI = 'true'
  }

  stages {
    stage('📥 Checkout') {
      steps {
        script {
          echo "=========================================="
          echo "📥 Stage: Checking out code from repository"
          echo "=========================================="
        }
        checkout scm
        script {
          // Get commit info
          def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
          echo "✅ Code checked out successfully"
          echo "   Commit: ${commitHash}"
          echo "   Message: ${commitMessage}"
        }
      }
    }

    stage('🔍 Code-Check (Lint)') {
      agent { docker { image 'node:20-alpine' } }
      steps {
        script {
          echo "=========================================="
          echo "🔍 Stage: Running code quality checks"
          echo "=========================================="
          echo "Step 1: Installing dependencies..."
          
          sh '''
            set -e
            if [ -f package-lock.json ]; then
              npm ci --no-audit --progress=false
            else
              npm install --no-audit --progress=false
            fi
            echo "✅ Dependencies installed"
          '''

          echo "Step 2: Running ESLint..."
          def lintStatus = sh(script: 'npm run lint', returnStatus: true)
          
          if (lintStatus != 0) {
            echo "❌ ESLint found issues!"
            error("Code quality check FAILED. Please fix the issues above and retry.")
          } else {
            echo "✅ Code quality check PASSED"
          }
        }
      }
    }

    stage('🏗️ Build') {
      steps {
        script {
          echo "=========================================="
          echo "🏗️ Stage: Building project"
          echo "=========================================="
          echo "✅ Build stage completed (placeholder)"
        }
      }
    }

    stage('🧪 Test') {
      steps {
        script {
          echo "=========================================="
          echo "🧪 Stage: Running tests"
          echo "=========================================="
          echo "✅ Test stage completed (placeholder)"
        }
      }
    }
  }

  post {
    always {
      echo "=========================================="
      echo "📊 Pipeline Summary"
      echo "=========================================="
      script {
        def status = currentBuild.result ?: 'SUCCESS'
        echo "Build Status: ${status}"
        echo "Build Number: #${BUILD_NUMBER}"
        echo "Build URL: ${BUILD_URL}"
      }
    }
    failure {
      echo "🚨 Pipeline FAILED - Check logs above for details"
    }
    success {
      echo "🎉 Pipeline SUCCEEDED - All checks passed!"
    }
    unstable {
      echo "⚠️ Pipeline UNSTABLE - Review warnings"
    }
  }
}
