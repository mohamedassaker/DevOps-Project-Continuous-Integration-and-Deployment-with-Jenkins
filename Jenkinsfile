#!/usr/bin/env groovy

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        def IMAGE_TAG
        def IMAGE_NAME = 'm8122000/demo-app' // replace with your docker hub repo name
        def ec2_user = 'ec2-user' // replace with ec2-user
        def ec2_ipaddress = 'ec2-ip-address' // replace with ec2-ip-address            
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage('build app') {
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    
                    def shellCmd = "bash ./server-cmd.sh ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmd.sh docker-compose.yml ${env.ec2_user}@${env.ec2_ipaddress}:/home/${env.ec2_user}"
                        sh " ssh -o StrictHostKeyChecking=no ${env.ec2_user}@${env.ec2_ipaddress} ${shellCmd}" 
                    }
                }
            }
        }
        // Make sure to ignore commits of 'jenkins' user from triggering new build
        // To prevent the pipeline from looping
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // git config here for the first time run
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/mohamedassaker/DevOps-Project-Continuous-Integration-and-Deployment-with-Jenkins.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
