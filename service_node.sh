#!/bin/bash

SERVICE_NAME=$2
INSTALL_DIR="/usr/local/$SERVICE_NAME"

if [ $(id -u) != "0" ]; then
    echo "Not the root user. Try using sudo Command!"
    exit 1
fi

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 [install|uninstall] <service_name>"
    exit 1
fi

if [ "$1" = "install" ]; then
    # Create the installation directory
    mkdir -p $INSTALL_DIR
    # Copy files excluding the script itself
    find . -maxdepth 1 ! -name "$(basename $0)" ! -name "." -exec cp -r {} $INSTALL_DIR/ \;

    # Create the systemd service file
    cat > /lib/systemd/system/$SERVICE_NAME.service <<-EOF
[Unit]
Description=$SERVICE_NAME Node.js Service
After=syslog.target network.target

[Service]
Type=simple
Restart=always
ExecStart=$INSTALL_DIR/$SERVICE_NAME
WorkingDirectory=$INSTALL_DIR

[Install]
WantedBy=multi-user.target
EOF

    # Enable and start the service
    systemctl enable $SERVICE_NAME
    systemctl start $SERVICE_NAME
    echo "$SERVICE_NAME service installed and started successfully."

elif [ "$1" = "uninstall" ]; then
    # Stop and disable the service
    systemctl stop $SERVICE_NAME
    systemctl disable $SERVICE_NAME
    # Remove the service file
    rm /lib/systemd/system/$SERVICE_NAME.service
    # Remove the installation directory
    rm -rf $INSTALL_DIR
    echo "$SERVICE_NAME service uninstalled and directory removed."

else
    echo "Usage: $0 [install|uninstall] <service_name>"
    exit 1
fi

