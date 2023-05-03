#!/bin/bash
args=$#
if (( args !=2 && args !=3   ))
then
		echo 'usage ./test.sh <scan dir> <output dir>'
		exit 1
fi 
count=0
tempdir="$(echo $1 | awk -F / '{ print $NF } ' |sed 's/\.pdf$//' )"
file1="$(realpath $2)"$tempdir"images"
file2="$(realpath $2)"$tempdir"inverted"
[[ -d $file1  ]] && rm -rf $file1
[[ -d $file2  ]] && rm -rf $file1
mkdir -p $file1 $file2
echo -e "\e[3""$3""m[-----------file accessed  $1 ------------]\e[0m"
#echo "file accessed $1.."
if ! which pdftoppm  >/dev/null 2>&1
then 
		sudo apt install poppler-utils -y 
fi 
if ! which convert >/dev/null 2>&1

then
		sudo apt install imagemagick -y 
fi
if ! which img2pdf >/dev/null 2>&1

then
		sudo apt install img2pdf  -y 
fi  


 pdftoppm -png "$1" "$file1/test" & 
 pid=$!
 pages="$(pdfinfo "$1" | grep -Eo 'Pages:.+' | awk '{print $2}')"

pid=$! # stores executed process id in pid

# check whether process is still running
# The "[^[]" excludes the grep from finding itself in the ps output
while ps | grep "$pid[^[]" >/dev/null
do 
		clear ;
		sleep 1 ;
		echo "$(echo "$( ls $file1 |wc -l )/$pages")"  # process is still running
done 
if wait $pid 
then
		echo 'completed'
fi 


#if ps | grep "$pid[^[]" >/dev/null
#then
#		echo "$(echo "$( ls $file |wc -l )/$pages")"  # process is still running
#else
#    # If the process is already terminated, then there are 2 cases:
#    # 1) the process executed and stop successfully
#    # 2) it is terminated abnormally
#
#    if wait $pid # check if process executed successfully or not
#    then
#        echo "success (ran)"
#    else
#        echo "failed (returned $?)" # process terminated abnormally
#    fi
#fi
#
 #if pdftoppm -png "$1" "$file1/test"
#then
#		echo -e "\e[3""$3""m[-----------pdf to img done of  $1 ------------]\e[0m"
#		#echo "$1 pdf to img done "
#fi 
#images="$(find "$file1" -name "*.png" )"
#while read -r line;
#do 
#		((count++))
#convert  "$line" -channel RGB -negate $(realpath $file2)/output"$count".png
#done < <(echo "$images")
#
#for i in $(ls "$file1")
#do
#		((count++))
#		cd "$file1" && convert  "$i" -channel RGB -negate $(realpath $file2)/output"$count".png
#done 
#echo -e "\e[3""$3""m[-----------invert of  img done of   $1 ------------]\e[0m"
##echo " $1 invert to img done"
#
#files="$(ls -v  $file2 | tr '\n' ' ' )"
#if cd $file2  && img2pdf $files -o  "$(realpath $2)" 
#then
#		rm -r $file1 &&  echo -e "\e[3""$3""m[-----------Removed dir   $file1 ------------]\e[0m"
#		rm -r $file2 &&  echo -e "\e[3""$3""m[-----------Removed dir   $file2 ------------]\e[0m"
#		echo -e "\e[3""$3""m[-----------success of    $1 ------------]\e[0m"
#		#echo "$1 success "
#fi
# 
#
