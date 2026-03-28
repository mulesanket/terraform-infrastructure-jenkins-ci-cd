pipeline {
    agent any

    environment {
        TERRAFORM_DIRECTORY = "environments/${BRANCH_NAME}"
    }

    stages {

        stage("Pipeline Start") {
            steps {
                echo "Starting the pipeline..."
            }
        }

        stage("Set Environment") {
            steps {
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Terraform Directory: ${env.TERRAFORM_DIRECTORY}"
                }
            }

        stage("Validate Environment") {
            steps {
                script {
                    if (!fileExists("${env.TERRAFORM_DIRECTORY}")) {
                        error "Terraform directory does not exist: ${env.TERRAFORM_DIRECTORY}"
                    }
                }
            }
        }

        stage("Deploy Dev") {
            when {
                branch "dev"
            }
            steps {
                echo "Deploying to DEV environment"

                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "echo Running Terraform for DEV"
                }
            }
        }

        stage("Deploy Prod") {
            when {
                branch "main"
            }
            steps {
                echo "Deploying to PRODUCTION environment"

                input message: "Approve deployment to PRODUCTION?", ok: "Deploy"

                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "echo Running Terraform for PROD"
                }
            }
        }

    post {
        success {
            echo "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed"
            }
       }
    }
}