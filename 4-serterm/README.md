# Part IV: Serial terminal

My own serial terminal.

Work in progress.

## Buttons

- **A**: Send the original HID USB scan code for unmapped keys (default: send *null*).
- **B**: Show ASCII gliphs for control characters (default: interpret some control characters).

## Terminfo

This is the `eyc.inf` terminfo file:

    eyc|Electronica y ciencia Text terminal,
      am,
      cols#60,
      lines#17,
      cr=^M, cud1=^J, clear=^L,
      cup=^T%p1%' '%+%c%p2%' '%+%c,cub1=^H,
      home=^T  ,
      it#8,ht=^I,
      acsc=l\332m\300k\277j\331q\304x\263u\264t\303n\305v\301w\302O\333a\261o\337s\334,

Compile it with:

    sudo tic -ts -v eyc.inf


## Components

UART from https://github.com/alexforencich/verilog-uart

