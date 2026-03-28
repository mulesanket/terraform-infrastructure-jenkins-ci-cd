pipeline {
    agent any

    tools {
        terraform "terraform-1.6.0"
    }

    stages {

        stage("Set Environment") {
            steps {
                script {
                    def TF_DIR
                    if (env.BRANCH_NAME == "dev") {
                        TF_DIR = "environments/dev"
                    } else if (env.BRANCH_NAME == "main") {
                        TF_DIR = "environments/prod"
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    env.TF_DIR = TF_DIR
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Terraform Directory: ${env.TF_DIR}"
                }
            }
        }

        stage("Validate Environment") {
            steps {
                script {
                    if (!fileExists(env.TF_DIR)) {
                        error "Terraform directory does not exist: ${env.TF_DIR}"
                    }
                    else {
                        echo "Terraform directory exists: ${env.TF_DIR}"
                    }
                }
            }
        }

        stage ("Terraform Init") {
            steps {
                dir("${env.TF_DIR}") {
                    sh "terraform init"
                }
            }
        }

        stage("Deploy Dev") {
            when { branch "dev" }
            steps {
                dir("${env.TF_DIR}") {
                    sh "echo Running Terraform for DEV"
                }
            }
        }

        stage("Deploy Prod") {
            when { branch "main" }
            steps {
                input message: "Approve deployment to PRODUCTION?", ok: "Deploy"

                dir("${env.TF_DIR}") {
                    sh "echo Running Terraform for PROD"
                }
            }
        }
    }
}