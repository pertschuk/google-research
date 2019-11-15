FROM tensorflow/tensorflow:1.15.0-py3

ADD ./ ./
RUN pip3 install -r albert/requirements.txt