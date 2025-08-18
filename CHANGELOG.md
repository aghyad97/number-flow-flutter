## 1.0.2

- **Improvements:**
  - Add startFromZero to enforce change even after render in case you are fetching from cache before render with delay
  - Add one more example to showcase startFromZero

## 1.0.1

- **Bug Fixes:**

  - Fixed deprecated `withOpacity` usage, replaced with `withValues(alpha: ...)` for Flutter compatibility
  - Removed unused `_previousValue` field to eliminate linter warnings
  - Updated constructor to use `super.key` instead of explicit key parameter
  - Made `_digitTransitions` list final and removed unused `_previousText` field

- **Code Quality:**
  - Improved code cleanliness by removing redundant variables
  - Enhanced compatibility with latest Flutter versions

## 1.0.0

- **Initial Release:**
  - Smooth digit-by-digit number animations with randomized spin directions
  - Animated width transitions with faded edges when digit count changes
  - Comprehensive number formatting support (currency, percentages, compact notation)
  - Custom animation curves (elastic, bounce, spring, smooth, anticipate)
  - High performance 60fps animations optimized for mobile
  - Accessibility support with motion preference respect
  - Extensive customization options for styling, timing, and behavior
  - Real-world examples for e-commerce, dashboards, gaming, and financial apps
  - Full Flutter port of the popular JavaScript number-flow library
