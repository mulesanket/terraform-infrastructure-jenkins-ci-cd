pipeline {
    agent any

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
                    echo "Terraform Directory: ${TF_DIR}"
                }
            }
        }

        stage("Validate Environment") {
            steps {
                script {
                    if (!fileExists(TF_DIR)) {
                        error "Terraform directory does not exist: ${TF_DIR}"
                    }
                    else {
                        echo "Terraform directory exists: ${TF_DIR}"
                    }
                }
            }
        }

        stage("Deploy Dev") {
            when { branch "dev" }
            steps {
                dir("${TF_DIR}") {
                    sh "echo Running Terraform for DEV"
                }
            }
        }

        stage("Deploy Prod") {
            when { branch "main" }
            steps {
                input message: "Approve deployment to PRODUCTION?", ok: "Deploy"

                dir("${TF_DIR}") {
                    sh "echo Running Terraform for PROD"
                }
            }
        }
    }
}