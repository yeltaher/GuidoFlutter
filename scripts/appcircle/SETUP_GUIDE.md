# Appcircle Setup Guide for Guido Flutter + Unity iOS

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Connect Repository](#connect-repository)
3. [Configure Signing](#configure-signing)
4. [Set Up Build Profile](#set-up-build-profile)
5. [Configure Workflow](#configure-workflow)
6. [Environment Variables](#environment-variables)
7. [First Build](#first-build)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before setting up Appcircle, ensure you have:

- [ ] Apple Developer Account (Individual or Organization)
- [ ] App ID registered in Apple Developer Portal
- [ ] Distribution Certificate (.p12 file)
- [ ] Provisioning Profile (.mobileprovision file)
- [ ] GitHub repository with the Guido project
- [ ] Appcircle account (free tier available)

---

## Step 1: Connect Repository

1. Log in to [Appcircle Dashboard](https://appcircle.io)
2. Click **"Add New Profile"**
3. Select **iOS** as the platform
4. Select **Flutter** as the target platform
5. Click **"Connect Repository"**
6. Select **GitHub** as the provider
7. Authorize Appcircle to access your repositories
8. Select the **GuidoFlutter** repository
9. Click **"Save"**

---

## Step 2: Configure Signing

### 2.1 Upload Apple Certificate

1. Go to **Signing Identities** > **Apple Certificates**
2. Click **"Add Certificate"**
3. Select **"Apple Distribution"** (for App Store) or **"Apple Development"** (for testing)
4. Upload your `.p12` certificate file
5. Enter the certificate password
6. Click **"Save"**

### 2.2 Upload Provisioning Profile

1. Go to **Signing Identities** > **Apple Profiles**
2. Click **"Add Profile"**
3. Upload your `.mobileprovision` file
4. The profile will be associated with your App ID automatically
5. Click **"Save"**

### 2.3 Verify Bundle ID

1. Go to **Signing Identities** > **Apple Identifiers**
2. Ensure your App ID is listed with the correct Bundle ID
3. The Bundle ID should match what's in your Xcode project (e.g., `com.yourcompany.guido`)

---

## Step 3: Set Up Build Profile

1. Go to your **Build Profile** (the one you created in Step 1)
2. Click on the **Configuration** tab

### 3.1 Project Settings

| Field | Value |
|-------|-------|
| Project or Workspace | `ios/Runner.xcworkspace` |
| Build Scheme | `Runner` |
| Xcode Version | `27.0` |

Click **"Autofill"** if available, or enter manually.

### 3.2 Flutter Settings

| Field | Value |
|-------|-------|
| Flutter Version | `3.47.4` (matches pubspec.yaml) |

### 3.3 Build Triggers

Configure when builds should trigger:

- **On push**: Enable for automatic builds on push
  - Branch: `main` (or `develop` for staging)
- **On tagged push**: Enable for release builds
  - Tag pattern: `v*`

### 3.4 Signing Configuration

1. Click **"Add Signing"**
2. Select your **Bundle ID** from the dropdown
3. Select your **Provisioning Profile** from the dropdown
4. Click **"Save"**

### 3.5 Versioning

1. Enable **"Version Management"**
2. Configure:

| Setting | Value |
|---------|-------|
| Build Number Source | Environment Variable |
| Build Number | `$AC_BUILD_NUMBER` |
| Version Number Source | Xcode |
| Version Number | (leave as is) |

This will automatically increment the build number with each build.

---

## Step 4: Configure Workflow

1. Click on the **Workflow** tab
2. You'll see the default workflow steps
3. Modify the workflow to match the required configuration

### Required Workflow Steps (in order):

#### Step 1: Cache Pull
- Add **"Cache Pull"** from Workflow Marketplace
- Configure cache paths:
  ```
  ~/.pub-cache
  ios/Pods
  ios/UnityLibrary/DerivedData
  ```
- Cache duration: `7` days

#### Step 2: Git Clone
- This is automatic, no configuration needed

#### Step 3: Xcode Select
- Add **"Xcode Select"** from Workflow Marketplace
- Set `AC_XCODE_VERSION` to `27.0`

#### Step 4: Custom Script - Build UnityFramework
- Add **"Custom Script"** from Workflow Marketplace
- Set **"Execute With"** to `Bash`
- Paste the contents of `scripts/appcircle/build_unity_framework.sh`

#### Step 5: Custom Script - Copy UnityFramework
- Add **"Custom Script"** from Workflow Marketplace
- Set **"Execute With"** to `Bash`
- Paste the contents of `scripts/appcircle/copy_unity_framework.sh`

#### Step 6: Flutter Install
- Add **"Flutter Install"** from Workflow Marketplace
- Set `AC_SELECTED_FLUTTER_VERSION` to `3.47.4`

#### Step 7: Flutter Build for iOS
- Add **"Flutter Build for iOS"** from Workflow Marketplace
- Configure:
  | Variable | Value |
  |----------|-------|
  | `$AC_FLUTTER_PROJECT_PATH` | `.` |
  | `$AC_FLUTTER_BUILD_MODE` | `release` |
  | `$AC_FLUTTER_BUILD_EXTRA_ARGS` | `--no-codesign --build-number=$AC_BUILD_NUMBER` |

#### Step 8: Xcodebuild for Devices (Archive & Export)
- Add **"Xcodebuild for Devices (Archive & Export)"** from Workflow Marketplace
- Configure:
  | Variable | Value |
  |----------|-------|
  | `$AC_SCHEME` | `Runner` |
  | `$AC_PROJECT_PATH` | `ios/Runner.xcworkspace` |
  | `$AC_CONFIGURATION_NAME` | `Release` |
  | `$AC_METHOD_FOR_EXPORT` | `app-store` (or `ad-hoc` for testing) |
  | `$AC_CLEAN_BUILD` | `true` |

#### Step 9: Export Build Artifacts
- Add **"Export Build Artifacts"** from Workflow Marketplace
- This will export the IPA file

#### Step 10: Cache Push
- Add **"Cache Push"** from Workflow Marketplace
- Configure cache paths (same as Cache Pull):
  ```
  ~/.pub-cache
  ios/Pods
  ios/UnityLibrary/DerivedData
  ```
- Cache duration: `7` days

---

## Step 5: Environment Variables

If you need additional environment variables:

1. Go to your **Build Profile** > **Configuration** > **Environment Variables**
2. Add any custom variables needed

For this project, the default Appcircle variables should be sufficient:
- `$AC_REPOSITORY_DIR` - Repository path
- `$AC_BUILD_NUMBER` - Auto-incrementing build number
- `$AC_GIT_BRANCH` - Current branch
- `$AC_GIT_COMMIT` - Current commit hash

---

## Step 6: First Build

### 6.1 Trigger Manual Build

1. Go to your **Build Profile**
2. Select the branch (e.g., `main`)
3. Click **"Start Build"**
4. Select your configuration and workflow
5. Click **"Start Build"** again

### 6.2 Monitor Build

1. Click on the build to view logs
2. Watch each step complete:
   - Cache Pull
   - Git Clone
   - Xcode Select
   - Build UnityFramework (custom script)
   - Copy UnityFramework (custom script)
   - Flutter Install
   - Flutter Build for iOS
   - Xcodebuild Archive & Export
   - Export Artifacts
   - Cache Push

### 6.3 Verify Output

1. After build completes, go to **Artifacts** tab
2. Download the `.ipa` file
3. Install on a test device using [TestFlight](https://testflight.apple.com/) or [Diawi](https://diawi.com/)

---

## Troubleshooting

### Issue 1: UnityFramework Build Fails

**Symptoms:**
- Build UnityFramework step fails
- Error: `Unity-iPhone.xcodeproj not found`

**Solutions:**
1. Verify the repository structure:
   ```
   ios/
   ├── UnityLibrary/
   │   ├── Unity-iPhone.xcodeproj/
   │   ├── UnityFramework/
   │   └── ...
   └── Runner.xcworkspace/
   ```
2. Check if Unity files are committed to the repository
3. Ensure Git LFS is configured (if using large files)

### Issue 2: CocoaPods Version Mismatch

**Symptoms:**
- Pod install fails
- Error: `CocoaPods version mismatch`

**Solutions:**
1. Add a custom script before Flutter Build to install pods:
   ```bash
   cd ios
   pod install --repo-update
   ```
2. Or commit your `Podfile.lock` to the repository

### Issue 3: Code Signing Errors

**Symptoms:**
- Xcodebuild fails with signing errors
- Error: `No matching provisioning profiles found`

**Solutions:**
1. Verify certificate is uploaded correctly in Signing Identities
2. Verify provisioning profile is uploaded and associated with correct App ID
3. Ensure Bundle ID in Xcode matches the one in Appcircle
4. Check that the provisioning profile includes the correct certificates

### Issue 4: Flutter SDK Not Found

**Symptoms:**
- Flutter Install step fails
- Error: `Flutter SDK not found`

**Solutions:**
1. Ensure Flutter Install step is placed before Flutter Build steps
2. Check the Flutter version specified is available
3. Try using `stable` as the version

### Issue 5: Framework Not Found After Build

**Symptoms:**
- Copy UnityFramework step fails
- Error: `UnityFramework.framework not found`

**Solutions:**
1. Check the Build UnityFramework step logs
2. Verify the DerivedData path is correct
3. The framework might be in a different location - check the build output

### Issue 6: Xcode Version Unavailable

**Symptoms:**
- Xcode Select step fails
- Error: `Xcode version not found`

**Solutions:**
1. Check available Xcode versions in Appcircle Build Infrastructure
2. Use a version that's available (e.g., `16.0` instead of `27.0`)
3. Contact Appcircle support if you need a specific version

---

## Advanced Configuration

### Custom Xcode Build Flags

If you need to pass additional flags to xcodebuild, modify the custom scripts:

```bash
xcodebuild -project ios/UnityLibrary/Unity-iPhone.xcodeproj \
  -target UnityFramework \
  -sdk iphoneos \
  -configuration Release \
  -derivedDataPath ios/UnityLibrary/DerivedData \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  OTHER_CFLAGS="-DFLAG" \  # Add your custom flags here
  2>&1 | tail -100
```

### Multiple Build Configurations

To support multiple configurations (Debug, Release, Profile):

1. Create separate build profiles in Appcircle
2. Configure different workflow steps for each
3. Use environment variables to differentiate

### Automated Release Pipeline

For automated releases:

1. Configure build triggers for tagged commits
2. Set up distribution profiles for TestFlight
3. Configure auto-distribution in the workflow

---

## Support

- **Appcircle Documentation**: https://docs.appcircle.io
- **Appcircle Support**: https://appcircle.io/support
- **Appcircle Slack**: https://join.slack.com/t/appcircleio/signup

---

## Quick Reference

### Workflow Summary
```
Cache Pull → Git Clone → Xcode Select → Build UnityFramework →
Copy UnityFramework → Flutter Install → Flutter Build iOS →
Xcodebuild Archive & Export → Export Artifacts → Cache Push
```

### Key Files
- `scripts/appcircle/build_unity_framework.sh` - Unity build script
- `scripts/appcircle/copy_unity_framework.sh` - Framework copy script
- `ios/Podfile` - CocoaPods configuration
- `pubspec.yaml` - Flutter project configuration

### Key Paths
- Unity Project: `ios/UnityLibrary/Unity-iPhone.xcodeproj`
- Unity Framework: `ios/UnityLibrary/Frameworks/UnityFramework.framework`
- Flutter Workspace: `ios/Runner.xcworkspace`
- Flutter Scheme: `Runner`
