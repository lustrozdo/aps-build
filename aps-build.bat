@echo off

SET subkey1=%random%%random%%random%%random%%random%%random%

SET subkey1=%subkey1:0=a%
SET subkey1=%subkey1:1=b%
SET subkey1=%subkey1:2=c%

SET curdir=%cd%
mkdir %subkey1%
cd %subkey1%

SET keypasspath=%curdir%\aps-key-pass.txt

if not exist %keypasspath% (
    echo sugartree > %keypasspath%
)

SET gitinstaller=git_install.exe
SET openjdkinstaller=openjdk_install.msi
SET commandlinetools=commandlinetools_tmp.zip
SET platformtools=platformtools_tmp.zip

curl -o %gitinstaller% -L https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe 
%gitinstaller% /SILENT

curl -o %openjdkinstaller% -L https://aka.ms/download-jdk/microsoft-jdk-17.0.9-windows-x64.msi
msiexec /i %openjdkinstaller% ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome INSTALLDIR="c:\Program Files\Microsoft" /passive

curl -o %commandlinetools% -L https://dl.google.com/android/repository/commandlinetools-win-10406996_latest.zip 
tar -xf %commandlinetools%

curl -o %platformtools% -L https://dl.google.com/android/repository/platform-tools_r34.0.5-windows.zip
tar -xf %platformtools%

mkdir Android\sdk\platform-tools
mkdir Android\sdk\cmdline-tools\latest

xcopy platform-tools\* Android\sdk\platform-tools /e
xcopy cmdline-tools\* Android\sdk\cmdline-tools\latest /e

rmdir /S /Q platform-tools
rmdir /S /Q cmdline-tools

SET JAVA_HOME=%ProgramFiles%\Microsoft
SET ANDROID_SDK_ROOT=%curdir%\%subkey1%\Android\sdk
SET ANDROID_CMD_LINE_TOOLS=%ANDROID_SDK_ROOT%\cmdline-tools\latest
SET ANDROID_PLATFORM_TOOLS=%ANDROID_SDK_ROOT%\platform-tools
SET ANDROID_BUILD_TOOLS=%ANDROID_SDK_ROOT%\build-tools\33.0.2

SET PATH=%PATH%;%JAVA_HOME%\bin;%ANDROID_CMD_LINE_TOOLS%\bin;%ANDROID_SDK_ROOT%;%ANDROID_PLATFORM_TOOLS%;%ANDROID_BUILD_TOOLS%;%ProgramFiles%\Git\bin

mkdir %ANDROID_SDK_ROOT%\licenses
(echo: & echo 601085b94cd77f0b54ff86406957099ebe79c4d6) > %ANDROID_SDK_ROOT%\licenses\android-googletv-license
(echo: & echo 859f317696f67ef3d7f30a50a5560e7834b43903) > %ANDROID_SDK_ROOT%\licenses\android-sdk-arm-dbt-license
(echo: & echo 24333f8a63b6825ea9c5514f83c2829b004d1fee) > %ANDROID_SDK_ROOT%\licenses\android-sdk-license
(echo: & echo 84831b9409646a918e30573bab4c9c91346d8abd) > %ANDROID_SDK_ROOT%\licenses\android-sdk-preview-license
(echo: & echo 33b6a2b64607f11b759f320ef9dff4ae5c47d97a) > %ANDROID_SDK_ROOT%\licenses\google-gdk-license
(echo: & echo d975f751698a77b662f1254ddbeed3901e976f5a) > %ANDROID_SDK_ROOT%\licenses\intel-android-extra-license
(echo: & echo e9acab5b5fbb560a72cfaecce8946896ff6aab9d) > %ANDROID_SDK_ROOT%\licenses\mips-android-sysimage-license

call sdkmanager "platform-tools" "platforms;android-33" "platforms;android-34" "build-tools;33.0.0" "build-tools;33.0.1" "build-tools;33.0.2"
call sdkmanager --update
call sdkmanager --licenses

git clone https://github.com/nightscout/AndroidAPS.git

cd AndroidAPS
call gradlew :app:assembleFullRelease
call gradlew :wear:assembleFullRelease

SET keypath=%curdir%\android-aps.jks
SET appoutdir=%curdir%\%subkey1%\AndroidAPS\app\build\outputs\apk\full\release
SET wearoutdir=%curdir%\%subkey1%\AndroidAPS\wear\build\outputs\apk\full\release

if not exist %keypath% (
    keytool -genkey -v -keystore %keypath% -storepass:file %keypasspath% -keyalg RSA -keysize 2048 -validity 10000 -alias key -dname "CN=aps, OU=aps, O=aps, L=aps, S=seoul, C=KR"
) 

zipalign -v -p 4 %appoutdir%\app-full-release-unsigned.apk %appoutdir%\app-full-release-unsigned-aligned.apk
zipalign -v -p 4 %wearoutdir%\wear-full-release-unsigned.apk %wearoutdir%\wear-full-release-unsigned-aligned.apk

SET builddir=%curdir%\aps-outputs
mkdir %builddir%

call apksigner sign --ks %keypath% --ks-pass file:%keypasspath% --out %builddir%\app-full-release.apk %appoutdir%\app-full-release-unsigned-aligned.apk
call apksigner sign --ks %keypath% --ks-pass file:%keypasspath% --out %builddir%\wear-full-release.apk %wearoutdir%\wear-full-release-unsigned-aligned.apk

cd %curdir%

call rmdir /S /Q %curdir%\%subkey1%

pause




