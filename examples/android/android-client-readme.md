# 📱 Android Client Setup Guide

Connect your Android device to print wirelessly to your Raspberry Pi printer server.

## 🎯 Overview

This guide shows how to set up wireless printing from Android devices to your Canon G2010 printer connected to a Raspberry Pi. Works with **Android 6.0+** and various printing apps.

![Android Setup Success](../../docs/images/android-setup-success.jpg)
*Android successfully printing to Raspberry Pi printer*

## 📋 Prerequisites

- ✅ Android device (version 6.0 or higher)
- ✅ Raspberry Pi wireless printer server running
- ✅ Both devices connected to the same Wi-Fi network
- ✅ Raspberry Pi IP address and printer name

## 🚀 Method 1: Canon Print Service (Recommended)

### Step 1: Install Canon Print Service

1. Open **Google Play Store**
2. Search for **"Canon Print Service"**
3. Install the app by Canon Inc.
4. The service will be automatically enabled

![Canon Print Service Install](images/android-canon-app.jpg)
*Installing Canon Print Service from Play Store*

### Step 2: Enable Print Service

1. Go to **Settings** > **Connected devices** > **Printing**
2. Find **Canon Print Service** and ensure it's enabled
3. Tap on it to configure if needed

![Print Service Settings](images/android-print-services.jpg)
*Android Print Services settings*

### Step 3: Add Printer Manually

Since auto-discovery often fails, manually add the printer:

1. Open any app that supports printing (e.g., Gallery, Chrome, Gmail)
2. Access the print option (usually in the menu or share button)
3. Tap **All printers** dropdown
4. Select **Add printer**
5. Choose **Canon Print Service**
6. Tap **Add by IP Address**

![Add Printer by IP](images/android-add-by-ip.jpg)
*Adding printer by IP address*

### Step 4: Configure Printer Connection

1. **IP Address**: Enter your Raspberry Pi's IP (e.g., `192.168.1.100`)
2. **Port**: Usually `631` (IPP port)
3. **Printer Path**: `/printers/Canon_G2010` (or your printer name)
4. **Full URL**: `http://192.168.1.100:631/printers/Canon_G2010`

![Printer Configuration](images/android-printer-config.jpg)
*Configuring printer connection details*

### Step 5: Test Print

1. Open **Gallery** app
2. Select any photo
3. Tap **Share** > **Print**
4. Select your Canon printer
5. Adjust settings (copies, paper size, etc.)
6. Tap **Print**

![Test Print](images/android-test-print.jpg)
*Testing print from Android Gallery*

## 🔧 Method 2: Mopria Print Service (Alternative)

### Why Use Mopria?

Mopria often works better with CUPS servers than manufacturer-specific apps.

### Step 1: Install Mopria

1. Download **Mopria Print Service** from Play Store
2. Enable it in **Settings** > **Printing**

### Step 2: Configure Printer

1. In print dialog, select **Mopria Print Service**
2. Add printer using IP address method
3. Use the same configuration as Canon Print Service

![Mopria Setup](images/android-mopria-setup.jpg)
*Mopria Print Service configuration*

## 🖨️ Method 3: Third-Party Apps

### PrinterShare

1. Install **PrinterShare** from Play Store
2. Open app and select **Add Printer**
3. Choose **Network Printer**
4. Enter IP address and port

### Let's Print Droid

1. Install **Let's Print Droid**
2. Configure IPP connection
3. Test with sample document

![Third Party Apps](images/android-third-party.jpg)
*Third-party printing apps*

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### ❌ "Printer not found" or "No printers detected"

**Cause**: Auto-discovery failure (very common on Android)

**Solutions**:
1. **Manual IP entry**: Always use the manual IP address method
2. **Check network**: Ensure both devices are on the same Wi-Fi network
3. **Verify CUPS sharing**: Check `http://PI_IP:631` in mobile browser

#### ❌ "Connection failed" or "Printer offline"

**Cause**: Network connectivity or firewall issues

**Solutions**:
1. **Test connection**: Open mobile browser and go to `http://PI_IP:631`
2. **Check firewall**: Ensure port 631 is open on Raspberry Pi
3. **Restart services**: Restart CUPS on Pi: `sudo systemctl restart cups`

#### ❌ "Print job stuck" or "Printing failed"

**Cause**: Driver compatibility or print queue issues

**Solutions**:
1. **Check print queue**: View queue at `http://PI_IP:631/jobs`
2. **Cancel jobs**: Clear any stuck print jobs
3. **Try different app**: Test with a different printing app

#### ❌ "Poor print quality" or "Garbled output"

**Cause**: Driver mismatch or settings issues

**Solutions**:
1. **Adjust print settings**: Lower quality, change paper size
2. **Update driver**: Use Generic/PCL driver in CUPS
3. **Check printer maintenance**: Run nozzle check on printer

### Network Troubleshooting

```bash
# On Raspberry Pi, check if printer is shared
sudo cupsctl --no-remote-admin
sudo cupsctl --remote-any

# Check firewall
sudo ufw status
sudo ufw allow 631/tcp

# Restart CUPS service
sudo systemctl restart cups
```

## 📊 Verification Checklist

- [ ] Canon Print Service installed and enabled
- [ ] Printer added with correct IP address
- [ ] Test page prints successfully
- [ ] Can print photos from Gallery
- [ ] Can print documents from apps
- [ ] Print quality is acceptable

## 🎛️ Print Settings and Options

### Adjusting Print Quality

1. In print dialog, tap **More settings**
2. Select **Print quality**:
   - **Draft**: Fastest, least ink
   - **Normal**: Balanced quality and speed
   - **High**: Best quality, more ink

### Paper Size Configuration

1. Select **Paper size**:
   - **A4**: Standard international
   - **Letter**: US standard
   - **Photo**: Various photo sizes

### Color Options

1. Choose **Color mode**:
   - **Color**: Full color printing
   - **Grayscale**: Black and white only

![Print Settings](images/android-print-settings.jpg)
*Android print settings options*

## 📱 App-Specific Printing

### From Chrome Browser

1. Open webpage
2. Tap **⋮** (menu) > **Print**
3. Select printer and print

### From Gmail

1. Open email
2. Tap **Print** icon
3. Choose printer and settings

### From Google Drive

1. Open document
2. Tap **⋮** > **Print**
3. Select printer

### From Gallery/Photos

1. Select image
2. Tap **Share** > **Print**
3. Adjust photo settings

![App Printing](images/android-app-printing.jpg)
*Printing from various Android apps*

## 🔍 Advanced Configuration

### Custom Print Profiles

Some apps allow saving print settings:

1. Configure printer settings
2. Save as profile/preset
3. Reuse for future prints

### Printer Maintenance

Access printer maintenance through CUPS:

1. Open mobile browser
2. Go to `http://PI_IP:631`
3. Select printer
4. Access maintenance options

## 📞 Need Help?

### Quick Diagnostics

1. **Test network**: Can you access `http://PI_IP:631` in mobile browser?
2. **Check printer**: Is printer visible in CUPS web interface?
3. **Verify sharing**: Is "Share This Printer" checked in CUPS?

### Getting Support

If issues persist:

1. **Check main troubleshooting guide**: [../../docs/troubleshooting.md](../../docs/troubleshooting.md)
2. **Review Android logs**: Use apps like "Log Viewer" to check print service logs
3. **Try different apps**: Test with multiple printing apps
4. **Create issue**: [GitHub Issues](https://github.com/pahasarapasidu/raspberry-pi-wireless-printer/issues)

## 🎯 Success Tips

- **Always use manual IP entry** - auto-discovery rarely works
- **Test with simple documents first** - photos and complex layouts can cause issues
- **Keep print settings simple** - start with draft quality and basic settings
- **Check network regularly** - ensure consistent Wi-Fi connection

## 🤝 Contributing

Have screenshots from your Android setup? Different device experiences? We'd love your contributions!

---

*Successfully tested with Android 8.0+ on Samsung, Google Pixel, OnePlus, and Xiaomi devices* ✅