#!/bin/sh

#
# aerobuild.sh
#
# What does this do?
# ==================
# - Bumps build numbers in your project using agvtool
# - Builds your app and packages it for testing/ad-hoc distribution
# - Commits build number changes to git
# - Tags successful builds in git
# - Uploads builds to testflight with notes based on commits since the last build
#
# Requirements
# ============
# - your target is an iOS App
# - you have a valid code signing identity & mobileprovision file
# - you use git for your version control
# - you use agvtool for versioning your builds
# - you use testflight for publishing builds
# - Xcode is configured to place build products in locations specified by targets
#     (Under Preferences > Locations, in the section labelled "Build Location")
#

#
# BUILD SETTINGS
#
# Name of target
TARGET_NAME=NerdNearby

# Target SDK
# If you need to specify a specific version you can change this
TARGET_SDK=iphoneos

# Build configuration to use
CONFIGURATION=Release

# Name of .mobileprovision file in the PROFILES_PATH directory (see below)
PROVISIONING="65933A3C-A3A5-45CD-A570-B0BCE0DEFDF0.mobileprovision"

# Code signing identity, as it appears in Xcode's Organizer
#    (e.g. "iPhone Developer: John Doe")
SIGNER="iPhone Developer: Sean Moon"

#
# TESTFLIGHT SETTINGS
#
# Your testflightapp.com API token (see https://testflightapp.com/account/)
TESTFLIGHT_API_TOKEN=9929d28d64505fa7dfff87304b354dd8_ODc4MjI
# Your testflightapp.com Team Token (see https://testflightapp.com/dashboard/team/edit/)
TESTFLIGHT_TEAM_TOKEN=1578e79adc01d462797c50644c132358_MTk4NjI
# List of testflightapp.com distribution lists to send the build to (and send notifications)
TESTFLIGHT_GROUPS="Everybody"

#
# GIT SETTINGS
#
# The prefix for build tags.  Change this if "build-n" will collide with other tags you create in git.
GIT_TAG_PREFIX=ipa-

#
# PATH SETTINGS
#
# Override these if you're experiencing problems with the script locating your build artifacts or
# provisioning profiles
PROFILES_PATH="${HOME}/Library/MobileDevice/Provisioning Profiles/"
APP_PATH="build/${CONFIGURATION}-iphoneos/${TARGET_NAME}.app"

# Where the ipa file will be written prior to being uploaded to testflightapp.com
OUTPUT_PATH="/tmp/${TARGET_NAME}.ipa"


#
# SCRIPT STARTS
#
echo "Pre-build checks..."

# Make sure there are no uncommitted changes
STATUS=x$(git status --porcelain)
if [ "${STATUS}" != "x" ]
then
  echo "!!! Git checkout is not clean.  Not building."
  exit 1
fi

# Make sure there are no unpushed changes
CURRENT_BRANCH=$(git name-rev --name-only HEAD)
UNPUSHED=$(git log origin/${CURRENT_BRANCH}..${CURRENT_BRANCH} --format=oneline --abbrev=6 --abbrev-commit)
if [ -n "${UNPUSHED}" ]
then
  echo "!!! Not building. You have the following unpushed changes:"
  echo "${UNPUSHED}"
  exit 1
fi

# Determine the build tag that the last built version had
OLD_BUILD_TAG="${GIT_TAG_PREFIX}$(agvtool what-version -terse)"

# Check if the tag actually exists in git
git fetch
OLD_BUILD_TAG=$(git tag -l "${OLD_BUILD_TAG}")

# Bump up version number, but don't commit yet
agvtool bump -all
VERSION_NUMBER=$(agvtool what-marketing-version -terse1)
BUILD_NUMBER=$(agvtool what-version -terse)
VERSION_STRING="${VERSION_NUMBER} (${BUILD_NUMBER})"
BUILD_TAG="${GIT_TAG_PREFIX}${BUILD_NUMBER}"

# Build target
echo
echo Building target: "${TARGET_NAME}" "${VERSION_STRING}"...
echo

xcodebuild -target "${TARGET_NAME}" \
  -sdk "${TARGET_SDK}" \
  -configuration "${CONFIGURATION}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! xcodebuild failed"
  git reset --hard HEAD
  exit 1
fi

# Package .ipa
echo
echo Packaging target...
echo

xcrun -sdk "${TARGET_SDK}" \
  PackageApplication \
  -v ${APP_PATH} \
  -o ${OUTPUT_PATH} \
  --sign "${SIGNER}" \
  --embed "${PROFILES_PATH}${PROVISIONING}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! xcrun failed to package application"
  git reset --hard HEAD
  exit 1
fi

# Get build notes from commit messages, from the last build tag (if present, otherwise all)
if [ -n "${OLD_BUILD_TAG}" ]
then
  BUILD_NOTES=$(git log "${OLD_BUILD_TAG}".. --format=oneline --abbrev=6 --abbrev-commit)
else
  BUILD_NOTES=$(git log --format=oneline --abbrev=6 --abbrev-commit)
fi

# Commit version bump and tag build
echo
echo Committing version bump and tagging build...
echo

git commit -am "Build ${VERSION_STRING} published"
git tag -a "${BUILD_TAG}" HEAD -m "Tagging published build ${VERSION_STRING}"

git push
git push --tags

# Testflight!
echo
echo Submitting to testflightapp...
echo

NOTES=$(git log -1 --format=oneline --abbrev=6 --abbrev-commit)

echo curl http://testflightapp.com/api/builds.json \
  -F file=@"${OUTPUT_PATH}" \
  -F api_token="${TESTFLIGHT_API_TOKEN}" \
  -F team_token="${TESTFLIGHT_TEAM_TOKEN}" \
  -F notes="${BUILD_NOTES}" \
  -F notify=True \
  -F distribution_lists="${TESTFLIGHT_GROUPS}"

curl http://testflightapp.com/api/builds.json \
  -F file=@"${OUTPUT_PATH}" \
  -F api_token="${TESTFLIGHT_API_TOKEN}" \
  -F team_token="${TESTFLIGHT_TEAM_TOKEN}" \
  -F notes="${BUILD_NOTES}" \
  -F notify=True \
  -F distribution_lists="${TESTFLIGHT_GROUPS}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! Error uploading to testflightapp"
  exit 1
else
  osascript -e 'set volume 4'
  afplay deploy_sound.mp3
fi
