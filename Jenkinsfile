pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "srirajpradhan19/jenkinskube"
    }
    stages {
        stage('Install Kubernetes') {
         steps {
           script {
              env.flag = 'false'
              try {
                 input('Do You Want to Provision?')
                 sh 'sudo apt update &&\
                 sudo apt install -y apt-transport-https ca-certificates curl software-properties-common &&\
                 sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\
                 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&\
                 sudo apt update &&\
                 sudo apt install -y docker-ce=18.06.1~ce~3-0~ubuntu &&\
                 sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - &&\
                 echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
                 sudo apt-get update && \
                 sudo apt-get install -y kubelet kubeadm kubectl &&\
                 sudo sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf &&\
                 sudo systemctl daemon-reload && \
                 sudo systemctl restart kubelet && \
                 sudo swapoff -a &&\
                 sudo kubeadm init --pod-network-cidr=172.31.16.0/20 && \
                 sudo mkdir -p /home/ubuntu/.kube && \
                 sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config && \
                 sudo chown $(id -u):$(id -g) /home/ubuntu/.kube/config && \
                 sudo cp -R /home/ubuntu/.kube/ /var/lib/jenkins && \
                 sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/ &&\
                 sudo usermod -aG docker jenkins && \
                 sudo chown root:docker /var/run/docker.sock && \
                 sudo systemctl restart kubelet && \
                 sudo kubectl taint nodes --all node-role.kubernetes.io/master- && \
                 git clone https://github.com/kubernetes/kube-state-metrics.git && \
                 cd kube-state-metrics && \
                 sudo kubectl apply -f kubernetes && \
                 sudo kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml && \
                 sudo kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml && \
                 sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml && \
                 sudo kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard'
              }
              catch(err) {
                  echo 'Aborted Provision, Deploying App!!!!!!!'
              }
           }
         }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        input 'Deploy to Dev Environment?'
                        app = docker.build(DOCKER_IMAGE_NAME)
                        app.inside {
                            sh 'echo Hello, World!'
                        }
                        env.flag = 'true'
                    }
                    catch(err) {
                        env.flag = 'false'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    if(env.flag == 'true'){
                        docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                            app.push("${env.BUILD_NUMBER}")
                        }
                    }
                }
            }
        }
        stage('DeployToProduction') {
            steps {
                script {
                   if(env.flag == 'true'){   
                    milestone(1)
                    kubernetesDeploy(
                        credentialsType: 'KubeConfig',
                        kubeConfig: [path: '/var/lib/jenkins/.kube/config'],
                        configs: 'train-schedule-kube.yml',
                        enableConfigSubstitution: true
                    )
                   }
                }
            }
        }
        stage('Rollback') {
            steps {
                script {  
                    try {
                        input('Do you want to Rollback?')
                        sh 'kubectl rollout undo deployment test && kubectl rollout status deployment test'
                    }
                    catch(err) {
                        currentBuild.result = "SUCCESS"
                    }
                }
            }
        }
    }
}
