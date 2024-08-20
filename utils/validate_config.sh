validate_config() {
    local config_file="$1"
    local template_file="$SCRIPT_DIR/config.sh"  # Path to the template

    # Load the template variables
    source "$template_file"

    # Load the variables from the config file to validate
    source "$config_file"

    # Check if all template variables are defined in the config file
    for var in ENV_PATH REGULAR_VARIABLES ARRAY_VARIABLES ASSOCIATIVE_ARRAY_VARIABLES; do
        if [ -z "${!var}" ]; then
            echo "Error: The configuration file is missing the variable $var."
            return 1
        fi
    done

    return 0
}