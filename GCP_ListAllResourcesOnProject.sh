 gcloud asset search-all-resources --scope=projects/PROJECTID --page-size=500 --format='csv(assetType,project)' | sed 1d | sort | uniq -c
