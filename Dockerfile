FROM nashif/docker-scancode:v0.1

ENV PATH=$HOME/scancode-toolkit:$PATH

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
