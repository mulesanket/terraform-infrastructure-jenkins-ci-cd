pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
    }

    tools {
        terraform "terraform-1.6.0"
    }

    stages {

        stage("Set Environment") {
            steps {
                script {
                    def TERRAFORM_DIRECTORY

                    if (env.BRANCH_NAME == "dev") {
                        TERRAFORM_DIRECTORY = "environments/dev"
                    } else if (env.BRANCH_NAME == "main") {
                        TERRAFORM_DIRECTORY = "environments/prod"
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    env.TERRAFORM_DIRECTORY = TERRAFORM_DIRECTORY
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Terraform Directory: ${env.TERRAFORM_DIRECTORY}"
                }
            }
        }

        stage("Validate Environment") {
            steps {
                script {
                    if (!fileExists(env.TERRAFORM_DIRECTORY)) {
                        error "Terraform directory does not exist: ${env.TERRAFORM_DIRECTORY}"
                    }
                    else {
                        echo "Terraform directory exists: ${env.TERRAFORM_DIRECTORY}"
                    }
                }
            }
        }

        stage ("Terraform Init") {
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform init"
                }
            }
        }

        stage("Deploy Dev") {
            when { branch "dev" }
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "echo Running Terraform for DEV"
                }
            }
        }

        stage("Deploy Prod") {
            when { branch "main" }
            steps {
                input message: "Approve deployment to PRODUCTION?", ok: "Deploy"

                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "echo Running Terraform for PROD"
                }
            }
        }
    }
}