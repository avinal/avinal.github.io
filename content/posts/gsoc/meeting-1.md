---
category: gsoc
date: 2021-06-04T22:30:00
description: In this second meeting points over default Makefiles were discussed.
  Ninja can be used as an alternative for Makefiles.
image: /images/tech-wallpaper-2.webp
tags:
- gsoc
- fossology
title: Community Bonding Meeting 1
---

In this second meeting points over default Makefiles were discussed. Ninja can be used as an alternative for Makefiles.

## Discussions

- **What is the use of** `Makefile.deps` **and** `Makefile.process`
  **files?**
  - `Makefile.deps` consists of many used and unused snippets. These
    snippets help setup the build and test environment for fossology.
    Since there are many directories that are hardcoded, special care is
    required while replacing this file.
  - `Makefile.process` generates a master variable from list of
    variables. It assists the script in `Makefile.conf` file. These
    files together generate a list of variables that can be used
    throughout the build process.
- The build can be made faster using **Ninja** instead of **Make**.
- Ninja supports parallel builds by default.
- Print the flags used once the CMake configuration is working. That
  will help us debug the process.

## Conclusion and Further Plans

- Write a *CMakeLists.txt* for **lib**.
- Push the working branch and update the link either on wiki or blog.

## Attendees

- [Gaurav Mishra](https://github.com/GMishx)
- [Anupam Ghosh](https://github.com/ag4ums)
- [Avinal Kumar](https://github.com/avinal)
