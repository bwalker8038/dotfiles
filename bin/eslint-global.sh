#!/usr/bin/env bash
# Usage: eslint-global [args]
# Runs ESLint using your global Flat Config

CONFIG="$HOME/.config/eslint/eslint.config.mjs"
ESLINT=$(command -v eslint)

if [[ ! -f "$CONFIG" ]]; then
  echo "❌ Global ESLint config not found at $CONFIG"
  exit 1
fi

exec "$ESLINT" --config "$CONFIG" "$@"
