2A
This file has a skybox, a moving terrain that takes in texture and changes
colors depending on height, and also has reflective water. The water uses
Perlin noise.

2B
This file uses GPUParticleSystem with an added noise function. It's strange,
because it looked like it was already had built-in noise. However, in case
that doesn't apply for the noise criteria, I added some noise displacement to
it. Adding the noise added distance between each particle. I didn't like that
because it broke the rainbow, so I have another version that doesn't use this
added noise.

The particle system itself creates a rainbow trail.

Credits:
Image/art for hw2A was downloaded from:
HW2A: https://opengameart.org/content/generic-platformer-tiles
      https://www.colorcombos.com/colors/FF0000 (same for 00FF00 and 0000FF)
HW2B: https://opengameart.org/content/sky-box-sunny-day