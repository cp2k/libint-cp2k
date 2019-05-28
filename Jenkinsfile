pipeline {
  agent {
    label "cp2k-libint"
  }

  stages {
    stage('prepare'){
      steps{
        sh "./autogen.sh"
      }
    }
    stage('build') {
      parallel {
        stage("lmax-4"){
          steps {
            script {
              configure_libint(4)
            }
          }
        }
        stage("lmax-5"){
          steps {
            script {
              configure_libint(5)
            }
          }
        }
        stage("lmax-6"){
          steps {
            script {
              configure_libint(6)
            }
          }
        }
        stage("lmax-7"){
          steps {
            script {
              configure_libint(7)
            }
          }
        }
      }
    }
  }
  post {
    success {
      script {
        tarballs = findFiles(glob: '**/*.tgz')
          upload_tarballs(tarballs)
      }
    }
  }
}

def configure_libint(lmax) {
  dir("lmax-${lmax}") {
    withEnv(["LMAX=${lmax}"]){
      sh '''../configure \
        --enable-eri=1 --enable-eri2=1 --enable-eri3=1 \
        --with-max-am=${LMAX} \
        --with-eri-max-am=${LMAX},$((LMAX-1)) \
        --with-eri2-max-am=$((LMAX+2)),$((LMAX+1)) \
        --with-eri3-max-am=$((LMAX+2)),$((LMAX+1)) \
        --with-opt-am=3 \
        --enable-generic-code --disable-unrolling \
        --with-libint-exportdir=libint-${TAG_NAME}-cp2k-lmax-${LMAX}
      make export
        '''
    }
  }
}

def upload_tarballs(tarballs) {
  def release_name = "libint_${TAG_NAME}_cp2k"

    withCredentials([usernamePassword(credentialsId: 'cp2k-libint_github', passwordVariable: 'GITHUB_TOKEN', usernameVariable: 'GITHUB_USER')]) {
      withEnv(["RELEASE_NAME=${release_name}"]) {
        def id = sh(script:
            '''curl \
            -sS \
            -X POST \
            -H "Authorization:token ${GITHUB_TOKEN}" \
            --data "{\\"tag_name\\": \\"${TAG_NAME}\\", \\"target_commitish\\": \\"master\\", \\"name\\": \\"${RELEASE_NAME}\\", \\"body\\": \\"libint ${TAG_NAME} configured for use with CP2K\\", \\"draft\\": false, \\"prerelease\\": true}" \
            "https://api.github.com/repos/cp2k/libint-cp2k/releases" \
            | jq -r .id \
            ''',
            returnStdout: true)

          for ( tb in tarballs ) {
            def tarball_name = tb.name.replace(".tgz", "")
              withEnv(["TARBALL=${tb.path}", "TARBALL_NAME=${tarball_name}", "ID=${id.trim()}"]) {
                sh '''
                  curl \
                  -X POST \
                  -H "Authorization:token ${GITHUB_TOKEN}" \
                  -H "Content-Type:application/octet-stream" \
                  --data-binary "@${TARBALL}" \
                  "https://uploads.github.com/repos/cp2k/libint-cp2k/releases/${ID}/assets?name=${TARBALL_NAME}.tgz"
                  '''
              }
          }
      }
    }
}

// vim: set filetype=groovy ts=2 sw=2 tw=0 :
