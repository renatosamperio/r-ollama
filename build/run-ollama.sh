#!/usr/bin/env bash

echo "Starting ollama server..."
ollama serve &

echo "Waiting for Ollama server to reply as active..."
file_name=/usr/bin/ollama
while [ "$(ollama list | grep 'NAME')" == "" ]; do

  if [ ! -f $file_name ]; then
      echo "File '$file_name' was not downloaded" >&2
  else 
      echo "File '$file_name' was found" >&1
  fi
  sleep 1
done

export MODEL_VERSION=$1
echo "Getting model $MODEL_VERSION"
ollama pull $MODEL_VERSION
