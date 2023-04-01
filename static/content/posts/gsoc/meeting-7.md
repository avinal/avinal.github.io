---
title: Coding Week 5 Meeting
date: 2021-07-09 22:22
tags: [gsoc, FOSSology]
category: gsoc
description: "This week was dedicated to perfecting CMake Installation Configuration. The installation was tested and bugs were discussed."
image: "/images/tech-wallpaper-8.webp"
---

This week was dedicated to perfecting CMake Installation Configuration. The installation was tested and bugs were discussed.

## Week 5 Progress

> CMake Installation Configuration is almost complete.
>
> - FOSSology can be installed completely via CMake
> - Post install script generation also added
> - To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- There are permission problems while running bash script of `nomos`,
  `monk` and `genvendor`.
  - One possible fix can be to add `bash` before each bash scripts.
  - The other fix is to modify shebang line in each script from
    `#!/bin/sh` to `#!/bin/bash`.
- In copyright agent same files are being compiled thrice, this is
  slowing down the build.
  - I am working on it. The problem is occurring because of three
    different executables.
  - I will try to combine the common objects together.
- There are some redundant files in the installation. And VERSION file
  is missing in `/usr/local/share/fossology`.

## Conclusion and Further Plans

- Fix copyright build.
- Remove redundant files and folders.
- Fix permission issues.

## Attendees

- [Gaurav Mishra](https://github.com/GMishx)
- [Avinal Kumar](https://github.com/avinal)
