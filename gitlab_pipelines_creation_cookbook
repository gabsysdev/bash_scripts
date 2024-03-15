#WORKFLOW:
# * Create repos(dev and deploy)
# * Init and wait for developers to push code and pass the env_vars+image_tag info
# * Add the env_vars+image_tag to /enviroments/DEV/terraform.tfvars on deploy_repo
# * Run dev pipeline
# * Run deploy pipeline
# * Check cloud run config (require auth+networking_all)

#VARS
GCLOUD_PROJECT= gcp-oh-bla-bla-bla
REPO_NAME= The new repository name
PROJECT_ID= Check below to set this variable
IMAGE_TAG= Devs will know
TEAM=desarrollo OR deploy

#To get PROJECT_ID:
  #Via curl:
  curl --header "PRIVATE-TOKEN: glpat-dXBU7kMrsbcnJkA-E8hC" "https://gitlabprod.zentricx.com/api/v4/groups" | jq '.' | nvim -
  #or from gitlab UI:
  #Go to project group repo tree, and then click the "Edit" option

#########

#Set gcloud project
gcloud config set project $GCLOUD_PROJECT
#Clone base repo
git clone https://gitlabprod.zentricx.com/gabriel/base_repo.git

#Create Deploy and Desarrollo repos:
#PROJECT_ID: 101 Deploy OR 38 Desarrollo
DESARROLLO_ID=38
DEPLOY_ID=101
curl --request POST --header 'Private-Token: glpat-dXBU7kMrsbcnJkA-E8hC' --header "Content-Type: application/json" --data '{"name":"${REPO_NAME}","namespace_id":"${DESARROLLO_ID}"}' https://gitlabprod.zentricx.com/api/v4/projects

curl --request POST --header 'Private-Token: glpat-dXBU7kMrsbcnJkA-E8hC' --header "Content-Type: application/json" --data '{"name":"${REPO_NAME}","namespace_id":"${DEPLOY_ID}"}' https://gitlabprod.zentricx.com/api/v4/projects

#For Deploy:
git clone $REPO_URL "${REPO_NAME}_deploy"
cd $REPO_NAME
git checkout -b DEV
git init --initial-branch=DEV
cp -a ../base_repo/. .
#EXPORT VARS
export REPO_NAME
export GCLOUD_PROJECT
export IMAGE_TAG
#REPLACE CORRESPONDING VARS ON:
#/common-module/variables.tf | nvim common-module/variables.tf +%s/$REPO/$REPO_NAME/g
#/environments/DEV/backend-tf | nvim environments/DEV/backend.tf +%s/$REPO/$REPO_NAME/g
#-----------------/terraform.tfvars #Ask devs for env_vars and image_tag | nvim environments/DEV/terraform.tfvars +%s/$REPO/$REPO_NAME/g
#-----------------/terraform.tfvars ###################################$ | nvim environments/DEV/terraform.tfvars +%s/$TAG/$IMAGE_TAG/g

mkdir environments/QA ; cp -r environments/DEV/* environments/QA/ ; cp ../base_repo/.gitlab-ci.yml ./ ; cp ../base_repo/.gitignore ./
git add . ; git commit 'Repo init' ;
git push -u origin DEV

#For Desarrollo:
git clone $REPO_URL "${REPO_NAME}_desarrollo"
cd $REPO_NAME
touch README.md
git checkout -b develop
git init --initial-branch=develop
git add .
git commit "Repo init"
git push -u origin develop

#Create artifact registry folder on its respective project, and save its url:
gcloud artifacts repositories create $REPO_NAME --repository-format=docker --location=us-east1 --async

ARTIFACT_IMAGE_URL=$(gcloud artifacts repositories describe $REPO_NAME --location=us-east1 --user-output-enabled 2>&1 |grep -o 'us-east1-.*')

#Add the following CI_REGISTRY and IMAGE_NAME variables to Settings>CI/CD of the repo:
REPO_ID=$(curl -s --header "PRIVATE-TOKEN: glpat-dXBU7kMrsbcnJkA-E8hC" "https://gitlabprod.zentricx.com/api/v4/projects" | jq '.[] | .id, .path_with_namespace' | grep -B 1 ${TEAM} |grep -B 1 ${REPO_NAME} |grep -v ${REPO_NAME})

#Seems like it creates the env_vars despite the "missing_value" error:
curl --request POST --header "PRIVATE-TOKEN: glpat-dXBU7kMrsbcnJkA-E8hC" \
    "https://gitlabprod.zentricx.com/api/v4/projects/$REPO_ID/variables" \
    --form "key=CI_REGISTRY" --form "value=${ARTIFACT_IMAGE_URL}"

curl --request POST --header "PRIVATE-TOKEN: glpat-dXBU7kMrsbcnJkA-E8hC" \
    "https://gitlabprod.zentricx.com/api/v4/projects/$REPO_ID/variables" \
    --form "key=IMAGE_NAME" --form "value=${REPO_NAME}"

#Wait for developers to push their code to repo and
#then add the .gitlab-ci.yml file:
#Clone the repo to your local (or pull the devs changes)
cp ../.gitlab-ci.yml.dev ./PATH TO THE Desarrollo REPO/gitlab-ci.yml

#Run the pipelines:
#For Desarrollo
#From UI> Go to repo>Build>Pipelines>Run pipeline>Select corresponding develop/tag branch>Run pipeline)

#For Deploy:
#From UI> Go to repo>Build>Pipelines>Run pipeline>Select corresponding DEV branch>Run pipeline)
