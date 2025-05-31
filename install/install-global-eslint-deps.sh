#!/usr/bin/env bash

echo "🔧 Installing global ESLint + Flat Config dependencies..."

npm install -g \
  eslint \
  @eslint/js \
  typescript \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin

echo "✅ Core ESLint packages installed."

# Optional: JSON and Markdown support
read -p "Do you want to install JSON and Markdown plugins globally as well? (y/N) " answer
case "$answer" in
  [yY][eE][sS]|[yY])
    npm install -g \
      eslint-plugin-jsonc \
      eslint-plugin-markdown
    echo "✅ JSON and Markdown plugins installed."
    ;;
  *)
    echo "⏩ Skipping optional plugins."
    ;;
esac

echo "🎉 Done. You can now use the fallback ESLint config globally."
