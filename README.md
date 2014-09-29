dreamlastnight
==============


Install
-------

install core

    sudo apt-get install nodejs npm postgresql-server-dev-all postgresql-devel python-dev build-essential imagemagick
    sudo ln -s /usr/bin/nodejs /usr/bin/node
    git clone https://github.com/nthitz/dreamlastnight

setup python deps

    #install pip on your own plz
    sudo pip install virtualenv
    sudo pip install virtualenvwrapper
    sudo pip install torando


install ruby, foreman
install sass


setup db 

    sudo -u postgres psql postgres
    # change postgres username password within shell
    sudo -u postgres createdb dream

import db from somewhere


setup enviornment

    export WORKON_HOME=~/Envs
    mkdir -p $WORKON_HOME
    source /usr/local/bin/virtualenvwrapper.sh

    mkvirtualenv  dreamEnv
    pip install -r requirements.txt
    add2virtualenv ./

    npm install -g bower
    npm install -g browserify
    npm install
    bower install

Or something along those lines.

