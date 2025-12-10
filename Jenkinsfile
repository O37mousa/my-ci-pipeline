
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo '✅ Code checked out.'
            }
        }

        stage('code-check') {
            steps {
                script {
                    // If Node.js project (package.json present) → run npm install + lint
                    // Otherwise → run a placeholder (keeps it generic)
                    def cmd = fileExists('package.json') ? 'npm install && npm run lint' : 'echo "lint check"'

                    echo "🔎 Running code check: ${cmd}"
                    int status = sh(script: cmd, returnStatus: true)

                    if (status != 0) {
                        error("❌ Code check failed. Please fix lint/static analysis errors and retry.")
                    } else {
                        echo '✅ Code check passed.'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building project...'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Running tests...'
            }
        }
    }

    post {
        failure { echo '🚨 Pipeline failed.' }
        success { echo '🎉 Pipeline succeeded.' }
    }
}
