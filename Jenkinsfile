pipeline {
    agent any

    environment {
        GOOGLE_CREDENTIALS = credentials('TERRAFORM-AUTHE')
    }

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    def tfHome = tool name: 'Terraform'
                    env.PATH = "${tfHome}:${env.PATH}"
                }
                sh 'echo "$GOOGLE_CREDENTIALS" > terraform.json'
                sh 'terraform --version'
            }
        }

        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -var="project_id=gcp-dev-space"'
            }
        }

        stage('Terraform Action') {
            steps {
                sh 'terraform ${ACTION} --auto-approve -var="project_id=gcp-dev-space"'
            }
        }
    }

    post {
        always {
            sh 'rm -f terraform.json'
        }
    }
}
