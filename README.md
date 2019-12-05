# dockerfiles

Collection of lightweight and ready-to-use docker images

## Images

* **[nginx-envsubst](nginx-envsubst/)** - Nginx image with support for environment variables using envsubst
* **[node](node/)** - Minimal Node + npm image
* **[mailcatcher](mailcatcher/)** - Extra small Mailcatcher image
* **[mailhog](mailhog/)** - MailHog image (alternative to Mailcatcher)

## FAQ

##### Why do you use `install.sh` scripts instead of putting the commands in the `Dockerfile`?

Structuring an image this way keeps it much smaller.