## Prerequisites
* Docker
* A machine running Linux or macOS, or familiarity with Docker
## Instructions

1. Clone this repository
2. Move (or copy) your script ending in `.sql` into the repo directory
3. Extract the data files into a subdirectory called `data`

Your directory structure should look like this:
```
.
├── data
│   ├── Batches.csv
│   ├── ...
├── Dockerfile
├── docker-entrypoint.sh
├── assignment.sql
├── README.md
└── run.sh
```

### Linux/macOS

Run the script `run.sh`.

```
./run.sh
```

The script will look for any file ending in `.sql` in your working directory and use the first one.

Options:
* `-i` non interactive mode
    * Runs the container in non-interactive mode.
* `-s` skip image build
    * Skips building the image (or checking if it needs to be rebuilt), saving a few seconds. Make sure it has already been built and tagged `fsad` before.
* `-f [file name]` use file
    * Uses `file name` instead of automatically detecting one

### Windows

Build the image.

```
docker build -t fsad .
```

Start a container with the image. Your sql file should be mounted at `/app/file.sql`. 

```
docker run -it -v [wherever the file is]:/app/file.sql --name=fsad fsad
```

Once finished, remove the container if you are not going to reuse it again.