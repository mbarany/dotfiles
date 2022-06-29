# Installation

1. Download and run [SpoonInstall](https://www.hammerspoon.org/Spoons/SpoonInstall.html)

2. Click "open config" from the Hammerspoon menu bar item and paste the following config:

   ```lua
   hs.loadSpoon("SpoonInstall")

   spoon.SpoonInstall.repos.ShiftIt = {
      url = "https://github.com/peterklijn/hammerspoon-shiftit",
      desc = "ShiftIt spoon repository",
      branch = "master",
   }

   spoon.SpoonInstall:andUse("ShiftIt", { repo = "ShiftIt" })

   spoon.ShiftIt:bindHotkeys({
     left = {{ 'ctrl', 'alt', 'cmd' }, 'left' },
     right = {{ 'ctrl', 'alt', 'cmd' }, 'right' },
     up = {{ 'ctrl', 'alt', 'cmd' }, 'up' },
     down = {{ 'ctrl', 'alt', 'cmd' }, 'down' },
     upleft = {{ 'ctrl', 'alt', 'cmd' }, '1' },
     upright = {{ 'ctrl', 'alt', 'cmd' }, '2' },
     botleft = {{ 'ctrl', 'alt', 'cmd' }, '3' },
     botright = {{ 'ctrl', 'alt', 'cmd' }, '4' },
     maximum = {{ 'ctrl', 'alt', 'cmd' }, 'm' },
     toggleFullScreen = {{ 'ctrl', 'alt', 'cmd' }, 'f' },
     toggleZoom = {{ 'ctrl', 'alt', 'cmd' }, 'z' },
     center = {{ 'ctrl', 'alt', 'cmd' }, 'c' },
     nextScreen = {{ 'ctrl', 'alt', 'cmd' }, 'n' },
     previousScreen = {{ 'ctrl', 'alt', 'cmd' }, 'p' },
     resizeOut = {{ 'ctrl', 'alt', 'cmd' }, '=' },
     resizeIn = {{ 'ctrl', 'alt', 'cmd' }, '-' }
   });
   ```
