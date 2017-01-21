# cdpath.sh

A simple CLI for handling the CDPATH environment variable.
**Tested on Bash and ZSH**.

### What's CDPATH?

`CDPATH` is an environment variable present on Unix-based systems that allows you to create shortcuts to any directory on your system, which will be accessible by using the `cd` command. Consider the directory: `$HOME/company/projects/my_project`. With `CDPATH`,
you can access it by defining a shortcut (the name, though, must be the last directory name):
```
$ cd my_project
~/company/projects/my_project
```
But, for that to happen, you'd have to `export CDPATH` with the following structure, and keep it saved on your shell's `rc file (.bashrc, .zshrc...)`:
```
$ export CDPATH=".:my_project:$HOME/company/projects/"
```

## Using cdpath.sh

By using `cdpath.sh`, you can not only have more control over the paths you choose to give a shortcut, but you can manage them with a simple interface.

### Sumary:

  - [Base Command]()
  - [Asking for help]()
  - [Adding a path/shortcut]()
  - [Removing a path/shortcut]()
  - [Listing paths/shortcuts]()
  - [Installing the `.cdpath` file]()
  - [Uninstalling the `.cdpath` file]()

#### Base Command

By typing only `cdpath`, you'll see this:
```
$ cdpath
usage: cdpath [-h] [-r] [-l] [-i] [-u] < name > < path >
See "cdpath -h" for help.
```

#### Asking for help

```
$ cdpath -h
cdpath basic usage: "cdpath < name > < path >"
    name    The path's shortcut, called with "cd"
    path    The path to link the name with

cdpath options:
    -h    Shows help
    -r    Removes a path from cdpath (e.g. "cdpath -r <name>")
    -l    Lists all mapped paths
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
There's no path mapped to "another_folder"
```

#### Listing paths/shortcuts

#### Installing the `.cdpath` file

#### Uninstalling the `.cdpath` file
