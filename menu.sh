#!/bin/bash

# Menu options
options=("Bitcoin Core" "LND" "Fulcrum" "Blockchain Explorer" "ThunderHub" "Wireguard VPN" "Exit")

# Function to display the menu
show_menu() {
    clear
    echo "***********************************"
    echo "   WELCOME TO MINIBOLT NODE MENU   "
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

# Menu options commands
execute_choice() {
    case $selected in
        0)
            echo ""
            ./bitcoin_core.sh
            ;;
        1)
            echo ""
            ./lnd.sh
            ;;
        2)
            echo ""
            ./fulcrum.sh
            ;;
        3)
            echo ""
            ./btc_rpc_explorer.sh
            ;;
        4)
            echo ""
            ./thunderhub.sh
            ;;
        5)
            echo ""
            ./wireguard.sh
            ;;        
        6)
            echo "Exiting..."
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
        #read -p "Press Enter to continue..." # Pause after execution
    fi
done
