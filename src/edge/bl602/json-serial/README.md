# Building

First, check out this [repo](https://github.com/pine64/bl_iot_sdk) and follow the instructions for setting up the `$BL60X_SDK_PATH` and `$CONFIG_CHIP_NAME` environment variables.

Then create a link to make it appear as if *this* directory is in `$BL60X_SDK_PATH/customer_app`

```shell
ln -s `pwd` $BL60X_SDK_PATH/customer_app/json-serial
```

That was the setup part. Now build it:

```shell
make
```

# Installing

Use the [bl60x-flash](https://github.com/stschake/bl60x-flash) utility:

```shell
bl60x-flash /dev/ttyUSB3 build_out/json-serial.bin
```
