[![Build Status](https://travis-ci.org/baremettle/bento-qemu.svg?branch=master)](https://travis-ci.org/baremettle/bento-qemu)
# bento-qemu

bento-qemu is a wrapper around Chef Software's
[Bento](http://opscode.github.io/bento) project that assists with creating
[Vagrant](http://vagrantup.com) baseboxes compatible with
[vagrant-libvirt](https://github.com/pradels/vagrant-libvirt) and (eventually?)
[vagrant-kvm](https://github.com/adrahon/vagrant-kvm) providers.

**Warning!!** This project is a work-in-progress. The end result (templates and currently hosted boxes)
are fine but the CLI tools need work (I'm a ruby n00b).

## Features
- Uses thor; tasks can be ran from CLI app or as thor tasks using included Thorfile
- Download Bento templates/scripts and add QEMU builders to all templates with a single command
- Compatible with all Bento templates that have a Virtualbox builder (used as basis for creating QEMU builder)
- Create sparse qcow2 libvirt box using qemu-img or virt-sparsify
- Ability to dynamically "strip" Bento's `minimize.sh` script from template on-the-fly during packer build process (template is parsed and injected to packer STDIN). Saves time (and MB) when using virt-sparsify tool downstream to create basebox.
- Other misc. tasks for template validation, cleanup, etc.

## Hosted Baseboxes
The following baseboxes are publicly available and were built using
this project. Note that these baseboxes are effectively the same as
other Bento baseboxes, so they are basic installs and do not include
Chef Client. All boxes listed below are 64-bit and are also discoverable
on [Vagrant Cloud](https://vagrantcloud.com/).

### Libvirt
* [ubuntu-12.04](https://s3.amazonaws.com/bento-qemu/vagrant/libvirt/baremettle-ubuntu-12.04-libvirt.box)
* [ubuntu-14.04](https://s3.amazonaws.com/bento-qemu/vagrant/libvirt/baremettle-ubuntu-14.04-libvirt.box)
* [debian-7.5](https://s3.amazonaws.com/bento-qemu/vagrant/libvirt/baremettle-debian-7.5-libvirt.box)
* [centos-5.10](https://s3.amazonaws.com/bento-qemu/vagrant/libvirt/baremettle-centos-5.10-libvirt.box)
* [centos-6.5](https://s3.amazonaws.com/bento-qemu/vagrant/libvirt/baremettle-centos-6.5-libvirt.box)

## Installation
Currently the best thing to do is to clone this repo and use bundler:

    $ git clone blah
    $ cd blah
    $ bundle install #--path vendor if you wanna throw it away easily

Documentation is pending, but here's the current list of commands:
```
$ bundle exec bento-qemu
Commands:
  bento-qemu build TEMPLATE                # Run packer build
  bento-qemu build-and-box TEMPLATE        # Run packer build followed by libvirt-box
  bento-qemu clean cache|builds|artifacts  # Clean the house
  bento-qemu help [COMMAND]                # Describe available commands or one specific command
  bento-qemu init                          # Create .bento_qemu.yml configuration file
  bento-qemu invoke-from-yaml FILENAME     # Run one or more tasks described in a YAML file
  bento-qemu libvirt-box TEMPLATE_FILE     # Convert qemu artifact to vagrant-libvirt compatible box
  bento-qemu update-bento                  # Download bento repository
  bento-qemu validate                      # Validate packer templates in bento directory
```
The tool uses a small user-configurable YAML file for storing config info.  It can be created with the init command.  Typical initial workflow is something like:
```
$ bundle exec bento-qemu init
$ bundle exec bento-qemu update-bento
$ bundle exec bento-qemu validate
$ bundle exec bento-qemu [build | build-and-box | invoke-from-yaml] etc.
```
The "invoke-from-yaml" is intended to create an automated workflow for builds, etc. A `sample_tasks.yml`
file is included, but any thor task in this app can be ran as long as it exists.

## Requirements
- thor
- mixlib-shellout
- Packer (generating qcow2 files)
- qemu-img (for building libvirt box)
- virt-sparsify (optional, for box building)

## TODO
- Documentation
- Tests and testing
- Build from pattern/wildcard (e.g. Bento's existing packer build task)

## Copyright
```text
Copyright (c) 2014 Brian Clark

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
