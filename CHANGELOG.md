## Unreleased
- Add `isWebOrDesktop` to ResponsiveBuilder. This will default to kIsWeb. 

## 0.4.0-nullsafety.1

- Adds null safety and correct small refined sizing

## 0.3.0

- Adds the refined sizing functionality

## 0.2.0+2

- Added `getValueForScreenType` functionality to the readme

## 0.2.0+1
- export the sizing config which I forgot to do first time.

## 0.2.0

- Adds responsive sizing config for global breakpoint setting

## 0.1.9

- Reverted the change for returning the mobile layout when break points doesn't define any.

## 0.1.8+1

- readme updates

## 0.1.8

- Changed enum naming to lowerCamelCase to follow convention
- Add a return for mobile when no breakpoints match

## 0.1.7

- Made 600 inclusive for tablet devices and 900 inclusive for desktop

## 0.1.6

- Added ScreenTypeValue builder to allow us to return different values depending on the screen type

## 0.1.4+1

Changelog styling updates

## 0.1.4

- Added optional screen break points definition to pass in to the ResponsiveBuilder or the ScreenLayoutView.

## 0.1.3

- Added shorthand bool properties to sizing information to check which device screen type is currently being show.

## 0.1.2

- Updated screen type calculation to account for being on the Web. Width was swapping with the height when it got too wide so we're checking for web explicitly and using the width of the window.

## 0.1.1

- Update the ScreenTypeLayout widget to use an incremental layout approach. If the desktop isn't supplied and we're in desktop mode we check if there's a tablet layout and show that, otherwise we show the mobile layout.

## 0.1.0

- Added initial widgets required for a clean responsive UI architecture.
