#Description: Replaces a FILE_NAME ($1) with the vars from ENVS_FILE (or $2), 
#which contains KEY VALUES side by side in each line,
#and generates a PARAMETRIZED_FILE, with the envs following the pattern:
#{
#name = VARN_NAME
#value = VALUEN
#},
#Usage: ./parametrize.sh FILE_NAME ENVS_FILE
FILE=$1
if [ -z "${2}" ]; then
	ENVS_FILE="ENVS_FILE"
else
	ENVS_FILE=$2
fi
echo > PARAMETRIZED_FILE
while read line; do
	echo "{" >> PARAMETRIZED_FILE
	KEY=$(echo $line | awk '{print $1}')
	echo "name = \"${KEY}\"" >> PARAMETRIZED_FILE
	VALUE=$(echo $line | awk '{print $2}')
	echo "value = \"${VALUE}\"" >> PARAMETRIZED_FILE
	echo "}," >> PARAMETRIZED_FILE
done < "${ENVS_FILE}"
