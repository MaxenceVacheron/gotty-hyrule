FROM debian:latest

COPY ./GAME /var/www/html/
RUN chmod +x /var/www/html/base_game/hyrule_castle.sh
RUN chmod +x /var/www/html/base_game/welcome.sh

WORKDIR /var/www/html/base_game/

ENTRYPOINT [ "./welcome.sh" ]
