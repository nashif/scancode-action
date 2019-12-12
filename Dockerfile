FROM nashif/docker-scancode:v0.2

ENV PATH=$HOME/scancode-toolkit:$PATH

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
