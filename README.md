# Temperature Icon

This program reads the device average temperature on Linux and shows corresponding icon in the tray.

The icons suppose temperature levels from cold to dangerously hot:

<div>
    <img src="icons/ok-0.png" width="25px">
    <img src="icons/ok-1.png" width="25px">
    <img src="icons/ok-2.png" width="25px">
    <img src="icons/warning-1.png" width="25px">
    <img src="icons/warning-2.png" width="25px">
    <img src="icons/bad-1.png" width="25px">
</div>

## Gettng Started

### Prerequisties

* **sensors** - utility for reading the temperatrues.
* **valac** - the Vala compiler.
* **libgtk2.0**
* **libgtk2.0-dev**

### Compilation

```bash
# Go into project folder.
$ cd tp-icon

# Run compiler.
$ sh compile.sh

# Run the compiled executable file.
$ ./tp-icon
```

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Copyright (c) 2018 Jed Dark