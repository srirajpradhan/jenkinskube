node {
  stage('DEV') {
        sh ("docker login --username kv1995 --password ${DOCKER_HUB}") 
	sh ("docker build -t kv1995/testapp:0.1 ./jenkinskube/")
        sh ("docker push kv1995/testapp:0.1")
        sh 'kubectl create deployment test --image=kv1995/testapp:0.1 --validate=false'
        sh 'kubectl expose deployment testapp --type=LoadBalancer'
        input('Do you want to Continue the pipeline to QA ?')
   }
  }
