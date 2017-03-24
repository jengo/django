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

## Dev mode

The project that is generated has a special dev mode that can be enabled by rebuilding the container.  This allows a developer to make changes and have django restart the app without rebuilding the container.  This is done by creating a docker volume link that connects to your host filesystem.  This is how the first build container works, it uses django to generate a project and write the files back to the host.

To run the project in developer mode run this inside your project directory.

```
make dev
```

 This Makefile target will rebuild your container and put you in a bash shell.  Your app is not running yet.  You will need to run this INSIDE that shell.

 ```
 make run
 ```

This will load your application in the foreground.  This allows you to see the output and kill it without destroying your dev container.  If you throw an exception in django it does not require a rebuild.  Simply perform a make run again if django totally died out.

Keep in mind, during this mode .dockerignore is not used.  All project files will appear inside the dev container.

When using developer mode, never try to build an image from that container!  The files you changed will NOT get added.  Only the files that were generated at build time.  Docker has mounted your dev source over top of the added directory.  Creating an image will only use the underlying code.

You should use a continuous integration tool to build, test and deploy your container using the standard build.
