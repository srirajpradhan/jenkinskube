pipeline {
 agent none
 stages {
  stage('DEV') {
    agent {
            docker { 
                  image 'kv1995/kubejenkins:v1'
                 }
          }
    steps {
      echo 'Deploying in DEV Environment'
      input('Do you want to Continue the pipeline to QA ?')
   }
  }

  stage('QA') {
    agent {
            docker { 
                  image 'kv1995/kubejenkins:v1' 
                 }
          } 
    steps { 
      echo 'Deploying in QA' 
   }
  }

  stage('Remove Dangling Docker Images') {
    steps {
      sh 'docker images -q -f dangling=true && docker rmi $(docker images -q -f dangling=true) || echo "Nope"'
    }
  }
 }
}
