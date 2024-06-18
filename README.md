# Public
Public download

2024.06.18 add 將node執行檔變成服務.sh
Example
"service_node.sh install node執行檔名稱"
建立/usr/local/node執行檔名稱目錄。
將目前目錄下除service_nodejs.sh之外的所有檔案複製到該目錄。
建立一個systemd服務文件，並啟動和啟用該服務。

"service_node.sh uninstall node執行檔名稱"
停止並停用node執行檔名稱服務。
刪除對應的systemd服務檔案。
刪除/usr/local/node執行檔名稱目錄。
