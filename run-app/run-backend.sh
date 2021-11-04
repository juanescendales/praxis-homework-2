#!/usr/bin/env bash

#Assign PORT sysenv variable to 4001
export PORT=4001
#Verify Port
echo "Value of PORT sysenv variable: $PORT"

#Start execution
echo "Executing backend server..."
nohup /shared/vuego-demoapp > backend_logs.out 2>&1 &
echo "Backend running successfully"