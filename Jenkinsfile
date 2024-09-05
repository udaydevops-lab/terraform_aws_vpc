// pipeline {
//     agent any

//     parameters {
//         choice(name: 'BRANCH_TO_BUILD', choices: ['release_audit_05jun2024', 'release-qa', 'development'], description: 'Select Git branch')
//         choice(choices: ['dev', 'qa', 'prod'], description: 'Choose the environment for deployment', name: 'ENVIRONMENT')
//     }

//     environment {
//         GIT_CREDENTIALS_ID = 'GitHub_User'
//         GIT_URL = "https://github.com/SatraHIS/satra-his-staff-ts-next.git"

//         // QA Env Variables
//         SSH_USER = 'satra'
//         SSH_HOST = '192.168.1.14'
//         NEXTJS_PATH = "/home/satra/his_next/satra-his-staff-ts-next"
//         SCRIPT_PATH = "/home/satra/shellscripts"
//     }

//     stages {
//         stage('Clean Workspace') {
//             steps {
//                 deleteDir()
//             }
//         }

//         stage('Checkout Code') {
//             steps {
//                 script {
//                     def selectedBranch = params.BRANCH_TO_BUILD
                    
//                     // Checkout the code from Git into the workspace directory
//                     checkout([$class: 'GitSCM',
//                         branches: [[name: selectedBranch]],
//                         doGenerateSubmoduleConfigurations: false,
//                         extensions: [[$class: 'CleanBeforeCheckout']],
//                         userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS_ID,
//                             url: env.GIT_URL]]])
//                 }
//             }
//         }

//         stage('Deploy') {
//             when {
//                 expression { params.ENVIRONMENT == 'qa' || params.ENVIRONMENT == 'dev' }
//             }
//             steps {
//                 script {
//                     if (params.ENVIRONMENT == 'qa') {
//                         // SSH into the server and copy the code
//                         sshagent(credentials: ['SSH_14']) {
//                             def scpCommand = "scp -o StrictHostKeyChecking=no -r ./* ${SSH_USER}@${SSH_HOST}:${NEXTJS_PATH}"
//                             def scpStatus = sh(script: scpCommand, returnStatus: true)
                        
//                             if (scpStatus != 0) {
//                                 error("Failed to copy code to the remote server.")
//                             }
//                         }
//                     } else if (params.ENVIRONMENT == 'dev') {
//                         sshagent(['Windows_SSH_Credentials_160']) {
//                             sh "ls -l && pwd"
//                             sh "scp -r ./* ${WINDOWS_USER}@${WINDOWS_IP}:${DEV_NEXTJS_PATH}"
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Run Application') {
//             when {
//                 expression { params.ENVIRONMENT == 'qa' || params.ENVIRONMENT == 'dev' }
//             }
//             steps {
//                 script {
//                     if (params.ENVIRONMENT == 'qa') {
//                         // SSH into the server and run the build command
//                         sshagent(credentials: ['SSH_14']) {
//                             def buildCommand = "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} ${SCRIPT_PATH}/jenkins_qa_deploy.sh"
//                             def buildStatus = sh(script: buildCommand, returnStatus: true)
                        
//                             // // Capture the content of nohup.out
//                             // def nohupContent = sh(script: "ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} 'cat /home/satra/his_next/satra-his-staff-ts-next/nohup.out'", returnStdout: true).trim()
        
//                             // if (buildStatus == 0) {
//                             //     echo "Script executed successfully"
//                             //     echo "Output:"
//                             //     echo nohupContent
//                             // } else {
//                             //     currentBuild.result = 'FAILURE'
//                             //     error("Script execution failed with exit status ${buildStatus}. Output:\n${nohupContent}")
//                             // }
//                         }
//                             } else if (params.ENVIRONMENT == 'dev') {
//                                     sshagent(['Windows_SSH_Credentials_160']) {
//                                         def sshCommand = "ssh ${WINDOWS_USER}@${WINDOWS_IP} 'powershell.exe -ExecutionPolicy Bypass -File ${DEV_NEXTJS_PATH}/nextjs_start.ps1'"
//                                         def sshStatus = sh(script: sshCommand, returnStatus: true)
                                        
//                                         if (sshStatus == 0) {
//                                             echo "Script executed successfully"
//                                         } else {
//                                             currentBuild.result = 'FAILURE'  // Mark the build as a failure
//                                             error("Script execution failed with exit status ${sshStatus}")
//                                         }
                
//                                 }
//                             }
//                 }
//             }
//         }
//     }
// }






