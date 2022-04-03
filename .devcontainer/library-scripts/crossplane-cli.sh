#!/usr/bin/env bash

curl -sSL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
mv -f kubectl-crossplane /usr/local/bin
chmod +x /usr/local/bin/kubectl-crossplane