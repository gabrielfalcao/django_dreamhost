#!/bin/bash
# -*- coding: utf-8; -*-
#
# Copyright (C) 2008 Gabriel Falcão <gabriel@nacaolivre.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

# basic functions
regex_it () {
 RESULT=`echo "$1" | sed -s "s/$2/$3/g"`;
 echo $RESULT;
}

append_slash () {
    echo `regex_it "$1" '\([^/]\)$' '\1\/'`;
}

replace_tag () {
    if [ -f $3 ]; then
        sed -i "s#[{][@]$1[@][}]#$2#g" $3;
    fi;
}

SCRIPT_TEMPLATES_URL='http://gnu.gabrielfalcao.com/django_dreamhost/'
PROJECTS_BASE_PATH=$HOME/projects
MY_TEMPLATES=`append_slash $PROJECTS_BASE_PATH`script_templates
DOWNLOADS_PATH=$HOME/downloads

HTACCESS_TEMPLATE_FILE='htaccess.template'
HTACCESS_TEMPLATE_URL=`append_slash $SCRIPT_TEMPLATES_URL`$HTACCESS_TEMPLATE_FILE
DISPATCH_TEMPLATE_FILE='dispatch.template'
DISPATCH_TEMPLATE_URL=`append_slash $SCRIPT_TEMPLATES_URL`$DISPATCH_TEMPLATE_FILE
DJANGIFIER_TEMPLATE_FILE='djangify.template'
DJANGIFIER_TEMPLATE_NEW_FILE='djangify'
DJANGIFIER_TEMPLATE_URL=`append_slash $SCRIPT_TEMPLATES_URL`$DJANGIFIER_TEMPLATE_FILE

# once dreamhost allow restricted access to your home, we need to use a fake "/"
MY_ROOT=$HOME/.myroot
MY_PREFIX=`append_slash $MY_ROOT`usr
MY_ETC=`append_slash $MY_ROOT`etc
MY_PYTHON=`append_slash $MY_PREFIX`bin/python2.5

PYTHON_SOURCE_PATH='Python-2.5.2'
PYTHON_SOURCE=$PYTHON_SOURCE_PATH'.tar.bz2'
PYTHON_DOWNLOAD_URL='http://www.python.org/ftp/python/2.5.2/'$PYTHON_SOURCE

DJANGO_SOURCE_PATH='Django-1.0.2-final'
DJANGO_SOURCE=$DJANGO_SOURCE_PATH'.tar.gz'
DJANGO_DOWNLOAD_URL='http://www.djangoproject.com/download/1.0.2/tarball/'

SETUPTOOLS_SOURCE_PATH='setuptools-0.6c9'
SETUPTOOLS_SOURCE=$SETUPTOOLS_SOURCE_PATH'.tar.gz'
SETUPTOOLS_DOWNLOAD_URL='http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c9.tar.gz#md5=3864c01d9c719c8924c455714492295e'

FLUP_SOURCE_PATH='flup-1.0.1'
FLUP_SOURCE=$FLUP_SOURCE_PATH'.tar.gz'
FLUP_DOWNLOAD_URL='http://pypi.python.org/packages/source/f/flup/flup-1.0.1.tar.gz#md5=414181781fb0923f884a38503e8e56da'

create_dirs () {
    mkdir -p $MY_PREFIX;
    mkdir -p $MY_ETC;
    mkdir -p `append_slash $PROJECTS_BASE_PATH`;
    mkdir -p $DOWNLOADS_PATH;
}

apply_template () {
    if [ -f $1 ]; then
        fullpath=$1;
        echo " [template processing] Replacing file $fullpath ...";
        replace_tag 'PROJECTS_BASE_PATH' $PROJECTS_BASE_PATH $fullpath;
        replace_tag 'MY_PYTHON' $MY_PYTHON $fullpath;
        replace_tag 'MY_PROJECTS' $PROJECTS_BASE_PATH $fullpath;
        replace_tag 'MY_TEMPLATES' $MY_TEMPLATES $fullpath;
        replace_tag 'MY_ROOT' $MY_ROOT $fullpath;
        replace_tag 'MY_PREFIX' $MY_PREFIX $fullpath;
        replace_tag 'MY_ETC' $MY_ETC $fullpath;
        replace_tag 'HTACCESS_TEMPLATE_FILE' $HTACCESS_TEMPLATE_FILE $fullpath;
        replace_tag 'DISPATCH_TEMPLATE_FILE' $DISPATCH_TEMPLATE_FILE $fullpath;
    fi;
}

setup_scripts () {
    mkdir -p $MY_TEMPLATES;
    pushd $MY_TEMPLATES;
    echo 'Downloading script templates ...';
    echo '';
    echo ' -> Downloading htaccess template ...';
    wget -c --quiet $HTACCESS_TEMPLATE_URL;
    echo ' -> Downloading dispatch.fcgi template ...';
    wget -c --quiet $DISPATCH_TEMPLATE_URL;
    echo ' -> Downloading djangifier script template ...';
    wget -c --quiet $DJANGIFIER_TEMPLATE_URL;
    echo 'Transforming script templates in functional scripts ...';
    for file in "$DISPATCH_TEMPLATE_FILE $HTACCESS_TEMPLATE_FILE $DJANGIFIER_TEMPLATE_FILE"; do
        fullpath=`append_slash $MY_TEMPLATES`$file;
        apply_template $fullpath;
    done;
    djangifier_bin=`append_slash $MY_PREFIX`bin/$DJANGIFIER_TEMPLATE_NEW_FILE;
    mv $DJANGIFIER_TEMPLATE_FILE $djangifier_bin;
    chmod +x $djangifier_bin;
    popd;
}

download_all () {
    echo 'Downloading everything ...'
    echo 'Entering on downloads folder:' $DOWNLOADS_PATH '...'
    pushd $DOWNLOADS_PATH;
    echo 'Downloading python 2.5.2 ...'
    wget -c --quiet $PYTHON_DOWNLOAD_URL;
    echo 'Downloading django 1.0.2 final ...'
    wget -c --quiet $DJANGO_DOWNLOAD_URL;
    echo 'Downloading setuptools 0.6c9 ...'
    wget -c --quiet $SETUPTOOLS_DOWNLOAD_URL;
    echo 'Downloading flup (python fcgi support) ...'
    wget -c --quiet $FLUP_DOWNLOAD_URL;
    popd;
}

extract_all () {
    echo 'Extracting everything ...'
    echo 'Entering on downloads folder:' $DOWNLOADS_PATH '...'
    pushd $DOWNLOADS_PATH;
    echo 'Extracting python ...'
    tar xjf $PYTHON_SOURCE;
    echo 'Extracting django ...'
    tar xzf $DJANGO_SOURCE;
    echo 'Extracting setuptools ...'
    tar xzf $SETUPTOOLS_SOURCE;
    popd;
}

install_all () {
    echo 'Installing Python 2.5.2 ...'
    pushd `append_slash $DOWNLOADS_PATH`$PYTHON_SOURCE_PATH;
    ./configure --prefix=$MY_PREFIX 2>&1 >> python.log;
    make 2>&1 >> python.log;
    make install 2>&1 >> python.log;
    echo 'export PATH='"`append_slash $MY_PREFIX`bin"':$PATH' >> $HOME/.bashrc
    echo 'export PATH='"`append_slash $MY_PREFIX`bin"':$PATH' >> $HOME/.bash_profile
    source $HOME/.bashrc
    popd;
    echo 'Installing django 1.0.2 final ...'
    pushd `append_slash $DOWNLOADS_PATH`$DJANGO_SOURCE_PATH;
    sed -i 's/django[-]admin[.]py/django-admin/g' setup.py
    cp django/bin/django-admin.py django/bin/django-admin
    cp extras/django_bash_completion `append_slash $MY_ETC`django_bash_completion
    echo ". `append_slash $MY_ETC`django_bash_completion" >> $HOME/.bashrc
    echo ". `append_slash $MY_ETC`django_bash_completion" >> $HOME/.bash_profile
    $MY_PYTHON setup.py install 2>&1 >> django.log
    popd;
    echo 'Installing setuptools 0.6c9 ...'
    pushd `append_slash $DOWNLOADS_PATH`$SETUPTOOLS_SOURCE_PATH;
    $MY_PYTHON setup.py install 2>&1 >> setuptools.log
    popd;
    echo 'Installing flup 1.0.1 ...'
    pushd `append_slash $DOWNLOADS_PATH`$FLUP_SOURCE_PATH;
    $MY_PYTHON setup.py install 2>&1 >> flup.log
    popd;
    echo 'Installing PIL (python imaging library) ...'
    `append_slash $MY_PREFIX`bin/easy_install --find-links http://www.pythonware.com/products/pil/ Imaging
}

if [ $0 != "-bash" ]; then
create_dirs
download_all
extract_all
install_all
setup_scripts
fi;
