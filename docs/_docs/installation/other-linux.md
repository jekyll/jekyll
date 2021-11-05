---
title: Jekyll on Linux
permalink: /docs/installation/other-linux/
---

Installation on other Linux distributions works similarly to installing on [Ubuntu](../ubuntu/).

## Install prerequisites

### Fedora

```sh
sudo dnf install ruby ruby-devel openssl-devel redhat-rpm-config gcc-c++ @development-tools
```
### RHEL8/CentOS8

```sh
sudo dnf install ruby ruby-devel
sudo dnf group install "Development Tools"
```

### Debian

```sh
sudo apt-get install ruby-full build-essential
```

### Gentoo

```sh
sudo emerge -av jekyll
```

or

```sh
sudo emerge --ask --verbose jekyll
```

### ArchLinux

```sh
sudo pacman -S ruby base-devel
```

### OpenSUSE

```sh
sudo zypper install -t pattern devel_ruby devel_C_C++
sudo zypper install ruby-devel
```

### Clear Linux

```sh
sudo swupd bundle-add ruby-basic
```
## Install Jekyll

Follow the instructions for [Ubuntu](../ubuntu/).
