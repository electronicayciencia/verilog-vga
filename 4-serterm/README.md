# Part IV: Serial terminal

My own serial terminal.

Main post (spanish):

- Mi propia consola serie (work in progress)

## Internals

### Block diagram

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/serterm.svg)

### Components

- [Control module](src/control/README.md)
- [Keyboard module](src/keyb/README.md)
- [Auxiliary modules](src/misc/README.md)
- [Text engine module](src/text/README.md)
- [Video module](src/video/README.md)
- [UART module](src/uart/README.md)


## Usage

### Terminfo

This is the terminal description file (`eyc.inf`):

    eyc|Electronica y ciencia Text terminal,
      am,
      cols#60,
      lines#17,
      cr=^M, cud1=^J, clear=^L, bel=^G,
      cup=^T%p1%' '%+%c%p2%' '%+%c, cub1=^H,
      home=^T  ,
      it#8,ht=^I,
      acsc=+\020\,\021-\036.\0370\333l\332m\300k\277j\331q\304x\263u\264t\303n\305v\301w\302O\333a\261o\337s\334

Compile it with the following command:

    sudo tic -ts -v eyc.inf

### Session

Add this to your `.bashrc`:

```
case "$TERM" in
    eyc)
      stty rows 17 cols 60 erase ^H werase ^W
      export LC_ALL=C
      export PAGER=more
    ;;
esac
```

### Buttons

- **A**: Send the original HID USB scan code for unmapped keys (default: send *null*).
- **B**: Show ASCII gliphs for control characters (default: interpret some control characters).

### Configuration

Select serial speed editing [src/config.v]

## Terminal capabilities

Supports monochrome text only.

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_login.jpg)

Cursor location is also supported:

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_vi.jpg)

And graphical characters, compatible with `dialog` applications:

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_dialog.jpg)


## Issues

This is a *true* auto-margin terminal. That means it doesn’t allow the last position on the screen to be updated without jumpint to the next line or scrolling the screen.

If some curses programs don't work properly, just decrease the width by one column:

    stty cols 59

