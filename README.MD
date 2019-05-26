# 3D Engine

Basic 3D engine made in Lua [LÖVE framework](https://love2d.org/)

Project is trying to resemble the effect that DLC ENERGY achieved using Pygame in his [youtube video](https://youtu.be/g4E9iq0BixA)

## Issues

Note that there are two opposing issues with rendering faces. They start to disappear near the edges of the screen or are causing graphical glitches while being off the screen.

The propotion of this problems is directly controlled by isOnScreen variable which is set to true if `vert_list[v][3]` (basically z coord)
of at least one vertice is `> 2.5`:

```lua
201 if vert_list[v][3] > 2.5 then
202    isOnScreen = true
203    break
204 end
```

[Originally](https://youtu.be/g4E9iq0BixA) it was `> 0` and then the faces never disappeared too early, but graphical glitches were substantially greater - present value is a compromise.

I'll try to fix it completety when the time allows.