---
title: Coding Week 3 Meeting
date: 2021-06-22 23:22
tags: [gsoc, FOSSology]
category: gsoc
description: "In this fifth meeting, question related to versioning and obtaining
commit hash were discussed, this was a short meeting."
image: "/images/tech-wallpaper-5.webp"
---

# Coding Week 3 Meeting

In this fifth meeting, question related to versioning and obtaining commit hash were discussed, this was a short meeting.

## Week 3 Progress

> Version file Implementation
>
> - Initial functions on obtaining commit and branch info
> - To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- **What is the regex expression used for obtaining version
  information?**
  - The regex has recently been modified to cover recent versions. The
    latest form is as below:

    ``` cpp
    ([[:digit:]]+.[[:digit:]]+.[[:digit:]]+)(-?rc[[:digit:]]+)?-?([[:digit:]]*)-?[[:alnum:]]*
    ```

  - You can also try alternatives to regex if possible for CMake.
- **Should I use** `git describe --tags` **or**
  `git describe --always HEAD` **for obtaining version information?**
  - In FOSSology we always use `git describe --tags`, no exception
    whatsoever.
- CMake provides a preset configuration for the install path on GNU
  systems, you can see the description
  [here](https://cmake.org/cmake/help/v3.10/module/GNUInstallDirs.html)
  based on the
  [configuration](https://www.gnu.org/prep/standards/html_node/Directory-Variables.html)
  suggested by the GNU After comparing the variables defined in
  Makefile.conf with these, it seems directly taken from GNU standards.
  So I wanted to ask if this would be okay to stick to the presets,
  instead of manually declaring the same paths? The former step will
  reduce the number of variables we are currently caching and will make
  it flexible for different installation scenarios.
  - Using the GNU standards is the ideal situation but FOSSology uses
    slightly different locations. For example, all agents end up under
    `/usr/local/share/fossology/` with their individual folders instead
    of going to `/usr/local/bin/`.
  - If the same results can be achieved by using the
    `CMAKE_INSTALL_<dir>` and `CMAKE_INSTALL_PREFIX` then yeah, it will
    be preferred.

## Conclusion and Further Plans

- Try adding the version and commit hash info.
- Implement writing version files for each build.

## Attendees

- [Michael C. Jaeger](https://github.com/mcjaeger)
- [Gaurav Mishra](https://github.com/GMishx)
- [Avinal Kumar](https://github.com/avinal)
