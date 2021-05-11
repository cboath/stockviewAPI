#!/bin/bash

aws dynamodb batch-write-item --request-items file://data/holdings.json

read -p "Database seeded."