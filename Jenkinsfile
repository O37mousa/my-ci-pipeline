
pipeline {
  agent any

  options {
    timestamps()
    timeout(time: 20, unit: 'MINUTES')
    // skipDefaultCheckout(true) // enable if you want to control checkout explicitly
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        echo '✅ Code checked out.'
      }
    }

    stage('code-check') {
      agent { docker { image 'node:20-alpine' } }
      steps {
        script {
          def status = sh(script: '''
            set -e
            if [ -f package-lock.json ]; then
              npm ci --no-audit --progress=false
            else
              npm install --no-audit --progress=false
            fi
            npm run lint
          ''', returnStatus: true)

          if (status != 0) {
            error("❌ Code check failed. Please fix lint/static analysis errors and retry.")
          } else {
            echo '✅ Code check passed.'
          }
        }
      }
    }

    stage('Build') {
      steps { echo '🏗️ Building project...' }
    }

    stage('Test') {
      steps { echo '🧪 Running tests...' }
    }
  }

  post {
    failure { echo '🚨 Pipeline failed.' }
    success { echo '🎉 Pipeline succeeded.' }
  }
}
