---
title: Everything on my Pi
date: 2024-04-29T10:47:00
category: raspi
image: /images/big-raspberry-pi.webp
description: A list of everything I have installed on my Raspberry Pi 5 and 4B.
tags:

- raspi
- linux
- pi
- raspbian
- debian
- ubuntu
- server
- docker

---

I always wanted to have my self-hosted server when I was in college. Never had enough money to do much until recently.
So after I got my first job, I have invested moderately (heavily ;)) in gadgets and stuff. And one of my most prized
possession is my Raspberry Pi 4 and Raspberry Pi 5. I have been using it for a while now, and I have installed many
useful things on both of them. So I thought I would share it with everyone. This is a list of everything I have on my
Pi.

## Hardware and Specifications

- [Raspberry Pi 5 8GB Model](https://www.raspberrypi.com/products/raspberry-pi-5/)
- [Raspberry Pi 4B 8GB Model](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/)
- [Raspberry Pi 15W USB-C Power Supply](https://www.raspberrypi.com/products/type-c-power-supply/)
- [Raspberry Pi 27W USB-C Power Supply](https://www.raspberrypi.com/products/27w-power-supply/)
- [Samsung SSD 970 EVO Plus 500GB](https://www.samsung.com/us/computing/memory-storage/solid-state-drives/ssd-970-evo-plus-nvme-m-2-500gb-mz-v7s500b-am/)
- [WD Blue SA510 SATA SSD M.2 2280](https://www.westerndigital.com/en-in/products/internal-drives/wd-blue-sa510-sata-m-2-ssd?sku=WDS500G3B0B)
- [Pimoroni NVMe Base for Raspberry Pi 5](https://shop.pimoroni.com/products/nvme-base?variant=41219587178579)
- [PiBOX NVMe SSD Enclosure](https://pibox.in/product/nvme-m2-enclosure-pibox-india-nvme-ssd-enclosure-usb-3-2-10gbps-tool-free-m-2-nvme-case-pci-e-nvme-reader-usb-c-supports-m-bm-keys-2230-2242-2260-2280-ssds-powerful-jm583-chipset/)

I already had a good quality ethernet cables and micro SD cards lying around. You may ask if I am using SSD then why use
a SD Card. The simple answer is that I am using an SSD for storing everything, but all the OS functions are still run on
the SD card. In an unlikely event, I can just pull out the SSD and plug it in a different machine to access my data.

## Applications I am hosting

I won't be going into many details about my configurations in this post. I will probably cover them in separate posts.
Here I will put a list of all the applications I am hosting and what I use them for.

I am using [Tailscale](https://tailscale.com/) to connect to my servers. They are locked down for access without
Tailscale network. There is an open source alternative called [Headscale](https://github.com/juanfont/headscale) as
well, but I haven't given much though of self-hosting them yet. For server management I am
using [RunTipi](https://runtipi.io/). It uses docker compose to manage all application install.

I will be listing the applications in the decreasing order of my priority.

### Immich

| Website                       | Source                                         | Category                 | Platforms         | Similar       |
| ----------------------------- | ---------------------------------------------- | ------------------------ | ----------------- | ------------- |
| [Immich](https://immich.app/) | [GitHub](https://github.com/immich-app/immich) | Photos and Videos Backup | Web, Android, iOS | Google Photos |

Immich is the best open source and feature rich replacement to Google Photos. For starters the installation is very
easy, and you can install clients on Android and iOS. You can also use a CLI import tool to upload all your media
easily. You get most of the Google Photos feature expect the editing tools. The project is in active development and the
feature set is increasing day-by-day. You can see a comparision with other FOSS
alternatives [here](https://meichthys.github.io/foss_photo_libraries/).

### Paisa

| Website                     | Source                                            | Category                   | Platforms | Similar          |
| --------------------------- | ------------------------------------------------- | -------------------------- | --------- | ---------------- |
| [Paisa](https://paisa.fyi/) | [GitHub](https://github.com/ananthakumaran/paisa) | Finance and Budget Manager | Web       | Beancount,ledger |

It is really hard to keep track of all expenses from multiple accounts and credit cards. There are great solutions and
applications but either they are too [complex](https://www.firefly-iii.org/) or paid. If you still decide to use them
most of them don't fit well with Indian users, simply because they were not planned with such users in mind. Nothing
wrong there but mindset and habits of users matters a lot in such kind of applications. This application became my
immediate favorite once I installed. There are many thing this application gets right. First of them is the ease to
use UI and use of India specific terms and inspired from Indian spending habits. There is a bit of learning curve since
this application builds on top of [Plain Text Accouting](https://plaintextaccounting.org/), but it starts making sense
once you learn it. The developer is an experienced Software engineer from India. This will work for most of the world
but for Indian users this is a must-have if you are looking for such application. I wish it can have an android app as
well. But the current web UI is more than enough.

### Vikunja

| Website                        | Source                                        | Category     | Platforms | Similar               |
| ------------------------------ | --------------------------------------------- | ------------ | --------- | --------------------- |
| [Vikunja](https://vikunja.io/) | [Gitea](https://kolaente.dev/vikunja/vikunja) | Todo, Kanban | Web       | Google Tasks, Todoist |

There are many great open source todo and kanban applications, I have tested many of them and settled for Vikunja. For
personal use it was easy to set up. It has all the necessary features but is not bloated. The UI is good and it also
supports CalDAV. An Android application is still in progress but you can utilize CardDAV with applications
like [DavX5](https://www.davx5.com/) or [Tasks.org](https://tasks.org/). You can also create teams and have
different projects.

### Atuin

| Website                    | Source                                     | Category           | Platforms             | Similar    |
| -------------------------- | ------------------------------------------ | ------------------ | --------------------- | ---------- |
| [Atuin](https://atuin.sh/) | [GitHub](https://github.com/atuinsh/atuin) | Shell History sync | Linux, MacOS, Android | zsh-histdb |

I have 4 servers and many devices, it is not often easy to get the similar commands on different machines. That is where
Atuin comes in. Atuin replaces your existing shell history with a SQLite database, and records additional context for
your commands. Additionally, it provides optional and fully encrypted synchronisation of your history between machines,
via an Atuin server.

### Gitea

| Website                           | Source                                      | Category         | Platforms | Similar                   |
| --------------------------------- | ------------------------------------------- | ---------------- | --------- | ------------------------- |
| [Gitea](https://about.gitea.com/) | [GitHub](https://github.com/go-gitea/gitea) | Git hosting, VCS | Web       | GitHub, BitBucket, GitLab |

Gitea is a GitHub replacement written in Go. It includes a lot of features from GitHub including package registry,
CI/CD, team collaboration etc. I have not been actively using it. But I plan to host my personal projects here.

### Paperless-ngx

| Website                                          | Source                                                   | Category                   | Platforms    | Similar  |
| ------------------------------------------------ | -------------------------------------------------------- | -------------------------- | ------------ | -------- |
| [Paperless-ngx](https://docs.paperless-ngx.com/) | [GitHub](https://github.com/paperless-ngx/paperless-ngx) | Document Management System | Web, Android | Docspell |

This is a document management application where I can store my PDF/text documents (not ebooks). It has built in OCR and
other useful feature to organise and search through your documents.

### Shiori

| Website | Source                                        | Category         | Platforms                  | Similar            |
| ------- | --------------------------------------------- | ---------------- | -------------------------- | ------------------ |
| -       | [GitHub](https://github.com/go-shiori/shiori) | Bookmark Manager | Web, Linux, MacOS, Windows | LinkWarden, Pocket |

Shiori is a simple bookmarks manager written in the Go language. Intended as a simple clone of Pocket. You can use it as
a command line application or as a web application. This application is distributed as a single binary, which means it
can be installed and used easily. There is a third party Android app as well. You can get
it [here](https://f-droid.org/en/packages/com.desarrollodroide.pagekeeper/).

## What is missing

I am still searching apps for a general purpose file server and ebook management. A lot of people have suggested and I
have also tried Nextcloud for file storage. I also believe it is the best open source alternative, but deep down it
feels laggy and too much bloated for personal use. I would prefer something very minimal that solely works as a file
server and explore and nothing else. Similarly, with ebooks, Calibre is good, but it feels outdated.

If you do have some great suggestions, please put them in comments down below. You can use GitHub sign in or put an
anonymous comment.
