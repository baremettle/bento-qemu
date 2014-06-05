# bento_qemu

bento-qemu is a wrapper around Chef Software's
[Bento](http://opscode.github.io/bento) project that assists with creating
[Vagrant](http://vagrantup.com) baseboxes compatible with
[vagrant-libvirt](https://github.com/pradels/vagrant-libvirt) and (eventually)
[vagrant-kvm](https://github.com/adrahon/vagrant-kvm) providers.


## Features
- Uses thor; tasks can be ran from CLI app or as thor tasks using included Thorfile
- Download Bento templates/scripts and add QEMU builders to all templates with a single command
- Compatible with all Bento templates that have a Virtualbox builder (used as basis for creating QEMU builder)
- Create sparse qcow2 libvirt box using qemu-img or virt-sparsify
- Ability to dynamically "strip" Bento's `minimize.sh` script from template on-the-fly during packer build process (template is parsed and injected to packer STDIN). Saves time (and MB) when using virt-sparsify tool downstream to create basebox.
- Other misc. tasks for template validation, cleanup, etc.

## Install / Examples / Etc.
Documentation pending, but here's some currently available commands/tasks
```
$ bento_qemu 
Commands:
  bento_qemu build                         # Run packer build
  bento_qemu clean cache|builds|artifacts  # Clean the house
  bento_qemu help [COMMAND]                # Describe available commands or one specific command
  bento_qemu init                          # Create .bento_qemu.yml configuration file
  bento_qemu libvirt-box TEMPLATE_FILE     # Convert qemu artifact to vagrant-libvirt compatible box
  bento_qemu update-bento                  # Download bento repository
  bento_qemu validate                      # Validate packer templates in bento_dir

```
## Requirements
- thor
- mixlib-shellout
- Packer (generating qcow2 files)
- qemu-img (for building libvirt box)
- virt-sparsify (optional, for box building)
## TODO
- Documentation
- Command(s) to chain packer builds and libvirt box creation
- Build from list
- Build from pattern (e.g. Bento's existing packer build task)

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
