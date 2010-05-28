# nutshell

access your dreamhost account through SSH and run:
    curl http://github.com/gabrielfalcao/django_dreamhost/raw/master/django_dreamhost.sh -o - | bash

afterwards you'll be able to setup new django projects with the command:
    djangify myproj

# what is this about

There are many ways to set up a Python environment without root
permissions.

I really don't like virtualenv, easy_install and other python's
workaroundish solutions.

This is a structure that creates a brand new python environment to
your user, so you can put your Django projects running on Dreamhost in
a few minutes.

# how does it works

The main script, django_dreamhost.sh does everything in a single shot.

* Download the following tarballs:
* Python 2.6.5
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

# djangifier, the big deal!

The big feature of this project is the djangifier, it is a script that
setup a new Django project structure.

You just get to run.

I.e:

    djangify my-project-name

creates a directory: `$HOME/projects/my-project-name`
adds a ready-to-run copy of files: `.htaccess` and `passenger_wsgi.py`

That's all!
