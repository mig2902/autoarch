#!/bin/bash
# open dialog for partition scheme
install_type=$(printf 'Boot + / + Swap + home\n/ + home' | fzf | awk '{print $1}')
