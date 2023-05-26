FROM python:3.9.16-bullseye

# env setting
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ Asia/Seoul

# working dir
RUN mkdir /app
WORKDIR /app

# os lib install 
RUN apt-get update
RUN apt-get -y install libgl1-mesa-glx vim

# pip upgrade
RUN /usr/local/bin/python -m pip install --upgrade pip

# volume
VOLUME ["/app"]

# port
EXPOSE 5010

# python lib install 
RUN pip install image pillow==9.5.0
RUN pip install numpy==1.24.3
RUN pip install opencv-python==4.7.0.72
RUN pip install Flask==2.3.2
RUN pip install torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install clip-by-openai==1.1

# copy source
COPY run_flask.py /app

# ENTRYPOINT /app/docker-entrypoint.sh
ENTRYPOINT /usr/local/bin/python /app/run_flask.py



