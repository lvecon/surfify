FROM python:3.8-slim-buster

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ Asia/Seoul
 
WORKDIR /app
ADD . /app
# for cloning clip repo
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git
# for opencv
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5010
CMD ["python", "run_flask.py"]
