#!/bin/bash

showCombatOptions() {
    echo -e "${red}1. Attack${nc}   ${green}2. Heal${nc}   3. Escape   ${blue}4. Protect${nc}"
}

escape() {
    echo "You're a coward, loser."
    exit 0
}

protect() {
    oldHeroHp=$heroHp
    newHeroHp=$((heroHp - opponentStr / 2))

    if [ $newHeroHp -gt 0 ]; then let heroHp=$newHeroHp
    else let heroHp=0
    fi

    printf "You protect yourself.\n"
    printf "$opponentName attacked you and dealt $((oldHeroHp - heroHp)) damage.\n"
}

actionCombatOptions() {
    if [[ ${action,,} = "attack" ]] || [[ $action =~ ^[0-9]+$ && $action -eq 1 ]]; then
        heroAttack
        let action=1
        readAction=0
    elif [[ ${action,,} = "heal" ]] || [[ $action =~ ^[0-9]+$ && $action -eq 2 ]]; then
        heal
        let action=2
        readAction=0
    elif [[ ${action,,} = "escape" ]] || [[ $action =~ ^[0-9]+$ && $action -eq 3 ]]; then
        escape
        let action=3
        readAction=0
    elif [[ ${action,,} = "protect" ]] || [[ $action =~ ^[0-9]+$ && $action -eq 4 ]]; then
        protect
        let action=4
        readAction=0
    else readAction=2
    fi
}
