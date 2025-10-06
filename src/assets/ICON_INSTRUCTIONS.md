# App Icon Setup Instructions

## Creating Your App Icon

1. Create a 1024x1024 PNG image for your app icon
2. Save it as `assets/icon.png`

3. For Android adaptive icons, also create:
   - `assets/icon_foreground.png` (1024x1024 with transparent background)
   - The background color is already set to #6200EE (app primary color)

## Generating Icons

Once you have the icon images, run:

```bash
flutter pub run flutter_launcher_icons
```

This will generate all required icon sizes for iOS and Android.

## Icon Design Tips

- Use simple, recognizable imagery
- Avoid fine details that won't be visible at small sizes
- Consider using a graduation cap or student-related symbol
- Match the app's purple (#6200EE) color scheme
- Ensure good contrast for visibility

## Icon Specifications

- **iOS**: 1024x1024 PNG (App Store)
- **Android**: 1024x1024 PNG (Adaptive icon)
- **Android Foreground**: 1024x1024 PNG with transparency
- **Android Background**: Solid color (#6200EE)

## Quick Start (Temporary)

For development, you can use a simple colored square:
1. Create a 1024x1024 image with purple background (#6200EE)
2. Add white text "SM" in the center (Student Master)
3. Save as `assets/icon.png` and `assets/icon_foreground.png`
