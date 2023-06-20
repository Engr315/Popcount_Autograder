FROM eecsautograder/ubuntu22:latest

WORKDIR /app

COPY . /app

RUN apt update && apt install -y cmake sudo && make deps
RUN make get-qcomps

