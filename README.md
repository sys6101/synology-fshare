# Fshare.vn — Synology Download Station Host Module

Module tích hợp Fshare.vn vào Synology Download Station, cho phép tải file trực tiếp thông qua giao thức kết nối chính thức của Fshare.

---

## Yêu cầu

- Synology NAS với DSM 3.2 trở lên
- Download Station đã cài đặt
- Tài khoản Fshare.vn (Free hoặc VIP)
- Quyền truy cập SSH vào NAS (chỉ cần cho lần cài đặt đầu tiên)

---

## Cài đặt

### Cách 1 — Tự động (khuyến nghị)

**Bước 1. Bật SSH trên Synology**

1. Đăng nhập vào giao diện DSM
2. Vào **Control Panel** → **Terminal & SNMP**
3. Tích vào **Enable SSH service**
4. Bấm **Apply**

**Bước 2. Kết nối SSH từ máy tính**

Tìm địa chỉ IP của NAS tại **Control Panel** → **Network** → **Network Interface** (ví dụ: `192.168.1.100`).

- **Windows**: Mở **Command Prompt** hoặc **PowerShell**, chạy:
```
ssh admin@192.168.1.100
```
Nhập mật khẩu tài khoản admin của DSM khi được hỏi.

- **Mac / Linux**: Mở **Terminal**, chạy:
```
ssh admin@192.168.1.100
```

> Thay `admin` bằng tên tài khoản DSM của bạn, và `192.168.1.100` bằng IP thực của NAS.

**Bước 3. Chạy lệnh cài đặt tự động**

Sau khi đã kết nối SSH thành công, dán và chạy lệnh sau:

```bash
sudo curl -s https://raw.githubusercontent.com/mson-ssh/synology-fshare/main/install.sh | bash
```

> Lệnh cần chạy với quyền `sudo` để có thể ghi file cấu hình và khởi động lại dịch vụ. Nếu gặp lỗi quyền truy cập, hãy chạy lệnh sau trước:
> ```
> sudo -i
> ```
> Sau đó chạy lại lệnh cài đặt (không cần `sudo` ở đầu nữa):
> ```
> curl -s https://raw.githubusercontent.com/mson-ssh/synology-fshare/main/install.sh | bash
> ```

Script sẽ tự động tải plugin, cấu hình đúng và khởi động lại Download Station.

**Bước 4. Nhập thông tin tài khoản**

Mở Download Station → Settings → File Hosting → chọn Fshare.vn → Edit → nhập email và mật khẩu Fshare → Verify.

---

### Cách 2 — Thủ công

**Bước 1. Tải file**

Tải `FshareVn.host` từ mục Releases của repository này.

**Bước 2. Thêm vào Download Station**

Mở Download Station → Settings → File Hosting → Add → chọn `FshareVn.host`.

**Bước 3. Cập nhật cấu hình qua SSH**

Do Download Station tự động rút gọn file cấu hình khi cài qua giao diện, cần chạy thêm lệnh qua SSH để đảm bảo plugin hoạt động đúng.

**3.1. Bật SSH trên Synology**

1. Đăng nhập vào giao diện DSM
2. Vào **Control Panel** → **Terminal & SNMP**
3. Tích vào **Enable SSH service**
4. Bấm **Apply**

**3.2. Kết nối SSH từ máy tính**

Tìm địa chỉ IP của NAS tại **Control Panel** → **Network** → **Network Interface** (ví dụ: `192.168.1.100`).

- **Windows**: Mở **Command Prompt** hoặc **PowerShell**, chạy:
```
ssh admin@192.168.1.100
```
Nhập mật khẩu tài khoản admin của DSM khi được hỏi.

- **Mac / Linux**: Mở **Terminal**, chạy:
```
ssh admin@192.168.1.100
```

> Thay `admin` bằng tên tài khoản DSM của bạn, và `192.168.1.100` bằng IP thực của NAS.

**3.3. Chạy lệnh cập nhật cấu hình**

Sau khi đã kết nối SSH thành công, dán và chạy lệnh sau:

```bash
cat > /volume1/@appconf/DownloadStation/download/userhosts/fsharevn/INFO << 'EOF'
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
EOF
```

**Bước 4. Khởi động lại Download Station**

```bash
sudo synopkg stop DownloadStation && sudo synopkg start DownloadStation
```

> Các lệnh cần chạy với quyền `sudo`.

**Bước 5. Nhập thông tin tài khoản**

Mở Download Station → Settings → File Hosting → chọn Fshare.vn → Edit → nhập email và mật khẩu Fshare → Verify.

| Kết quả | Ý nghĩa |
|---------|---------|
| Valid | Tài khoản VIP, sẵn sàng sử dụng |
| Free user | Tài khoản Free, tốc độ bị giới hạn |
| Login failed | Sai thông tin đăng nhập hoặc lỗi kết nối |

![Hướng dẫn cài đặt](assets/screenshot1.png)

---

## Sử dụng

Dán link Fshare vào Download Station như bình thường:

```
https://www.fshare.vn/file/XXXXXXXXXX
```

![Kết quả tải](assets/screenshot2.png)

---

## Lưu ý

Mã nguồn này không thu thập bất kỳ dữ liệu cá nhân nào của người dùng. Thông tin đăng nhập chỉ được sử dụng để xác thực trực tiếp với hệ thống Fshare và không được lưu trữ hay gửi đến bất kỳ bên thứ ba nào.

Module ưu tiên tái sử dụng phiên đăng nhập đã được lưu tạm trên thiết bị. Việc xác thực lại với hệ thống Fshare chỉ xảy ra khi phiên hiện tại hết hạn hoặc không còn hợp lệ.

Module sử dụng giao thức kết nối của Fshare không có khóa đăng ký chính thức. Fshare hiện đã tạm ngưng cấp quyền truy cập cho cá nhân. Người dùng tự chịu trách nhiệm khi sử dụng.

---

## Giấy phép

MIT

---
---

# Fshare.vn — Synology Download Station Host Module

A file hosting module that enables Synology Download Station to download files from Fshare.vn using Fshare's official service interface.

---

## Requirements

- Synology NAS with DSM 3.2 or later
- Download Station installed
- Fshare.vn account (Free or VIP)
- SSH access to the NAS (required for initial setup)

---

## Installation

### Method 1 — Automatic (recommended)

**Step 1. Enable SSH on Synology**

1. Log in to DSM
2. Go to **Control Panel** → **Terminal & SNMP**
3. Check **Enable SSH service**
4. Click **Apply**

**Step 2. Connect via SSH**

Find your NAS IP address at **Control Panel** → **Network** → **Network Interface** (e.g. `192.168.1.100`).

- **Windows**: Open **Command Prompt** or **PowerShell** and run:
```
ssh admin@192.168.1.100
```
Enter your DSM admin password when prompted.

- **Mac / Linux**: Open **Terminal** and run:
```
ssh admin@192.168.1.100
```

> Replace `admin` with your DSM username and `192.168.1.100` with your NAS IP address.

**Step 3. Run the installer**

Once connected, paste and run the following:

```bash
sudo curl -s https://raw.githubusercontent.com/mson-ssh/synology-fshare/main/install.sh | bash
```

> The command requires `sudo` to write configuration files and restart the service. If you encounter a permission error, run the following first:
> ```
> sudo -i
> ```
> Then run the installer again (without `sudo`):
> ```
> curl -s https://raw.githubusercontent.com/mson-ssh/synology-fshare/main/install.sh | bash
> ```

The script will automatically download the plugin, apply the correct configuration, and restart Download Station.

**Step 4. Configure credentials**

Open Download Station → Settings → File Hosting → select Fshare.vn → Edit → enter your Fshare email and password → Verify.

---

### Method 2 — Manual

**Step 1. Download**

Download `FshareVn.host` from the Releases section of this repository.

**Step 2. Add to Download Station**

Open Download Station → Settings → File Hosting → Add → select `FshareVn.host`.

**Step 3. Fix configuration via SSH**

Download Station strips certain configuration fields when installing via the UI. You will need to connect via SSH to restore them.

**3.1. Enable SSH on Synology**

1. Log in to DSM
2. Go to **Control Panel** → **Terminal & SNMP**
3. Check **Enable SSH service**
4. Click **Apply**

**3.2. Connect via SSH**

Find your NAS IP address at **Control Panel** → **Network** → **Network Interface** (e.g. `192.168.1.100`).

- **Windows**: Open **Command Prompt** or **PowerShell** and run:
```
ssh admin@192.168.1.100
```
Enter your DSM admin password when prompted.

- **Mac / Linux**: Open **Terminal** and run:
```
ssh admin@192.168.1.100
```

> Replace `admin` with your DSM username and `192.168.1.100` with your NAS IP address.

**3.3. Run the configuration command**

Once connected, paste and run the following:

```bash
cat > /volume1/@appconf/DownloadStation/download/userhosts/fsharevn/INFO << 'EOF'
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
EOF
```

**Step 4. Restart Download Station**

```bash
sudo synopkg stop DownloadStation && sudo synopkg start DownloadStation
```

> Commands require `sudo` to run.

**Step 5. Configure credentials**

Open Download Station → Settings → File Hosting → select Fshare.vn → Edit → enter your Fshare email and password → Verify.

| Result | Meaning |
|--------|---------|
| Valid | VIP account, ready |
| Free user | Free account, limited speed |
| Login failed | Invalid credentials or connection error |

![Installation guide](assets/screenshot1.png)

---

## Usage

Paste any Fshare link into Download Station as usual:

```
https://www.fshare.vn/file/XXXXXXXXXX
```

![Download result](assets/screenshot2.png)

---

## Disclaimer

This module does not collect any personal data. Credentials are used solely to authenticate with Fshare's service and are never stored or transmitted to any third party.

The module prioritizes reusing an existing session cached on the device. Re-authentication only occurs when the current session has expired or is no longer valid.

This module communicates with Fshare's service without an officially registered access key. Fshare has suspended access for individual developers. The author assumes no responsibility for any consequences arising from its use.

---

## License

MIT
