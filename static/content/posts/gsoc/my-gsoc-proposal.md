---
title: "New Build System and improving CI/CD workflow"
date: 2023-03-30 21:14
tags: [gsoc, fossology, proposal]
category: gsoc
description: It has been 2 years since I was a Google Summer of Code Student. It was an outstanding opportunity and I really enjoyed working on the project. Not only that, but it added numerous skills to my resume and polished many others. Today I want to make my proposal public, that helped me get selected.
image: "/images/tools-build-comparision.webp"
---

## Current Build System and Workflow

It has been 2 years since I was a Google Summer of Code Student. It was an outstanding opportunity and I really enjoyed working on the project. Not only that, but it added numerous skills to my resume and polished many others. Today I want to make my proposal public, that helped me get selected.

### Build System

FOSSology’s build system is based on multilevel Makefile that work together to
provide a build infrastructure for the project. Although make is a robust build
system, but it is too outdated and slow compared to modern build systems. Although
build configurations are not supposed to be updated as often as source files,
there are few noticeable problems with make.

* Configuration is mostly hard-coded, i.e., if needed to use different tools or add source files, the Makefile needs to be updated
* All the dependencies and libraries have to be added manually by writing configuration for each of them
* Although the FOSSology project currently supports Linux only, if in the future it has to be ported to other platforms, make won’t be able to support it. Hence, it is not future safe.

### Workflow (Continuous Integration)

FOSSology project has been using open-source tier Travis CI for all its continuous
integration and deployment needs. GitHub launched its CI/CD system some years ago,
and it has become a standard for CI/CD. Travis CI does the work but provides significantly
fewer features when compared to GitHub Actions.

* It has been observed that Travis CI is noticeably slower than GitHub Action for a similar configuration
* Travis CI lacks the tight and seamless integration of GitHub Actions with other GitHub Services, some of them are the ability to integrate and communicate with GitHub apps, auto-manage to pull requests and issues, better support for Dockerized builds.

## Why a New Build System(CMake)?

There were many possible candidates for a new build system for the FOSSology project.
Each has its pros and cons. After numerous comparisons and the ability of the new
build system to integrate well with the existing system, CMake seems to be the best
choice. Given below is a quick overview of different build systems and their execution times.

![Configure and Build time comparision](/images/tools-build-comparision.webp)

Here, CMake (Make & Ninja) performs better than average compared to other tools.
The criteria for choosing CMake were not only performance, but many other factors.

* The build system should be easily available on all supported distros - Cmake supports _UNIX, MS Windows (MSVC, Borland, Cygwin, MinGW) and Mac OS X, and more_
* It should be easy to install – CMake is available via all popular package managers and repositories
* Should improve build speed – In general, CMake always outperforms bare metal make systems.
* The learning curve is not too steep – CMake is not very hard and neither too easy to learn. For common projects, it is easy to learn.

### CMake Perks

* No other dependencies apart from the C/C++ compiler
* Includes a testing framework (CTest)
* Includes a multipurpose packaging solution (CPack)
* Migrating from Make to CMake is easier compared to other build systems
* Can generate platform-specific build configuration; hence the same script can be used for multiple platforms
* All modern C/C++ IDEs have inbuilt support for CMake or via a plugin (Visual Studio, XCode, CLion)
* Can load dependencies automatically from the internet or local file system
* Source and build folders are separate by default in CMake, this avoids bloating the source folders and accidentally deleting important files.

### Comparison of CMake and Make syntax

#### Make Syntax

```makefile
CXXFLAGS = -I../include -I.

SRC := $(wildcard *.cc)
DEP := $(patsubst %.cc,%.d,$(SRC))
OBJ := $(patsubst %.cc,%.o,$(SRC))

all: $(PROGNAME)

$(PROGNAME): $(OBJ) ../lib/$(LIBNAME)
    $(CXX) $(CXXFLAGS) $^ -o $@

%.d: %.cc
    $(CXX) -MM $(CXXFLAGS) $< | sed 's/\($*\)\.o[ :]*/\1.o $@ : /g' > $@

ifneq ($(filter clean,$(MAKECMDGOALS)),clean)
-include $(DEP)
endif

clean:
    $(RM) $(DEP) $(OBJ) $(PROGNAME)
```

#### Corresponding CMake File

```cmake
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

AUX_SOURCE_DIRECTORY(${CMAKE_CURRENT_SOURCE_DIR} source)
add_executable(hellocmake ${source})
target_link_libraries(hellocmake LINK_PUBLIC libhellocmake)
```

### How to (c)make the move?

#### Step 1: Determine the total number and types of Makefiles to migrate

We will determine the required time for the whole migration and the number of respective
CMake scripts to be written. In general, CMake scripts have fewer lines than Make
scripts for the same task. However, the top-level CMake configuration can be very
complex depending on how many configurations we want to create.

* There are [168 Makefile](https://github.com/search?q=Makefile+repo%3Afossology%2Ffossology+filename%3A%22Makefile%22&type=Code)configurations as of now in FOSSology Project
* Types: Build, Install, Test, Uninstall, Coverage, Clean, Package, and other sister types

#### Step 2: Start migrating Makefiles one agent/directory at a time

The FOSSology project’s build system follows a bottom-up approach. That means all
the child directories need to be built first to build their parents. Since most
of the agents in FOSSology are independent programs, their CMake config can be
written separately. I have created a sample project to demonstrate the Make and
CMake syntax and build process. It also demonstrates the cross-platform ability
of CMake. The project can be accessed here: [https://github.com/avinal/make-cmake](https://github.com/avinal/make-cmake)

#### Step 3: Create the Top-Level CMakeLists.txt to link all the libraries

The top-level CMakelIsts.txt will be complex and most of the work, as well as testing,
will be done during this phase. In the initial stage, I plan to create just the
minimum to at least build the whole project in one go without any bells and whistles.

#### Step 4: Add required configurations (Install, Package, Test)

Once the top-level CMakeLists.txt is building the project without any problems.
We will now add the required configurations such as install, package, test, uninstall,
and other configurations.

#### Step 5: Test the new Build System

It is almost done, we may start testing our shiny build system. Checking every
single configuration for errors and loopholes. This step will also make use of a
new CI/CD system for testing purposes. Thus, simultaneously migrating the CI from
Travis CI to GitHub Actions.

## Improving the CI/CD workflow

With the new build system, the FOSSology project will get a new CI/CD too. There
were several tasks proposed for improving the workflow of FOSSology. I have completed
many of them already. Given Below is an overview of the tasks proposed and their status.

* Syntax Check ([#1919](https://github.com/fossology/fossology/pull/1919))
* Static Code Analysis ([#1919](https://github.com/fossology/fossology/pull/1919))
* Copy/Paste Detector ([#1919](https://github.com/fossology/fossology/pull/1919))
* PHP Codesniffer ([#1919](https://github.com/fossology/fossology/pull/1919))
* Docker Tests
* C/C++ agent tests
* PHPUnit tests
* GitHub Page Release ([#1917](https://github.com/fossology/fossology/pull/1917))
* Implementing Caching in workflows
* Implement source install (reference[#207](https://github.com/fossology/fossology/issues/207))
* DOC, Commit, and PR guideline checks

### How will the workflow improve?

We are migrating the whole workflow to the GitHub Actions platform, in general,
GHA provides better integration and builds time.

#### Step 6: Migrate the C/C++ agent tests and PHPUnit Tests

By this time, we have already migrated our build system to CMake and thus the new
workflow will be based on CMake configurations. The goal will be to add more platforms
(Debian/Ubuntu/Fedora etc.) for tests and upgrade the tools to their latest compatible versions.

#### Step 7: Implement Source Install test for Ubuntu, Debian, and Fedora

As of now, source install is not tested for any of the distributions, so this step
aims at adding source install testing capability to the new CI.

#### Step 8: Implement caching in workflows and testing

GitHub Action can store cache dependencies for a given period and thus reduces the
number of times the virtual machine has to fetch packages. This in turn reduces
the overall build time as well as reduces the load on servers.

## Project Deliverables

* New Build System (CMake) for the project
* New Packaging, Install and Test configuration
* C/C++ agents tests for multiple versions of GCC
* PHPUnit tests
* Docker Tests
* Cached Workflows
* Source installs tests for Debian, Ubuntu, Fedora
* Checks for Pull Requests and Commit guidelines

## Other Deliverables

* For track my progress as well as a resource for future contributors, I will be writing a weekly/biweekly blog. The same can be used for preparing the final GSoC report.
* Since CMake will be new for the FOSSology Community, I will document all the important topics that I will come across while migrating the build system. This will be both a handpicked resource and a reference for future contributors.
* I would love to be a part of the community even after GSoC, although the build system and CI/CD doesn’t need to be updated that often, I would like to contribute to other parts of the project.

## Experience

I have 3 years of experience in C/C++ programming and one year of experience with
CMake and Make. I have used CMake and Make for many of my projects, as well as contributed
to other open-source projects. Furthermore, I have created/migrated the CI/CD for
many open-source organizations to GitHub Actions, and created many personal projects
using GHA as well.

I have been contributing to many open-source organizations since 2019. I participated
as a Technical Writer in the Google Season of Docs 2021 program under the VideoLAN
organization. So, I have a nice understanding of open-source project workflow and
contribution standards. I am well versed in Git and GitHub.

## Tech Stack

* CI/CD: **GitHub Actions, Travis CI**
* Build Systems: **CMake, Make**
* Languages: **C/C++, PHP, Shell Script**
* Version Control: **Git, GitHub**
* OS: **Ubuntu, Fedora, Debian**
* Compilers: **GCC, Clang**
* Containers: **Docker**

## Proposed Timeline

### Community Bonding (May 17th - June 6th, 2021)

* Discussing and collaborating with fellow participants and getting familiar with the FOSSology community and projects.
* Since CMake is new for our FOSSology community, I will learn and bring in the resources so that people get comfortable with it before the coding period starts.
* Going through the codebase and plan strategies for the migration, his includes identification of various types, segregation of libraries, executables, and dependencies.

### Coding Week 1 (June 7th - June 13th, 2021)

* Plan the priority order of migration, and create lists for all different configurations
* Create CMake configuration for libraries.
* There are approximately 8 libraries, since configuration is not that complex, it should take no longer than 1 week to complete

### Coding Week 2 & 3 (June 14th - June 27th, 2021)🚩

* If libraries are complete, migrate the agents one by one, since FOSSOlogy is based on a modular architecture, many agents can be independently migrated
* There are some 27 agents, 2 agents per day should take 2 weeks; hence I have merged these weeks.
* Time may vary for different agents to be migrated to CMake, but on average, this should take 2 weeks.
* Buffer Period

### Coding Week 4 (June 28th - July 4th, 2021)

* By now all the agents and libraries are migrated and presently the top-level CMakeLists.txt should be created. Since this file will be complex and will need all the child configuration to work, the testing and completion should approximately take 1 week.
* This week will also check the overall gains in terms of performance and stability of the new build system.
* This is also the minimum requirement for the build system to be said working and to add more configurations

### Coding Week 5 (July 5th - July 11th, 2021)🚩

* This week will continue the development of the Top-level CMake configuration.
* More configuration will be added for Install, Test, Uninstall, Package
* If completed, testing will start and will continue for the next week
* Buffer Period

### Coding Week 6 (July 12th - July 18th, 2021) First Evaluation

* The build system is a very crucial element of the project; hence it must be tested thoroughly before final rolling.
* This week, I will continue the development of all required configuration and testing of the new Build System.
* By the end of this week, the new build system will be able to properly build the project and use the configurations, this also marks the end of the first phase and first evaluation.
* Buffer Period

### Coding Week 7 (July 19th - July 25th, 2021)

* With all the build system working, this week will be used to migrate the CI from Travis to GitHub Actions starting with the C/C++ agent’s test
* Now the C++ agent tests will be executed using the new Build System
* If completed, then the PHPUnit test migration will start

### Coding Week 8 (July 26th - August 1st, 2021)🚩

* Complete the PHPUnit CI migration
* Add Docker tests
* Start implementing source install test CI

### Coding Week 9 (August 2nd - August 8th, 2021)

* Complete Source Install CI
* Start implementing workflow caching
* Fixing bugs and clearing backlogs
* Buffer Period

### Coding week 10 (August 9th - August 15th, 2021)🚩

* Checking the build system
* Checking the CI/CD
* Completing reports and documentation
* Update the existing documentation and readme for the new build system and CI

### Final Evaluations (August 16th - August 23rd, 2021)

* Code and report submission

### Milestones 🚩

1. All agents and libraries have now a CMake build configuration
2. Top-level CMake configuration with a stable build
3. Top-level CMake configuration with other configs i.e. install, package, test
4. C/C++ agent tests, PHPUnit test implemented in CI
5. CI/CD is complete according to the task list

## **Pre GSoC Involvements**

### In FOSSology

* [feat(CI): Migrate API docs generation and deployment to GitHub Actions](https://github.com/fossology/fossology/pull/1917) [MERGED]
* [feat(CI): Migrate Static Checks and Analysis to GitHub Actions from Travis CI](https://github.com/fossology/fossology/pull/1919) [MERGED]
* [fix(make): Fix warnings in make for Ubuntu 20.04.2 LTS](https://github.com/fossology/fossology/pull/1923) [OPEN]
* [Upgrade this project from PHP 7 to PHP 8](https://github.com/fossology/fossology/issues/1920) [ISSUE]
* [Improving build system and CI/CD flow][https://github.com/fossology/fossology/discussions/1931](DISCUSSION)

### Other Contributions

* [VideoLAN/VLC for Android User Documentation](https://code.videolan.org/docs/vlc-android-user) [PROJECT]
* [boostorg/gil](https://github.com/boostorg/gil/issues?q=author%3Aavinal) [2 PR, 1 ISSUE]
* [embox/embox](https://github.com/embox/embox/issues?q=author%3Aavinal) [1 PR]
* [JetBrains/swot][https://github.com/JetBrains/swot/pulls?q=author%3Aavinal](1 PR)
* [jupyter-xeus/xeus-sqlite][https://github.com/jupyter-xeus/xeus-sqlite/issues?q=author%3Aavinal](1 PR, 1 ISSUE)
* [github/explore](https://github.com/github/explore/pulls?q=avinal) [2 PR]

## My Development Environment

* Operating Systems: Ubuntu 20.04 LTS, Windows 10 20H2
* Editors: Visual Studio Code, Vim
* IDE: Visual Studio, CLion
* Internet Speed: 20 Mbps

## References and Resources

1. [A sample Make CMake project structure and comparison](https://github.com/avinal/make-cmake)
2. [CMake Reference Documentation — CMake 3.20.0 Documentation](https://cmake.org/cmake/help/latest/)
3. [A simple comparison](https://mesonbuild.com/Simple-comparison.html) of different build systems
4. [Why the KDE project switched to CMake -- and how (continued)](https://lwn.net/Articles/188693/)
5. [bksys / scons (Re: win32 port)](https://mail.kde.org/pipermail/kde-buildsystem/2006-January/000410.html)
6. [CMake vs Make](https://prateekvjoshi.com/2014/02/01/cmake-vs-make/)

## Motivation

Ever since I came to know about GSoC(that was in my first year), I wanted to be
a part of it. This was even before I got the idea of Open Source. Once I started
contributing to open source, I started liking it and gradually became a part. I
did Google Season of Docs 2020 under the VideoLAN organization and got a nice overview
of open-source development, communities, and programs.

I found that the FOSSology community is very passionate about open-source contributions,
and they welcome experts and noobs alike. Other than that, open community meetings
are one of the best things I encountered in my open-source journey. I hope by being
a part of this community I will exchange skills and experiences and thus help both
the community and me.

## Commitments

This summer, I don’t have any classes or internships. I found this project very
fascinating, and I have already worked out a portion of this project, so this project
is my _priority_. Although the program is supposed to be part-time, I will be able
to work full time as well on weekends. I will attend all the meetings and prepare
reports on time. I am an active member of the community presently, and will continue
the streak during GSoC as well as after GSoC.

**Thanks**
