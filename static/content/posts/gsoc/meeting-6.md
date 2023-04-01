---
title: Coding Week 4 Meeting-2
date: 2021-07-02 22:22
tags: [gsoc, FOSSology]
category: gsoc
description: "In this eighth meeting questions related to post install generation were asked. This was a short meeting."
image: "/images/tech-wallpaper-7.webp"
---

In this eighth meeting questions related to post install generation were asked. This was a short meeting.  

## Week 4 Progress

> Version parsing logic implemented.
>
> - VERSION and COMMIT_HASH added to every executables.
> - Installing part is complete except `cli`.
> - Symbolic Links are installing and working fine.
> - Version, Symbolic Links, `VERSION` file generation, `version.php` generation are now more modular and called via a single function for each agent
> - Most dependencies are now moved to single configuration file.
> - Vendor directory generation and installing are now working.
> - To test the current progress, follow the instructions [here](https://github.com/avinal/FOSSology/wiki#test-the-new-system-only-gcc-with-make-and-ninja-tested-for-now)

## Discussions

- **Why all the symbolic links in cli points to** `fo_wrapper`
  **script?**
  - The `fo_wrapper` script calls the PHP script on the symbolic link
    that called the fo_wrapper. It also initializes any requirement
    before calling the scripts.
- **How to generate all the other configuration in**
  `/usr/local/etc/fossology` **directory?**
  - You can find the input files for all these configurations in the
    `install/defcon` directory.
- **What are** `OBSOLETEFILES` **in** `www/ui/Makefile` **?**
  - They are kept for compatibility purposes. Although they have been
    removed in the current versions of FOSSology, if a user installs a
    new version on top of an older instance, then we should explicitly
    remove those files.
- **I have created a separate folder for generating vendor directory. Is
  that okay?**
  - Yeah, it should be fine, But it would be better to rename it to
    something else. Or even better if moved to *www* itself. Since these
    files are used by www.

## Conclusion and Further Plans

- Move `vendor` scripts to `www` directory.
- Implement installing for FOSSology cli.
- Implement installing configuration scripts.
- Finish installation for testing

## Attendees

- [Gaurav Mishra](https://github.com/GMishx)
- [Avinal Kumar](https://github.com/avinal)
