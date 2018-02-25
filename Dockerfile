FROM golang:1.10-stretch

RUN go get -d -u github.com/golang/dep && \
    cd $(go env GOPATH)/src/github.com/golang/dep && \
    export DEP_LATEST=$(git describe --abbrev=0 --tags) && \
    git checkout $DEP_LATEST && \
    go install -ldflags="-X main.version=$DEP_LATEST" ./cmd/dep && \
    git checkout master

RUN go get github.com/codegangsta/gin

COPY . /go/src/wiki
WORKDIR /go/src/wiki
RUN dep ensure

ENV WIKI_PORT=8088
CMD ["sh", "-c", "gin --path '.' --port ${WIKI_PORT} run wiki.go"]
