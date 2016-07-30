#!/usr/bin/env bash
ionic_build="C:/Output/ionic_build.txt"
cordova_build="C:/Output/cordova_build.txt"
unsigned_apk="C:/Users/Tosh/WebstormProjects/Morgregorian/platforms/android/build/outputs/apk/android-release-unsigned.apk"
keystore="C:/Users/Tosh/WebstormProjects/Morgregorian/morgregorian.keystore"
morgregorian_apk="C:/Users/Tosh/WebstormProjects/Morgregorian/morgregorian.apk"

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
        exit 1
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
        exit 1
  fi
done
echo  "Checking if moregregorian.keystore file is present..."
  if [ -e $keystore ]
  then
          echo "morgregorian.keystore file is present"
  else
    echo "Generating Keystore..."
    C:/Program\ Files/Java/jdk1.8.0_102/bin/keytool.exe -genkey -v -keystore C:/Users/Tosh/WebstormProjects/Morgregorian/morgregorian.keystore -alias morgregorian -keyalg RSA -keysize 2048 -validity 10000
     echo "Generated Keystore..."
  fi
 echo "Generating Jarsigner..."
 C:/Program\ Files/Java/jdk1.8.0_102/bin/jarsigner.exe -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore morgregorian.keystore $unsigned_apk morgregorian
 echo "Generated Jarsigner..."
 echo "Executing Zipalign..."
 if [ -e $morgregorian_apk ]
  then
      echo "Please wait existing apk file is deleting..."
      rm $morgregorian_apk
       echo "Existing apk file deleted..."
  fi
      echo "Building new morgregorian.apk file ....."
      C:/Android-sdk/build-tools/23.0.3/zipalign.exe -v 4 $unsigned_apk morgregorian.apk
      echo "Created new morgregorian apk file..."

