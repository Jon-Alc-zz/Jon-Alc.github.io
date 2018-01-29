1A
NOTE: There's a load-time on the textures.
Each object has its own set of lights and texture being projected onto it as it rotates.
Each of the objects seem partially rendered, but that's because of arguments I specified.
I liked seeing inside the shapes, and seeing how it would be rendered if it were incomplete.

1B
I found the image from opengameart.org. I found art I liked, then edited the image to be 512
by 512. After, I looked at http://setosa.io/ev/image-kernels/ to understand more about
kernels. I liked the emboss effect, since I liked its sharpness and emphasis on outlines.
Because the matrix is diagonally symmtrical, the X and Y kernels ended up being the same.

1C
I came up with the effect on my own and by accident. There are 7 states, one for each color
in the color spectrum (ROYGBIV). For an explanation of how my shader fits into the cellular
automata rules:

1: The pixels are still a 2D cell grid
2: There are 7 different cell states, one for each color of the rainbow
3: The threshold value is determined by a cell's 8 neighbors. If there's more of one color,
   the cell switches to that color. However, this caps out at 4. If more than half of the
   neighbors are one color, then the cell switches to the second most color.
4: The initial state is weighted toward cool colors (GBIV) rather than warmer ones (ROY).
5: Neighbor colors are counted. The current cell's color will switch to the color there's
   more of, unless more than half of the cells are that color.
6: Repeat.

The state of this cellular automata ends in a static motion of Red, Orange, and Yellow.

Credits:
Image/art for hw1B was downloaded from:
HW1A: https://www.textures.com
HW1B: https://opengameart.org/content/generic-platformer-tiles
      http://setosa.io/ev/image-kernels/
HW1D: http://www.scholarlygamers.com/review/2017/09/12/killing-floor-2-xbox-one-review/