# Tideways Daemon Image

## Use

```sh
docker run \
	-ti \
	-e TIDEWAYS_DAEMON_EXTRA="--log=/var/log/tideways/daemon.log" \
	-p 9135:9135 \
	--name tideways \
	scolib/tideways:<tag>
```


## Environment Variables

| Variable               | Default | Description                                                  |
| ---------------------- | ------- | ------------------------------------------------------------ |
| TIDEWAYS_DAEMON_EXTRA | none    | see [https://support.tideways.com/article/56-daemon](https://support.tideways.com/article/56-daemon) |