---
category: gsoc
date: 2021-07-23T22:22:00
description: This week I implemented CMake packaging configuration for FOSSology.
  There were two meetings in this week and this report covers both of them.
image: /images/tech-wallpaper-9.webp
tags:
- gsoc
- FOSSology
title: Coding Week 7 Meeting
---

This week I implemented CMake packaging configuration for FOSSology. There were two meetings in this week and this report covers both of them.

## Week 7 Progress

> Initial CMake packaging configuration implemented.
>
> - Packages can be built according to the FOSSology previous packaging structure.
> - Copyright, ecc and keyword now builds faster.
> - To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- **Where I can find packaging info for FOSSology?**
  - All the scripts and companion files are located inside `debian`
    folder.
  - The most important files are `control`, which contains the
    dependency and description of each package, and `rules` file, which
    contains the make commands for creating the packages.
- **What are** `${shlibs:Depends}` **and** `${misc:Depends}` ?
  - They are dependencies required for creating Debian packages. CMake
    should be adding them by default so we can safely ignore them.
- **Will the new packages have the same structure as the old ones?**
  *(Michael)*
  - Yes for compatibility purposes Gaurav has suggested exactly follow
    the same structure as the old one.
- **Copyright build is slow because the same object files are being
  compiled three times, can you improve that?** *(Gaurav)*
  - I can try compiling the common object files beforehand and then
    adding the executables. But how to know the common object files?
  - Gaurav showed me where in the Makefiles I can find the common object
    files.
- There are problems with copying the symbolic link and packaging them.
  So I have to find some alternatives to resolve that.
- With component installing, package description can no longer be set.
- The `fossology-common` package contains file from `fossology-db`
  package. And the `fossology-db` package is empty.
  - Gaurav said this was unexpected and should not happen. This seems to
    be a very old bug with packaging.

## Conclusion and Further Plans

- Work more on the packaging.
- Improve compilation of copyright and monk agents
- Try to solve the packaging bug and add a pull request for that.
- Move on to implementing testing configurations.

## Attendees

- [Michael C. Jaeger](https://github.com/mcjaeger)
- [Gaurav Mishra](https://github.com/GMishx)
- [Anupam Ghosh](https://github.com/ag4ums)
- [Shaheem Azmal M MD](https://github.com/shaheemazmalmmd)
- [Avinal Kumar](https://github.com/avinal)
