# Rocky Linux 9 設定 Linode Longview 備忘錄

這份備忘錄記錄了在 Rocky Linux 9 環境中安裝與設定 Linode 的 Longview 工具的完整流程。

## 前提
Linode 的 Longview Yum 軟體庫尚未支援 CentOS 或 Rocky Linux 9，因此在安裝時需要做一些額外處理。

## 安裝步驟
以下步驟參考自 Linode 官方文件: https://www.linode.com/docs/products/tools/longview/get-started/?tabs=centos

### 1. 安裝相依套件
`linode-longview` 使用 `init.d` 腳本，因此需要先安裝 `initscripts`：

```bash
sudo dnf install initscripts
```

### 2. 新增 Yum 軟體庫
Rocky Linux 9 尚未有對應的 CentOS 9 軟體庫，我們改用 CentOS 8 的版本，建立 `/etc/yum.repos.d/longview.repo`，內容如下：

```ini
[longview]
name=Longview Repo
baseurl=https://yum-longview.linode.com/centos/8/noarch/
enabled=1
gpgcheck=1
```

### 3. 暫時修改加密政策
為了安裝套件，需要將加密政策暫時調降至 SHA1：

```bash
sudo update-crypto-policies --set DEFAULT:SHA1
```

### 4. 安裝 Linode Longview
執行以下步驟安裝 Longview 及其相依元件：

```bash
# 建立儲存 API 金鑰的目錄與檔案
sudo mkdir -p /etc/linode/
echo '在此處填入您的 API 金鑰' | sudo tee /etc/linode/longview.key

# 登錄 GPG 金鑰
curl -O https://yum-longview.linode.com/linode.key
sudo rpm --import linode.key

# 安裝 linode-longview 套件
sudo dnf install linode-longview
```

> 安裝過程中可能會因 systemd 單元檔未自動部署而失敗，稍後我們會手動新增單元檔。

### 5. 部署 systemd 單元檔並啟動服務
手動下載並放置 `longview.service` 單元檔：

```bash
sudo curl -o /usr/lib/systemd/system/longview.service https://raw.githubusercontent.com/linode/longview/master/Extras/init/longview.service
```

若服務已透過 init.d 啟動，可先終止相關程序：

```bash
sudo kill -9 <PID>
```

啟用並啟動服務，並確認服務狀態：

```bash
sudo systemctl enable longview
sudo systemctl start longview
sudo systemctl status longview
```

### 6. 恢復預設加密政策
完成安裝與設定後，將加密政策恢復為預設：

```bash
sudo update-crypto-policies --set DEFAULT
```
