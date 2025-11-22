@echo off

SET subkey1=%random%%random%%random%%random%%random%%random%

SET subkey1=%subkey1:0=a%
SET subkey1=%subkey1:1=b%
SET subkey1=%subkey1:2=c%

SET curdir=%cd%
mkdir %subkey1%
cd %subkey1%

SET gitinstaller=git_install.exe
SET openjdkinstaller=openjdk_install.msi

curl -o %gitinstaller% -L https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe 
%gitinstaller% /SILENT

curl -o %openjdkinstaller% -L https://aka.ms/download-jdk/microsoft-jdk-21.0.5-windows-x64.msi
msiexec /i %openjdkinstaller% ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome INSTALLDIR="c:\Program Files\Microsoft" /passive

cd %curdir%

call rmdir /S /Q %curdir%\%subkey1%




