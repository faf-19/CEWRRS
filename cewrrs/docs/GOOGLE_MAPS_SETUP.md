# Google Maps API Setup Guide

This guide explains how to set up Google Maps API for your CEWRRS Flutter project.

## ✅ **What's Already Done**

I've updated your configuration files:

### **Android Setup** (`cewrrs/android/app/src/main/AndroidManifest.xml`)
- ✅ Added location permissions
- ✅ Added Google Maps API key configuration placeholder
- ✅ Added internet permission

### **iOS Setup** (`cewrrs/ios/Runner/AppDelegate.swift`)
- ✅ Added Google Maps import
- ✅ Added API key configuration placeholder

## 🔑 **Next Steps: Get Your API Key**

### **1. Create Google Cloud Project**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable billing (required for API usage)

### **2. Enable Required APIs**
In the Google Cloud Console, enable these APIs:
- **Maps SDK for Android**
- **Maps SDK for iOS** 
- **Geocoding API**
- **Places API** (optional but recommended)

### **3. Create API Key**
1. Go to "Credentials" → "Create Credentials" → "API Key"
2. Copy the generated API key
3. **RESTRICT YOUR API KEY** (very important for security):
   - For Android: Add your app's package name and SHA-1 fingerprint
   - For iOS: Add your app's Bundle ID

## 🔧 **Configure Your API Key**

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` in both files:

### **Android** (`android/app/src/main/AndroidManifest.xml`)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

### **iOS** (`ios/Runner/AppDelegate.swift`)
```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
```

## 📋 **Required Permissions**

Your app will need these permissions for location services:
- **ACCESS_FINE_LOCATION** - For precise location
- **ACCESS_COARSE_LOCATION** - For approximate location
- **INTERNET** - For map tiles and geocoding

## 🚀 **Testing Your Setup**

1. **Run `flutter clean`** and `flutter pub get`
2. **Build and run** your app on a device
3. **Navigate to the report page** and tap "Place"
4. **Select a location** on the map
5. **Verify the map preview** appears in the form

## 🔒 **Security Best Practices**

1. **Restrict your API key** to specific platforms and apps
2. **Monitor API usage** in Google Cloud Console
3. **Set up billing alerts** to avoid unexpected charges
4. **Consider using environment variables** for API keys in production

## 📱 **Expected Behavior**

Once properly configured:
- ✅ Map loads when selecting location
- ✅ Location marker appears
- ✅ Address is resolved from coordinates
- ✅ Map preview shows in report form

## 🆘 **Troubleshooting**

### **Maps not loading?**
- Check API key is valid and not restricted
- Ensure all required APIs are enabled
- Check internet connection
- Verify location permissions are granted

### **Build errors?**
- Run `flutter clean` and rebuild
- Check iOS/macOS pods: `cd ios && pod install`
- Ensure API key format is correct

Your Google Maps integration is now ready! Just add your API key to both configuration files.