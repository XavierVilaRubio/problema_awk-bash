file=$1
awk -F, ' \
NR==1{
	for(i=1;i<=NF;i++)
		fields[i]=$i
	
	print "{\n \""title"\":["
}
NR>1{
	print "  {"
	for(i in fields){
		printf("   \"%s\":%s%s\n", fields[i], ($i ~ /^[0-9]+$/ ) ? $i : "\""$i"\"", (i!=NF) ? ",":"")
	}
	print (NR-1!=lines) ? "  }," : "  }"
}
END{print" ]\n}"} ' \
lines=$(wc -l < $file) \
title=$(echo $file | awk -F'.' '{print $1}') \
$file