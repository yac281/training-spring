#!/bin/bash
set -e
ollama serve &
sleep 5
ollama pull llama3.2:latest

if ! ollama list | grep -q 'HappyCat'; then
  echo "Creating custom model: HappyCat"
  ollama create HappyCat -f /root/Modelfile
else
  echo "Model already exists"
fi

wait
