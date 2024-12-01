#!/usr/bin/env bash

echo "Starting Ollama server..."
ollama serve &

echo "Waiting for Ollama server to reply as active..."
while [ "$(ollama list | grep 'NAME')" == "" ]; do
  sleep 1
done

ollama pull llama3.2
ollama pull llava
ollama pull sqlcoder
ollama pull mistral