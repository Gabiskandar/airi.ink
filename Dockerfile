FROM omnijarstudio/naamio:0.4

LABEL authors="Gabrielle Iskandar <gabiskandar@gmail.com>"

RUN mkdir -p /usr/share/naamio/aether

COPY .build /usr/share/naamio/aether

ENV NAAMIO_SOURCE=aether
ENV NAAMIO_TEMPLATES=aether/stencils/

WORKDIR /usr/share/naamio/

ENTRYPOINT ["/usr/share/naamio/Naamio"]
