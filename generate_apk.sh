#!/usr/bin/env bash
ionic_build="C:/Output/ionic_build.txt"
cordova_build="C:/Output/cordova_build.txt"
apk_output="C:/Users/Tosh/WebstormProjects/Morgregorian/platforms/android/build/outputs/apk/android-release-unsigned.apk"
echo "Please wait... ionic is building.."
  ionic build android &> $ionic_build
  ##exit 1 ## Set a failed return code
for i in "${ionic_build}"
do
  if grep 'BUILD SUCCESSFUL' $ionic_build
    then
      echo "Build generated without any error..."
      elif grep 'Error' $ionic_build
    then
         echo "Oops it's an error..Please check the BUILD output"
  else
        echo "Sorry not found the build"
  fi
done
     echo "Please wait... cordova is building..."
      cordova build --release android &> $cordova_build
for i in "${cordova_build}"
do
  if grep 'BUILD SUCCESSFUL' $cordova_build
    then
      echo "Build generated without any error..."
      elif grep 'Error' $cordova_build
    then
         echo "Oops it's an error..Please check the BUILD output"
  else
        echo "Sorry not found the build"
  fi
done
      cd C:/Program\ Files/Java/jdk1.7.0_79/bin
      echo "Generating Keystore..."
      keytool -genkey -v -keystore $apk_output/android-release-unsigned.apk.keystore -alias morgregorian -keyalg RSA -keysize 2048 -validity 10000
      echo "Generating Jarsigner..."
      jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore HelloWorld-release-unsigned.apk alias_name
      echo "Executing Zipalign..."
      zipalign -v 4 android-release-unsigned.apk HelloWorld.apk


