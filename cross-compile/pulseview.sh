#!/bin/bash

EXE="pulseview"
BINDIR="$(dirname "$(readlink -f "$0")")"
LIBDIR="$(readlink -f "${BINDIR}/../lib")"
DECDIR="$(readlink -f "${BINDIR}/../share/libsigrokdecode/decoders")"
REALBIN="${BINDIR}/${EXE}.real"

LD_LIBRARY_PATH="${LIBDIR}" SIGROKDECODE_DIR="${DECDIR}" "${REALBIN}" "$@"
