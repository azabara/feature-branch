#!/bin/bash

#Checking if scripts runs as root
#       if [ "$(id -u)" != 0 ]; then
#               echo "This script must be run as root."
#               exit 1
#       fi

#Downloading archive from ftp server
curl -O ftp://ftp/AdvancedLinuxShellScriptingEnv.tar.gz --user vsftp:aq12w34e

        if [ -s ./AdvancedLinuxShellScriptingEnv.tar.gz ]; then
                sudo tar -xzvf AdvancedLinuxShellScriptingEnv.tar.gz -C /tmp/
        else
                echo "File doesn't exist"
                exit 1
fi

#Removing temporary files
sudo tar -xvf /tmp/*.tar -C /tmp/
sudo rm -f /tmp/*.tar; rm -f ~/*.gz

#Asking user to choose an environment name
echo "Enter Environment Name (FeatureBranch is default): "
                read -rp"[FeatureBranch/Other]: " -e -i FeatureBranch USER_INPUT
        if [[ $USER_INPUT == "FeatureBranch" ]]; then
                export FeatureBranch='/tmp/AdvancedLinuxShellScriptingEnv'
        else
                export $USER_INPUT='/tmp/AdvancedLinuxShellScriptingEnv'
        fi

#Looking for environment folder
        if sudo find / -type d -wholename $USER_INPUT; then
                echo "Found our environment folder."
        else
                echo "Cannot find our environment folder..."
#               exit 1
fi

USER_INPUT=/tmp/AdvancedLinuxShellScriptingEnv

#Checking if the environment folder exist
        if  [ ! -d $USER_INPUT ]; then
                echo "Error. Directory $USER_INPUT DOES NOT exist."
#               exit 1
fi

#Copying unified folder if exist
        if [ -d $USER_INPUT/Prod/unified/ ]; then
               sudo cp -r $USER_INPUT/Prod/unified/nginx /etc/nginx/
        fi

#Copying environments folders by hostname
        if [[ $(hostname -s) == web3-us-east1.local ]]; then
                cp $USER_INPUT/Prod/web3-us-east1.local/nginx /etc/nginx
        fi


        if [[ $(hostname -s) == web4-us-east1.local ]]; then
                cp $USER_INPUT/Prod/web4-us-east1.local/nginx /etc/nginx
        fi


        if [[ $(hostname -s) == fb1-eu-west.local ]]; then
                cp $USER_INPUT/FeatureBranch/fb1-eu-west.local/nginx /etc/nginx
        fi


        if [[ $(hostname -s) == demo.local ]]; then
                cp $USER_INPUT/Demo/demo.local/nginx /etc/nginx
        fi


        if [[ $(hostname -s) == stage-api.local ]]; then
                cp $USER_INPUT/Stage/stage-api.local/nginx /etc/nginx
        fi


        if [[ $(hostname -s) == stage-us-east2.local ]]; then
                cp $USER_INPUT/Stage/stage-us-east2.local/nginx /etc/nginx
        fi

#Restarting nginx
        if sudo systemctl restart nginx; then
                echo "Nginx successfully restarted"
#                exit 0
        else
                echo "Failed to restart nginx"
 #               exit 1
        fi
