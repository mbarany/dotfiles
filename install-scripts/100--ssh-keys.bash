# Generate GitHub SSH keys for personal and work accounts
# Keys are used for both SSH authentication and git commit signing

SSH_DIR="$HOME/.ssh"
PERSONAL_KEY="$SSH_DIR/id_github_personal"
WORK_KEY="$SSH_DIR/id_github_work"

# Ensure .ssh directory exists with proper permissions
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
fi

generate_ssh_key() {
  local key_path="$1"
  local key_name="$2"
  local email="$3"

  if [ -f "$key_path" ]; then
    echo -e "${__COLORS_BLUE}${key_name}${__COLORS_CLEAR} SSH key already exists at ${key_path}"
    return 0
  fi

  echo ""
  echo -e "Generating ${__COLORS_GREEN}${key_name}${__COLORS_CLEAR} SSH key..."
  echo "This key will be used for GitHub SSH auth and commit signing."
  echo ""

  read -r -p "Email for ${key_name} key: " email_input
  email_input=${email_input:-$email}

  # Generate ed25519 key (modern, secure, and works with GitHub)
  ssh-keygen -t ed25519 -C "$email_input" -f "$key_path"

  # Set proper permissions
  chmod 600 "$key_path"
  chmod 644 "${key_path}.pub"

  echo ""
  echo -e "${__COLORS_GREEN}${key_name} key generated!${__COLORS_CLEAR}"
  echo ""
  echo "Public key (add this to GitHub -> Settings -> SSH and GPG keys):"
  echo -e "${__COLORS_YELLOW}"
  cat "${key_path}.pub"
  echo -e "${__COLORS_CLEAR}"
  echo ""
}

setup_ssh_config() {
  local default_key="$1"
  local config_file="$SSH_DIR/config"

  # Check if github.com host already configured
  if grep -q "^Host github.com" "$config_file" 2>/dev/null; then
    echo -e "${__COLORS_BLUE}GitHub SSH config${__COLORS_CLEAR} already exists in ~/.ssh/config"
    return 0
  fi

  echo ""
  echo "Adding GitHub SSH config..."

  # Prepend GitHub config to existing config or create new
  local temp_config
  temp_config=$(mktemp) || { echo "Failed to create temp file"; return 1; }
  trap 'rm -f "$temp_config"' RETURN

  cat > "$temp_config" << EOF
Host github.com
    IdentityFile ${default_key}
    IdentitiesOnly yes

EOF

  if [ -f "$config_file" ]; then
    cat "$config_file" >> "$temp_config"
  fi

  mv "$temp_config" "$config_file"
  chmod 600 "$config_file"

  echo -e "${__COLORS_GREEN}GitHub SSH config added!${__COLORS_CLEAR}"
}

setup_allowed_signers() {
  local key_path="$1"
  local email="$2"
  local signers_file="$HOME/.git_allowed_signers"

  if [ ! -f "$signers_file" ]; then
    echo "Creating allowed signers file..."
    touch "$signers_file"
  fi

  local pub_key=$(cat "${key_path}.pub")

  # Check if this key is already in the file
  if grep -q "$pub_key" "$signers_file" 2>/dev/null; then
    echo -e "${__COLORS_BLUE}Key already in allowed signers${__COLORS_CLEAR}"
    return 0
  fi

  echo "${email} ${pub_key}" >> "$signers_file"
  echo -e "${__COLORS_GREEN}Added key to allowed signers file${__COLORS_CLEAR}"
}

# Main flow
echo ""
echo "=========================================="
echo "  GitHub SSH Key Setup"
echo "=========================================="
echo ""

# Always generate personal key
echo ""
response=$(yes-no "Generate personal GitHub SSH key (id_github_personal)?")
echo ""

if [ "$response" == "y" ]; then
  generate_ssh_key "$PERSONAL_KEY" "Personal" ""
fi

# Optionally generate work key
echo ""
response=$(yes-no "Generate work GitHub SSH key (id_github_work)?")
echo ""

GENERATED_WORK="n"
if [ "$response" == "y" ]; then
  generate_ssh_key "$WORK_KEY" "Work" ""
  GENERATED_WORK="y"
fi

# Determine which key to use as default
echo ""
echo "Which key should be the default for github.com?"
echo "  1) Personal (id_github_personal)"
if [ "$GENERATED_WORK" == "y" ] || [ -f "$WORK_KEY" ]; then
  echo "  2) Work (id_github_work)"
fi
echo ""

read -r -p "Default key [1]: " default_choice
default_choice=${default_choice:-1}

if [ "$default_choice" == "2" ] && ([ "$GENERATED_WORK" == "y" ] || [ -f "$WORK_KEY" ]); then
  DEFAULT_KEY="$WORK_KEY"
  DEFAULT_KEY_NAME="Work"
else
  DEFAULT_KEY="$PERSONAL_KEY"
  DEFAULT_KEY_NAME="Personal"
fi

echo ""
echo -e "Using ${__COLORS_GREEN}${DEFAULT_KEY_NAME}${__COLORS_CLEAR} key as default for github.com"

# Setup SSH config
setup_ssh_config "$DEFAULT_KEY"

# Setup git signing (allowed signers file)
if [ -f "$PERSONAL_KEY" ]; then
  read -r -p "Email for personal git commits (for allowed signers): " personal_email
  setup_allowed_signers "$PERSONAL_KEY" "$personal_email"
fi

if [ -f "$WORK_KEY" ]; then
  read -r -p "Email for work git commits (for allowed signers): " work_email
  setup_allowed_signers "$WORK_KEY" "$work_email"
fi

echo ""
echo -e "${__COLORS_GREEN}SSH key setup complete!${__COLORS_CLEAR}"
echo ""
echo "Next steps:"
echo "  1. Add your public key(s) to GitHub: https://github.com/settings/keys"
echo "  2. Test with: ssh -T git@github.com"
echo ""

unset SSH_DIR PERSONAL_KEY WORK_KEY DEFAULT_KEY DEFAULT_KEY_NAME GENERATED_WORK
unset -f generate_ssh_key setup_ssh_config setup_allowed_signers
