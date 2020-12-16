#!/usr/bin/bash

RED="\033[31m"
GREEN="\033[32m"
NC="\033[0m"

player_1=${RED}"X"${NC}
player_2=${GREEN}"O"${NC}

turn=1
game_on=true

welcome_message() {
    clear
    echo "=========================="
    echo "=== TIC TAC TOE GTIDIC ==="
    echo "=========================="
    read -e -p "Quina mida vols el tauler? " size
    j=0
    if [ $size -gt 3 ]; then
        a="$(seq -f "%02g" 01 $(($size*$size)))"
        else
        a="$(seq -f "%g" 01 $(($size*$size)))"
    fi

    for i in $a
    do
        moves[$j]=$i
        j=$((j+1))
    done
}
print_board () {
    clear
    echo "=========================="
    echo "=== TIC TAC TOE GTIDIC ==="
    echo "=========================="
    for((i=0; i<$size; i++)) do
        s=$(($i*$size))
        echo -e -n " ${moves[$s]} |"
        for((j=$(($s+1)); j<$(($s+$size-1)); j++)) do
            echo -e -n " ${moves[$j]} |"
        done
        echo -e " ${moves[$j]}"
        if [ $size -gt 3 ]; then
            echo -n "--------"
        fi
        echo "-----------"
    done
}

player_pick(){
    if [[ $(($turn % 2)) == 0 ]]
    then
        play=$player_2
        echo -n -e ${GREEN}"PLAYER 2 PICK A SQUARE: "${NC}
    else
        play=$player_1
        echo -n -e ${RED}"PLAYER 1 PICK A SQUARE: "${NC}
    fi

    read square

    space=${moves[($square -1)]}

    if [[ ! $square =~ ^-?[0-9]+$ ]] || [[ ! $space =~ ^[0-9]+$  ]]
    then 
        echo "Not a valid square."
        player_pick
    else
        moves[($square -1)]=$play
        ((turn=turn+1))
    fi
    space=${moves[($square-1)]} 
}

check_match() {
    if  [[ "${moves[$1]}" == "${moves[$2]}" ]]&& \
        [[ "${moves[$2]}" == "${moves[$3]}" ]]; then
            game_on=false
    fi
    if [ $game_on == false ]; then
        if [ "${moves[$1]}" == "$player_1" ];then
            echo "Player one wins!"
            return 
        else
            echo "Player two wins!"
            return 
        fi
    fi
}

check_winner(){
    #VERTICALS
    for ((i=0; i<$(($size-2)); i++)) do
        for ((j=0; j<size; j++)) do
            check_match $(($j+$((size*i)))) $(($j+$(($size*$((i+1)))))) $(($j+$(($size*$((i+2))))))
            if [ $game_on == false ]; then return; fi
        done
    done

    #HORITZONTALS
    for ((i=0; i<$(($size-2)); i++)) do
        for ((j=0; j<size; j++)) do
            check_match $(($i+$((size*j)))) $(($((i+1))+$((size*j)))) $(($((i+2))+$((size*j))))
            if [ $game_on == false ]; then return; fi
        done
    done

    #DIAGONALS DESCENDENTS
    for ((i=0; i<$(($size-2)); i++)) do
        for ((j=0; j<$(($size-2)); j++)) do
            check_match $(($((size*i))+$j)) $(($(($size*$((i+1))+1))+$j)) $(($(($size*$((i+2))+2))+$j))
            if [ $game_on == false ]; then return; fi
        done
    done

    #DIAGONALS ASCENDENTS
    for ((i=0; i<$(($size-2)); i++)) do
        for ((j=0; j<size; j++)) do
            check_match $(($((size*$((i+2))))+$j)) $(($((size*$((i+1))+1))+$j)) $(($((size*$((i))+2))+$j))
            if [ $game_on == false ]; then return; fi
        done
    done
}

welcome_message
print_board
while $game_on
do
    player_pick
    print_board
    check_winner
done
