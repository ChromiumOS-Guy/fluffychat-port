# FluffyChat-Port

A port of modern fluffychat to Ubuntu Touch

## Known Issues:
* OSK takes a bit of time to load due to plugin initalizing last. (not fixable)
* No hardware acceleration (fix coming with mir2.x subsurface support)
* Will crash if opened from OpenStore. (fix coming with mir2.x subsurface support)
* Seperate Clipboard (copy/paste) then rest of system (fix coming with mir2.x subsurface support)
* Opens on a weird XWayland transparent window you need to manually switch to the correct window.

* #### Potentially fixable by Fluffychat team:
    * Flutter adaptive ui is not adaptive and doesn't recognize its in portrait.
    * You cannot delete through OSK for some reason (every other button works)

* #### LANDSCAPE Issues:
    * Inputs on the right side of the screen do not work in landscape mode (fix coming when [this](https://gitlab.com/ubports/development/core/lomiri/-/merge_requests/207) is merged)

if you want to contribute or check on the progress on the subsurface support go [here](https://gitlab.com/ubports/development/core/qtmir/-/merge_requests/83)

### License

Copyright (C) 2025  ChromiumOS-Guy

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3, as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranties of MERCHANTABILITY, SATISFACTORY
QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
