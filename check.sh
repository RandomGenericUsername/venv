#!/bin/bash



check(){
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
    if [[ ! -f "$install_path/config.sh" ]]; then
        echo "No config file found at $install_path. Exiting now..."
        exit 1
    fi
    validate_config "$install_path/config.sh"
    if [ $? -ne 0 ]; then
        echo "Invalid config.sh file"
        exit 1
    fi
    echo "Valid venv installation at: $install_path"
    exit 0
}
