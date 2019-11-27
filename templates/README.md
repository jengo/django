# jengo django
This was generated from [Jolene Engo's (jengo) simple django boiler plate with docker](https://github.com/jengo/django).  You will want to replace this with one for your project.

## Next steps for your project

### Uncomment .env in the .gitignore file
Credentials should never get checked into git, not even dev credentials.  This boilerplate does violate this rule ONLY for the purposes of testing an out of the box CI setup.

### Access DB web UI adminer
You can access adminer with https://localhost/adminer/ using the credentials in .env

This is only used in local dev, it's strongly recommended you never add this to prod.

### Access django admin
Django admin can be access used https://localhost/admin/

To create an admin user, run
```
make create_admin
```

The default credentials are for the admin are located in the .env file

## Running in dev mode
```
make dev
```
The Makefile contains a special dev build mode.  This will start the django project using bash.  From there you will run scripts/run-dev.sh in the console.

That will start django using runserver.  When you make changes to your code on your host OS, django will automagically reload.  If there is an exception that kills django, you can restart django with the same command again.  Rather than rebuilding the container over and over while you troubleshoot the issue.

The directory structure will be almost the exact same as running in "production mode".  Production mode is considered the final build in CI.  But obviously in dev mode there might be some finals that aren't contained in the final image.  Many things in .dockerignore will still be present.

To test and simulate "production mode" simply run
```
make depends
```


