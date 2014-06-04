# Bento-Qemu

Bento-Qemu is a Thor-based extension of Chef Software's [Bento](http://opscode.github.io/bento) project that encapsulates [Packer](http://packer.io) templates for building [Vagrant](http://vagrantup.com) baseboxes. Bento already provides template and boxes for "core" Vagrant providers (Virtualbox and VMWare) but does not include Qemu-related support for those who use [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt) or [vagrant-kvm](https://github.com/adrahon/vagrant-kvm) plugins with Vagrant.  Bento-Qemu helps with this.

##  tl;dr
Bento-Qemu extends Bento by programatically adding a Qemu builder to each Bento packer template by "mutating" existing Virtualbox builders into Qemu builders. So... all Bento templates with Virtualbox support will also have Qemu support. It can also convert Qemu artifacts into vagrant-libvirt boxes (no support yet for vagrant-kvm).
## Description

TODO: Description

## Features

## Examples

    require 'bento_qemu'

## Requirements

## Install

    $ gem install bento_qemu

## Synopsis

    $ bento_qemu

## Copyright

Copyright (c) 2014 Brian Clark

See LICENSE.txt for details.
