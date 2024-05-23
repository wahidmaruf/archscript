#!/bin/bash

mkdir -p ~/dev
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz -P ~/dev
tar xf ~/dev/flutter_linux_*-stable.tar.xz -C ~/dev && rm ~/dev/flutter_linux_*-stable.tar.xz

echo 'export PATH="$PATH:~/dev/flutter/bin"' >> ~/.bashrc
echo 'export CHROME_EXECUTABLE=/opt/google/chrome/google-chrome' >> ~/.bashrc
echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> ~/.bashrc

source ~/.bashrc

flutter doctor
