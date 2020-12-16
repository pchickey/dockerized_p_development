#!/bin/bash
set -ex
docker build --tag p_development:latest .
docker run -v $(pwd):/workdir --workdir=/workdir -it p_development:latest /bin/bash
