pipeline {
  agent { label 'terraform' }

  environment {
    AWS_REGION = "ap-northeast-1"
    CREDENTIALS_ID = "7053b360-e011-4c9b-b4ed-21c041da2d4d"
  }

  stages {
    stage("Build") {
        steps {
          withAWS(credentials: "${CREDENTIALS_ID}", region: "${AWS_REGION}") {
            sh "cd ./app"
            sh "pip3 install -r ./requirements.txt -t ."
            sh "zip -q -r ./code.zip ."
            sh "aws s3 cp ./code.zip s3://eddie-terraform/schedule-start-stop-resource-by-tag/lambda/code.zip"
          }
        }
    }
    stage("Terraform Init") {
      steps {
        script {
          terraformInit = sh(returnStdout: true, script: "terraform init")
          println("Terraform Init Output: ${terraformInit}")
        }
      }
    }
    stage("Terraform Plan") {
      steps {
        script {
          withAWS(credentials: "${CREDENTIALS_ID}", region: "${AWS_REGION}") {
            terraformPlan = sh(returnStdout: true, script: "terraform plan")
            println("Terraform Plan Output: ${terraformPlan}")
          }
        }
      }
    }
    stage("Terraform Apply") {
      steps {
        withAWS(credentials: "${CREDENTIALS_ID}", region: "${AWS_REGION}") {
          script {
            terraformApply = sh(returnStdout: true, script: "terraform apply -auto-approve")
            println("Terraform Apply Output: ${terraformApply}")
          }
        }
      }
    }
  }
}
