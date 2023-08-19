###Creates parent folder, enviroment folders (DEV, PDN, QA-QC and SHARED), and projects on each enviroment folder. GCP_SetParentAndEnvsDirs_SetProjectsOnEnvsDirs.sh

#Enter organization and display name of the parent folder
read -p "Enter organization ID: " ORGID
read -p "Enter parent folder name: " DISPLAYNAME

#Create Parent folder
gcloud resource-manager folders create --organization=$ORGID --display-name="$DISPLAYNAME" | grep name | sed -e "s/'//g" | sed -e "s/name: folders//g" | sed -e 's./..g' | sed -e 's/^[ \t]*//' > test.file ; PARFOLDER=$(cat test.file) ; echo $PARFOLDER ; rm test.file
​
#Create enviroments folders 
gcloud resource-manager folders create --folder=$PARFOLDER --display-name="DEV" | grep name | sed -e "s/'//g" | sed -e "s/name: folders//g" | sed -e 's./..g' | sed -e 's/^[ \t]*//' > test.file ; DEVFOLDER=$(cat test.file) ; echo $DEVFOLDER ; rm test.file
gcloud resource-manager folders create --folder=$PARFOLDER --display-name="PDN" | grep name | sed -e "s/'//g" | sed -e "s/name: folders//g" | sed -e 's./..g' | sed -e 's/^[ \t]*//' > test.file ; PDNFOLDER=$(cat test.file) ; echo $PDNFOLDER ; rm test.file
gcloud resource-manager folders create --folder=$PARFOLDER --display-name="QA-QC" | grep name | sed -e "s/'//g" | sed -e "s/name: folders//g" | sed -e 's./..g' | sed -e 's/^[ \t]*//' > test.file ; QAFOLDER=$(cat test.file) ; echo $QAFOLDER ; rm test.file
gcloud resource-manager folders create --folder=$PARFOLDER --display-name="SHARED" | grep name | sed -e "s/'//g" | sed -e "s/name: folders//g" | sed -e 's./..g' | sed -e 's/^[ \t]*//' > test.file ; SHAREDFOLDER=$(cat test.file) ; echo $SHAREDFOLDER ; rm test.file
​
#Create projects on each folder:
#DEV
#gcloud projects create <PROJECT_NAME> --folder=$DEVFOLDER
#PDN
#gcloud projects create <PROJECT_NAME> --folder=$PDNFOLDER
#QA-QC
#gcloud projects create <PROJECT_NAME> --folder=$QAFOLDER
#TRANSVERSAL
#gcloud projects create <PROJECT_NAME> --folder=$SHAREDFOLDER
