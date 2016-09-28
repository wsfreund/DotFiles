# DotFiles

The default configurations are always conservative and disables many tools
which can improve produtivity. In this package, many configurations that were
found to be useful through these years are shared and enabled by default so
that new comers can improve their learning curve to the command line.  Everyone
is invited to help in this task so that users can make the most of the dark
terminal (yes, b/c dark terminals rulez!) world.

Mainly, three major command line behaviors will be changed: the shell
interpreter itself will be set to the Z shell, whereas most of the systems use
bash as default shell; the command line editor 'vim' will be installed with lua
support and many plugins will be enabled by default; and add some better
configuration for the screen command.

The user previous configuration, when existent, will be copied to
~/DotFiles/backups folder and can be restored by simply replacing the links
created by DotFiles to the old files.

# Dependencies

## MacOS

In order to install this on MacOS, make sure you have installed the following
components:

 - zsh >= 5.0.7 (`zsh --version`).
 - tmux >= 2.2 (`tmux -V`);
 - git

If you don't have any one of the above, I suggest their installation with
[macports](https://www.macports.org) project (`sudo port install <program>`) or
[brew](http://brew.sh) (`brew install <program>`)

The zsh will need a bit more work, as you will need to add it to your
`/etc/shells` file (e.g. `sudo echo "/usr/local/Cellar/zsh/*/bin/zsh" >>
/etc/shells` --- supposing you only have one zsh installed and you brew
installed it) and, finally, set it as the default shell by doing `chsh -s
/usr/local/Cellar/zsh/*/bin/zsh`.

## Unix

The main dependency is git itself, the program will attempt to install the
dependencies on your user account, but many of them have dependencies on their
own and their installation may fail. If you are facing troubles when attempting
to install the DotFiles, try to install the dependency yourself. 
It is also possible to avoid having your own version of a program by installing
the dependencies on the system if you have root access. The following
depenciencies are installed if not available:

 - zsh >= 5.0.7 (`zsh --version`).
 - tmux >= 2.2 (`tmux -V`);
 - git 

# Installation

Make sure you have git installed on your system and clone the
repository into your home directory:

```
git clone https://github.com/wsfreund/DotFiles.git
```

And then install it:

``` 
cd DotFiles
./install.sh
```

# Uninstall

The user configuration prior to DotFiles installation, when existent, are
copied to ~/DotFiles/backups folder. Simply remove the links created by
DotFiles and move the backups to their original system places.

# License and warranty

Copyright © 2016 Werner Spolidoro Freund `wsfreund__at__that_g_started_company_email_domain`

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

This program is free software. It comes without any warranty, to the
extent permitted by applicable law. You can redistribute it and/or
modify it under the terms of the Do What The Fuck You Want To Public
License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.
