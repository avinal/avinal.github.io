---
category: blogs
date: 2024-09-22T05:47:00
description: Privacy is just like hope. It is the quintessential human delusion,
  simultaneously the source of your greatest strength and your greatest weakness.
  This post outlines my switch to GrapheneOS and my experiences so far.
image: /images/grapheneos-kill-bloat.webp
tags:
- grapheneos
- privacy
- degoogle
- android
- pixel
- google
- security
title: "GrapheneOS Saga: The Privacy-Centric Midlife Crisis"
---

In **The Matrix Resurrections**, Morpheus says *Not all seek to control. Just as not all wish to be
free*. The ever-increasing cases of privacy invading technology and the number of people sprinting
to adopting them reflects the quotes in its entirety. It is true that in the modern world it is
nearly impossible to have control of your complete data. But with few changes, you can decide how
much one has access to your data. Do remember once anything is on internet, it is forever.

## My Smartphone Journey

I got my first smartphone in 2014. It
was [Samsung Galaxy Star Pro](https://www.gsmarena.com/samsung_galaxy_star_pro_s7260-5749.php), a
very basic budget smartphone with Android 4.1. I used it until mid-2019, then for a few months I
used ASUS ZenPhone Go. It belonged to my friend. This also means I have never used 3G on smartphone.
It was a direct jump from 2G to 4G.

My first good smartphone
was [Nokia 6.1 Plus](https://www.gsmarena.com/nokia_6_1_plus_(nokia_x6)-9178.php). Excellent build
quality, clean OS with decent performance. Camera quality was surprisingly excellent considering
that it had almost no AI-based processing. Nokia can be a market leader in smartphone, but it seems
either they don't care much or they aren't putting much effort. I had to leave this phone in a year
because of severe charging port issue. Other than that it is still one of my most favourite
smartphone.

Then I bought [Google Pixel 4a](https://www.gsmarena.com/google_pixel_4a-10123.php) in January of
2021. First gadget bought with my first earning. Pixel 4 and 5 series are my most favourite
smartphones still. These are ergonomic and handy phones without many bells and whistles. The design
is nice with good performance and clean OS. After these, things started going bad.

My current smartphone is [Google Pixel 7a](https://www.gsmarena.com/google_pixel_7a-12170.php)
bought in 2023. It is good, but for the price I would expect a little more. Takes excellent photos
and the performance is decent. The stock OS is unfortunately not as clean as it used to be.

## Why GrapheneOS?

Before I can explain why I choose GrapheneOS, I should explain what I need. It can vary person to
person and phone to phone. But the keywords are the same, privacy, security, performance and
control.

### What I Do Not Need on My Smartphone

This is a very opinionated list of things I do not want on my phone. This is in part inspired by
privacy and performance concerns. A lot of it comes from my way of interacting with smartphone.

- AI: It is wonderful in quantities in which wine can be enjoyed. Too much of it and the phones
  behaves exactly like a drunken, too much talk but very little of it makes any sense.
- Apps I will never use: Every smartphone comes with some set of preinstalled applications. Some of
  them as crucial for the phone to function normally. Some of them are useful but may have an
  alternative. And others neither crucial nor useful. And on most phones you cannot even
  uninstall/disable them. It makes no sense to keep two apps with same functions or apps with no
  functions.
- Spyware/Malware/Adware/Bloatware: On many smartphones these are intentionally installed. OK, maybe
  not the first two, but definitely the next two. Most of the Chinese smartphones are riddled with
  Adware and Bloatware, probably the reason why they are so cheap. They are privacy nightmares and
  eat up your performance and battery.
- Inability to control permissions: A smartphone is a huge data generator and gatherer. If wrong
  entities have access to it, they may use it for nefarious purposes. One of the shocking example
  is [How Facebook was able to track location using accelerometer](https://www.cpomagazine.com/data-privacy/facebooks-use-of-alternate-location-tracking-methods-to-circumvent-apple-privacy-protections-expands-to-accelerometer-data/).
  So I would like to oversee what permissions each application has.
- Gimmicks: IYKYK

I still want my phone to be usable and have regular updates. I want it to perform close to what it
was designed for.

### It just makes sense

Once you are clear that what you do not want on your smartphone, GrapheneOS immediately makes sense.
I can achieve everything listed above and more. I actually researched and planned for almost a year
before I finally installed it. Now that I have done it, I think there is no going back.

## Installing using Fedora

GrapheneOS can be installed using WebUSB or via command line. Both are simple, but WebUSB is
simpler. Since Fedora is not in
the [supported OS](https://grapheneos.org/install/web#prerequisites). WebUSB may not work, for me,
it didn't. So I opened my favourite tool, the terminal and started
typing. [Installation via CLI](https://grapheneos.org/install/cli) works flawlessly as long as you
follow it step by step. There are few extra steps you might need for Fedora, that I will be
explaining here:

1. Install these packages:

  ```bash
  sudo dnf install android-tools
  ```

2. Follow the official instructions up
   to [OEM unlocking and booting into bootloader](https://grapheneos.org/install/cli#booting-into-the-bootloader-interface)
3. Check if fastboot can detect your device

  ```bash
  sudo fastboot devices
  ```

4. After that, you can continue following the instructions. Use `sudo`.

Wait patiently, as it takes some time and there is not much interactive response. Be sure that the
process has ended successfully before you disconnect your phone.

## First Impressions

The onboarding was short and clean. No account logins, no spooky agreements to accept. Once you set
up your phone, it should feel like a minimal installation of any Linux distros, few necessaries
preinstalled apps and nothing else.

In GrapheneOS all apps are sandboxed, no matter what is its origin. They have similar permission
scopes and no app is treated as royalty. On stock Android, some Google apps have system level
access, which they absolutely don't need for function. Unlike most custom OS available, GrapheneOS
is a completely de-Googled OS. You can see a detailed
comparison [here](https://eylenburg.github.io/android_comparison.htm). This means you should be just
fine without any Google Apps at all.

## Getting It To Speed

I wanted to retain my ease of use and most of previous apps. Some of them may be privacy invading
but with newly gained superpowers, I should be able to control them. I do use a fair share of Google
Apps as well as FOSS applications.

![Fully Configured GrapheneOS - Lockscreen, HomeScreen and Apps Menu](/images/grapheneos-looks.webp)

### My daily drivers

These are everyday applications, like calendar, payment and banking apps, maps, messaging, phone,
contacts, browser, email etc. To install apps from the Play Store, you will need to install Play
Services first. This is easy, just go to the App Store and install them.

### Enhancers

There are few apps, mostly FOSS, that I use to improve my experience. In no particular order (its
alphabetic):

- [AdGuard Home Manager](https://github.com/JGeek00/adguard-home-manager): An AdGuard Home client
  app, that lets me quickly control and manage my self-hosted AdGuard Home installation.
- [Aegis](https://getaegis.app/): Probably the best 2FA apps that is also FOSS. Compared to popular
  options like Google Authenticator, it encrypts your token at rest, lets you import and export as
  well as take encrypted backups.
- [Immich](https://immich.app/): A FOSS and self-hosted Google Photos replacement. Except editing,
  it has everything you may need in a media backup app. Even more features are being added
  regularly.
- [Insular](https://secure-system.gitlab.io/Insular/): I use this to enable a separate work profile
  where I keep all my less used or data hungry applications. When not in use, I can just pause them,
  and it saves battery as well as enhances privacy.
- [Lawnchair](https://lawnchair.app/): To be frank, I am unable to find a launcher that fits to my
  liking. My favorite launcher is still the OP Nokia Lumia launcher. Lawnchair is a Pixel launcher
  replacement with a lot more features and customizations. I use it
  with [Arcticons](https://arcticons.com/).
- [ServerBox](https://github.com/LollipopKit/flutter_server_box): I use this to keep an eye on my
  servers and even make small updates via ssh.
- [Tailscale](https://tailscale.com/): Three of the apps mentioned above will be unusable if not for
  Tailscale. In layman terms, it is a p2p VPN that tricks all the participating devices like they
  are connected in same local network. So you can access your remote servers and data without ever
  exposing them to internet. Additionally, it also redirects your DNS request to a custom server (
  like AdGuard Home) or even make one of your devices act as exit node.

## Things I Loved

New OS, new experiences and new things to love. There are many things that made me say _**Wow**_,
but I will point out the most significant changes in my smartphone experience.

### Game-changers

- Google Pixels are known for churning out good performance out of comparatively less powerful
  hardware. With recent AI outbreak, Google and other organizations are putting too much of it even
  in places, that makes little sense. GrapheneOS is clean from all that bloat, not even the
  Assistant. If I really need it, I can install specific applications.
- Battery life improvement is the biggest visible change I observed. I am now getting around 25%
  more screen time than before with similar uses.
- I can now decide what permission each app has as well as stop their access to network completely
  without relying on a third party app. You also get fine control for your location data as well as
  activity indicator.
- As I mention in my first point, Pixels have good performance, but GrapheneOS takes it to another
  level. My phone feels significantly faster. This should be expected since you no longer have bloat
  apps running in background.

### Little things

- You can archive any installed application instead of removing them. This makes sure that you don't
  have to set up again but still get rid of them in practice.
- Ability to install apps in user profiles without any App Store installation.
- The usual things, you can see the complete list of improvements/new things
  on [GrapheneOS features](https://grapheneos.org/features) page.

## Things That Went Wrong

Yes, not everything is great with GrapheneOS. There were some downsides, some failures as well loss
of data. I backed up all my data before making the switch and still got a few things wrong.

### Horribly Wrong :(

- I lost my WhatsApp data completely. I am still a bit sad about it. This happened because WhatsApp
  couldn't detect active backup on my Google Drive and decided to start new. This is a scary example
  of how dependent everything is on Google, if WhatsApp had allowed independent backup, this would
  not have happened. I did find a probable fix, but after I lost my data. You can use _Transfer
  Chats_ feature of WhatsApp to transfer between phones. But you need two phones with latest
  versions of WhatsApp, so not possible for me anyway. There was a lot of not-important data, few
  important and some which I wanted to remove but couldn't. So the destiny decided it for me, it
  seems.
- GrapheneOS doesn't have a great backup solution. It uses an implementation of Seedvault, which is
  secure but not reliable at all. Most of the time it simply doesn't work. Except USB backup,
  nothing worked for me. That also means you have to regularly take manual backup.

### Manageable

- All banking apps worked, except PayTM. After some research, I found that it is not GrapheneOS
  fault. It seems PayTM hardcoded application used for webview. The usual _Android System Webview_
  is not available neither installable on GrapheneOS since it uses its own implementation. It is
  okay, because I always use a different payment app.
- Getting location to work was a little tricky. The first few attempts completely failed. GrapheneOS
  uses something called _Reroute location request to OS_ which limits when and how Play Services can
  access location. A great privacy feature, but it took some time to work.

## Things I am missing

- Reliable backups would be a major missing. The GrapheneOS seems to be working on it, but it may
  take time.
- Some of the features are not latest compared to Stock Android or even completely missing, i.e.
  Wallpaper Chooser, Extreme Battery Saver, Digital Wellbeing, pausing of apps. I understand that
  these may not be a priority for the team, so it's okay.
- I loved _Now Playing_ feature on Pixel, it is not available.
- Although GrapheneOS is extremely minimal, there are still apps you cannot remove. The preinstalled
  apps for dialer, contacts and cameras are simple and do the work, but the UI is pretty outdated,
  and they do not have many features. So I installed alternatives, but I cannot remove them. Some of
  them can be disabled though.
- There are few UI issues that need fixing. Not anything critical, but sometimes it bothers.

## References

- [GrapheneOS Website](https://grapheneos.org/)
- [Comparison of Android ROMs](https://eylenburg.github.io/android_comparison.htm)
- [Installation using Fedora - Forum](https://discuss.grapheneos.org/d/359-fedora-to-install-grapheneos/4)
- [The Matrix Resurrections](https://www.imdb.com/title/tt10838180/)
