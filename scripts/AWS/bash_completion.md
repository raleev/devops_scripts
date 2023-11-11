## For bash

```bash
complete -C '/usr/local/bin/aws_completer' aws
```

## For zsh

```bash
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -C '/usr/local/bin/aws_completer' aws

```
