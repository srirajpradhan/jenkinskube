pipeline {
 agent none
 stages {
  stage('DEV') {
    agent {dockerfile true} 
    steps {
      echo 'Deploying in DEV Environment'
      input('Do you want to Continue the pipeline to QA ?')
   }
  }

  stage('QA') {
    agent {dockerfile true}   
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
