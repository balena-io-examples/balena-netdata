# balena-netdata

In order to deploy this service to your service, you can copy & paste the [`docker-compose.yml`](./docker-compose.yml)
directives into your own `docker-compose.yml`, and copy the [`netdata`](./netdata) directory to your project. It is
always good to check the netdata plugins [here](https://learn.netdata.cloud/docs/agent/collectors/plugins.d/) to see if
there is anything else worth exposing for your project!

With the project in place and deployed to device, you can navigate to `{{IP or hostname.local}}:19999` to view the
statistics that netdata is collecting. Happy monitoring!

Alternatively, test this project directly by clicking below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy)

## Debugging
To enable remote access via public URLs, you can either set up a reverse proxy (like nginx or HAProxy) and forward port
80 to 19999. Alternatively, you can uncomment the `[web]` section of [netdata.conf](./netdata/netdata.conf) to configure
netdata to listen on port 80 directly.

## Current issues
* Devices < balenaOS 2.48 are unable to resolve container statistics.
* Only `aarch64` and `amd64` architectures are supported.
