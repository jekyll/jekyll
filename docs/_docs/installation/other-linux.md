---
title: Jekyll on Linux
permalink: /docs/installation/other-linux/
---
Installation on other Linux distributions works similarly as on [Ubuntu](../ubuntu/).

On Fedora, the dependencies can be installed as follows:

 ```sh
sudo dnf install ruby ruby-devel @development-tools
```

On Debian:

```sh
sudo apt-get install ruby-full build-essential
```

On ArchLinux:

```sh
sudo pacman -S ruby base-devel
```

On openSUSE:

```sh
sudo zypper install -t pattern devel_ruby devel_C_C++
```

The rest works the same as on [Ubuntu](../ubuntu/).
