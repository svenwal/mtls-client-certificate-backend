FROM golang:1.8

WORKDIR /go/src/app

RUN apt-get update
RUN apt-get -y install vim less nginx

COPY . .

CMD ["./startup.sh"]
