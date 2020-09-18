pipeline {
    agent any
    stages {
        
        stage('Lint Dockerfile') {
            steps {
                script {
                    docker.image('hadolint/hadolint').inside() {
                            sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
                            sh '''
                                lintErrors=$(stat --printf=%s  hadolint_lint.txt)
                                if [ "$lintErrors" -gt "0" ]; then
                                    echo "Errors!!!"
                                    cat hadolint_lint.txt
                                    exit 1
                                else
                                    echo "No Errors!!!"
                                fi
                            '''
                    }
                }
            }
        }

        stage('Lint HTML') {
            steps {
                sh 'tidy -q -e html/*.html'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-capstone-app .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                    sh "docker tag devops-capstone-app ngkatzios/devops-capstone-app"
                    sh 'docker push ngkatzios/devops-capstone-app'
                }
            }
        }

        stage('Deployment') {
            steps {
                withAWS(credentials: 'aws-capstone', region: 'eu-west-2') {
                    sh "aws eks --region eu-west-2 update-kubeconfig --name capstone"
                    sh "kubectl config use-context ARN-CLUSTER-HERE"
                    sh "kubectl apply -f kubernetes.yml"
                    sh "kubectl get nodes"
                    sh "kubectl get deployments"
                    sh "kubectl get pod -o wide"
                    sh "kubectl get service/devops-capstone-app"
                }
            }
        }

        stage('Rollout Status') {
            steps {
                withAWS(credentials: 'aws-capstone', region: 'eu-west-2') {
                   sh "kubectl rollout status deployments/devops-capstone-app"
                }
            }
        }

        stage("Clean up") {
            steps{
                sh "docker system prune"
            }
        }
    }
}
