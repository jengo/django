# jengo django
Jolene Engo's (jengo) simple django boiler plate with docker

*This is currently an incomplete experimental project, not recommended for use!*

This is a set of tools to create a boiler plate django project and app using Docker containers.  This will also create all the required files to setup the containers for your project.  This includes a database container, MySQL and PostgreSQL (future).  This is a total rewrite of my previous version that didn't use Docker compose.


## How to use

### Step 1 (optional)
The first step can be skipped if you are just quickly testing this script and want to see what it generates.

Database options are either mysql (default) or postgres.

```
export PROJECT=myproject
export DATABASE_TYPE=mysql
```


### Step 2

```
make
```

That will build a temporary build container with all the required Python libraries and utilities to build your project.  After Django creates the project a few files will be generated from templates.  Such as the required docker configs, nginx configs, Makefile for project and replacement settings.py file.  The new settings.py file will use docker to grab the config settings, including database credentials.

All of those generated files will leave in ./build.  This script will also automagically create a git repo and add the files into it.  From there, only the files in build are needed moving forward.  The jengo django checkout is a one time used app.

Keep in mind the repo that is created does not have a remote origin!  You must add this after and push these new files.
