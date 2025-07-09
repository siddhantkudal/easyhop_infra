pipeline{
    agent any;
    environment {
        TF_VERSION = "1.12.1"
        AWS_REGION = "ap-south-1"
        ENV = "dev" // Can be parameterized
    }
    stages{
        // stage("Clean workspace"){
        //     steps{
        //       cleanWs();
               
        //     }
        // }
        stage("Checkout CSM"){
            steps{
                git url:"https://github.com/siddhantkudal/easyhop_infra.git", branch: "master"
            }
        }
        // stage('Setup Terraform') {
        //     steps {
        //         sh '''
        //               curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
        //               unzip terraform.zip
        //               sudo mv terraform /usr/local/bin/
        //               terraform version
        //         '''
        //      }
        // }
        
        stage('Init') {
            steps {
                    withCredentials([
                         string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                         ]){
                
                     sh ' terraform init'
                }
            }
        }
        stage('Validate') {
            steps {
                    withCredentials([
                         string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                         ]){
                
                     sh 'terraform validate'
                    }
            }
        }
        stage('Plan'){
            steps{
                     withCredentials([
                         string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                         ]){
                             
                             sh 'AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY terraform plan'
                         }
                }

        }
        stage("Apply "){
            steps{
                script {
                def manualApprove=input(
                    message: "Terraform code will deploy to ${ENV} environment",
                    parameters: [
                        choice(name: 'Approval Stage', choices:['Yes','No'], description: "Select Yes if you want to deploy the application on ${ENV}:")
                        ]
                    )
                    if (manualApprove == 'Yes'){
                        withCredentials([
                         string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                         ]){
                                sh '''
                                AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY terraform apply -auto-approve
                                '''
                         }
                    }
                }
            }
        }
        
        
    }
    post{
            success {
                echo 'Clone successfully'
            }
            failure {
                echo 'clone failed'
            }
        }
    
    
    
}