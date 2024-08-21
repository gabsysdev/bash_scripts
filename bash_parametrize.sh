#Description: Replaces a FILE_NAME ($1) with the variables
#written on ENVS_FILE (or $2), which contains KEY VALUES
#side by side on each line.
#Usage: ./parametrize.sh FILE_NAME ENVS_FILE
FILE=$1
if [ -z "${2}" ]; then
	ENVS_FILE="ENVS_FILE"
else
	ENVS_FILE=$2
fi
while read line; do
	KEY=$(echo $line | awk '{print $1}')
	VALUE=$(echo $line | awk '{print $2}')
	sed -i "s/${KEY}/${VALUE}/g" "${FILE}"
done < "${ENVS_FILE}"
