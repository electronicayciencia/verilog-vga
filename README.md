# Verilog VGA

This is a beginner project to learn how do LCD displays and FPGA work.

The used LCD is 480x272 4.3" TFT screen.

## Part I: Patterns

Draw basic preconfigured patterns.

Repository:

- [1. Patterns](1-patterns)

Main post (spanish): 

- [Pantalla LCD con Tang Nano I. Patrones](https://www.electronicayciencia.com/2021/11/lcd_tang_nano_I_patrones.html)

Patterns are:

### Filled screen

Fill all pixels with the same color. Just to check that your hsync and vsync signals are right.

![](https://www.electronicayciencia.com/assets/2021/11/lcd_tang_nano_I_patrones/img/filled_hsync.jpg)

### Edge frame

To check that your timing and x/y coordinates are syncronized.

![](https://www.electronicayciencia.com/assets/2021/11/lcd_tang_nano_I_patrones/img/pat_edge.jpg)

### Checkboard

Well, it's nice and classic.

![](https://www.electronicayciencia.com/assets/2021/11/lcd_tang_nano_I_patrones/img/pat_checkboard.jpg)

### Color gradient

To display basic colors and its combinations.

![](https://www.electronicayciencia.com/assets/2021/11/lcd_tang_nano_I_patrones/img/pat_gradient.jpg)



## Part II: Images

Draw images from ROM or RAM.

Repository:

- [2. Images](1-image)

Main post (spanish): 

- [Gráficos VGA con FPGA Tang Nano parte II. Imágenes](https://www.electronicayciencia.com/2021/12/lcd_tang_nano_II_imagenes.html)

4 sub-projects:

### image_mono

1-bit image. To learn how to use ROM, synchronize signals and adjust image size.

![](https://www.electronicayciencia.com/assets/2021/12/lcd_tang_nano_II_imagenes//img/mono.jpg)

### mono_static

Writing white noise to video framebuffer. To learn how to use Semi Dual Port BRAM.

![](https://www.electronicayciencia.com/assets/2021/12/lcd_tang_nano_II_imagenes//img/static.gif)

### image_4c

2-bit image. Imitate CGA color palettes.

![](https://www.electronicayciencia.com/assets/2021/12/lcd_tang_nano_II_imagenes//img/4c_palette0.jpg)

![](https://www.electronicayciencia.com/assets/2021/12/lcd_tang_nano_II_imagenes//img/4c_palette1.jpg)

### led_counter

Filling screen with textures.

![](https://www.electronicayciencia.com/assets/2021/12/lcd_tang_nano_II_imagenes//img/led_counter.gif)


