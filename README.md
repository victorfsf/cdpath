# cdpath.sh

A simple CLI for handling the CDPATH environment variable.
**Tested on Bash and ZSH**.

### What's CDPATH?

`CDPATH` is an environment variable present on Unix-based systems that allows you to create shortcuts to any directory on your system, which will be accessible by using the `cd` command. Consider the directory: `$HOME/company/projects/my_project`. With `CDPATH`,
you can access it by defining a shortcut (the name, though, must be the last directory name):
```shell
$ cd my_project
~/company/projects/my_project
```
But, for that to happen, you'd have to `export CDPATH` with the following structure, and keep it saved on your shell's `rc file (.bashrc, .zshrc...)`:
```shell
$ export CDPATH=".:my_project:$HOME/company/projects/"
```
## Installation

### Manual
Download the file `cdpath.sh` to any directory you'd like (usually, I'd use `/usr/local/bin/`):
###### For BASH:
```
curl -o /usr/local/bin/cdpath.sh https://raw.githubusercontent.com/victorfsf/cdpath/master/cdpath/cdpath.bash.sh
```
###### For ZSH:
```
curl -o /usr/local/bin/cdpath.sh https://raw.githubusercontent.com/victorfsf/cdpath/master/cdpath/cdpath.zsh.sh
```
Then, add the following line to your shell's `rc file (.bashrc, .zshrc...)`:
```shell
source "/path/to/cdpath.sh"
```
So, if you chose `/usr/local/bin/`:
```shell
source "/usr/local/bin/cdpath.sh"
```
Then, restart or source your shell:
```shell
$ . ~/.zshrc
```
###### OR
```shell
$ . ~/.bashrc
```

### Using install.sh
Download or clone this repository. Then, execute the following commands:
```
$ chmod +x render.sh install.sh
$ ./install.sh -<shell: zsh, bash>
```
So, if you're using ZSH, you'd need to run:
```
$ ./install.sh -zsh
```
And if you're using Bash:
```
$ ./install.sh -bash
```
Then, restart or source your shell:
```shell
$ . ~/.zshrc
```
###### OR
```shell
$ . ~/.bashrc
```

## Using cdpath.sh

By using `cdpath.sh`, you can not only have more control over the paths you choose to give a shortcut, but you can manage them with a simple interface.

### Sumary:

  - [Base Command](#base-command)
  - [Asking for help](#asking-for-help)
  - [Adding a path/shortcut](#adding-a-pathshortcut)
  - [Removing a path/shortcut](#removing-a-pathshortcut)
  - [Listing paths/shortcuts](#listing-pathsshortcuts)
  - [Installing the `.cdpath` file](#installing-the-cdpath-file)
  - [Uninstalling the `.cdpath` file](#uninstalling-the-cdpath-file)

#### Base Command

By typing only `cdpath`, you'll see this:
```
$ cdpath
usage: cdpath [-h] [-r] [-l] [-i] [-u] <name> <path>
See "cdpath -h" for help.
```

#### Asking for help

```
$ cdpath -h
cdpath basic usage: "cdpath <name> <path>"
    name    The path's shortcut, called with "cd"
    path    The path to link the name with

cdpath options:
    -h    Shows help
    -r    Removes a shortcut from cdpath (e.g. "cdpath -r <name>")
    -l    Lists all shortcuts and their respective paths
    -i    Installs cdpath
    -u    Uninstalls cdpath (use [-y] to skip input)
```

#### Adding a path/shortcut

`cdpath.sh` accepts any of the following path structures:
```
$ cdpath my_project $HOME/company/projects/
```

```
$ cdpath my_project $HOME/company/projects/my_project
```
```
$ cdpath my_project .
```

```
$ cdpath my_project company/projects/
```

```
$ cdpath my_project company/projects/my_project
```

#### Removing a path/shortcut

`cdpath.sh` will loop through the arguments after the `-r` option and try to remove all of the given shortcuts:
```
$ cdpath -r my_project
Successfully removed "my_project"
```

```
$ cdpath -r my_project another_folder
Successfully removed "my_project"
There's no shortcut named "another_folder"
```

#### Listing paths/shortcuts

```
$ cdpath -l
Shortcuts:
    my_project -> /home/user/company/projects/my_project
```

#### Installing the `.cdpath` file

*This action will be performed when you add a new shortcut*, but if you want to create and configure the `~/.cdpath` file (in case you changed shells and that shell isn't properly configured, for example), you can just call:
```
cdpath -i
```

#### Uninstalling the `.cdpath` file

To remove the `~/.cdpath` file and it's `source` from the shell's rc file, just type:
```
$ cdpath -u
Are you sure you want to remove cdpath?
All your shortcuts will be lost! (y/N): 
```
###### Or, to skip input:
```
$ cdpath -u -y
Uninstalling cdpath...
Done.
```
