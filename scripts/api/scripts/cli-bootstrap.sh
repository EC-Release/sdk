#!/bin/bash
rm -Rf ~/.ec/script/*-bootstrap.sh
exec env --ignore-environment /bin/bash -l
