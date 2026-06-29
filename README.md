# Minimal Python Docker Jenkins Project

A **very simple** project to learn how Docker, Jenkins, and AWS work together.

## 📁 Project Structure

```
python-docker-jenkins-basic/
├── app.py                 # Simple Flask app (Hello World)
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker configuration
├── docker-compose.yml    # Local testing setup
├── Jenkinsfile          # CI/CD pipeline
├── deploy-ec2.sh        # AWS deployment script
└── README.md
```

## 🔍 What Each File Does

### 1. **app.py** - The Application
- Simple Flask web app
- 2 endpoints: `/` (hello) and `/health` (health check)
- Runs on port 5000

### 2. **requirements.txt** - Dependencies
- Lists Python packages needed
- `Flask` - web framework
- `Werkzeug` - Flask dependency

### 3. **Dockerfile** - Docker Configuration
- Uses `python:3.9-slim` as base image
- Installs requirements
- Copies app.py
- Exposes port 5000
- Runs the app

### 4. **docker-compose.yml** - Local Development
- Makes it easy to run the app locally
- Maps port 5000 to your machine

### 5. **Jenkinsfile** - CI/CD Pipeline
- Stages:
  1. **Checkout** - Get code from GitHub
  2. **Build** - Create Docker image
  3. **Run** - Test the container
  4. **Stop** - Clean up
  5. **Cleanup** - Remove images

### 6. **deploy-ec2.sh** - AWS Deployment Script
- Connects to EC2 instance
- Installs Docker
- Clones repo
- Runs the app

---

## 🚀 Quick Start

### Step 1: Local Testing (No Docker)
```bash
# Install Python 3.9+
python --version

# Install dependencies
pip install -r requirements.txt

# Run app
python app.py

# Open browser: http://localhost:5000
```

### Step 2: Local Testing (With Docker)
```bash
# Build image
docker build -t python-app .

# Run container
docker run -p 5000:5000 python-app

# Test
curl http://localhost:5000/health
```

### Step 3: Docker Compose (Easiest)
```bash
# Start
docker-compose up -d

# Check logs
docker-compose logs -f

# Stop
docker-compose down
```

---

## 🔨 Jenkins Setup

### Prerequisites
- Jenkins installed on EC2 instance
- Docker installed on Jenkins machine
- GitHub account with repo access

### Setup Steps

#### 1. Install Jenkins on EC2
```bash
ssh -i your-key.pem ec2-user@your-ec2-ip

sudo yum update -y
sudo yum install -y java-11-openjdk git docker
sudo systemctl start docker
sudo usermod -aG docker jenkins

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

#### 2. Access Jenkins
- Open: `http://your-ec2-ip:8080`
- Get initial password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Complete setup wizard

#### 3. Create New Pipeline Job
1. Click **New Item**
2. Enter name: `python-docker-app`
3. Select **Pipeline**
4. Click **OK**
5. Under **Pipeline** section:
   - Select **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/savlaj79/python-docker-jenkins-basic.git`
   - Script Path: `Jenkinsfile`
6. Click **Save**
7. Click **Build Now**

#### 4. View Pipeline
- Watch the build in progress
- View logs for each stage
- See success/failure status

---

## ☁️ AWS EC2 Deployment

### Prerequisites
- AWS Account
- EC2 instance running (Amazon Linux 2)
- Security group allowing ports: 22, 80, 5000, 8080

### Option 1: Manual Deployment
```bash
# Edit the script with your details
vim deploy-ec2.sh

# Make executable
chmod +x deploy-ec2.sh

# Run
./deploy-ec2.sh
```

### Option 2: Manual SSH Deploy
```bash
# SSH into EC2
ssh -i your-key.pem ec2-user@your-ec2-ip

# Install Docker
sudo yum update -y
sudo yum install -y docker git
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Clone repo
cd /home/ec2-user
git clone https://github.com/savlaj79/python-docker-jenkins-basic.git
cd python-docker-jenkins-basic

# Build and run
docker build -t python-app .
docker run -d -p 80:5000 python-app

# Check status
curl http://localhost/health
```

### Option 3: Using Docker Compose on EC2
```bash
# SSH into EC2
ssh -i your-key.pem ec2-user@your-ec2-ip

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone and run
cd /home/ec2-user
git clone https://github.com/savlaj79/python-docker-jenkins-basic.git
cd python-docker-jenkins-basic
docker-compose up -d

# Access app
curl http://localhost:5000
```

---

## 📊 Understanding the Pipeline

### What Happens When You Click "Build Now" in Jenkins:

```
1. CHECKOUT
   └─ Jenkins clones your GitHub repo
   └─ Gets all files (app.py, Dockerfile, etc.)

2. BUILD
   └─ Reads Dockerfile
   └─ Builds Docker image
   └─ Tags it with build number

3. RUN
   └─ Starts container from image
   └─ Maps port 5000
   └─ Waits 5 seconds
   └─ Runs health check

4. STOP
   └─ Stops the test container
   └─ Removes it

5. CLEANUP
   └─ Removes old Docker images
   └─ Frees up space
```

---

## 🧪 Testing

### Test the app locally
```bash
# Via Python
python app.py
curl http://localhost:5000

# Via Docker
docker run -p 5000:5000 python-app:latest
curl http://localhost:5000

# Via Docker Compose
docker-compose up
curl http://localhost:5000
```

### Expected Response
```json
{
  "message": "Hello from Python Docker!",
  "status": "success"
}
```

### Health Check
```bash
curl http://localhost:5000/health

# Response
{"status": "healthy"}
```

---

## 🔧 Troubleshooting

### Port already in use
```bash
lsof -i :5000
kill -9 <PID>
```

### Docker build fails
```bash
# Clear Docker cache
docker builder prune

# Build without cache
docker build -t python-app --no-cache .
```

### Jenkins can't run Docker
```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Restart Jenkins
sudo systemctl restart jenkins
```

### Can't connect to EC2
```bash
# Check security group (allow port 22, 80, 5000, 8080)
# Check key permissions
chmod 400 your-key.pem

# Test SSH
ssh -i your-key.pem ec2-user@your-ec2-ip
```

---

## 📚 Learning Flow

1. **Week 1**: Understand Python + Flask
   - Run `python app.py`
   - Test endpoints with curl

2. **Week 2**: Learn Docker
   - Build image: `docker build -t python-app .`
   - Run container: `docker run -p 5000:5000 python-app`
   - Understand Dockerfile

3. **Week 3**: Setup Jenkins
   - Install Jenkins on EC2
   - Create first pipeline
   - See automatic builds

4. **Week 4**: Deploy to AWS
   - Run app on EC2
   - Access from internet
   - Scale up

---

## 📖 Resources

- [Flask Docs](https://flask.palletsprojects.com/)
- [Docker Docs](https://docs.docker.com/)
- [Jenkins Docs](https://www.jenkins.io/doc/)
- [AWS EC2 Docs](https://docs.aws.amazon.com/ec2/)

---

## ❓ Questions?

If anything is unclear, break it down:
1. Test Python app first
2. Then test with Docker
3. Then test with Jenkins
4. Finally deploy to AWS

Go step by step! 🚀
