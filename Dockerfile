FROM tensorflow/tensorflow:1.15.0-py3

RUN git clone --depth 1 https://github.com/pertschuk/google-research
RUN pip3 install -r albert/requirements.txt