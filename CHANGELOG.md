## [0.1.0] - 2019-10-29

Added initial widgets required for a clean responsive UI architecture.

## [0.1.1] - 2019-11-06

Update the ScreenTypeLayout widget to use an incremental layout approach. If the desktop isn't supplied and we're in desktop mode we check if there's a tablet layout and show that, otherwise we show the mobile layout.

## [0.1.2] - 2019-11-06

Updated screen type calculation to account for being on the Web. Width was swapping with the height when it got too wide so we're checking for web explicitly and using the width of the window.

## [0.1.3] - 2019-11-06

Added shorthand bool properties to sizing information to check which device screen type is currently being show.

## [0.1.4] - 2019-11-11

Added optional screen break points definition to pass in to the ResponsiveBuilder or the ScreenLayoutView.
