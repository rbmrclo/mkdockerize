mkdockerize
======

> Plug and play your mkdocs project on the fly! :rocket:

Start writing markdown files for your project's documentation in less than a minute. You only need docker. :ok_hand:
`mkdockerize` allows you to build and serve a valid mkdocs project without the hassle of setting up dependencies in your local machine.


## Table of Contents

- [Goal](#goal)
- [Directory structure](#directory-structure)
- [Setup](#setup)
  - [docker](#get-docker)
  - [build](#build-the-image)
- [mkdockerize.sh](#mkdockerizesh)
  - [Copy the script](#copy-the-script)
  - [Run the script](#run-the-script)
- [Work journal](#work-journal)

## Goal

We want to use Docker to encapsulate a tool called [Mkdocs](http://www.mkdocs.org/) to produce and serve a website because we don’t want to install Mkdocs locally.

The idea is to:

- Create a Git project that builds a Docker image.
- This Docker image, when run, should accept a directory from your local filesystem as input and use Mkdocs to produce and serve a website.
- This local directory is the root of a valid Mkdocs project with which this tool can create the site.

## Directory structure

```
.
├── README.md                       # Project documentation
├── docker                          # Main folder for the docker image
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   └── requirements.txt
├── examples                        # Sample valid mkdocs project created via `mkdocs new`
│   ├── engineering-docs
│   │   ├── docs
│   │   │   └── index.md
│   │   ├── mkdocs.yml
│   └── open-source-library-docs
│       ├── docs
│       │   └── index.md
│       └── mkdocs.yml
├── mkdockerize.sh                # Wrapper script that runs both `produce` and `serve` options of the docker container.
└── .gitlab-ci.yml                # Gitlab CI Configuration
```

## Setup

#### Get Docker

Before using `mkdockerize`, we assume that you already have `docker` installed in your local machine. However, in the case that you haven't installed it yet, kindly download it from [here](https://docs.docker.com/install/).

#### Build the image

This project comes from a zipped `robbie.marcelo.zip` file. Assuming that you have already extracted the content of the zip file, kindly do as follows:

```bash

$ cd path/to/robbie.marcelo/docker
$ docker build -t mkdockerize .
```

## mkdockerize.sh

Once you're done building our docker image, you can just simply copy this wrapper script to the root of any valid mkdocs project.

You can test it by using the example projects provided in `examples/` directory.

#### Copy the script

```
$ cp mkdockerize.sh examples/engineering-docs
```

#### Run the script

```
$ cd examples/engineering-docs
$ ./mkdockerize.sh
```

Visit <http://localhost:8000> on your browser to see the website.

At this point, you are now ready to start developing your documentation website by. Take note that the built-in dev-server allows you to preview your documentation as you're writing it. It will even auto-reload and refresh your browser whenever you save your changes.

## Work journal

I've created a private gist which serves as a journal of my work and represents my train of thought for this DevOps challenge.
- https://gist.github.com/rbmrclo/564b7cd6dc16fb4a94eb2c9badbcd8ea

-------
:copyright: Crafted with love and care by **[@rbmrclo]**.

[@rbmrclo]: https://github.com/rbmrclo
