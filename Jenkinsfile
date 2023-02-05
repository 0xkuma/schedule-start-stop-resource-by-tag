pipeline {
  agent { label 'terraform-agent' }

  environment {
    AWS_REGION = "ap-northeast-1"
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

    stage("Terraform Plan") {
      steps {
        script {
          terraformPlan = sh(returnStdout: true, script: "terraform plan")
          println("Terraform Plan Output: ${terraformPlan}")
        }
      }
    }

    stage("Terraform Apply") {
      steps {
        withAWS(credentials: 'my-aws-credentials', region: "${AWS_REGION}") {
          script {
            terraformApply = sh(returnStdout: true, script: "terraform apply -auto-approve")
            println("Terraform Apply Output: ${terraformApply}")
          }
        }
      }
    }
  }
}
