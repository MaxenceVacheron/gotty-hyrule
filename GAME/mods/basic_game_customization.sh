#!/bin/bash

let coins=12
declare -i gameFights
declare -i gameDifficulty

menu(){
    printf "${blue}${bold}====================== HYRULE CASTLE ======================${normal}${nc}\n"
    echo "Choose an action"
    echo "1. New Game"
    echo "2. Exit"

    readAction=1

    while [ $readAction -gt 0 ]; do
    if [ $readAction -eq 2 ]; then printf "Invalid choice. Enter 1 to start a game or 2 to exit.\n"; fi
    read action

    if [[ $action =~ ^[0-9]+$ && $action -eq 1 ]]; then
        difficulty; let gameDifficulty=$?
        numberOfFights; let gameFights=$?
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 2 ]]; then 
        exit 0
        readAction=0
    else readAction=2
    fi
    done
}

difficulty(){
    clear
    printf "${blue}${bold}====================== Hyrule Castle ======================${normal}${nc}\n"
    echo "Choose a difficulty"
    echo "1. Normal"
    echo "2. Difficult"
    echo "3. Insane"

    readAction=1

    while [ $readAction -gt 0 ]; do
    if [ $readAction -eq 2 ]; then printf "Invalid choice.\n"; fi
    read action

    if [[ $action =~ ^[0-9]+$ && $action -eq 1 ]]; then
        return 1
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 2 ]]; then 
        return 2
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 3 ]]; then 
        return 3
        readAction=0
    else readAction=2
    fi
    done
}

numberOfFights(){
    clear
    printf "${blue}${bold}====================== Hyrule Castle ======================${normal}${nc}\n"
    echo "Choose a number of fights"
    echo "1. 10"
    echo "2. 20"
    echo "3. 50"
    echo "4. 100"

    readAction=1

    while [ $readAction -gt 0 ]; do
    if [ $readAction -eq 2 ]; then printf "Invalid choice.\n"; fi
    read action

    if [[ $action =~ ^[0-9]+$ && $action -eq 1 ]]; then
        let gameFights=10
        return 10
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 2 ]]; then 
        let gameFights=20
        return 20
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 3 ]]; then 
        let gameFights=50
        return 50
        readAction=0
    elif [[ $action =~ ^[0-9]+$ && $action -eq 4 ]]; then 
        let gameFights=100
        return 100
        readAction=0
    else readAction=2
    fi
    done
}

adaptDifficulty() {
    if [ $gameDifficulty -eq 2 ]; then
        let opponentHp=$opponentHp*3/2
        let opponentStr=$opponentStr*3/2
        let opponentHpMax=$opponentHpMax*3/2

    elif [ $gameDifficulty -eq 3 ]; then
        let opponentHp=$opponentHp*2
        let opponentStr=$opponentStr*2
        let opponentHpMax=$opponentHpMax*2
    fi
}

menu
