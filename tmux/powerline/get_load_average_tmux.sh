#!/bin/sh

echo "(#[fg=yellow]$(uptime | awk '{print $(NF-2)}')#[default]) "
