pipeline {
  agent { label 'terraform' }

  environment {
    AWS_REGION = "ap-northeast-1"
    CREDENTIALS_ID = "7053b360-e011-4c9b-b4ed-21c041da2d4d"
  }

  stages {
    stage("Terraform Init") {
      steps {
        script {
          terraformInit = sh(returnStdout: true, script: "terraform init")
          println("Terraform Init Output: ${terraformInit}")
        }
      }
    }

    stage("List Terraform Files") {
      steps {
        script {
          terraformFiles = sh(returnStdout: true, script: "ls -al")
          println("Terraform Files: ${terraformFiles}")
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
