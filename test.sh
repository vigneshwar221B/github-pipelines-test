#!/bin/bash

# Your string variable
environment="prod-eu"

# Check if the value is "prod" or "qa"
if  [[ "$environment" == prod* ]] || [ "$environment" == "qa" ]; then
    echo "Environment is prod/qa"
elif [ "$environment" == "dev" ]; then
    echo "Environment is dev"
else
    echo "Environment is not valid"
fi
