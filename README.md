# rpm-builder

To build the docker image :

```bash
docker build -t rpm-builder .
```
Grab a coffee or work on something else while this runs. It takes a while

Once the image is built. You need to mount a volume to download the rpm to your local filesystem

```bash
mkdir rpm
docker run --rm -i -v ${PWD}/rpm:/rpm rpm-builder-linux /bin/bash <<COMMANDS
fpm -s dir -t rpm -C /tmp/opencv --name TCOpenCV --version 4.1.0 --iteration 3 --description "opencv 4.1.0" .
cp TCOpenCV-4.1.0-3.x86_64.rpm /rpm
COMMANDS
```

This should result in a the rpm file in the `rpm` directory
