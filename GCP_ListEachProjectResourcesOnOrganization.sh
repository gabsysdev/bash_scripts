#GCP
#Creates a file "organizationId.list" with a list of all the resources that each project on the organization has (asks for organization ID)
read -p 'Enter organization ID:' ORGID

echo "Searching for projects on this organization..."
echo "NOTE: Projects which contains sys- in its name will not be listed"

echo """gcloud asset search-all-resources --scope='organizations/$ORGID' | grep 'project: projects' | sort -u | sed 's/project: projects//g' > dirtyProjects.tmp """ > getDirtyProjectsList.sh

chmod u+x getDirtyProjectsList.sh
./getDirtyProjectsList.sh

while read -r line;
do echo "ProjectNumber: ${line#?}" ; gcloud projects describe ${line#?} | grep 'projectId: ' ; echo "" ; done < dirtyProjects.tmp | grep projectId | sed -e "s/projectId: //g" > projectIds.tmp ; sed -i '/sys-/d' projectIds.tmp

while read -r PROJECTID; do echo $PROJECTID ; gcloud asset search-all-resources --scope=projects/$PROJECTID --page-size=500 --format='csv(assetType,project)' | sed 1d | sort | uniq -c ; echo "" ; done < projectIds.tmp > $ORGID.list

rm projectIds.tmp
rm dirtyProjects.tmp
rm getDirtyProjectsList.sh
