# libint-cp2k

Provides tarballs of CP2K-configured libint releases for different maximum angular momenta. The latest release can be downloaded [here](https://github.com/cp2k/libint-cp2k/releases/latest).

## Choosing an appropriate libint version

The provided libint tarballs are named `libint-<version>-cp2k-lmax-<lmax>`
with `<version>` the corresponding libint version and `<lmax>` the maximum supported angular momentum (e.g. the `...-lmax-4` library providing support for up to g-type functions). Note that choosing higher values for `lmax` will increase build time and library size.

More specifically, a libint version with max. angular momentum `lmax` has support for the following types of basis functions:
* orbital basis functions with angular momentum up to `lmax` for integrals and `lmax - 1` for derivatives (4-center ERIs)
* auxiliary (RI) basis functions with angular momentum up to `lmax + 2` for integrals and `lmax + 1` for derivatives (3- and 2-center ERIs).

The specific configuration options of a libint tarball can be found in the `compiler.config` file. If you need a different libint configuration for CP2K, please let us know by submitting an issue with the exact `configure` options.

## Build instructions

The libint library is installed as part of the [CP2K toolchain](https://github.com/cp2k/cp2k/blob/master/INSTALL.md), which is based on the autoconf tool (see README inside the tar file):

**Important:** CP2K requires that libint is built with *Fortran bindings*.

## Internal: Build Setup (CI)

The following instructions are about our internal setup to automatically generate the provided libint2 source tarballs.

Requirements:

* [Jenkins CI](https://jenkins.io/)
  * [Plugin: GitHub Pipeline for Blue Ocean](https://plugins.jenkins.io/blueocean-github-pipeline)
  * [Plugin: Docker](https://plugins.jenkins.io/docker-plugin)
  * [Plugin: Pipeline Utility Steps](https://plugins.jenkins.io/pipeline-utility-steps)
  * [Plugin: Multibranch Pipeline Inline Definition](https://plugins.jenkins.io/inline-pipeline)
  * [Plugin: Basic Branch Build Strategies plugin](https://plugins.jenkins.io/basic-branch-build-strategies)
* Docker host

Steps:

* On the Docker host: Setup a Docker image based on the provided `Dockerfile`
* In Jenkins:
  * Connect the Docker host and register the image as a Docker Template, labelling it `cp2k-libint`
  * Add credentials using a GitHub token for a service user capable of making releases
  * Create a new Multibranch Pipeline job, using as the inline `Jenkinsfile` the one provided in this repo (use `README.md` as the marker file)

Caveats:

* At the time of creating this workflow there was no (easy) way to provide a `Jenkinsfile` from a separate repository which is why the `Jenkinsfile` in this repository is **not** automatically picked up but has to be copied to the Jenkins job.
