#!/bin/bash

# Function to ask "Are you sure?"
ask_confirmation() {
    echo ""
    read -p "Are you sure you want to perform this action? (y/n): " confirm
    case $confirm in
        [Yy]*)
            return 0   # Continue with the action
            ;;
        [Nn]*)
            echo ""
            echo "Operation canceled."
            return 1   # Cancel the action
            ;;
        *)
            echo "Invalid input. Action canceled."
            return 1   # Cancel the action
            ;;
    esac
}

# Menu options
options=("Getinfo" "Logs" "Start LND" "Stop LND" "Restart LND" "< Back")

# Function to display the menu
show_menu() {
    clear
    echo "***********************************"
    echo "                LND                "
    echo "***********************************"
    echo

    for i in "${!options[@]}"; do
        if [[ $i == $selected ]]; then
            echo -e "> \e[1;32m${options[$i]}\e[0m" # Highlight selected option
        else
            echo " ${options[$i]}"
        fi
    done
}

# Function to execute selected option
execute_choice() {
    case $selected in
        0)
            echo ""
            lncli getinfo
            ;;
        1)
            echo ""
            journalctl -fu lnd | sed '1s/^/\n/' &
            pid=$!
            read -p "Press Enter to return to menu..."
            kill $pid
            ;;
        2)
            if ask_confirmation; then
            echo ""
            sudo systemctl start lnd
            fi
            ;;
        3)
            if ask_confirmation; then
            echo ""
            sudo systemctl stop lnd
            fi
            ;;
        4)
            if ask_confirmation; then
            echo ""
            sudo systemctl restart lnd
            fi
            ;;
        5)
            echo ""
            echo ""
            exit 0
            ;;
    esac
}

# Initialize selection index
selected=0

# Infinite loop to keep the menu open
while true; do
    show_menu

    # Read user input (arrow keys)
    read -rsn1 key # Read 1 character (silent)
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key # Read 2 more characters
        case $key in
            '[A') # Up arrow
                ((selected--))
                if [[ $selected -lt 0 ]]; then
                    selected=$((${#options[@]} - 1)) # Wrap to bottom
                fi
                ;;
            '[B') # Down arrow
                ((selected++))
                if [[ $selected -ge ${#options[@]} ]]; then
                    selected=0 # Wrap to top
                fi
                ;;
        esac
    elif [[ $key == "" ]]; then # Enter key
        execute_choice
        read -p "Press Enter to continue..." # Pause after execution
    fi
done
