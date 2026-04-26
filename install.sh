#!/bin/bash

REPO="https://raw.githubusercontent.com/mson-ssh/synology-fshare/main"
PLUGIN_DIR="/volume1/@appconf/DownloadStation/download/userhosts/fsharevn"

echo "========================================"
echo "  Fshare.vn Plugin Installer"
echo "  for Synology Download Station"
echo "========================================"

# Kiểm tra đang chạy trên Synology
if [ ! -f /etc/synoinfo.conf ]; then
    echo "[!] Script này chỉ chạy trên Synology NAS."
    exit 1
fi

# Kiểm tra Download Station đã cài chưa
if [ ! -d /volume1/@appstore/DownloadStation ]; then
    echo "[!] Download Station chưa được cài đặt."
    exit 1
fi

# Kiểm tra curl
if ! command -v curl &> /dev/null; then
    echo "[!] curl không có sẵn trên hệ thống."
    exit 1
fi

echo ""
echo "[*] Tạo thư mục plugin..."
mkdir -p "$PLUGIN_DIR"

echo "[*] Tải host.php..."
curl -fsSL "$REPO/host.php" -o "$PLUGIN_DIR/host.php"
if [ $? -ne 0 ]; then
    echo "[!] Tải host.php thất bại."
    exit 1
fi

echo "[*] Ghi INFO..."
cat > "$PLUGIN_DIR/INFO" << 'JSON'
{
    "name":                  "fsharevn",
    "hostprefix":            "fshare.vn,www.fshare.vn",
    "displayname":           "Fshare.vn",
    "version":               "1.0",
    "majorversion":          "3",
    "minorversion":          "4",
    "minfirmware":           "2600",
    "min_dl_major_version":  "3",
    "min_dl_minor_version":  "4",
    "min_dl_build":          "2600",
    "authentication":        "yes",
    "module":                "host.php",
    "class":                 "SynoFileHostingFshareVn",
    "supporttasklist":       "yes",
    "description":           "Update 04.2026"
}
JSON

echo "[*] Xóa session cache cũ..."
rm -rf /tmp/dsm_fsharevn/

echo "[*] Restart Download Station..."
synopkg stop DownloadStation > /dev/null 2>&1
sleep 2
synopkg start DownloadStation > /dev/null 2>&1
sleep 2

echo ""
echo "========================================"
echo "  [+] Cài đặt hoàn tất!"
echo ""
echo "  Bước tiếp theo:"
echo "  1. Mở Download Station"
echo "  2. Settings > File Hosting > Fshare.vn"
echo "  3. Edit > nhập email + password > Verify"
echo "========================================"
