Python Docker Builds
====================

Builds `CPython <https://python.org>`_ from source in an Ubuntu 18.04
environment. It is intended to make *any* version of CPython available as
needed. Ubuntu packages are usually only available for a subset of Python
versions.


Usage
-----

The complete built python environment is stored in ``/opt/python``
inside the docker image. To use it in another Dockerfile, use the
following commands::

  COPY --from=jyamad/python-build:3.7.8-1.0 /opt/python /opt/python
  RUN ln -s /opt/python/bin/python3 /opt/python/bin/python
  ENV PATH=/opt/python/bin:$PATH

Or you can copy the files out to your host computer::

  id=$(docker create image-name)
  docker cp $id:/opt/python local-python-dir
  docker rm -v $id


Building
--------

To use github to build a new version, create a tag and push it::

  git tag 3.8.5-1.0
  git push --tag

To build an image locally, clone the repo and specify the desired
python version like so::

  docker build --build-arg PYTHON_VERSION=3.8.5 -t jyamad/python-build:3.8.5-1.0 .
  docker push jyamad/python-build:3.8.5-1.0

Version Names
-------------

The build versions are the python version (e.g. 3.8.5) followed by a build spec
(e.g. 1.0), separated by a dash. For instance, ``3.8.5-1.0`` may be followed by
``3.8.5-1.1``, indicating a patched version of Python 3.8.5.

This versioning scheme is modeled after Linux package managers.

.. _Docker: https://www.docker.com/
