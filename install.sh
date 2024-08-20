#!/bin/bash

help_install() {
    echo "Usage: env.sh install <path>"
    echo ""
    echo "Installs the environment management system at the specified directory."
    echo "This setup creates the necessary files to manage regular variables, arrays,"
    echo "and associative arrays within the environment."
    echo ""
    echo "Arguments:"
    echo "  <path>  The directory where the environment files will be created."
    echo ""
    echo "Exit Codes:"
    echo "  0  Installation successful."
    echo "  1  Error during installation (e.g., directory not writable or files cannot be created)."
    exit 1
}

install() {
    local install_path="$1"
    [[ "$install_path" == "." ]] || [[ "$install_path" == "./" ]] && install_path=$INVOKE_DIR
    
    if [ -z "$install_path" ]; then
        echo "Error: No installation path provided."
        help_install
        return 1
    fi

    # Check if directory exists or can be created
    if [ ! -d "$install_path" ]; then
        mkdir -p "$install_path"
        if [ $? -ne 0 ]; then
            echo "Error: Unable to create directory at $install_path."
            return 1
        fi
    fi

    # Check if files can be created
    touch "$install_path/testfile"
    if [ $? -ne 0 ]; then
        echo "Error: Cannot write to $install_path."
        return 1
    fi
    rm "$install_path/testfile"  # Clean up

    # Create environment files
    echo "Installing environment system in $install_path..."
    touch "$install_path/env-regular.conf"
    touch "$install_path/env-array.conf"
    touch "$install_path/env-assoc-array.conf"

    # Replace placeholders in the template and write to the new config.sh
    sed "s|{{ENV_PATH}}|$install_path|g" "$SCRIPT_DIR/config.sh" > "$install_path/config.sh"

    echo "Environment system installed successfully in $install_path."

    return 0
}
