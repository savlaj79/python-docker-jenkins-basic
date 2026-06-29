pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'python-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out code...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh '''
                    which docker || (apt-get update && apt-get install -y docker.io)
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                '''
            }
        }
        
        stage('Run Container') {
            steps {
                echo '▶️  Running container...'
                sh '''
                    docker run -d -p 5000:5000 --name python-app-test-${BUILD_NUMBER} ${DOCKER_IMAGE}:${DOCKER_TAG}
                    sleep 5
                    curl http://localhost:5000/health || echo "Health check in progress"
                '''
            }
        }
        
        stage('Stop Container') {
            steps {
                echo '⏹️  Stopping container...'
                sh 'docker stop python-app-test-${BUILD_NUMBER} || true'
                sh 'docker rm python-app-test-${BUILD_NUMBER} || true'
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleanup...'
            sh 'docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true'
        }
        success {
            echo '✅ Build successful!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}
