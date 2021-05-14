# Stache

## What

A simple shell based templating language

## Why

All other templating languages were:

1. larger than the container I was deploying.
2. Too complicated for such a simple task.

## How

`{{}}` is env replacement, e.g. `{{HOME}}` == `$HOME`
`{{!}}` is command replacement, e.g. `{{!echo 1}}` == `1`

env vars substituted before command substitution
