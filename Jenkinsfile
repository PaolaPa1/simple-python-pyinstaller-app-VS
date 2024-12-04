pipeline {
    agent {
        docker {
            image 'python:3.9'  // L'immagine che desideri usare per l'agente
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Monta il socket Docker del sistema host
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py' 
                stash(name: 'compiled-results', includes: 'sources/*.py*') 
            }
        }
    }
}
