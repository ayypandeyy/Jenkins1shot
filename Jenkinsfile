pipeline{
    agent{
        label 'Worker-1'
    }
    stages{
        stage("pwd"){
            steps{
                sh 'pwd'
            }
        }
        stage("ls"){
            steps{
                sh 'ls'
            }
        }
        stage("Make directory"){
            steps{
                sh 'mkdir -p TestDir'
            }
        }
        stage("Create file in that directory and write content in it"){
            steps{
                sh 'touch TestDir/test.txt'
                sh 'echo "FromJenkins Master node using git poll by making change on git" > TestDir/test.txt'
            }
        }
    }
}
