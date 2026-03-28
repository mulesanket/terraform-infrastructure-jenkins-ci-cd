
pipeline {
    agent any

    environment {
        TERRAFORM_DIRECTORY = ""
    }
    
    stages {
        stage('Deploy Dev') {
    when { branch 'dev' }
    steps {
        dir('environments/dev') {
            sh 'terraform init'
        }
    }
}

        stage('Deploy Prod') {
    when { branch 'main' }
    steps {
        dir('environments/prod') {
            sh 'terraform init'
        }
    }
}
    }
}