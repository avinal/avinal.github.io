---
title: Coding Week 4 Meeting-1
date: 2021-06-29 23:22
tags: [gsoc, FOSSology]
category: gsoc
description: "In this seventh meeting question related to installing the FOSSology were discussed."
image: "/images/tech-wallpaper-6.webp"
---

# Coding Week 4 Meeting-1

In this seventh meeting question related to installing the FOSSology were discussed.

## Week 4 Progress

> CMake configuration files have been refactored to make each agent as a separate sub-project.
>
> - Symbolic links are installing.
> - VERSION files can be generated now during configure step
> - To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- **There are two types of replacements CMake can configure file with.**
  `@VARIABLE@` **and** `${VARIABLE}` **. Since in PHP** `$variable` **is
  used, it may create problem for CMake replacements. So may I replace
  them?**
  - Yeah sure, go ahead. It will be more robust.
  - The replacement of `$VARIABLE` can be stopped by using `@ONLY`
    option in `configure_file(...)` command.
- **How to generate vendor directory?**
  - The code for generating vendor directory is in `src/Makefile`.
  - Before executing code for the generation, make sure to copy
    `composer.json` and `composer.lock` to the target directory.
  - There is also a patch that FOSSology needs to function as intended.
    Make sure to run that patch to check and apply.
  - For now, we generate *vendor* while building, but it would be nice
    if it can be generated in the build step.
- **Currently I am generating the VERSION file in configure step itself.
  Should I move it to the build or install step?**
  - Yeah, please move it to the build step. As in configure step the
    data might be outdated.
- **Is there any configuration for Release that we can use to install or
  test?** *(Michael)*
  - Yeah, there are 4 inbuilt configurations for various levels of
    optimization and can be applied to tests and installation.
- **Is the VERSION file is generated for each agent or whole project at
  once? Because in the latter case, the VERSION file can be generated as
  the last step.**
  - No agent has a VERSION file along with the main VERSION file for
    FOSSology.
- **How I can build and install a single agent or component?**
  - There are two ways you can build and install a specific agent or
    component only.

  - The first one is quite simple. Just change your directory to the
    specific agent's directory and run all the usual commands for
    building and installing.

  - The second one is a bit for typing work. This can be used directly
    from the top-level directory. After configuring the CMake, you can
    run the following command to install the specific component.

    ``` bash
    # for Unix Makefiles
    make list_install_component # this will list all the available components
    cmake -DCOMPONENT=<component-name> -P cmake_install.cmake
    ```

  - I am writing a macro that will let us install a component by simply
    running `make install component`.

## Conclusion and Further Plans

- Implement generation of vendor directory.
- Move VERSION file generation to build step.

## Attendees

- [Michael C. Jaeger](https://github.com/mcjaeger)
- [Gaurav Mishra](https://github.com/GMishx)
- [Avinal Kumar](https://github.com/avinal)
