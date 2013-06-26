haxelib run Basis build.basis android
cd bin/android/bin
adb uninstall org.tbyrne.guise.basisAndroid
adb install null-debug.apk
adb shell am start org.tbyrne.guise.basisAndroid/org.tbyrne.guise.basisAndroid.BasisActivity

pause