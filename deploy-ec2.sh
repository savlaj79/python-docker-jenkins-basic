#!/bin/bash

# Variables
EC2_USER="ec2-user"
EC2_HOST="your-ec2-public-ip"
KEY_PAIR="/path/to/your/key.pem"
REPO_URL="https://github.com/savlaj79/python-docker-jenkins-basic.git"
APP_DIR="/home/ec2-user/python-docker-jenkins-basic"

echo "🚀 Deploying to AWS EC2..."

# SSH and deploy
ssh -i $KEY_PAIR $EC2_USER@$EC2_HOST << 'ENDSSH'
    echo "📦 Installing Docker..."
    sudo yum update -y
    sudo yum install -y docker git
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user
    
    echo "📥 Cloning repository..."
    cd /home/ec2-user
    git clone $REPO_URL
    cd $APP_DIR
    
    echo "🐳 Building Docker image..."
    docker build -t python-app:latest .
    
    echo "▶️  Running container..."
    docker run -d -p 80:5000 --name python-app --restart unless-stopped python-app:latest
    
    echo "✅ Deployment complete!"
    echo "🌐 Access at: http://$EC2_HOST"
ENDSSH
