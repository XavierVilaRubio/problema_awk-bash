clear
awk -F, ' \
    BEGIN{print"{\n \"pokedex\":["}
    {
        if(NR==1){
            for(i=1;i<=NF;i++)
                fields[i]=$i
        }

        print"  {"
        for(i in fields){
            printf("   \"%s\":%s%s\n", fields[i], ($i ~ /^[0-9]+$/ ) ? $i : "\""$i"\"", (i!=NF) ? ",":"")
        }
        print ($1!=721) ? "  }," : "  }"
    }
    END{print" ]\n}"} ' \
pokedexAll.csv