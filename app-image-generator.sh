# This script will generate application icons from an SVG file.
# It requires librsvg to be installed.

# The script will output a single folder, 'output', with subfolders for Android and IOS.
# The subfolders will contain the images.
# Params: (file) - the filename of the svg input file (should end with .svg)

# The script will generate app icons for iOS and splash screen logo's for Android & iOS.
# Android App Icons can be created through Asset Studio, thus this script does not have to handle that.
# Splash screen logo's assume that the logo is 2/3 the screen with & it's a square.

# =================== Script Startup checks =============================

if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "A filename is required"
    return 1
fi

if [[ ! $1 == *.svg ]]
  then 
    echo "A filename should end with the SVG file extension (.svg)"
    return 1
fi

# =================== Make Directories =============================
# Remove the old output folder if it exists
output_folder="$PWD/output"
if [ -d "$output_folder" ]
    then
        echo "Removing old output folder"
        rm -rf $output_folder
fi

echo "Making the needed directories"

# Make the needed directories 
mkdir output
mkdir output/android
mkdir output/android/drawable-ldpi
mkdir output/android/drawable-mdpi
mkdir output/android/drawable-hdpi
mkdir output/android/drawable-xhdpi
mkdir output/android/drawable-xxhdpi
mkdir output/android/drawable-xxxhdpi
mkdir output/ios
mkdir output/ios/AppIcon.appiconset
mkdir output/ios/LaunchImage.imageset
mkdir output/ios/LaunchImage.imageset/portrait
mkdir output/ios/LaunchImage.imageset/landscape

# =================== Make Android Images =============================
echo "Creating the Android Splash Screen Logo's"

rsvg-convert -w 135 -h 135 $1 > output/android/drawable-ldpi/logo.png

rsvg-convert -w 215 -h 215 $1 > output/android/drawable-mdpi/logo.png

rsvg-convert -w 320 -h 320 $1 > output/android/drawable-hdpi/logo.png

rsvg-convert -w 480 -h 480 $1 > output/android/drawable-xhdpi/logo.png

rsvg-convert -w 640 -h 640 $1 > output/android/drawable-xxhdpi/logo.png

rsvg-convert -w 855 -h 855 $1 > output/android/drawable-xxxhdpi/logo.png

# =================== Make IOS Images =============================
echo "Creating the IOS App Icons"

rsvg-convert -w 20 -h 20 $1 > output/ios/AppIcon.appiconset/Icon-20.png

rsvg-convert -w 29 -h 29 $1 > output/ios/AppIcon.appiconset/Icon-29.png

rsvg-convert -w 40 -h 40 $1 > output/ios/AppIcon.appiconset/Icon-40.png

rsvg-convert -w 58 -h 58 $1 > output/ios/AppIcon.appiconset/Icon-58.png

rsvg-convert -w 60 -h 60 $1 > output/ios/AppIcon.appiconset/Icon-60.png

rsvg-convert -w 76 -h 76 $1 > output/ios/AppIcon.appiconset/Icon-76.png

rsvg-convert -w 80 -h 80 $1 > output/ios/AppIcon.appiconset/Icon-80.png

rsvg-convert -w 87 -h 87 $1 > output/ios/AppIcon.appiconset/Icon-87.png

rsvg-convert -w 120 -h 120 $1 > output/ios/AppIcon.appiconset/Icon-120.png

rsvg-convert -w 152 -h 152 $1 > output/ios/AppIcon.appiconset/Icon-152.png

rsvg-convert -w 167 -h 167 $1 > output/ios/AppIcon.appiconset/Icon-167.png

rsvg-convert -w 180 -h 180 $1 > output/ios/AppIcon.appiconset/Icon-180.png

rsvg-convert -w 1024 -h 1024 $1 > output/ios/AppIcon.appiconset/Icon-1024.png

echo "Creating the IOS Splash Screen Logo's"

rsvg-convert -w 320 -h 320 $1 > 'output/ios/LaunchImage.imageset/Launch-Image-320x320@1x.png'
rsvg-convert -w 640 -h 640 $1 > 'output/ios/LaunchImage.imageset/Launch-Image-320x320@2x.png'
rsvg-convert -w 960 -h 960 $1 > 'output/ios/LaunchImage.imageset/Launch-Image-320x320@3x.png'

# Portrait

# iPhone Xs Max
rsvg-convert -w 1242 -h 2688 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-1242x2688.png

# iPhone Xr
rsvg-convert -w 828 -h 1792 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-828x1792.png

# Iphone X / Xs
rsvg-convert -w 1125 -h 2436 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-1125x2436.png

# Iphone Retina HD 5.5"
rsvg-convert -w 1242 -h 2208 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-1242x2208.png

# Iphone Retina HD 4.7"
rsvg-convert -w 750 -h 1334 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-750x1334.png

# Iphone 2x (iOS 5,6, 7+)
rsvg-convert -w 640 -h 960 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-640x960.png

# Iphone Retina 4 (iOS 5,6, 7+)
rsvg-convert -w 640 -h 1136 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-640x1136.png

# iPad 1x (iOS 5,6, 7+)
rsvg-convert -w 768 -h 1024 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-768x1024.png

# iPad 2x (iOS 5,6, 7+)
rsvg-convert -w 1536 -h 2048 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-1536x2048.png

# iphone 1x
rsvg-convert -w 320 -h 480 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-320x480.png

# iPad 1x (no status bar)
rsvg-convert -w 768 -h 1004 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-768x1004.png

# iPad 2x (no status bar)
rsvg-convert -w 1536 -h 2008 $1 > output/ios/LaunchImage.imageset/portrait/SplashScreenLogo-1536x2008.png

# Landscape

# iPhone Xs Max
rsvg-convert -w 2688 -h 1242 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-2688x1242.png

# Iphone Xr
rsvg-convert -w 1792 -h 828 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-1792x828.png

# Iphone X / Xs
rsvg-convert -w 2436 -h 1125 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-2436x1125.png

# Iphone Retina HD 5.5"
rsvg-convert -w 2208 -h 1242 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-2208x1242.png

# iPad 1x
rsvg-convert -w 1024 -h 768 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-1024x768.png

# iPad 2x
rsvg-convert -w 2048 -h 1536 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-2048x1536.png

# iPad 1x (no status bar)
rsvg-convert -w 1024 -h 748 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-1024x748.png

# iPad 2x (no status bar)
rsvg-convert -w 2048 -h 1496 $1 > output/ios/LaunchImage.imageset/landscape/SplashScreenLogo-2048x1496.png