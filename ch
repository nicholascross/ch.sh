#!/usr/bin/env zsh

set -e

check_dependency() {
  command -v "$1" >/dev/null 2>&1 || { echo >&2 "$2"; echo "To install, use: $3"; exit 1; }
}

check_dependency fzf "fzf is required for interactive selection." "brew install fzf"
check_dependency glow "glow is required for displaying markdown." "brew install glow"
check_dependency promptly "promptly is required for generating options and markdown." "brew tap nicholascross/promptly; brew install promptly"

if [ "$#" -eq 0 ] || [ "$1" = "--help" ]; then
  echo "Usage: ch <topic>"
  echo "Generate and display a cheatsheet for the specified topic"
  echo "If a cheatsheet already exists, display it using glow"
  echo
  echo "ch uses promptly which requires configuration to use your specific LLM provider. See: https://github.com/nicholascross/Promptly/blob/main/Docs/configuration.md"
  exit 0
fi

cheatsheet_config_dir="$HOME/.config/ch.sh"

if [ -f "${cheatsheet_config_dir}/theme.json" ]; then
  style_file="${cheatsheet_config_dir}/theme.json"
else
  style_file="$(brew --prefix ch)/share/ch/theme.json"
fi

# Create the cheatsheet directory if it doesn't exist
cheatsheet_dir="$HOME/.config/ch.sh/cheatsheets"
mkdir -p "$cheatsheet_dir"
cheatsheet_file="${cheatsheet_dir}/$(echo "$1" | tr ' ' '_').md"

if [ -f "$cheatsheet_file" ]; then
  # If a cheatsheet already exists, display it using glow
  glow -s "$style_file" -p "$cheatsheet_file"
else
  # Generate options for clarifying the topic using role-based messaging with promptly
  clarifications=$(promptly \
    --message "system:You are an assistant who generates disambiguation and clarifying options for creating cheatsheets for macOS commandline tools.  Any choices should be presented as independent options.  Use clear and concise language.  Only output the options." \
    --message "user:Given the topic '$1', generate a list of options to create a cheatsheet.")

  # Use fzf for interactive option selection - multiple options can be selected
  selected_clarifications=$(echo "$clarifications" | fzf -m --height 40% --reverse --border)

  # Generate the cheatsheet in markdown format using role-based messaging with promptly
  generated_cheatsheet=$(promptly \
    --message "system:You are an assistant who generates succinct yet comprehensive cheat sheets in markdown format. Only output the cheatsheet without any additional commentary." \
    --message "user:Generate a cheatsheet for the following macOS commandline tool topic '$1' while considering the following clarifications: $selected_clarifications.")

  # Save the generated cheatsheet and display it using glow
  echo "$generated_cheatsheet" > "$cheatsheet_file"
  glow -s "$style_file" -p "$cheatsheet_file"
fi
