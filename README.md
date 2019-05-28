# libint-cp2k

Provides tarballs of CP2K-configured libint releases for different maximum angular momenta.

The available libint tarballs are released as `libint-<version>-cp2k-lmax-<lmax>`
with `<version>` the corresponding libint version and `<lmax>` the maximum supported angular momentum quantum number.

The specific configuration options of a libint tarball can be found in the `compiler.config` file.

For further information on how to build libint, refer to the [libint wiki](https://github.com/evaleev/libint/wiki#compiling-libint-library).
CP2K requires that libint is built with *Fortran bindings*.

If you need a different libint configuration for CP2K, please let us know by submitting an issue with the exact configuration option.

## Internal: Build Setup

The following instructions are about our internal setup to automatically generate the provided libint2 source tarballs.

Requirements:

* [Jenkins CI](https://jenkins.io/)
  * [Plugin: GitHub Pipeline for Blue Ocean](https://plugins.jenkins.io/blueocean-github-pipeline)
  * [Plugin: Docker](https://plugins.jenkins.io/docker-plugin)
  * [Plugin: Pipeline Utility Steps](https://plugins.jenkins.io/pipeline-utility-steps)
  * [Plugin: Multibranch Pipeline Inline Definition](https://plugins.jenkins.io/inline-pipeline)
* Docker host

Steps:

* On the Docker host: Setup a Docker image based on the provided `Dockerfile`
* In Jenkins:
  * Connect the Docker host and register the image as a Docker Template, labelling it `cp2k-libint`
  * Add credentials using a GitHub token for a service user capable of making releases
  * Create a new Multibranch Pipeline job, using as the inline `Jenkinsfile` the one provided in this repo (use `README.md` as the marker file)

Caveats:

* At the time of creating this workflow there was no (easy) way to provide a `Jenkinsfile` from a separate repository which is why the `Jenkinsfile` in this repository is **not** automatically picked up but has to be copied to the Jenkins job.
