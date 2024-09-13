pipeline {

    agent { label 'pwcslave1' }

	environment {	
		DOCKERHUB_CREDENTIALS=credentials('dockerloginid')
	}
	
    stages {
        stage('SCM_Checkout') {
            steps {
                echo 'Perform SCM Checkout'
				git 'https://github.com/Edu-TCS-DevOps-Aug21/java-mvn-springbootapp.git'
            }
        }
        stage('Application_Build') {
            steps {
                echo 'Perform Maven Build'
				sh 'mvn -Dmaven.test.failure.ignore=true clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
				sh 'docker version'
				sh "docker build -t loksaieta/loksai-eta-app:${BUILD_NUMBER} ."
				sh 'docker image list'
				sh "docker tag loksaieta/loksai-eta-app:${BUILD_NUMBER} loksaieta/loksai-eta-app:latest"
            }
        }

		stage('Login2DockerHub') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		stage('Publish_to_Docker_Registry') {
			steps {
				sh "docker push loksaieta/loksai-eta-app:latest"
			}
		}
		stage('Deploy to Kubernetes') {
            steps {
				script {
				sshPublisher(publishers: [sshPublisherDesc(configName: 'PoW-Kubernetes', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'kubectl apply -f k8sdeploy.yaml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '.', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '*.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
			}	
            }
		}
    }
}
