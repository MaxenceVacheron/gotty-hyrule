#!/bin/bash

declare -i classesArray

fetchClasses() {
    i=0
    while IFS=',' read -r id name strength weakess attack_type alignment rarity
    do
        if [ $((rarity - rarityPick)) == 0 ]; then
            classesArray[${i},0]=$id
            classesArray[${i},1]=$name
            classesArray[${i},2]=$strength
            classesArray[${i},3]=$weakess
            classesArray[${i},4]=$attack_type
            classesArray[${i},5]=$alignment
            classesArray[${i},6]=$rarity

            let i=i+1
        fi
    done < <(tail -n +2 ../csv/classes.csv)
}


heroAttack() {
    if [[ $heroClass ]]; then echo 'a'
    else echo "b"
    fi

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
