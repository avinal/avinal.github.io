---
category: blogs
date: 2024-06-07T02:47:00
description: In January, I started switching to terminal-based tools and just
  recently, I was able to use my terminal for most of my development work.
  This blog highlights what tools I am using and for what purposes.
image: /images/dog-using-terminal.jpg
tags:
- terminal
- zellij
- neovim
- tmux
- zoxide
- lazygit
- fzf
- atuin
- alacritty
- starship
- toolbox
- toolbx
- gh
- zsh
- oh-my-zsh
- cli
- stow
title: "Echoes from the Shell: The Tools That Talk Back"
---

I started programming on a Windows machine about 6 years ago. I had just joined
college and had little clue about what tools to use and where to start. Slowly
I learnt new things and knowing more tools from friends, seniors, blogs and
YouTube. One thing was pretty common, almost everyone was recommending a Linux
based OS. I wasn't completely ready to switch, so I started using WSL2. WSL2
with Visual Studio Code were my daily driver for everything programming for
next 2.5 years.

## Linux loading

I got selected into Google Summer of Code in 2021 and the project I was
contributing to runs solely on Linux. So I finally left Windows and started
using Ubuntu. I was also a part of GLUG (GNU/Linux Users Group) in my college,
and that was one of the factors that motivated me to move. I used Ubuntu and
VS Code for next 1 year.

The next significant change to my setup came in 2022 January when I joined Red Hat
as an Intern. And the first task given to me was "Remove everything on your
ThinkPad and install Fedora". I used it for few months and then I switched to
Fedora on my personal laptop as well. After using Fedora for 2.5 years now, I
want to say Fedora is simply an excellent choice for students and developers
alike (until you intend to use Arch and burn the world).

## My current setup

Currently, I am using Fedora 40 with Sway Window Manager and tons of terminal
based tools. Just to be clear, I am not a keyboard nerd, but it does get my
work done faster and non-intrusively. I use a mouse for a fair share of my work
(I own [Logitech MX Master 3s](https://avinal.space/posts/blogs/configuring-logitech-mouse-on-fedora/)).
I will now be explaining what tools I use and why I prefer them. You can
get additional information about them by simply an internet search as they are pretty
famous.

This is not a blog about replicating the exact setup. So I will omit the
obvious tools, i.e. ZSH, plugins etc. Rather, I will enlist the major tools.
I am going to divide my tools in few categories:

- Tools I use for development
- Enhancing Terminal capabilities
- Miscellaneous

## Tools I use for development

This will be a trivial section, there are thousands of articles and videos
on the internet that cover this topic. I am just going to add my two paise.

### Neovim

Well, I know. You are going to say "yeah, expected". But IIWII. I started using
Neovim as my primary development tool in January this year. It was a little hard
to get used to it, but once I got familiar it feels like a breeze. I switched
from VS Code because of how bloated it is getting. I do not want a superfast
editor with outstanding benchmarks and awesome features and customizability.
Those are secondary, but most of all, I don't like being distracted. With all the
new things getting into VS Code it felt like, just too many features than I
need. I totally love VS Code, it was my daily drive for 5 years but
I felt I needed something minimal, and minimal it is.

I did some hopping from one config to another in the last 5 months and finally, I
decided to configure it myself using kickstart repository and it works better
than ever. I am still learning how to get most out of it.

- [Neovim](https://neovim.io/)
- [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
- [Carbonfox from Nightfox.nvim theme](https://github.com/EdenEast/nightfox.nvim?tab=readme-ov-file#carbonfox)
- [My configuration](https://github.com/avinal/dotfiles/tree/main/.config/nvim)

### Lazygit

When I moved from VS Code to Neovim, the one thing I missed most was a GUI
git extension. Although I use git CLI for most of my VCS work, but having a
visual display is helpful, especially for browsing changes and going through
commit history. VS Code git extension is a great tool and lazygit almost
replaces that for me. It has exactly those features that I generally use.
Plus it is configurable, the default configuration is more than enough for
most including me.

- [Lazygit](https://github.com/jesseduffield/lazygit)

### GitHub CLI

Many people have mixed opinion about this tool. For me, it works best for
what I generally do. And no, it doesn't replace git for me, I treat it like
a snippet tool that does few things with minimal effort, which would otherwise
take multiple commands using git. Additionally, most of the development work
I do go to GitHub, so it helps with that as well.

I mostly use it to clone, gist, creating pull requests, navigating issues,
checking out pull request branches, creating new repositories, and sometimes
for getting workflow status/logs. I strongly recommend it if you are eager to do
more from your terminal.

- [GitHub CLI](https://cli.github.com/)

## Enhancing Terminal capabilities

This category is focused on supercharging the default terminal with advanced
capabilities like better prompt, multiplexing, configurable layouts, session
management etc.

### Alacritty

What is wrong with Gnome terminal? Nothing. It is fantastic and I still use it
for many tasks. When it comes to configuring your terminal and actually being
able to reuse your configuration across machines, alacritty simply stands out.
It has tons of configurations and I loved using it, so I switched to it.

- [Alacritty](https://alacritty.org/)
- [GitHub Monaspace Argon font](https://monaspace.githubnext.com/)
- [My configuration](https://github.com/avinal/dotfiles/blob/main/.config/alacritty/alacritty.toml)

### Zellij

This one is interesting and new. I started using tmux as most people do when
they want to increase the density of work in a single terminal. It works and
is configurable as well. But there are some shortcomings for tmux. It does not
let you save a layout and the session management is basic. If you restart, you
will probably lose your setup.

Zellij address these problems and includes many new features on top of it.
You can create a layout in advance and also define what commands should be run
on start. There is a native plugin system and you can write plugins in most
languages that compile to WebAssembly. The configuration is human-friendly
and you can have multiple configuration files.

Initially, most users face issues with zellij default key bindings because of
their conflicts with Neovim. I choose to use different leader keys for
different tools. Here is the setup I use after getting recommendation on Reddit.

- Neovim: Ctrl
- Sway WM: OS Key/Command/Win Key
- Zellij: Alt

I also heavily modified the default key bindings as I saw fit. The tool is in
active development with numerous features planned.

- [Zellij](https://zellij.dev/)
- [Zellij vs Tmux](https://github.com/zellij-org/zellij/discussions/1701#discussioncomment-3517152)
- [My configuration](https://github.com/avinal/dotfiles/tree/main/.config/zellij)

### Atuin

I have covered Atuin before in my [last post](https://avinal.space/posts/raspi/everything-on-my-pi/#atuin).
So this will be a brief mention here. Atuin helps you sync your command
history across machines and provides excellent filtering and retrieval. If you
need a backup of your command history, Atuin is a way to go.

- [Atuin](https://atuin.sh/)
- [My configuration](https://github.com/avinal/dotfiles/blob/main/.config/atuin/config.toml)

## Miscellaneous

This section focuses on the tools that aren't very common but they rather
are unique in their own way, and you can get extra superpowers.

### Toolbx

This is more like a virtual terminal environment where you can install tools and
packages without adding them to the host OS. For example, if you are testing
some software, or want to build a project but don't want to install in your
machine. Or even having multiple independent environment and multiple distros
to develop your projects. I find this tool very useful. If you have such use
cases, give it a try.

- [Toolbx](https://containertoolbx.org/)

### Fzf

fzf is a companion tool that provides you fuzzy finding capabilities for a lot of
common CLI tools. You can use it in a plethora of ways and the integration with
tools are countless. It also comes with an interactive interface. This is a tool
which I want to say, you will understand only when you use it.

- [fzf](https://junegunn.github.io/fzf/)

### zoxide

zoxide brands itself as a smarter cd command, and this is precisely what it does.
It remembers where you often go and helps you get there faster next time. It
uses an impressive algorithm internally to rank the suggestions based on your
use.

- [zoxide](https://github.com/ajeetdsouza/zoxide)

## Echos

Here is the list of all other tools and plugins I didn't discuss, but they
are a useful part of my daily work.

- [Zsh](https://www.zsh.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [GNU Stow](https://www.gnu.org/software/stow/)

Please leave a comment, if you like reading this blog, or it helped you find a
good tool.
