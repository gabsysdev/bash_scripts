#GCP
#Count resources quantity and show them, from project name argument
read -p 'Project: ' line

echo $line
echo "Number of resources on project: "

gcloud asset search-all-resources --scope='projects/'$line'' --read-mask="name,assetType,displayName,state" --order-by="assetType" | grep -c assetType

echo 'Project $line contains the following resources: '
echo ''

gcloud asset search-all-resources --scope='projects/'$line'' --read-mask="name,assetType,displayName,state" --order-by="assetType"
