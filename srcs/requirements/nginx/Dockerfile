# syntax=docker/dockerfile:1

FROM debian AS nginx

WORKDIR /conf

COPY --from=builder / ./conf
