# How to

Load the file `fontmenu.el`. A buffer named `*Font Menu*` is created.
This buffer displays a sample text in all available fonts, as below.

![Default behaviour on Emacs 24.5.1](images/Screenshot from 2016-11-22 10-09-32.png)

## Customize the Sample Text and Script 

In this buffer,

1. Press `t` to change the sample text to, say, `ஸ்ரீ ஜம்புநாதன்`.
2. Press `s` to narrow the fonts to a chosen script, say `tamil`.

The buffer now displays the new sample text only in those fonts that
support the chosen script, as below.

![Behaviour on Emacs 24.5.1, with a chosen text and script](images/Screenshot from 2016-11-22 10-10-42.png)

## Experiment with different fonts for the frame

You can press `C-m` in `*Font Menu*` buffer to change the frame font to
the one under current line.

# Issues on Emacs 25.1.1

Above steps were repeated on `Emacs 25.1.1`.  The library works no
longer the same.  This seems like a regression in `Emacs 25.1.1`.

![Default behaviour on Emacs 25.1.1](images/Screenshot from 2016-11-22 10-11-34.png)

![Behaviour on Emacs 25.1.1, with a chosen text and script](images/Screenshot from 2016-11-22 10-12-22.png)
