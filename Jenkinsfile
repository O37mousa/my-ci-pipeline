
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
            agent {
                docker { image 'node:20-alpine' } // use Node 20 LTS
            }
            steps {
                sh 'npm ci && npm run lint' // or npm install if you prefer
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
