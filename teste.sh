#!/bin/bash

set -e

COMPLETION_DIR="$HOME/.config/dotfiles"
COMPLETION_FILE="$COMPLETION_DIR/dot-completion.sh"

mkdir -p "$COMPLETION_DIR"

cat > "$COMPLETION_FILE" << 'EOF'
_dot_completion() {
    local cur

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "install update" -- "$cur") )
}

complete -F _dot_completion dot
EOF

# garantir permissão correta (sem sudo)
chmod 644 "$COMPLETION_FILE"

# adicionar ao bashrc apenas se ainda não existir
if ! grep -q "dot-completion.sh" "$HOME/.bashrc"; then
    echo "source $COMPLETION_FILE" >> "$HOME/.bashrc"
    echo "✔ Autocomplete adicionado ao .bashrc"
fi

echo "✔ Autocomplete configurado (reinicie o terminal ou rode: source ~/.bashrc)"
