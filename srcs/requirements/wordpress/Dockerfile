# syntax=docker/dockerfile:1

FROM debian AS wordpress

WORKDIR /conf

COPY --from=builder / ./conf
