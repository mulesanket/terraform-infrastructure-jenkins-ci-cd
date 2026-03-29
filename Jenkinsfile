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
                    echo "Using TF Dir: ${env.TERRAFORM_DIRECTORY}"
                }
            }
        }

        stage("Validate Environment") {
            steps {
                script {
                    if (!fileExists(env.TERRAFORM_DIRECTORY)) {
                        error "Terraform directory does not exist: ${env.TERRAFORM_DIRECTORY}"
                    }
                }
            }
        }

        stage("Terraform Init") {
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform init"
                }
            }
        }

        stage("Terraform Format Check") {
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform fmt -check -recursive"
                }
            }
        }

        stage("Terraform Validate") {
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform validate"
                }
            }
        }

        stage("Terraform Plan") {
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform plan -out=tfplan"
                    sh "terraform show tfplan"
                }
            }
        }

        stage("Deploy Dev") {
            when { branch "dev" }
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }
}