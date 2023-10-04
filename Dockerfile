FROM eecsautograder/ubuntu22:latest
COPY . .
RUN apt update 
RUN apt install -y libncurses5-dev gcc-arm-linux-gnueabi e2tools libfdt-dev wget tar \
                   libglib2.0-dev libpixman-1-dev libncurses5-dev bc
RUN wget -q https://github.com/Engr315/Popcount_Autograder/releases/latest/download/qcomps.tar.gz
RUN tar -xf qcomps.tar.gz
