FROM longinius/ionic

ENV ANDROID_COMPILE_SDK="28" \
    ANDROID_BUILD_TOOLS="28.0.3" \
    ANDROID_SDK_TOOLS="4333796"

WORKDIR /opt
RUN mkdir android && cd android

RUN apt-get --quiet update --yes && \
    apt-get --quiet install --yes openjdk-8-jdk-headless wget tar unzip gradle lib32stdc++6 lib32z1

RUN update-java-alternatives --set java-1.8.0-openjdk-amd64

RUN mkdir -p /root/.android && \ 
    touch /root/.android/repositories.cfg

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    unzip -d android-sdk-linux android-sdk.zip && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"

ENV ANDROID_HOME=/opt/android-sdk-linux \
    ANDROID_SDK_ROOT=/opt/android-sdk-linux \
    PATH=$PATH:/opt/android-sdk-linux/platform-tools/:/opt/android-sdk-linux/build-tools/${ANDROID_BUILD_TOOLS}

RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses