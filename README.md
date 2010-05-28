# What is this about

There are many ways to set up a Python environment without root
permissions.

I really don't like virtualenv, easy_install and other python's
workaroundish solutions.

This is a structure that creates a brand new python environment to
your user, so you can put your Django projects running on Dreamhost in
a few minutes.

# How does it works

The main script, django_dreamhost.sh does everything in a single shot.

* Download the following tarballs:
* Python 2.6.5
* Django 1.2.1
* Setuptools 0.6c11

* Create a fake-root directory in user's home: $HOME/.myroot
* Create "etc" subdir
* Compile and install Python under $HOME/usr as $prefix
* Install the rest of python modules (Django, PIL, etc.)

* Download install auxiliary scripts, through script-templates and replace its internal strings.
* per project .htaccess template
* per project WSGI passenger template
* djangifier template

* Create the default projects dir:
* $HOME/projects

# Djangifier, the big deal!

The big feature of this project is the djangifier, it is a script that
setup a new Django project structure.

You just get to run.

I.e:

    djangify my-project-name

creates a directory: `$HOME/projects/my-project-name`
adds a ready-to-run copy of files: `.htaccess` and `passenger_wsgi.py`

That's all!
