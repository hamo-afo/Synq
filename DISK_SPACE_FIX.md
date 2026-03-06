# Disk Space Issue - Solution

## Current Situation:

- **C: drive**: Only 1.07 GB free ❌ (Too low!)
- **E: drive**: 30.08 GB free ✅ (Plenty!)
- **D: drive**: 22.89 GB free ✅

## Quick Fixes (In Order):

### Step 1: Clear Windows Temp Files

```powershell
# As Administrator:
Remove-Item -Path C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path C:\Users\$env:USERNAME\AppData\Local\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
```

### Step 2: Clear Browser Cache

```powershell
# Chrome cache
Remove-Item -Path "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue

# Edge cache
Remove-Item -Path "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue
```

### Step 3: Clear Android/Flutter Cache (Safe to Delete)

```powershell
# Remove old build files
Remove-Item -Recurse -Force "C:\Users\$env:USERNAME\.gradle\caches\*" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "C:\Users\$env:USERNAME\.flutter\bin\cache\artifacts" -ErrorAction SilentlyContinue
```

### Step 4: Move Android SDK to Drive E: (Optional but Recommended)

The Android SDK can be 50+ GB. Moving it to E: drive will free up C: and give Android more space.

**Method 1: Set Environment Variable**

```powershell
# Edit environment variables and add/change:
$env:ANDROID_SDK_ROOT = "E:\Android\sdk"

# Make it permanent by editing System Environment Variables
```

**Method 2: Move Manually**

```powershell
# Copy (takes time)
Copy-Item -Recurse "C:\Users\$env:USERNAME\AppData\Local\Android\sdk" "E:\Android\sdk"

# Verify copy was successful, then delete original
Remove-Item -Recurse -Force "C:\Users\$env:USERNAME\AppData\Local\Android\sdk"

# Set environment variable to E:\Android\sdk
```

### Step 5: Use Drive E: for Emulator

```powershell
# Edit Android SDK Manager settings to use E: drive for emulator AVDs
$env:ANDROID_AVD_HOME = "E:\Android\avd"
```

## Recommended Actions (Pick 2-3):

**Option A - Minimum (Frees ~2 GB)**

1. Clear Windows Temp files
2. Clear Browser Cache
3. Clear Android gradle cache

**Option B - Better (Frees ~10+ GB)**

1. Do Option A
2. Move Android SDK to E: drive

**Option C - Best (Frees ~50+ GB)**

1. Do Option B
2. Move entire `AppData\Local\Android` folder to E: drive

## After Freeing Space:

Once you have 5+ GB free on C:, run:

```bash
flutter emulators --launch Medium_Phone_API_36.0
flutter run
```

## ⚠️ IMPORTANT: Don't Delete These Folders!

- `C:\Users\Hamza\Desktop\synq` - Your app code ✅ Keep!
- `C:\Users\Hamza\Desktop\flutter` - Flutter SDK (can move to E:)
- `C:\Program Files` - System programs (don't touch)

---

**Need Help?** Use File Explorer to find large folders taking up space:

1. Right-click C: drive → Properties
2. Look at Storage usage breakdown
3. Delete old downloads, backups, or cached files

The safest quick win is clearing Temp and Browser Cache - should gain 2-3 GB immediately!
