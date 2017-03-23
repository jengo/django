# jengo django
Jolene Engo's (jengo) simple django boiler plate with docker

*This is currently an incomplete experimental project, not recommended for use!*

This is a set of tools to create a boiler plate django project and app using Docker containers.  This will also create all the required files to setup the containers for your project.  This includes a database container, MySQL and PostgreSQL (future).  This is a total rewrite of my previous version that didn't use Docker compose.


## How to use (This is still being solidified)
First, set a name for your project the default is jengo_django.  You can skip this step if you just quickly want to see the output that this script generates.

```
export PROJECT=myproject
```


Next run

```
make
```

That will build a temporary build container with all the required Python libraries and utilities to build your project.  After Django creates the project a few files will be generated from templates.  Such as the required docker configs, nginx configs, Makefile for project and replacement settings.py file.  The new settings.py file will use docker to grab the config settings, including database credentials.

