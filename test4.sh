#!/bin/bash 
[[ $# -ne 2  ]] && echo 'no args' && exit 1 
pidarray=()
infoarry=()
killbackground()
{
arr=("$@")
	for i in "${arr[@]}"	
	do
			kill   $i
			echo "trap detected killing $i "
	done 
}
file="$(realpath $1)"
output="$(realpath $2)"
count=0
#for i in $(ls "$file"  )
#do 
#		((count++))
#		#echo -e "\e[3""$count""m[-----------processing $i ------------]\e[0m$1  "
#		./pdftoinvert.sh "$file/$i"   "$output/$i" $count  & 
#			
#		pidarray+=("$!")
#		infoarry+=("$file/$i")
#done 

while IFS= read -r line ;
do 
(( count++ ))
bash ./pdftoinvert.sh "$line" "$output/$(echo $line | awk -F / '{print $NF}')" $count & 
	pidarray+=("$!")
	infoarry+=("$file")
done< <( find "$file" -name "*.pdf" )


index=0
for i in "${pidarray[@]}" 
do
		wait "$i"
		echo -e "\e[3""$index""m[-----------$i ended, was ${infoarry[$index]}-----------]\e[0m$1  "
		
		((index++))
done 
wait 
echo "all process ended"
#trap killbackground "${pidarray[@]}" 1 3 9 2 15 
