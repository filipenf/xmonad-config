#!/bin/bash

VENV_PATH=~/.xmonad/python/venv

virtualenv -p python3 ${VENV_PATH}

${VENV_PATH}/bin/pip install -r requirements.txt
