node {
  stage('DEV') { 
        sh 'docker login --username kv1995 --password Karanverma9515@'
	sh ("docker build -t kv1995/testapp:latest .")
        sh ("docker push kv1995/testapp:latest")
        sh 'kubectl delete deployments testapp || true'
        sh 'kubectl create -f deployment.yaml'
        sh 'kubectl expose deployment testapp --type=LoadBalancer'
        input('Do you want to Continue the pipeline to QA ?')
   }
  }
