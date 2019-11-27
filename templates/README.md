# jengo django
This was generated from Jolene Engo's (jengo) simple django boiler plate with docker.  You will want to replace this with one for your project.

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