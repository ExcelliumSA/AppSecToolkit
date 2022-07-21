#!/usr/bin/env sh

###
# Usage: sudo ./route.sh *default route interface* *special route interface* *IPs to access on the special interface*
###

# Get default route on selected interface
DEF_ROUTE=$(ip r show dev $1 | grep 'default' | grep -o -E 'via [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | cut -d ' ' -f2)

# Get route on selected default interface
SPEC_ROUTE=$(ip r show dev $2 | grep 'default' | grep -o -E 'via [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | cut -d ' ' -f2)
SPEC_INT=$2

# Delete all existing routes
ip r flush 0/0
echo "Routes deleted"

# Add default route
ip r a default via $DEF_ROUTE dev $1
echo "Default route added"

# Skip the 2 interface in the arguments
shift
shift

for i in "$@"; do
  ip r a $i via $SPEC_ROUTE dev $SPEC_INT
  echo "Route for $i added"
done
