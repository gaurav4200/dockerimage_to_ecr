pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-docker-image .'
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region YOUR_REGION | docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com
                    docker tag my-docker-image:latest YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/my-docker-image:latest
                    docker push YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/my-docker-image:latest
                    '''
                }
            }
        }
        stage('Apply Terraform') {
            steps {
                script {
                    sh '''
                    cd terraform
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}