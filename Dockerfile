FROM eecsautograder/ubuntu22:latest

COPY . .

RUN apt update && apt install -y cmake sudo tar wget e2tools && make deps
RUN make get-qcomps

