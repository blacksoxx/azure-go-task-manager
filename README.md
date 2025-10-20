# Cloud-Native Go Task Manager

A production-ready, cloud-native task management system built with Go microservices architecture, deployed on Kubernetes with GitOps principles using ArgoCD and Kustomize.

## Architecture Overview

This project implements a microservices-based task management system with the following components:

### Core Services

- **API Gateway**: Entry point for all client requests, handles routing and request forwarding
- **Auth Service**: Manages user authentication and JWT token generation/validation
- **User Service**: Handles user profile management and user-related operations
- **Task Service**: Core task management functionality (CRUD operations)
- **Notification Service**: Manages notifications and alerts for users

### Infrastructure Components

- **PostgreSQL**: Primary database for persistent data storage
- **ELK Stack**: Centralized logging with Elasticsearch, Logstash (Filebeat), and Kibana
- **ArgoCD**: GitOps continuous delivery tool for Kubernetes
- **Ingress Controller**: Manages external access to services

## Technology Stack

- **Backend**: Go (Golang)
- **Database**: PostgreSQL
- **Container Orchestration**: Kubernetes
- **Container Runtime**: Docker
- **Infrastructure as Code**: Terraform
- **Cloud Provider**: Azure (AKS, ACR, PostgreSQL)
- **GitOps**: ArgoCD
- **Logging**: ELK Stack (Elasticsearch, Filebeat, Kibana)
- **Configuration Management**: Kustomize

## Project Structure

```
.
├── api-gateway/              # API Gateway service
├── auth-service/             # Authentication service
├── user-service/             # User management service
├── task-service/             # Task management service
├── notification-service/     # Notification service
├── k8s/                      # Kubernetes manifests
│   ├── argocd/              # ArgoCD applications
│   ├── base/                # Base Kustomize configurations
│   └── overlays/            # Environment-specific overlays
│       ├── staging/
│       └── production/
├── terraform/               # Infrastructure as Code
│   ├── modules/            # Terraform modules (ACR, AKS, PostgreSQL)
├── classic/                # Classic Kubernetes manifests
└── scripts/               # Deployment utility scripts
```

## Prerequisites

- Go 1.25.1
- Docker 
- Kubernetes cluster (local or cloud)
- kubectl
- Terraform (for infrastructure provisioning)
- Azure CLI (if deploying to Azure)
- ArgoCD CLI (optional)

## Getting Started

### Local Development with Docker Compose

1. Clone the repository:
```bash
git clone <repository-url>
cd Cloud-Native-Go-Task-Manager
```

2. Start services with Docker Compose:
```bash
docker-compose up -d
```

3. Access the services:
- API Gateway: http://localhost:8080
- Individual services run on their configured ports

### Kubernetes Deployment

#### Using Classic Manifests

Deploy to Kubernetes using traditional manifests:

```bash
# Apply configurations
kubectl apply -f classic/k8s/config/

# Deploy services
kubectl apply -f classic/k8s/manifests/
```

#### Using Kustomize (Recommended)

Deploy using Kustomize for environment-specific configurations:

```bash
# Staging environment
kubectl apply -k k8s/overlays/staging

# Production environment
kubectl apply -k k8s/overlays/production
```

#### Using ArgoCD (GitOps)

1. Install ArgoCD in your cluster:
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

2. Deploy the root application:
```bash
kubectl apply -f k8s/argocd/applications/root-application.yaml
```

ArgoCD will automatically deploy and sync all applications defined in the `k8s/argocd/applications/` directory.

### Infrastructure Provisioning with Terraform

Provision Azure infrastructure (AKS cluster, ACR, PostgreSQL):

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply infrastructure
terraform apply
```

## Configuration

### Environment Variables

Each service uses environment variables for configuration. Key variables include:

- `DATABASE_URL`: PostgreSQL connection string
- `JWT_SECRET`: Secret key for JWT token generation
- `PORT`: Service port number
- `AUTH_SERVICE_URL`: URL for authentication service
- `TASK_SERVICE_URL`: URL for task service
- `USER_SERVICE_URL`: URL for user service

### Secrets Management

Sensitive data is stored in Kubernetes secrets:
- `postgresql-secret`: Database credentials
- `auth-secret`: JWT signing keys

Update secrets in:
- Base: `k8s/base/shared-configs/`
- Overlays: `k8s/overlays/{staging|production}/shared-configs/`

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login user
- `POST /auth/refresh` - Refresh JWT token

### Users
- `GET /users/:id` - Get user profile
- `PUT /users/:id` - Update user profile
- `DELETE /users/:id` - Delete user

### Tasks
- `GET /tasks` - List all tasks
- `POST /tasks` - Create new task
- `GET /tasks/:id` - Get task details
- `PUT /tasks/:id` - Update task
- `DELETE /tasks/:id` - Delete task

### Notifications
- `GET /notifications` - List notifications
- `POST /notifications` - Create notification
- `PUT /notifications/:id/read` - Mark as read

## Monitoring and Logging

### ELK Stack

The project includes a complete ELK stack for centralized logging:

- **Elasticsearch**: Log storage and indexing
- **Filebeat**: Log collection from pods
- **Kibana**: Log visualization and analysis

Access Kibana dashboard:
```bash
kubectl port-forward -n logging svc/kibana 5601:5601
```

Then visit: http://localhost:5601

## Development

### Building Services

Build individual services:

```bash
# Example: Build auth service
cd auth-service
go build -o bin/auth-service cmd/main.go
```

### Building Docker Images

```bash
# Build all images
docker-compose build

# Build specific service
docker build -t task-manager/auth-service:latest ./auth-service
```


## Deployment Scripts

Utility scripts are provided in the `scripts/` directory:

- `scripts/deploy/deploy-k8s.sh`: Deploy to Kubernetes (Classic way, not recommended)
- `scripts/deploy/image-push.sh`: Build and push images to ACR registry



