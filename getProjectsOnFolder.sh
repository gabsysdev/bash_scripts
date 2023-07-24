#GCP
#Show all the projects inside a folder (asks for folder ID)
read -p 'Ingrese ID de carpeta:' folder

echo "Searching for projects on this folder..."

echo """gcloud asset search-all-resources --scope='folders/$folder' | grep 'project: projects' | sort -u | sed 's/project: projects//g' > dirtyProjects.tmp """ > getDirtyProjectsList.sh

chmod u+x getDirtyProjectsList.sh
./getDirtyProjectsList.sh

while read -r line;
do echo "ProjectNumber: ${line#?}" ; gcloud projects describe ${line#?} | grep 'name: \|projectId: ' ; echo "" ; done < dirtyProjects.tmp

rm dirtyProjects.tmp
rm getDirtyProjectsList.sh
