---
category: gsoc
date: 2021-07-30T22:47:00
description: This week I implemented CMake packaging configuration for FOSSology.
  The new configuration fixes issue with previous packaging configurations. It also
  retains the component wise installation features.
image: /images/tech-wallpaper-10.webp
tags:
- gsoc
- FOSSology
title: Coding Week 8 Meeting
---

This week I implemented CMake packaging configuration for FOSSology. The new configuration fixes issue with previous packaging configurations. It also retains the component wise installation features.

## Week 8 Progress

> CMake Packaging configuration almost completed.

- Packages can be built according to the FOSSology previous packaging structure.
- Initial testing configuration added.
- Ninja build has been fixed.
- To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- **How is the testing implemented in FOSSology?**
  - Not all agents have testing implemented.
  - There are two types of tests *Unit* and *Functional*.
  - At first, the test executable calls multiple PHP scripts to create a
    test environment. And then tests are executed.
  - Files related to testing and common for all the agents are in
    `src/testing`
  - Other tests depends on `phpunit`. This *PHPUnit* is generated inside
    `vendor`.
- **As of now, the testing configurations are hardcoded, what should I
  do, because it seems the testing configuration will require changes to
  a lot of files?**
  - Decide a deadline for the testing configuration and if until that
    point there is not very productive implementation then move to the
    next task that is implementing CI.
- As of now building, installation, and packaging via CMake is working
  and in a stable state. To create an initial Pull Request. This would
  also be useful in case of the final evaluation and further testing
  will be based on this PR itself.
- Fix any bugs or if there is the scope of improvement in Building,
  Installation and Packaging do that.

## Conclusion and Further Plans

- Prepare for an initial PR.
- Fix known bugs and apply Improvements.
- Work on testing configurations.

## Attendees

- [Gaurav Mishra](https://github.com/GMishx)
- [Shaheem Azmal M MD](https://github.com/shaheemazmalmmd)
- [Avinal Kumar](https://github.com/avinal)
