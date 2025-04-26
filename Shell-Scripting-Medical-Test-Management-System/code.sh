#--------------------------------------------check if the information of test is extied-------------------------------------
if [ -e "medicalTest.txt" ]
then
echo "medicalTest.txt is exited"

else
echo "file (medicalTest.txt) not found"
sleep 1
echo "please check the file before running"
sleep 2
exit 1
fi


#--------------------------------------------check if the file for Patient test is extied-------------------------------------

if [ -e "midecalRecord.txt" ]
then
echo "midecalRecord.txt is exited"

else
echo "file (midecalRecord.txt) not found"
sleep 1
echo "the file is creating.............."
sleep 2
touch midecalRecord.txt
fi


sleep 1
echo "the system is downloading........."
sleep 2




#------------------------------------------------------------------------------------------number of Patient tests----------------------------------------------------------------
n=$(cat midecalRecord.txt | wc -l)



#---------------------------------------------------------------------------read from midecalRecord.txt and save it to array--------------------------------------------------------
line=1
word=1
index1=0
index2=0

declare -A array1
while [ $line -le $n ]
do

word=1
index2=0
while [ $word -le 6 ]
do

if [ $index2 -eq 0 ]
then
array1[$index1,$index2]=$(cat midecalRecord.txt | sed -n "${line}p"  | cut -d':' -f $word)
index2=$(($index2 + 1))
fi





array1[$index1,$index2]=$(cat midecalRecord.txt | sed -n "${line}p"  | cut -d':' -f 2 | cut -d',' -f $word | cut -d" " -f2)

word=$(($word +1))
index2=$(($index2 + 1))
done

index1=$(($index1 + 1))
line=$(($line +1))

done


#------------------------------------------------------------------------------------------number of tests----------------------------------------------------------------
m=$(cat medicalTest.txt | wc -l)

#--------------------------------------------------------------------------------------read from medicalTest.txt and save it to array--------------------------------------------------------

line=1
word=1
index1=0
index2=0

declare -A array2
while [ $line -le $m ]
do

word=1
index2=0
while [ $word -le 4 ]
do

if [ $index2 -eq 1 ]
then

moreexited=$(cat medicalTest.txt | sed -n "${line}p"  | grep ">" )

if [ -n "$moreexited" ]
then
array2[$index1,$index2]=$(cat medicalTest.txt | sed -n "${line}p"  | cut -d',' -f $word | cut -d">" -f2 | cut -d" " -f2)
word=$(($word +1))
index2=$(($index2 + 1))
else
array2[$index1,$index2]=
index2=$(($index2 + 1))
fi





elif [ $index2 -eq 2 ]
then

lessexited=$(cat medicalTest.txt | sed -n "${line}p"  | grep "<" )

if [ -n "$lessexited" ]
then
array2[$index1,$index2]=$(cat medicalTest.txt | sed -n "${line}p"  | cut -d',' -f $word | cut -d"<" -f2 | cut -d" " -f2)
word=$(($word +1))
index2=$(($index2 + 1))
else
array2[$index1,$index2]=
index2=$(($index2 + 1))
fi

else




array2[$index1,$index2]=$(cat medicalTest.txt | sed -n "${line}p"  | cut -d',' -f $word | cut -d" " -f2)


word=$(($word +1))
index2=$(($index2 + 1))
fi


done

index1=$(($index1 + 1))
line=$(($line +1))

done




#--------------------------------------------------------------------------------------------------------print tests-------------------------------------------------------

printdata() {
for ((i = 0; i < n; i++)); do
 for ((j = 0; j < 6; j++)); do
 printf "%s|" "${array1[$i,$j]}"
 done

printf "\n"
done

}

printtest() {
for ((i = 0; i < m; i++)); do
 for ((j = 0; j < 4; j++)); do
 printf "%s|" "${array2[$i,$j]}"
 done

printf "\n"
done

}


#------------------------------------------------------------------------------------------------------ VALIDTION FUNCTION -------------------------------------------------------------------
valid=1
datavalid(){
data="$1"
type="$2"
valid=1
#**************************************************ID VAILDTION********************************
if [ "$type" == "ID" ]
then 
 #===============check that is just numbers=======
 justnumber=$(echo $data | tr -d "\." | tr -d '0-9'  )
 if [ -n "$justnumber" ]
 then 
 echo "please just enter numbers"
 valid=0
 fi  

 
 #=========check if it is integer==========
 integer=$(echo $data | grep "\.")
 if [ -n "$integer" ]
 then 
 echo "please just enter  intger"
  valid=0
 fi
 
 #===========check if it is 7 digit==========
 if [ $valid -eq 1 ]
 then
 if [ $data -gt 9999999 -o $data -lt 1000000 ]
 then
 echo "please enter ID with 7 digit"
 valid=0
 fi
 fi
 
 
 
 
 
 
 
 
#******************************************************TEST DATE VAILDTION***********************************************








elif [ "$type" == "Test date" ]
then
#===============check that is just numbers=======
 justnumber=$(echo $data | tr -d "-" | tr -d '0-9'  )
 if [ -n "$justnumber" ]
 then 
 echo "please just enter numbers"
 valid=0
 fi
#==================check if  the format is right=======
 if [ $valid -eq 1 ]
 then
  year=$(echo $data | cut -d'-' -f1)
  month=$(echo $data | cut -d'-' -f2)
  other=$(echo $data | cut -d'-' -f3)


   if [ -z "year" ]
   then
   echo "please enter the year"
   valid=0
  elif [ -z "$month" ]
  then
  echo "please enter the month"
  valid=0
  elif [ -n "$other" ]
  then
    echo "please just enter the month and year"
    valid=0
  
   fi
   fi


#===================check if the numbers in the right range==============
 if [ $valid -eq 1 ]
  then
  if [ $year -lt 1000 -o $year -gt 9999 ]
  then 
   echo "please enter the year in range 4 digit"
   valid=0
  fi



  numberofdigit=$(echo "$month"| wc -c )
  if [ $numberofdigit -ne 3 ]
  then
  echo "please enter the month in range 2 digit like: 01  not 1 "
  valid=0
  elif [ $month -lt 1 -o $month -gt 12 ]
  then
   echo "please enter vaild month in range (12,1)"
   valid=0
    fi
   
  fi

#*************************************************RESULT VAILDTION**************************************** 

elif [ "$type" == "Result" ]
then

#===============check that is just numbers=======
 justnumber=$(echo $data | tr -d "\." | tr -d '0-9'  )
 if [ -n "$justnumber" ]
 then 
 echo "please just enter numbers"
 valid=0
 fi
 
  #=========check if it is float==========
 float=$(echo $data | grep "\.")
 if [ -z "$float" ]
 then 
 echo "please just enter the number in float format like 123.0"
  valid=0
 fi
 
 #*************************************************STATUS VAILDTION****************************************
 
 elif [ "$type" == "Status" ]
 then
 
 #==============check that is just string=======
 juststring=$(echo $data | tr -d '[a-zA-Z]'  )
 if [ -n "$juststring" ]
 then 
 echo "please just enter string"
 valid=0
 fi
  #===========check that is extied states=======
   if [ $valid -eq 1 ]
   then
    if [ "$data" != "pending" -a "$data" != "completed" -a "$data" != "reviewed" ]
    then
    echo "pleae enter one of the following (pending,completed,reviewed)"
     valid=0
    fi
    fi 
 #*************************************************TEST NAME VAILDTION****************************************
 elif [ "$type" == "Test name" ]
 then
 
 
 #===============check that is just string=======
 juststring=$(echo $data | tr -d '[a-zA-Z]'  )
 if [ -n "$juststring" ]
 then 
 echo "please just enter string"
 valid=0
 fi
#*************************************************Unit VAILDTION****************************************

elif [ "$type" == "Unit" ]
then
 #===============check that is no numbers in unit=======
nonumber=$(echo $data | grep '[0-9]'  )
 if [ -n "$nonumber" ]
 then 
 echo "please just enter the unit without any nubmer"
 valid=0
 fi


fi

}










#-------------------------------------------------------------------------------------------------CHECK IF NAME OF TEST EXITED----------------------------------------------------------
istestexcited=0
excitedtest(){

nameoftest="$1"

istestexcited=0
for ((i = 0; i < m; i++)); do
 if [ "${array2[$i,0]}" == "$nameoftest" ]
 then
 istestexcited=1
 break
 fi

done

}

#------------------------------------------------------------------------------------------------------------CHECK IF PATIENT EXICTED-----------------------------------

ispatientexcited=0
excitedpatient(){

ID="$1"

ispatientexcited=0
for ((i = 0; i < n; i++)); do
 if [ "${array1[$i,0]}" -eq $ID ]
 then
 ispatientexcited=1
 break
 fi

done

}


#--------------------------------------------------------------------------------------------------------ADD TEST---------------------------------------------------------------------
addtest(){
#=======================ID==============
ID=""
echo "please enter your Patient ID"
read ID
datavalid "$ID" "ID"

while [ $valid -eq 0 ]
do
echo "please enter valid ID ! ! !"
read ID
datavalid "$ID" "ID"
done

#======================test name===================
name=""
echo "please enter your test name"
read name
datavalid "$name" "Test name"
excitedtest "$name"
while [ $valid -eq 0 ]
do
echo "please enter valid name ! ! !"
read name
datavalid "$name" "Test name"
done

while [ $istestexcited -eq 0 ]
do
echo "please enter exited test in system ! ! !"
read name
excitedtest "$name"
done

#========================test date======================

date=""
echo "please enter your test date"
read date
datavalid "$date" "Test date"

while [ $valid -eq 0 ]
do
echo "please enter valid date ! ! !"
read date
datavalid "$date" "Test date"
done
 #=================================result===================
result=""
echo "please enter your result"
read result
datavalid "$result" "Result"

while [ $valid -eq 0 ]
do
echo "please enter valid result ! ! !"
read result
datavalid "$result" "Result"
done
#================================Unit====================
unit=""
echo "please enter your unit"
read unit
datavalid "$unit" "Unit"

while [ $valid -eq 0 ]
do
echo "please enter valid unit ! ! !"
read unit
datavalid "$unit" "Unit"
done


#================================status====================

status=""
echo "please enter your status"
read status
datavalid "$status" "Status"

while [ $valid -eq 0 ]
do
echo "please enter valid status ! ! !"
read status
datavalid "$status" "Status"
done



echo "$ID: $name, $date, $result, $unit, $status" >> midecalRecord.txt
array1[$n,0]="$ID"
array1[$n,1]="$name"
array1[$n,2]="$date"
array1[$n,3]="$result"
array1[$n,4]="$unit"
array1[$n,5]="$status"

n=$((n+1))

}


#-----------------------------------------------------------------------------------------------------------CHAECK IF TEST IS abnormal---------------------------

isabnormal=1
abnormal(){

name="$1"
result="$2"


result=$( echo $result | tr -d "\." | tr -d " ")   
isabnormal=0

#======================================
for ((i = 0; i < m; i++)); do



 if [ "${array2[$i,0]}" == "$name" ]
 then

value="${array2[$i,1]}"

# we check first if condetin excited then we check if it is less than the min
    if [ -n "$value" ]
    then

       isfloat=$( echo $value | grep "\.")
       
     if [ -n "$isfloat" ]
     then 
       value=$( echo $value | tr -d "\." | tr -d " ")
      else
      value="$value 0"
      value=$(echo $value | tr -d " ")
      fi

       
      if [ $result -lt $value ]
       then
         isabnormal=1
         fi

     fi

     value="${array2[$i,2]}"
    
# we check first if condetin excited then we check if it is more than the max     
   if [ -n "$value" ]
   then
     
      isfloat=$( echo $value | grep "\.")

     if [ -n "$isfloat" ]
     then 
       value=$( echo $value | tr -d "\." | tr -d " ")
      else
       value="$value 0"
       
      value=$(echo $value | tr -d " ")
      
      fi
   
     
        
       if [ $result -gt $value ]
       then
         isabnormal=1
         fi

     fi


# when we find first test we exit the loop since it uniq test
   break

 fi
 

done


}







#-------------------------------------------------------------------------------------------------SEARCH FOR TEST-------------------------------------------------------------------
searchtest(){
typeofsearch="$1"
ID="$2"


datavalid "$ID" "ID"


while [ $valid -eq 0 ]
do
echo "please enter valid ID ! ! !"
read ID
datavalid "$ID" "ID"
done



excitedpatient "$ID"
#check if the patient  excited , if not we keep asking user until entering  excited patient 
while [ $ispatientexcited -eq 0 ]
do
echo "the patient is not excited, please try again"
read ID
excitedpatient "$ID"
done




count=1
#=============================ALL====================
if [ "$typeofsearch" == "all" ]
then

for ((i = 0; i < n; i++)); do
 if [ "${array1[$i,0]}" == "$ID" ]
 then
 printf "%d- %s: %s, %s, %s, %s, %s" "$count" "${array1[$i,0]}" "${array1[$i,1]}" "${array1[$i,2]}" "${array1[$i,3]}" "${array1[$i,4]}" "${array1[$i,5]}"
 printf "\n"
 count=$((count+1))
 fi
 
done



if [ $count -eq 1 ]
then
echo "there is no Patient with this ID"
fi


#===============================abnormal================
elif [ "$typeofsearch" == "abnormal" ]
then
for ((j = 0; j < n; j++)); do
 if [ "${array1[$j,0]}" == "$ID" ]
 then
 
 
 
   abnormal "${array1[$j,1]}" "${array1[$j,3]}"
  
   if [ $isabnormal -eq 1 ]
   then
    
   printf "%d- %s: %s, %s, %s, %s, %s" "$count" "${array1[$j,0]}" "${array1[$j,1]}" "${array1[$j,2]}" "${array1[$j,3]}" "${array1[$j,4]}" "${array1[$j,5]}"
   printf "\n"
   count=$((count+1))
   
   fi
 fi



done


if [ $count -eq 1 ]
then
echo "there is no Patient with abnormal result"
fi



#====================================PERIOD==================
elif [ "$typeofsearch" == "period" ]
then



echo "please enter date in format (YYYY-MM) "
echo "from :"
read from
datavalid "$from" "Test date" 
while [ $valid -eq 0 ]
do
echo "please enter valid date !  ! !"
read from
datavalid "$from" "Test date" 
done

yearfrom=$( echo $from | cut -d'-' -f 1 ) 
monthfrom=$( echo $from | cut -d'-' -f 2 ) 

echo "please enter date in format (YYYY-MM) "
echo "to :"
read to
datavalid "$to" "Test date" 
while [ $valid -eq 0 ]
do
echo "please enter valid date !  ! !"
read to
datavalid "$to" "Test date" 
done

yearto=$( echo $to | cut -d'-' -f 1 ) 
monthto=$( echo $to | cut -d'-' -f 2 ) 


for ((i = 0; i < n; i++)); do

if [ "${array1[$i,0]}" == "$ID" ]
 then
  
 year=$( echo "${array1[$i,2]}" | cut -d'-' -f 1 ) 
 month=$( echo "${array1[$i,2]}" | cut -d'-' -f 2 )
 

 if [ $year -ge $yearfrom ] && [ $year -le $yearto ]
 then
 

   
    
    
    if [ "$month" -lt "$monthfrom" ] && [ "$year" -eq "$yearfrom" ]
    then
     continue
    
    
    elif [ "$month" -gt "$monthto" ] &&  [ "$year" -eq "$yearto" ]
    then
      continue
    
    
    else
    
       printf "%d- %s: %s, %s, %s, %s, %s" "$count" "${array1[$i,0]}" "${array1[$i,1]}" "${array1[$i,2]}" "${array1[$i,3]}" "${array1[$i,4]}" "${array1[$i,5]}"
       printf "\n"
       count=$((count+1))
 
 
     fi
 
  fi
 
 fi  


done


if [ $count -eq 1 ]
then
echo "there is no Patient with this range"
fi



#=====================================STATUS============
elif [ "$typeofsearch" == "status" ]
then



echo "please enter the status that you want to serach for"
read status
datavalid "$status" "Status"

while [ $valid -eq 0 ]
do


echo "please enter valid statues"
read status
datavalid "$status" "Status"
done


for ((i = 0; i < n; i++)); do

 if [ "${array1[$i,0]}" == "$ID" ]
  then
   
     if [ "$status" == "${array1[$i,5]}" ]
       then
         printf "%d- %s: %s, %s, %s, %s, %s" "$count" "${array1[$i,0]}" "${array1[$i,1]}" "${array1[$i,2]}" "${array1[$i,3]}" "${array1[$i,4]}" "${array1[$i,5]}"
         printf "\n"
         count=$((count+1))
         
         fi


 fi 
done


if [ $count -eq 1 ]
then
echo "there is no Patient with this status"
fi



fi

}








#--------------------------------------------------------------------------------------------------------FIND abnormal DATA------------------------------------------------------------------------
allabnormal(){

echo 
name=""
echo "please enter your test name"
read name
datavalid "$name" "Test name"
excitedtest "$name"
while [ $valid -eq 0 ]
do
echo "please enter valid name ! ! !"
read name
datavalid "$name" "Test name"
done

while [ $istestexcited -eq 0 ]
do
echo "please enter exited test in system ! ! !"
read name
excitedtest "$name"
done

count=1
for ((j = 0; j < n; j++)); do
 
  if [ "${array1[$j,1]}" == "$name" ]
  then
   abnormal "${array1[$j,1]}" "${array1[$j,3]}"
  
   if [ $isabnormal -eq 1 ]
   then
    
   printf "%d- %s: %s, %s, %s, %s, %s" "$count" "${array1[$j,0]}" "${array1[$j,1]}" "${array1[$j,2]}" "${array1[$j,3]}" "${array1[$j,4]}" "${array1[$j,5]}"
   printf "\n"
   count=$((count+1))
   
   fi
 fi
done


if [ $count -eq 1 ]
then
echo "there is no Patient with abnormal result"
fi

}




declare -A array3

declare -A array4




#-------------------------------------------------------------------------------------------------------------FIND AVARGE VALUE FOR EACH TEST---------------------------------------------------

averge(){

for ((j = 0; j < m; j++)); do
array3[$j]=0
 done

for ((j = 0; j < m; j++)); do
array4[$j]=0
 done


for ((i = 0; i < n; i++)); do



 for ((j = 0; j < m; j++)); do

  if [ "${array1[$i,1]}" == "${array2[$j,0]}" ]
  then
    realvalue="${array1[$i,3]}"
    
        isfloat=$( echo $realvalue | grep "\.")

     if [ -n "$isfloat" ]
     then 
       realvalue=$( echo $realvalue | tr -d "\." | tr -d " ")
      else
       realvalue="$realvalue 0"
       
      realvalue=$(echo $realvalue | tr -d " ")
      
      fi
    
    
   array3[$j]=$((realvalue + array3[$j]))
   array4[$j]=$((array4[$j]+1))
    break
   fi


 done
  
done


 for ((j = 0; j < m; j++)); do
 
   if [ ${array4[$j]} -ne 0 ]
   then
   array3[$j]=$(( array3[$j] /  array4[$j] ))
   fi
   
   
 done


 for ((j = 0; j < m; j++)); do
 
 
 if [ ${array4[$j]} -eq 0 ]
 then
 array3[$j]=0
 continue
 fi
 

 fraction=$(( array3[$j]%10 ))
 numberofchar=$( echo "${array3[$j]}" | wc -c )
 numberofchar=$((numberofchar - 2))
 value=$( echo "${array3[$j]}" | cut -c $1-$numberofchar)
 value="$value . $fraction"
 value=$(echo "$value" | tr -d " ")
 
 array3[$j]="$value"
 
 done



}


#====================================print avarge=======================

printavg() {
for ((i = 0; i < m; i++)); do
 
 printf "%s :%s"  "${array2[$i,0]}" "${array3[$i]}"
 

printf "\n"
done

}


#------------------------------------------------------------------------------------------------------------UPDATE------------------------------------------------------------------------
update(){


#=======================ID==============
ID=""
echo "please enter your Patient ID"
read ID
datavalid "$ID" "ID"

while [ $valid -eq 0 ]
do
echo "please enter valid ID ! ! !"
read ID
datavalid "$ID" "ID"
done

#======================test name===================
name=""
echo "please enter your test name"
read name
datavalid "$name" "Test name"
excitedtest "$name"
while [ $valid -eq 0 ]
do
echo "please enter valid name ! ! !"
read name
datavalid "$name" "Test name"
done

while [ $istestexcited -eq 0 ]
do
echo "please enter exited test in system ! ! !"
read name
excitedtest "$name"
done

#========================test date======================

date=""
echo "please enter your test date"
read date
datavalid "$date" "Test date"

while [ $valid -eq 0 ]
do
echo "please enter valid date ! ! !"
read date
datavalid "$date" "Test date"
done
 #=================================result===================
result=""
echo "please enter your result"
read result
datavalid "$result" "Result"

while [ $valid -eq 0 ]
do
echo "please enter valid result ! ! !"
read result
datavalid "$result" "Result"
done
#================================Unit====================
unit=""
echo "please enter your unit"
read unit
datavalid "$unit" "Unit"

while [ $valid -eq 0 ]
do
echo "please enter valid unit ! ! !"
read unit
datavalid "$unit" "Unit"
done


#================================status====================

status=""
echo "please enter your status"
read status
datavalid "$status" "Status"

while [ $valid -eq 0 ]
do
echo "please enter valid status ! ! !"
read status
datavalid "$status" "Status"
done


echo "$ID: $name, $date, $result, $unit, $status"
updatetest=$( cat midecalRecord.txt | grep -w "$ID: $name, $date, $result, $unit, $status")


if [ -z "$updatetest" ]
then
echo "there is no test with same information"

else

whichline=$( cat midecalRecord.txt | grep -w -n "$ID: $name, $date, $result, $unit, $status" | cut -d':' -f 1)
theindex=$(($whichline - 1))


echo "please enter your new result"
read newresult
datavalid "$newresult" "Result"

while [ $valid -eq 0 ]
do
echo "please enter valid result ! ! !"
read newresult
datavalid "$newresult" "Result"
done
old="$ID: $name, $date, $result, $unit, $status"
new="$ID: $name, $date, $newresult, $unit, $status"


array1[$theindex,3]="$newresult"


tempfile=$(mktemp)
file="midecalRecord.txt"

sed "s|$old|$new|g" "$file" > "$tempfile"

mv "$tempfile" "$file"

fi
}


#----------------------------------------------------------------------------------------------------------------------DELETE----------------------------------------------------------

delete(){

#=======================ID==============
ID=""
echo "please enter your Patient ID"
read ID
datavalid "$ID" "ID"

while [ $valid -eq 0 ]
do
echo "please enter valid ID ! ! !"
read ID
datavalid "$ID" "ID"
done

#======================test name===================
name=""
echo "please enter your test name"
read name
datavalid "$name" "Test name"
excitedtest "$name"
while [ $valid -eq 0 ]
do
echo "please enter valid name ! ! !"
read name
datavalid "$name" "Test name"
done

while [ $istestexcited -eq 0 ]
do
echo "please enter exited test in system ! ! !"
read name
excitedtest "$name"
done

#========================test date======================

date=""
echo "please enter your test date"
read date
datavalid "$date" "Test date"

while [ $valid -eq 0 ]
do
echo "please enter valid date ! ! !"
read date
datavalid "$date" "Test date"
done
 #=================================result===================
result=""
echo "please enter your result"
read result
datavalid "$result" "Result"

while [ $valid -eq 0 ]
do
echo "please enter valid result ! ! !"
read result
datavalid "$result" "Result"
done
#================================Unit====================
unit=""
echo "please enter your unit"
read unit
datavalid "$unit" "Unit"

while [ $valid -eq 0 ]
do
echo "please enter valid unit ! ! !"
read unit
datavalid "$unit" "Unit"
done


#================================status====================

status=""
echo "please enter your status"
read status
datavalid "$status" "Status"

while [ $valid -eq 0 ]
do
echo "please enter valid status ! ! !"
read status
datavalid "$status" "Status"
done



deletedtest=$( cat midecalRecord.txt | grep -w "$ID: $name, $date, $result, $unit, $status")


if [ -z "$deletedtest" ]
then
echo "there is no test with same information"

else

whichline=$( cat midecalRecord.txt | grep -w -n "$ID: $name, $date, $result, $unit, $status" | cut -d':' -f 1)
theindex=$(($whichline - 1))






old="$ID: $name, $date, $result, $unit, $status"


for ((i = $theindex; i < n; i++)); do
next=$((i+1))




for ((b = 0; b < 6; b++)); do

array1[$i,$b]="${array1[$next,$b]}"
done

done


n=$((n-1))


tempfile=$(mktemp)
file="midecalRecord.txt"

sed "$whichline d" "$file" > "$tempfile"

mv "$tempfile" "$file"



fi



}


#===============================================================menu for searching=====================================

searchmenu(){


echo "please enter the ID"
read ID

echo "1-Retrieve all patient tests"
echo "2-Retrieve all up abnormal patient tests"
echo "3-Retrieve all patient tests in a given specific period"
echo "4-Retrieve all patient tests based on test status" 

echo "please choose one of the follwing optaion"

read op

if [ $op -eq 1 ]
then

searchtest "all" "$ID"

elif [ $op -eq 2 ]
then

searchtest "abnormal" "$ID"

elif [ $op -eq 3 ]
then

searchtest "period" "$ID"

elif [ $op -eq 4 ]
then

searchtest "status" "$ID"

else

echo "not valid choice"

fi

}


#==================================MENU FOR PROGRAM==========================
menu(){

echo "1-add test"
echo "2-search for test"
echo "3-delete a test"
echo "4-search for abnromal test"
echo "5-find avarge value for each test"
echo "6-update test"
echo "7-statices"
echo "8-exit"
}

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


#=====================================================================================================M A I N===================================================================================

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo
echo "============================STATICES================================"
echo
echo "number of Patient tests is $n"
echo "number of valid test is is $m"
echo
echo "============================PATIENTS IS============================="
echo
printdata
echo
echo "============================TESTS IS============================="
echo
printtest
echo
echo "========================================================================================================="
echo "==================================================SYSTEM START==========================================="
echo "========================================================================================================="
echo
menu
echo "please choose one of the follwing"
read ch


while [ $ch -ne 8 ]
do

echo
echo "=============================================================================================================="
echo "================================================RESULT======================================================="
echo "=============================================================================================================="
echo

if [ $ch -eq 1 ]
then

addtest

elif [ $ch -eq 2 ]
then
searchmenu

elif [ $ch -eq 3 ]
then

delete

elif [ $ch -eq 4 ]
then

allabnormal


elif [ $ch -eq 5 ]
then

averge
printavg

elif [ $ch -eq 6 ]
then
update

elif [ $ch -eq 7 ]
then
echo
echo "=======================================NUMBER Of PATIENTS==========================================="
echo
echo "number of Patient tests is $n"
echo
echo "============================patients is============================="
echo
printdata
echo
echo "============================tests is============================="
echo
printtest
echo
elif [ $ch -eq 8 ]
then

echo "exit................"


else

echo "not valid choice"

fi

echo "==================================================MENU======================================================"
echo
menu
echo "please choose one of the follwing"
read ch

done

