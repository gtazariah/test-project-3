pipeline {
	agent any

	environment {
		DOCKERHUB_USERNAME = 'azariahgt'
		APP_SERVER='172.31.22.242'
	}

	stages {
	
		stage('Checkout'){
			steps {
				checkout scm
			}		

		}

		stage('Show Branch'){
			steps {
				echo "Building Branch: ${BRANCH_NAME}"
				echo "Build Number: ${BUILD_NUMBER}"
			}
		}

		stage('Docker login'){
			steps {
				withCredentials([
					usernamePassword(
						credentialsId: 'dockerhub-credentials'.
					usernameVariable: 'DOCKER_USER',
					passwordVariable: 'DOCKER_TOKEN'	
					)
				]){
					sh '''
					echo "$DOCKER_TOKEN" | \
					docker login \
					-u $DOCKER_USER \
					--password-stdin 
					'''
				
				}
		
			}
		}
		stage('Build and Deploy DEV'){
			when {
				branch 'dev'
			}

			steps {
				sh '''
					chmod +x build.sh
					./build.sh dev ${BUILD_NUMBER}

				'''
	
				sh '''
					ssh -o BatchMode=yes ubuntu@$APP_SERVER \
					"/home/ubuntu/react-app/deploy.sh dev ${BUILD_NUMBER}"
				'''
			}
		}

		stage('Build and deploy PROD'){
			when {
				branch 'master'
			}

			steps {
				sh '''
					chmod +x build.sh
					./build.sh prod ${BUILD_NUMBER}								'''

				sh '''
					ssh -o BatchMode=yes ubuntu@$APP_SERVER \
					"/home/ubuntu/react-app/deploy.sh prod ${BUILD_NUMBER}"
					
				'''
			}
		}
		
	}

	post
	{
		success
		{
			echo "Pipeline Completed Successfully"
		}

		failure
		{
			echo "Pipeline failed"
		}

		always
		{
			sh 'docker logout || true'
		}
	}
}
