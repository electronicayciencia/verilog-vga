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

### Buttons

- **A**: Send the original HID USB scan code for unmapped keys (default: send *null*).
- **B**: Show ASCII gliphs for control characters (default: interpret some control characters).

### LEDs

- **Red**: Sending *break* signal.
- **Green**: Button A is active.
- **Blue**: Button B is active.

### Configuration

Select serial speed editing (src/config.v)[src/config.v].


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

### Raspberry UART

In Raspberry Pi 3, the good UART is usually dedicated to Bluetooth module. And only the *miniuart* is exposed in the GPIO header. Thist *miniuart* does not support parity or break signal. It also derives its baudrate from the processor clock.

In order to use the full featured UART, you must disable bluetooth. To do this, add the following to `/boot/config.txt`:

```
dtoverlay=disable-bt
enable_uart=1
```

You can also force to use the *miniuart* for the bluetooth module. But this is not recomended:

```
dtoverlay=miniuart-bt
```


### Break key

In order to use SAK as a Secure Access Key, add this to the boot sequence:

```
setserial /dev/ttyAMA0 sak
```


## Terminal capabilities

Supports monochrome text only.

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_login.jpg)

Cursor location is also supported:

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_vi.jpg)

And graphical characters, compatible with `dialog` applications:

![](https://www.electronicayciencia.com/assets/2024/01/consola-serie/img/screen_dialog.jpg)

**Break** is invoked using the SysReq key.


### Control character table

|Code  |Caret | Name  |Action
|:----:|:----:|:-----:|------------------------
|`0x00`| `^@` | `NUL` | Do nothing (padding)
|`0x01`| `^A` | `SOH` | 
|`0x02`| `^B` | `STX` | 
|`0x03`| `^C` | `ETX` | 
|`0x04`| `^D` | `EOT` | 
|`0x05`| `^E` | `ENQ` | 
|`0x06`| `^F` | `ACK` | 
|`0x07`| `^G` | `BEL` | Flash the screen (visual bell)
|`0x08`| `^H` | `BS`  | Move cursor back one position
|`0x09`| `^I` | `HT`  | Move cursor to the next multiple-of-8 position
|`0x0a`| `^J` | `LF`  | Move cursor down one position. Scroll if this is the last line
|`0x0b`| `^K` | `VT`  | 
|`0x0c`| `^L` | `FF`  | Clear the screen and home cursor
|`0x0d`| `^M` | `CR`  | Move cursor to first column, same line
|`0x0e`| `^N` | `SO`  | 
|`0x0f`| `^O` | `SI`  | 
|`0x10`| `^P` | `DLE` | (Used for graphics: right arrow)
|`0x11`| `^Q` | `DC1` | (Used for graphics: left arrow)
|`0x12`| `^R` | `DC2` | 
|`0x13`| `^S` | `DC3` | 
|`0x14`| `^T` | `DC4` | Move cursor to #1,#2. See terminfo file
|`0x15`| `^U` | `NAK` | 
|`0x16`| `^V` | `SYN` | 
|`0x17`| `^W` | `ETB` | 
|`0x18`| `^X` | `CAN` | 
|`0x19`| `^Y` | `EM`  | 
|`0x1a`| `^Z` | `SUB` | 
|`0x1b`| `^[` | `ESC` | 
|`0x1c`| `^\ `| `FS`  | 
|`0x1d`| `^]` | `GS`  | 
|`0x1e`| `^^` | `RS`  | (Used for graphics: up arrow)
|`0x1f`| `^_` | `US`  | (Used for graphics: down arrow)
|`0x7f`| `^?` | `DEL` | Move cursor back one position


## Issues

This is a *true* auto-margin terminal. That means it doesn’t allow the last position on the screen to be updated without jumping to the next line or scrolling the screen.

If some curses programs don't work properly, just decrease the width by one column:

    stty cols 59

