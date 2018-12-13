#!/bin/bash 

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout portus.key -out portus.crt
