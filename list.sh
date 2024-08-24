#!/bin/bash

# Function to display the help message
_help_list() {
    echo "Usage: venv {regular|array|assoc-array|detail|<no argument>} [--config <config-file>]"
    echo ""
    echo "Commands:"
    echo "  regular          - List only regular variables in alphabetical order."
    echo "  array            - List only array variables in alphabetical order."
    echo "  assoc-array      - List only associative array variables in alphabetical order."
    echo "  detail           - List all variables with their types in alphabetical order."
    echo "  <no argument>    - List all variables (regardless of type) in alphabetical order."
    echo ""
    echo "Options:"
    echo "  --config, -c     Specify a custom configuration file."
    echo ""
    echo "Example usage:"
    echo "  venv regular --config /path/to/config.sh"
    echo "  venv detail"
    exit 1
}



# Function to list all variables with their types in the desired format, sorted alphabetically
list_all_with_details() {
    #echo "Variables with Details:"
    if [[ -f "$CONFIG_FILE" ]]; then
        grep '^__VAR__TYPE__' "$CONFIG_FILE" | while IFS='=' read -r var_type; do
            var_name=$(echo "$var_type" | sed 's/^__VAR__TYPE__//' | cut -d '=' -f 1)
            var_type_value=$(echo "$var_type" | cut -d '=' -f 2 | tr -d '"')
            
            case "$var_type_value" in
                "regular")
                    echo "$var_name -> regular variable"
                    ;;
                "array")
                    echo "$var_name -> array variable"
                    ;;
                "associative_array")
                    echo "$var_name -> associative_array variable"
                    ;;
            esac
        done | sort
    else
        echo "No variables found."
    fi
    echo
}


# Function to list all variables alphabetically
list() {
    local type_filter="$1"
    case "$type_filter" in
        regular)
            #echo "Regular Variables:"
            if [[ -f "$REGULAR_VARIABLES" ]]; then
                cut -d '=' -f 1 "$REGULAR_VARIABLES" | sort
            else
                echo "No regular variables found."
            fi
            ;;
        array)
            #echo "Array Variables:"
            if [[ -f "$ARRAY_VARIABLES" ]]; then
                cut -d '=' -f 1 "$ARRAY_VARIABLES" | sort
            else
                echo "No array variables found."
            fi
            ;;
        assoc-array)
            #echo "Associative Array Variables:"
            if [[ -f "$ASSOCIATIVE_ARRAY_VARIABLES" ]]; then
                cut -d '[' -f 1 "$ASSOCIATIVE_ARRAY_VARIABLES" | uniq | sort
            else
                echo "No associative array variables found."
            fi
            ;;
        detail)
            list_all_with_details
            ;;
        "")
            #echo "Variables:"
            {
                [[ -f "$REGULAR_VARIABLES" ]] && cut -d '=' -f 1 "$REGULAR_VARIABLES"
                [[ -f "$ARRAY_VARIABLES" ]] && cut -d '=' -f 1 "$ARRAY_VARIABLES"
                [[ -f "$ASSOCIATIVE_ARRAY_VARIABLES" ]] && cut -d '[' -f 1 "$ASSOCIATIVE_ARRAY_VARIABLES" | uniq
            } | sort
            ;;
        *)
            _help_list 
            exit 0
    esac
}
