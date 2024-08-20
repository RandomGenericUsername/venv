#!/bin/bash

help_uninstall() {
    echo "Usage: env.sh uninstall [<path> | --config <config-file>]"
    echo ""
    echo "Uninstalls the environment system."
    echo "This removes the environment directory and its associated files."
    echo ""
    echo "Options:"
    echo "  <path>           The directory where the environment is installed."
    echo "  --config, -c     Specify a custom configuration file to determine the installation path."
    echo ""
    echo "Exit Codes:"
    echo "  0  Uninstallation successful."
    echo "  1  Error during uninstallation (e.g., path not found, files cannot be deleted)."
    exit 1
}

uninstall() {
    if [[ -z "$1" ]] && [[ ! -f "$CONFIG_FILE" ]];then
        echo "No installation path provided nor config file"
        exit 1
    fi

    local install_path="$1"
    source "$SCRIPT_DIR/utils/get_var_from_config.sh"  
    source "$SCRIPT_DIR/utils/validate_config.sh"  

    if [[ -z "$install_path" ]]; then
        var="ENV_PATH"
        install_path=$(get_var_from_config "$var")
        status=$?
        if [ $status -ne 0 ]; then
            echo "Variable '${var}' is not defined in config file: $?"
            exit 1
        fi
    fi
    validate_config "$install_path/config.sh"
    if [ $? -ne 0 ]; then
        echo "Invalid config.sh file"
        exit 1
    fi

    rm -rf "$install_path"
    echo "Environment uninstalled successfully from $install_path."
    exit 0
}
