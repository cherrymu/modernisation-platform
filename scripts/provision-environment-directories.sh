#!/bin/bash

basedir=terraform/environments
networkdir=environments-networks
templates=terraform/templates/*.tf

provision_environment_directories() {
  # This reshapes the JSON for subnet sets to include the business unit, pulled from the filename; and the set name from the key of the object:
  # [
  #   {
  #     "subnet_sets": [
  #       {
  #         "cidr": "10.233.8.0/21",
  #         "accounts": [
  #           "nomis",
  #           "oasys",
  #         ],
  #         "set": "general",
  #         "business-unit": "hmpps"
  #       },
  #       {
  #         "cidr": "10.233.16.0/21",
  #         "accounts": [
  #           "delius"
  #         ],
  #         "set": "delius",
  #         "business-unit": "hmpps"
  #       }
  #     ]
  #   }...
  # ]
  networking_definitions=$(jq -n '[ inputs | { subnet_sets: .cidr.subnet_sets | to_entries | map_values(.value + { set: .key, "business-unit": input_filename | ltrimstr("environments-networks/") | rtrimstr(".json") | split("-")[0] } ) } ]' "$networkdir"/*.json)

  for file in environments/*.json; do
    application_name=$(basename "$file" .json)
    directory=$basedir/$application_name

    if [ -d "$directory" ]; then

      # Do nothing if a directory already exists
      echo ""
      echo "Ignoring $directory, it already exists"
      echo ""
    else
      # Create the directory and copy files if it doesn't exist
      echo ""
      echo "Creating $directory"

      mkdir -p "$directory"
      copy_templates "$directory" "$application_name"

    fi

    # This filters and reshapes networking_definitions to only include the business units and subnet sets for $APPLICATION_NAME
    # e.g. if hmpps-production.json and laa-production.json both contained subnet-sets that specified the account "core-sandbox",
    # and $APPLICATION_NAME was core-sandbox, it would output this:
    # [
    #   {
    #     "business-unit": "hmpps",
    #     "set": "general"
    #   },
    #   {
    #     "business-unit": "laa",
    #     "set": "general"
    #   }
    # ]

    # check if /environments-networks files exists for this application
    FILE_EXISTS=`jq --arg APPLICATION_NAME "$application_name" '.[].subnet_sets[] | select(.accounts[] | contains($APPLICATION_NAME))' <<< "$networking_definitions"`
    if [[ ${FILE_EXISTS} ]]
    then
      # set up raw jq data that includes application name, business unit and subnet-set
      RAW_OUTPUT=`jq --arg APPLICATION_NAME "$application_name" 'limit(1;.[].subnet_sets[] | select(.accounts[] | contains($APPLICATION_NAME)) | { "business-unit": ."business-unit", "set": .set, "application": $APPLICATION_NAME } )' <<< "$networking_definitions"`
    else
      # set up raw jq data that includes application name, blank business unit and blank subnet-set
      RAW_OUTPUT=`jq -n --arg APPLICATION_NAME "$application_name" '{ "business-unit": "", "set": "", "application": $APPLICATION_NAME }'`
    fi
    # wrap raw json output with a header and store the result in the applications folder
    jq -rn --argjson DATA "${RAW_OUTPUT}" '{ networking: [ $DATA ] }' > "$directory"/networking.auto.tfvars.json
  done
}

copy_templates() {

  for file in $templates; do
    filename=$(basename "$file")

    if [ ${filename} != "member-providers.tf" ] && [ ${filename} != "data.tf" ]
    then
      echo "Copying $file to $1, replacing application_name with $application_name"
      sed "s/\$application_name/${application_name}/g" "$file" > "$1/$filename"
      if [ ${filename} == "backend.tf" ]
      then
        sed -i "s/environments\//environments\/accounts\//g" "$1/$filename"
      fi
    fi
  done

  echo "Finished copying templates."
}

provision_environment_directories
