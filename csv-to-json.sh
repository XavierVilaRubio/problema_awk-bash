file=$1
title=${file%.csv}

awk -v title="$title" -v lines="$(wc -l < $file)" -F, ' \
NR==1{
    for(i=1;i<=NF;i++)
        fields[i]=$i
    
    print "{\n \""title"\":["
}
NR>1{
    print "  {"
    for(i=1;i<=NF;i++){
        printf("   \"%s\":%s%s\n", fields[i], ($i ~ /^[0-9]+$/ ) ? $i : "\""$i"\"", (i!=NF) ? ",":"")
    }
    print (NR-1!=lines) ? "  }," : "  }"
}
END{print" ]\n}"} ' $file > ${title}.json

echo "The output is in ${title}.json"