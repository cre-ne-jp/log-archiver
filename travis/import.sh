#!/bin/bash

for f in log-archiver_dump/conversation_messages_*.json
do
  time bin/rails json:import[$f] || exit 1
  echo $f
done

for f in log-archiver_dump/messages_*.json
do
  time bin/rails json:import[$f] || exit 1
  echo $f
done
