# Why Docker

개발을 하거나 테스트를 할때 서버의 환경과 동일한 구성으로 작업을 할 수 있다.

이번에 CPU 서버는 debian bullseye 로 구성되어 있어 해당 버전에 맞는 파이썬 환경을 구성하도록 스크립트를 작성하였다.

CPU버전은 Python 버전은 정확히 알지 못하여 bullseye 의 기본 버전인 3.9로 도커 베이스 이미지를 선택하였다.

CPU 서버 속도가 늦어 GPU로 추가 설정을 진행하였다.

GPU서버는 NVIDIA L4 - g2-standard-4 로 ubuntu 22.04 에 nvidia driver설치 후 nvidia-docker을 셋팅하였다

GPU버전은 nvidia/cuda:12.1.0-base-ubuntu20.04 도커 베이스 이미지를 선택하였다.

개발 PC 에 파이썬의 가상환경을 따로 구축할 필요없이 바로 사용가능한 형태로 작성되었다.

GPU는 nvidia 드라이버에 nvidia-docker 을 구성해야 한다.


# Docker Build

docker build -t 이미지명:태그명 도커파일위치

예) docker build -t jams777/surfi-keyword:latest .

예) docker build -t jams777/surfi-keyword:gpu .

```
docker build -t jams777/surfi-keyword:latest .
[+] Building 122.3s (19/19) FINISHED
 => [internal] load build definition from Dockerfile                                                       0.1s
 => => transferring dockerfile: 882B                                                                       0.0s
 => [internal] load .dockerignore                                                                          0.1s
 => => transferring context: 2B                                                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.9.16-bullseye                                  2.4s
 => [auth] library/python:pull token for registry-1.docker.io                                              0.0s
 => [internal] load build context                                                                          0.1s
 => => transferring context: 2.91kB                                                                        0.0s
 => [ 1/13] FROM docker.io/library/python:3.9.16-bullseye@sha256:603ac689b89c2a59791a4e7cd3d727f2a673ac3d  0.3s
 => => resolve docker.io/library/python:3.9.16-bullseye@sha256:603ac689b89c2a59791a4e7cd3d727f2a673ac3df0  0.0s
 => [ 2/13] RUN mkdir /app                                                                                 0.4s
 => [ 3/13] WORKDIR /app                                                                                   0.1s
 => [ 4/13] RUN apt-get update                                                                             3.1s
 => [ 5/13] RUN apt-get -y install libgl1-mesa-glx vim                                                    14.0s
 => [ 6/13] RUN /usr/local/bin/python -m pip install --upgrade pip                                         4.1s
 => [ 7/13] RUN pip install image pillow==9.5.0                                                            6.7s
 => [ 8/13] RUN pip install numpy==1.24.3                                                                  5.1s
 => [ 9/13] RUN pip install opencv-python==4.7.0.72                                                        8.3s
 => [10/13] RUN pip install Flask==2.3.2                                                                   2.6s
 => [11/13] RUN pip install torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/  26.2s
 => [12/13] RUN pip install clip-by-openai==1.1                                                            3.3s
 => [13/13] COPY run_flask.py /app                                                                         0.1s
 => exporting to image                                                                                    44.5s
 => => exporting layers                                                                                   32.0s
 => => exporting manifest sha256:09cee90a50b52471b248a8c51cb0379c0a0f6d602a4f5570548a2b10ce5bcdaa          0.0s
 => => exporting config sha256:6ad02058ad031562091c4a7020af03e74a7f8319b35fe3ad59507ae6ba39a91c            0.0s
 => => exporting attestation manifest sha256:c287651499df1687ed3301964180e79fdbad1c62819b8f848969c434b566  0.0s
 => => exporting manifest list sha256:b7886dcd9e571b8c4b011f8fcae66dbb089d6c85d3840ae630cef75a6ed57c3a     0.0s
 => => naming to docker.io/jams777/surfi-keyword:latest                                                    0.0s
 => => unpacking to docker.io/jams777/surfi-keyword:latest                                                12.3s

```

# Docker container start 

docker run -it -p 5010:5010 이미지명:태그명 

cpu 예) docker run -it -p 5010:5010 jams777/surfi-keyword:latest

gpu 예) docker run -it --runtime=nvidia --gpus all -p 5010:5010 jams777/surfi-keyword:gpu

```
docker run -it -p 5010:5010 jams777/surfi-keyword:latest
100%|████████████████████████| 353976522/353976522 [00:41<00:00, 8447065.14it/s]
 * Serving Flask app 'run_flask'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5010
 * Running on http://172.17.0.2:5010
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 399-769-038
172.17.0.1 - - [27/May/2023 01:08:08] "GET / HTTP/1.1" 404 -
172.17.0.1 - - [27/May/2023 01:08:08] "GET /favicon.ico HTTP/1.1" 404 -
```

# Test

브라우저에서  localhost:5010 으로 확인
