FROM nashif/docker-scancode:v0.2

WORKDIR scancode-toolkit

ENV PATH=$HOME/scancode-toolkit:$PATH

COPY entrypoint.sh /entrypoint.sh
COPY license_check.py /license_check.py

ENTRYPOINT ["/entrypoint.sh"]
