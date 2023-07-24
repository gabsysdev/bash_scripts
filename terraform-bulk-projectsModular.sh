#GCP
#From a list of project files (called "projects.list"), creates
#a terraform.tf file with name "importation_<project>.tf" for each project
#Note: Not modular, tf file can be used to extract data and work on terraform. File maintenance would be difficult to achieve.

function CreateProjectsList(){
        rm projects.list
        while read proj; do echo "Add project ID (empty input to stop adding projects): ";
                if [ -z $proj ]; then
                        break
                fi
                echo " "$proj >> projects.list
        done

        echo "Finished loading projects to save on terraform files"
}

function ActivateCloudAsset(){
        while read -r line;
        do gcloud config set project $line ;  gcloud services enable cloudasset.googleapis.com 
        done < projects.list

        echo "Finished enabling services"
}

function InstallConfigConnector(){
        while read -r line;
        do gcloud config set project $line ; sudo apt-get install google-cloud-sdk-config-connector
        done < projects.list

        echo "Finished installing config-connector"
}


function PrepareProjectsToExport(){
        ActivateCloudAsset()
        InstallConfigConnector()
}

function BulkExport(){
        rm terraExport

        while read -r line;
        do echo """ echo "Exporting $line to tf" ; gcloud beta resource-config bulk-export --project="$line" --resource-format=terraform > "importation_$line.tf" ; """ >> terraExport
        done < projects.list

        echo "Starting bulk export sequence"

        chmod u+x terraExport
        ./terraExport

        echo "Finished exportation"
        rm terraExport
}

function FullExport(){
        CreateProjectsList()
        PrepareProjectsToExport()
        BulkExport()
}

function Menu(){
        PS3="Select item please: "
        items=("Add Projects, Enable Services, Install ConfigConnector and Export" "Enable Services, Install ConfigConnector and Export" "Export only")
        while true; do
                select item in "${items[@]}" Quit
                do
                        case $REPLY in
                                1) echo "Selected item #$REPLY which means $item"; FullExport();break;;
                                2) echo "Selected item #$REPLY which means $item"; PrepareProjectsToExport(); BulkExport();break;;
                                3) echo "Selected item #$REPLY which means $item"; BulkExport(); break;;
                                $((${#items[@]}+1))) echo "We're done!"; break 2;;
                                *) echo "Ooops - unknown choice $REPLY"; break;
                        esac
                done
        done
}

#Main
Menu();
