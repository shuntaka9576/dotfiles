# install flutter
# See https://flutter.dev/docs/get-started/install/macos
ghq get https://github.com/flutter/flutter.git
export PATH="$HOME/repos/github.com/flutter/flutter/bin:$PATH"
flutter precache

# setup android
curl -OL https://dl.google.com/android/repository/commandlinetools-mac-6609375_latest.zip # insatall command line tools only
mkdir /usr/local/opt/android-sdk/cmdline-tools
unzip commandlinetools-mac-6609375_latest.zip -d /usr/local/opt/android-sdk/cmdline-tools
rm -rf commandlinetools-mac-6609375_latest.zip
export PATH="/usr/local/opt/android-sdk/cmdline-tools/tools/bin:$PATH"
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk

# install SDKMAN!(pacakge manager for java)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 8.0.265-amzn
export JAVA_HOME=$HOME/.sdkman/candidates/java/current
export PATH=$JAVA_HOME/bin:$PATH

# install android tools
# See https://developer.android.com/studio/intro/update.html
sdkmanager "build-tools;30.0.1" # Android SDK Build-Tools
sdkmanager "platform-tools" # Android SDK Platform-Tools
sdkmanager "platforms;android-29"
sdkmanager "platforms;android-30"
sdkmanager "sources;android-29"
sdkmanager "emulator" # Android Emulator
sdkmanager "extras;android;m2repository"
sdkmanager "extras;google;m2repository"
sdkmanager "extras;google;google_play_services"
