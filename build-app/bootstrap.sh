#!/usr/bin/env bash
echo "Update the system: "
sudo yum update -y

echo "Git : "
git --version 2>/dev/null
#Git status
if [ $? -ne 0 ]; then
    echo "Git is not installed, installing..."
    sudo yum install git -y
    echo "Git installed successfully"
    git --version
fi

echo "Go Lang : "
go version 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Go Lang is not installed, installing..."
    sudo yum install golang -y
    echo "Go Lang installed successfully"
    go version
fi


echo "NodeJS and NPM:"
node --version 2>/dev/null && npm --version 2>/dev/null
if [ $? -ne 0 ]; then
    echo "NodeJS and NPM are not installed, installing..."
    curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum install nodejs -y
    source ~/.bash_profile

    echo "NodeJS and NPM installed successfully"
    node --version && npm --version
fi

echo "VueCLI:"
vue --version 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Vue CLI is not installed, installing..."
    npm install -g yarn -y
    yarn global add @vue/cli -y
    echo "VUE CLI installed successfully"
    vue --version
fi


source ~/.bash_profile
#Clonando el repositorio
echo "Cloning project ..."
if ! [ -d "/home/vagrant/vuego-demoapp" ]; then
    git clone https://github.com/jdmendozaa/vuego-demoapp /home/vagrant/vuego-demoapp
fi
echo "App repository cloned from https://github.com/jdmendozaa/vuego-demoapp"


# Go
echo "Backend - buliding..."
cd /home/vagrant/vuego-demoapp/server
go build -o /shared
echo "Backend - Golang built successfully"


# Vue
echo "Frontend - buliding..."
cd /home/vagrant/vuego-demoapp/spa
yarn import
rm -f package-lock.json
yarn install
yarn upgrade
echo 'VUE_APP_API_ENDPOINT="http://10.0.0.8:4001/api"' > /home/vagrant/vuego-demoapp/spa/.env.production
yarn build
tar -zcvf dist.tar.gz ./dist && mv dist.tar.gz /shared
echo "Frontend - Vue built successfully"