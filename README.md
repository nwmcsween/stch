# Stch

## What

A simple shell based templating language kind of like mustache(5) and gomplate , etc but ~512 bytes vs ~30MB, only use this in containerized or restricted envs as the templating script will happily `rm -rf /*`.

## Why

All other templating languages were:

1. larger than the container I was deploying.
2. Too complicated for such a simple task.

## How

* `$()` and `\`\`` are escaped
* `$[[:alpha:]_][[:alnum:]_]*` is escaped.
* `${var}` is not escaped and will do env replacement.
* `{{!cmd}}` is command replacement and is converted to `$(cmd)`.
* `{{>file}}` is file replacement and is converted to `$(cat file | stch)`.

## Gotchas/Issues

* `{{>file}}` is single depth (not recursive) and is relative to the script execution.
* `{{!cmd}}` cannot be nested as this would need recursive replacement, pipe or use helper functions to manage this (patches welcome as long as it's not a loop).

## Example

```sh
$variables are not interpolated but ${variables} are,
{{! echo "will execute a command"}} and {{>this/will/include/a/file/given/a/path.txt}}
```
