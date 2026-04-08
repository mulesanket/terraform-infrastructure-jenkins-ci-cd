pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
        skipStagesAfterUnstable()
        timeout(time: 1, unit: 'HOURS')
    }

    tools {
        terraform "terraform-1.6.0"
    }

    environment {
        TF_IN_AUTOMATION = "true"
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }

        stage ("Checkout Infrastructure Code") {
            steps {
                checkout scm
            }
        }

        stage("Set Environment") {
            steps {
                script {
                    def TERRAFORM_DIRECTORY

                    if (env.BRANCH_NAME == "dev") {
                        TERRAFORM_DIRECTORY = "environments/development"
                    } else if (env.BRANCH_NAME == "main") {
                        TERRAFORM_DIRECTORY = "environments/production"
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    env.TERRAFORM_DIRECTORY = TERRAFORM_DIRECTORY
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Terraform Dir: ${env.TERRAFORM_DIRECTORY}"
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
                    retry(2) {
                        sh "terraform init"
                    }
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

        stage("Archive Plan") {
            steps {
                archiveArtifacts artifacts: "${env.TERRAFORM_DIRECTORY}/tfplan", fingerprint: true
            }
        }

        stage("Approval for Dev") {
            when { branch "dev" }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: "Approve deployment to DEV?", ok: "Proceed"
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

        stage("Approval for Prod") {
            when { branch "main" }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: "Approve deployment to PROD?", ok: "Proceed"
                }
            }
        }

        stage("Deploy Prod") {
            when { branch "main" }
            steps {
                dir("${env.TERRAFORM_DIRECTORY}") {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed"
        }
        success {
            echo "Terraform Deployment successful"
        }
        failure {
            echo "Terraform Deployment failed"
        }
    }
}