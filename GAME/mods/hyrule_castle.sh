#!/bin/bash

# Output style
bold=$(tput bold)
underline="\e[4m"
normal=$(tput sgr0)
red="\033[0;31m"
lightRed="\033[1;31m"
lightGreen="\033[1;32m"
blue="\033[0;34m"
green="\033[0;32m"
yellow="\033[1;33m"
nc="\033[0m"

#mods
source $(dirname $0)/basic_game_customization.sh

# Data
level=1
declare -i turn

declare -i rarityPick
declare -A ennemiesArray
declare -A bossesArray

heroName=""
declare -i heroHp
declare -i heroHpMax
declare -i heroStr
declare -i heroDef
declare -i heroRes
heroType=""

opponentName=""
declare -i opponentHp
declare -i opponentHpMax
declare -i opponentStr
declare -i opponentDef
declare -i opponentRes
opponentType=""

pickRarity() {
    random=$(((RANDOM % 100) + 1)) # between 1 & 100 both included
    if [[ random -le 50 ]]; then let rarityPick=1
    elif [[ random -gt 50 && random -le 80  ]]; then let rarityPick=2
    elif [[ random -gt 80 && random -le 95  ]]; then let rarityPick=3
    elif [[ random -gt 95 && random -le 99  ]]; then let rarityPick=4
    elif [[ random -gt 99 && random -le 100  ]]; then let rarityPick=5
    fi
}

fetchHero() {
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity
    do
        if [ $((rarity - rarityPick)) == 0 ]; then
            heroName=$name
            let heroHpMax=$hp
            let heroHp=$hp
            let heroStr=$str
            let rarity=$rarity
            let heroDef=$def
            let heroRes=$res

            # if [[ ${classesArray[${class},4]} == "physical" ]]; then let heroType="physical"
            # else let heroType="magical"
            # fi
        fi
    done < <(tail -n +2 ../csv/players.csv)
}

fetchEnnemies() {
    i=0
    lines=$(grep -cve '^\s*$' ../csv/ennemies.csv)
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity
    do
        if [ $((rarity - rarityPick)) == 0 ]; then
            ennemiesArray[${i},0]=$id
            ennemiesArray[${i},1]=$name
            ennemiesArray[${i},2]=$hp
            ennemiesArray[${i},3]=$mp
            ennemiesArray[${i},4]=$str
            ennemiesArray[${i},5]=$int
            ennemiesArray[${i},6]=$def
            ennemiesArray[${i},7]=$res
            ennemiesArray[${i},8]=$spd
            ennemiesArray[${i},9]=$luck
            ennemiesArray[${i},10]=$race
            ennemiesArray[${i},11]=$class
            ennemiesArray[${i},12]=$rarity

            let i=i+1
        fi
    done < <(tail -n +2 ../csv/ennemies.csv)
}

fetchBosses() {
    i=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity
    do
        if [ $((rarity - rarityPick)) == 0 ]; then
            bossesArray[${i},0]=$id
            bossesArray[${i},1]=$name
            bossesArray[${i},2]=$hp
            bossesArray[${i},3]=$mp
            bossesArray[${i},4]=$str
            bossesArray[${i},5]=$int
            bossesArray[${i},6]=$def
            bossesArray[${i},7]=$res
            bossesArray[${i},8]=$spd
            bossesArray[${i},9]=$luck
            bossesArray[${i},10]=$race
            bossesArray[${i},11]=$class
            bossesArray[${i},12]=$rarity

            let i=i+1
        fi
    done < <(tail -n +2 ../csv/bosses.csv)
}

fetchFromEnnemies() {
    randomIdx=$(((RANDOM % $((${#ennemiesArray[@]} / 13))) + 1 ))

    opponentName=${ennemiesArray[$((randomIdx - 1)),1]}
    let opponentHp=${ennemiesArray[$((randomIdx - 1)),2]}
    let opponentHpMax=$opponentHp
    let opponentStr=${ennemiesArray[$((randomIdx - 1)),4]}
    let opponentDef=${ennemiesArray[$((randomIdx - 1)),6]}
    let opponentRes=${ennemiesArray[$((randomIdx - 1)),7]}

    opponentClass=${ennemiesArray[$((randomIdx - 1)),11]}

    # if [[ ${classesArray[$opponentClass,4]} == "physical" ]]; then let opponentType="physical"
    # else opponentType="magical"
    # fi
}

fetchFromBosses() {
    randomIdx=$(((RANDOM % $((${#bossesArray[@]} / 13))) + 1 ))

    opponentName=${bossesArray[$((randomIdx - 1)),1]}
    let opponentHp=${bossesArray[$((randomIdx - 1)),2]}
    let opponentHpMax=$opponentHp
    let opponentStr=${bossesArray[$((randomIdx - 1)),4]}
    let opponentDef=${ennemiesArray[$((randomIdx - 1)),6]}
    let opponentRes=${ennemiesArray[$((randomIdx - 1)),7]}

    opponentClass=${ennemiesArray[$((randomIdx - 1)),11]}

    # if [[ ${classesArray[$opponentClass,4]} == "physical" ]]; then let opponentType="physical"
    # else opponentType="magical"
    # fi
}

heroAttack() {
    oldOpponentHp=$opponentHp
    newOpponentHp=$((opponentHp - heroStr))

    if [ $newOpponentHp -gt 0 ]; then let opponentHp=$newOpponentHp
    else let opponentHp=0
    fi

    printf "You attacked $opponentName and dealt $((oldOpponentHp - opponentHp)) damage.\n"
}

opponentAttack() {
    oldHeroHp=$heroHp
    newHeroHp=$((heroHp - opponentStr))

    if [ $newHeroHp -gt 0 ]; then let heroHp=$newHeroHp
    else let heroHp=0
    fi

    printf "$opponentName attacked you and dealt $((oldHeroHp - heroHp)) damage.\n"
}

heal() {
    oldHeroHp=$heroHp
    newHeroHp=$((heroHp + heroHpMax / 2))

    if [ $newHeroHp -lt $heroHpMax ]; then let heroHp=$newHeroHp
    else let heroHp=$heroHpMax
    fi

    echo "You healed $((heroHp - oldHeroHp)) HP."
}

fight() {
    if [ $turn -eq 1 ]; then
        echo "You encounter a $opponentName."
        let turn++
    fi
    printf "\n${blue}${bold}====================== FIGHT $level ======================${normal}${nc}\n"
    echo -e "${red}${bold}${opponentName}${normal}${nc}"
    printf "HP "
    for (( i=0; i<$opponentHp; i++ )); do printf "${yellow}*${nc}"; done
    for (( i=0; i<($opponentHpMax-$opponentHp); i++ )); do printf "${nc}*${nc}"; done
    printf " ${opponentHp}/${opponentHpMax}\n\n"
    echo -e "${green}${bold}${heroName}${normal}${nc}"
    printf "HP "
    for (( i=0; i<${heroHp}; i++ )); do printf "${yellow}*${nc}"; done
    for (( i=0; i<($heroHpMax-$heroHp); i++ )); do printf "${nc}*${nc}"; done
    printf " ${heroHp}/${heroHpMax}\n\n"
    echo -e "${underline}Choose an action${normal}"
    showCombatOptions
}

main() {
    # source $(dirname $0)/more_statistics.sh
    pickRarity
    # fetchClasses
    fetchHero
    fetchEnnemies
    fetchBosses
    clear
    source $(dirname $0)/better_combat_options.sh

    for ((i=0; i< $gameFights; i++)); do
        let turn=1

        if [ $i -eq 10 ]; then fetchFromBosses
        else fetchFromEnnemies
        fi

        adaptDifficulty

        while [[ $heroHp -gt 0 && $opponentHp -gt 0 ]]; do
            readAction=1
            fight $turn

            while [ $readAction -gt 0 ]; do
                if [ $readAction -eq 2 ]; then printf "Invalid choice. Enter 1 to attack or 2 to heal.\n"; fi
                read action
                clear
                actionCombatOptions

                if [[ $readAction -ne 2 && $action -lt 3 && $heroHp -gt 0 && $opponentHp -gt 0 ]]; then opponentAttack; fi
            done
        done

        if [ $heroHp -eq 0 ]; then
            echo "You're dead."
            exit 0
        else
            echo "You win !"
            let coins++
        fi

        let level++
    done
}

main
exit 0
