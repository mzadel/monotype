
# Monotype

Banish distractions and get down to writing.



## Overview

- Monotype is a live USB system that restricts you to a simple text editor.
  Boot from your USB key and start writing
- Edits to the text are saved to the USB key, which can subsequently be read
  for importing into your usual OS
- It runs entirely from RAM, and does not touch your existing operating system
  installation in any way



## About

Monotype is a live USB system that provides you with one application, and one
application alone: a text editor.  It allows you to focus on your writing
without the distractions of the web or your email.  Basically, it turns your
computer into a typewriter.  Insert the USB key, boot from it, and write away.

Everything you write is saved back to the USB key.  Quit the editor and reboot
to go back to your existing operating system, which is not touched in any way.

To import your writing into your usual word processor for further editing,
insert the key into any computer with a standard OS (Windows/Linux/Mac), and
your writing will be available on the key in the file `text/text.txt`.

The difference between Monotype and other "distractionless" writing
applications is that Monotype is a self-contained, single-task operating system
that provides no access to your networking hardware or other applications.



### Motivation and design

Our computers serve as
both tools for work and tools for entertainment.  This can be a problem,
since when you're trying to focus on work, your entertainment is right there in
front of your face.  It's too easy to quickly check your email or look at your
favourite blog while you should be working.

Monotype is designed in the vein of tools that help lock you out of the
entertainment and distractions on your computer.  Instead of locking them out,
however, it excludes them altogether: Monotype provides no other features other
than allowing you to write your text.

Part of the idea behind the system is to be as simple and minimal as possible, so
the interface is text-oriented and doesn't include any graphics.  This might be
a bit raw for some users, but it's intended to highlight the fact that you
don't need fancy software to write.

In the spirit of simplicity and focus, no choices are provided to the user.
You may only edit one file, called text.txt.  Also, care has been taken in
disallowing users from getting root or accessing a shell.  This is done to
protect haxxors from themselves.  Programmers will engage in all manner of
technical play/configuration/tomfoolery to avoid doing work that they may not
like doing (that is, writing).



## Building and installation

Monotype is designed to be built from a Debian stable installation.  To build,
just run the `build.sh` script.  This will build `initrd.gz`, as well as the
main image to burn to the USB key.

You will need the following packages to build Monotype:

    sudo apt-get install parted dosfstools mtools syslinux

Once you build the image (`monotype.img`), write it to your USB key:

    sudo dd if=monotype.img of=/dev/sdX

where `/dev/sdX` should be replaced with the device that corresponds to
your USB key.

**WARNING:** this will destroy whatever's currently on the key, so make sure
you back it up if you need the data on it.  Also, be very, very careful when
specifying the device for your USB key!  You could potentially delete your
whole operating system.



## Technical Details

Monotype is implemented as a live Linux system with customised boot scripts
that launch straight into the text editor.  It doesn't use a graphical
environment and only contains a minimum set of userspace binaries.  It's
completely contained in an initrd, and is based on Debian stable.

The initrd is created using an adapted version Debian's initramfs-tools
package.  A custom init script and other startup scripts were written for the
initrd.  An image for writing is then created, which includes the generated
initrd, a stock kernel, and syslinux.

The build system is meant to be run from within a Debian installation, and it
refers to system files outside of the source tree.  It probably won't build on
other distributions, save for Debian derivatives (like Ubuntu).

Since the system is just an initrd, it runs entirely from ram.

The `monotype.img` file is created as a 20mb image.  This means that when you
write it to a 4gb USB key, you'll only be able to access 20mb.  The image
writing process completely clobbers whatever partitions and filesystems were
previously on the key.  In the interest of keeping the installation simple for
typical users, I opted to provide a small image that totally monopolizes the
key.  Workarounds to preserve the key's whole capacity are left as an exercise
to the reader.



## Alternatives

- Do it yourself: take a basic text-only or graphical Linux installation and
  rig it up to boot straight into a text editor, saving in the local
  filesystem.  You'd configure the system's `inittab`, the user account's
  `.bashrc`,  and/or the user's `.xinitrc` files to do this.
  Articles on setting up a Linux kiosk (e.g. for web browsing) are applicable here.
    - For example:
      How to Turn Your Laptop Into a Typewriter. Erez Zukerman, PCWorld (2012)<br/>
      <http://www.pcworld.com/article/259236/how_to_turn_your_laptop_into_a_typewriter.html>
- Text editors that aim to block out visual distractions:
    - [WriteRoom](http://www.hogbaysoftware.com/products/writeroom) (Mac, paid)
    - [PyRoom](http://pyroom.org/) (GPL, cross-platform)
    - [Dark Room](http://they.misled.us/dark-room) (Windows, free)
    - [Write Monkey](http://writemonkey.com/index.php) (Windows, free)
    - [Typewriter](http://www.lifehackingmovie.com/2009/05/18/typewriter-minimal-text-editor-freeware/)  (Java, cross-platform, free)



## License and Disclaimer

Monotype is provided under the terms of the GNU GPL.  The source files that
have been copied from Debian are subject to their respective licenses.

Please note: this is alpha software and I cannot be held responsible for any
damage to your computer or loss of work that results from its installation or
use.  Be sure to back up your files regularly and use common sense.



## Author

Mark Zadel, 2012

Email: `zadel@music.mcgill.ca`

Feedback welcome.

