# gitlab-ci-android
This Docker image contains the Android SDK and most common packages necessary for building Android apps in a CI tool like GitLab CI. Make sure your CI environment's caching works as expected, this greatly improves the build time, especially if you use multiple build jobs.

A `.gitlab-ci.yml` with caching of your project's dependencies would look like this:

```
image: megakrutak/gitlab-ci-android

variables:
  VERSION_SDK_TOOLS: "3859397" # "26.0.1"
  GCLOUD_AUTH_KEY_FILE: "authKeyFile.json"
  GCLOUD_PROJECT_ID: "project-id"

stages:
- build
- test

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

build:
  stage: build
  script:
  - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/apk/app-debug.apk

test:
  stage: test
  script:
  - chmod 777 $GCLOUD_AUTH_KEY_FILE
  - echo n | gcloud init
  - gcloud auth activate-service-account --key-file="${GCLOUD_AUTH_KEY_FILE}"
  - gcloud config set project $GCLOUD_PROJECT_ID
  - gcloud firebase test android models list
  - ./gradlew clean assembleMock assembleAndroidTest -PdisablePreDex
  - gcloud firebase test android run firebase-test-matrix.yml:nexus5-device --app app/build/outputs/apk/app-mock-debug.apk --test app/build/outputs/apk/app-mock-debug-androidTest.apk
```
