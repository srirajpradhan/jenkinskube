node {
  stage('DEV') {
        sh ("docker login --username kv1995 --password ${DOCKER_HUB}") 
	sh ("docker build -t kv1995/testapp:latest /home/ubuntu/jenkinskube/Dockerfile")
        sh ("docker push kv1995/testapp:latest")
        sh 'kubectl delete deployment testapp || true'
        sh 'kubectl run hellonode --image=kv1995/testapp:latest'
        sh 'kubectl expose deployment testapp --type=LoadBalancer'
        input('Do you want to Continue the pipeline to QA ?')
   }
  }
