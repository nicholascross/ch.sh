ch - Interactive Cheatsheet Generator
========================================
ch is a command-line utility that allows you to generate and view concise cheatsheets for macOS command-line tools on the fly. If a cheatsheet for a topic already exists, ch will display it in a stylish markdown format using Glow. Otherwise, it leverages interactive clarifications (using fzf) and role-based messaging via Promptly to generate a helpful cheatsheet.

Features
--------
• Generates cheatsheets on demand for specified topics.
• Uses interactive selection via fzf to clarify ambiguous topics.
• Displays cheatsheets in a visually appealing format using Glow with a custom theme.
• Caches generated cheatsheets in your configuration directory for quick future access.

Requirements
------------
• zsh (the script is written in zsh)
• fzf – for interactive option selection
• glow – for styling and viewing markdown files
• promptly – for generating clarifications and cheatsheets via role-based messaging

```bash
brew install fzf
brew install glow
brew tap nicholascross/promptly && brew install promptly
```

Installation
------------
1. Clone or download the repository to your local machine.
2. Ensure that fzf, glow, and promptly are installed and available in your PATH.
3. Copy the script (ch) to a directory included in your PATH (e.g., /usr/local/bin/) and make sure it is executable:
   $ chmod +x /usr/local/bin/ch
4. Ensure the provided style file (theme.json) is in the appropriate location or update the script’s path to suit your configuration.

Usage
-----
To generate or view a cheatsheet, simply run:
   $ ch <topic>
For example:
   $ ch git

• If a cheatsheet for “git” exists in your configuration directory (~/.config/ch.sh/cheatsheets/), it will be displayed using Glow.
• Otherwise, the script will first prompt you with clarifying options (using fzf) and then generate a new cheatsheet using promptly.
• Note: Promptly requires configuration to work with your preferred LLM provider. Follow the configuration instructions here: https://github.com/nicholascross/Promptly/blob/main/Docs/configuration.md

Configuration
-------------
• ch stores its configuration files and generated cheatsheets in your home directory under:
   ~/.config/ch.sh
• The custom Glow style (theme.json) is used to display markdown content. Feel free to modify or replace it as needed.

Contributing
------------
If you encounter issues or would like to suggest improvements, please open an issue or submit a pull request.

License
-------
This project is licensed under the MIT License. See the LICENSE file for details.
