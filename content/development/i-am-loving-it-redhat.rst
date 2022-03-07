.. |redhat_logo| image:: /images/redhat_logo.png
    :width: 1.5em
    :align: middle
    :target: https://redhat.com


**************************************
My internship at Red Hat |redhat_logo|
**************************************

:date: 2022-02-25 20:47
:slug: i-am-loving-it-redhat
:category: development
:tags: kubernetes, redhat, docker, golang, tekton, openshift, intern
:summary: 


I have been contributing to open source for the last 3 years and Red Hat was one of the companies that I was very fond of. I must say all my contributions and consistency paid off, and I made it to the Red Hat as a DevTools intern. This post is about onboarding and how I prepared myself for working on the actual project. 


On the first day of my internship, I met two amazing teammates `Saytam <https://github.com/>`_ and `Utkarsh <https://github.com/>`_. We were also introduced to a Senior Software Engineer `Piyush Garg <https://github.com>`_ who later mentored us. The initial few meetings were more on the introduction and what to learn topics. Before I jump into more details let me explain first what does a **DevTools Developer/Engineer** do? 



What does a DevTools Developer/Engineer do?
-------------------------------------------

From `MDN Web Docs <https://developer.mozilla.org/en-US/docs/Glossary/Developer_Tools>`_ **Developer tools (or "development tools" or short "DevTools") are programs that allow a developer to create, test, and debug software.** At RedHat, a lot of open source developer tools of industry standards are developed. There are many, OpenShift, Tekton, CodeReady containers, and many more. 

.. |golang_logo| image:: /images/golang.png
    :width: 2.5em
    :align: top

Learning on the |golang_logo|
-----------------------------

There was a lot of learning and still a lot to learn. In a meeting with my manager Pradeepto Bhattacharya, I was told that I will be working on TektonCD or OpenShift Pipelines, and both of them require a sound knowledge of Golang, CI/CD, Containers, Docker, and Kubernetes. I was familiar with CI/CD, containers, and Docker but never used Golang and Kubernetes. We were provided plenty of good resources and my teammates also helped with many awesome resources. I am listing all the resources with their category.


Golang
""""""

.. image:: /images/goladder.png
    :class: float-md-right rounded ml-3
    :alt: Gopher on the ladder
    :height: 20em

One of Golang’s biggest advantages is that it offers the clarity and ease of use that other languages lack. Golang’s advantages make it easy for new programmers to quickly understand the language and for seasoned veterans to easily read each other’s code.

- `Official Go Documentation <https://go.dev/doc/>`_ - *Start from here*
- `Go by Example <https://gobyexample.com/>`_ - *bite-size examples for most of the golang features*
- `Golang tutorial series - GOLANGBOT.COM <https://golangbot.com/learn-golang-series/>`_ - *in-depth tutorial of golang*
- `Effective Go <https://go.dev/doc/effective_go>`_ - *writing good golang programs*
- `The Go Playground <https://go.dev/play/>`_ - *official online golang ide*
- `The Go Programming Language - Book <https://www.gopl.io/>`_ *for learning advanced level golang*
- `Golang Tutorial for Beginners | Full Go Course - TechWorld with Nana <https://youtu.be/yyUHQIec83I>`_ *if you prefer video tutorials, I don't :)*
  
Docker
""""""

Docker takes away repetitive, mundane configuration tasks and is used throughout the development lifecycle for fast, easy, and portable application development - desktop and cloud. Docker’s comprehensive end-to-end platform includes UIs, CLIs, APIs, and security that are engineered to work together across the entire application delivery lifecycle.

.. image:: /images/docker-architecture.png
    :class: float-md-right img-fluid my-3
    :alt: The Docker Architecture


- `Docker and Containers - Katacoda <https://www.katacoda.com/courses/docker>`_ *interactive lessons on docker and containers*
- `Docker for beginners <https://docker-curriculum.com/>`_
- `Docker Tutorial for Beginners | TechWorld with Nana <https://youtu.be/3c-iBn73dDE>`_ *video tutorial*

Kubernetes
""""""""""

.. image:: /images/kubernetes-meme.png
    :width: 200
    :alt: Kubernetes tech
    :class: float-md-left border mr-3 


**Kubernetes** is the Greek word for a ship’s captain. We get the words Cybernetic and Gubernatorial from it. The Kubernetes project focuses on building a robust platform for running thousands of containers in production. 

- `Learn Kubernetes - Katacoda <https://www.katacoda.com/courses/kubernetes>`_ *interactive lessons with kubernetes*
- `kube by example <https://kubebyexample.com/>`_ *learn by doing*
- `Kubernetes Tutorial for Beginners <https://youtu.be/X48VuDVv0do>`_ *video tutorial*

*Not so Minimal* Tekton Server
------------------------------

In late January, we were asked to implement our learnings and deep dive into Kubernetes and TektonCD through an assignment project. Soon we realized that whatever we were learning so far was not even close to what we were going to implement. We were given a document containing the requirements of the applications we were supposed to create along with all the documentation and architectural diagrams. 


The application was called **Minimal Tekton Server**. It is a set of three different applications, i.e a server, a CLI, and a dashboard. In short, this application is supposed to *listen to custom resources being created and then transfer the request to Tekton API to create the corresponding resource on the OpenShift/Kubernetes cluster.* 


So are you interested in how it went? Please follow up with my next blog.