
pipeline {
    agent any

    environment {
        TERRAFORM_DIRECTORY = ""
    }
    
    stages {
        stage ("Pipeline Start") {
            steps {
                echo "Starting the pipeline..."
            }   
        }

        stage ("Setting Environment") {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        env.TERRAFORM_DIRECTORY = "environments/prod"
                    }
                    else if (env.BRANCH_NAME == "dev") {
                        env.TERRAFORM_DIRECTORY = "environments/dev"
                    }
                    else {
                        error "Branch name ${env.BRANCH_NAME} is not recognized."
                    }

                    echo "Branch name: ${env.BRANCH_NAME}"
                    echo "Terraform directory set to: ${env.Terraform_Directory}"
                }
            }
        }
    }
}