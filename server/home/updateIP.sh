#!/bin/bash

# Generate a polo token on the public server and add that token here
token='fill me'
curl -v --ssl -L -X POST -H "Content-Type: application/json" -d "{\"token\": \"$token\"}" https://ddns.heid.cc
