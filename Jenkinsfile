pipeline {
    agent {
        docker {
            image 'docker:dind'
            args '--privileged --network=red_jenkins'
        }
    }
    environment {
        DOCKER_HOST = 'tcp://jenkins-docker:2376'
        DOCKER_CERT_PATH = '/certs/client'
        DOCKER_TLS_VERIFY = '1'
    }
    stages {
        stage('Build') {
            steps {
                sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*') 
                script {
                    echo 'Building application...'
                    sh 'docker version'
                    sh '''
                        docker build -t my-app:latest .
                        docker run --rm my-app:latest
                    '''
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline complete.'
        }
    }
}
