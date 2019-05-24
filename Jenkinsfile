pipeline {
  agent {
    label "cp2k-libint"
  }

  stages {
    stage('build') {
      steps {
        sh "./autogen.sh"
        dir("build") {
          sh """../configure \
            --enable-eri=1 --enable-eri2=1 --enable-eri3=1 \
            --with-max-am=5 \
            --with-eri-max-am=5,4 \
            --with-eri2-max-am=5,4 \
            --with-eri3-max-am=5,4 \
            --with-opt-am=3 \
            --enable-generic-code --disable-unrolling
            make export
            """
        }
      }
    }
  }
  post {
    success {
      script {
        tarball = findFiles(glob: '**/*.tgz')[0]
      }

      archiveArtifacts artifacts: tarball.path, fingerprint: true
      upload_tarball(tarball)
    }
  }
}

def upload_tarball(tarball) {
  def release_name = tarball.name.replace("libint", "libint_cp2k").replace(".tgz", "")

  withCredentials([usernamePassword(credentialsId: 'cp2k-libint_github', passwordVariable: 'GITHUB_TOKEN', usernameVariable: 'GITHUB_USER')]) {
    withEnv(["TARBALL=${tarball.path}", "RELEASE_NAME=${release_name}"]) {
      sh '''\
      response=$(\
        curl \
          -sS \
          -X POST \
          -H "Authorization:token ${GITHUB_TOKEN}" \
          --data "{\\"tag_name\\": \\"${TAG_NAME}\\", \\"target_commitish\\": \\"master\\", \\"name\\": \\"${RELEASE_NAME}\\", \\"body\\": \\"libint ${TAG_NAME} configured for use with CP2K\\", \\"draft\\": false, \\"prerelease\\": true}" \
          "https://api.github.com/repos/cp2k/libint-cp2k/releases")

      id=$(echo "${response}" | jq -r ".id")

      curl \
        -X POST \
        -H "Authorization:token ${GITHUB_TOKEN}" \
        -H "Content-Type:application/octet-stream" \
        --data-binary "@${TARBALL}" \
        "https://uploads.github.com/repos/cp2k/libint-cp2k/releases/${id}/assets?name=${RELEASE_NAME}.tgz"
      '''
    }
  }
}

// vim: set filetype=groovy ts=2 sw=2 tw=0 :
