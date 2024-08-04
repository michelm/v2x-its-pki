#!/bin/bash
#
# Setup Google Cloud Platform (GCP) project
# and assure the required API's are enabled.
#
set -e -o pipefail

usage="Usage: $(basename $0) [-p project] [-n name] [-f folder] [-o organization]"

project=${V2XPKI_PROJECT_ID:-'vee2peekayai'}
name=${V2XPKI_PROJECT_NAME:-$poject}
folder=$V2XPKI_FOLDER_ID
organization=$V2XPKI_ORGANIZATION_ID

while getopts ':p:n:f:o:h' opt; do
  case "$opt" in
    p)
      project="$OPTARG"
      ;;

    n)
      name="$OPTARG"
      ;;

    f)
      folder="$OPTARG"
      ;;

    o)
      organization="$OPTARG"
      ;;

    h)
      echo $usage
      exit 0
      ;;

    :)
      echo -e "Option requires an argument.\n$usage"
      exit 1
      ;;

    ?)
      echo -e "Invalid command option.\n$usage"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

args="--enable-cloud-apis --name=$name $args"

if [ ! -z "$folder" ] ; then
    args="$args --folder=$folder"
fi

if [ ! -z "$organization" ] ; then
    args="$args --organization=$organization"
fi

project_count=$(gcloud projects list | (grep "^$project " || true) | wc -l)
if [ $project_count -gt 0 ] ; then
    echo "[INFO] project $project exists"
else
    echo "[INFO] creating project($project $args)"
    gcloud projects create $project $args
fi

project_number=$(gcloud projects describe v2x-its-pki | grep "^projectNumber" | awk '{print $2}' | sed "s/'//g")
echo "[INFO] project(id=$project, number=$project_number)"

echo "[INFO] set $project as active project"
gcloud config set project $project

account=$(gcloud billing accounts list | (grep True || true) | awk '{print $1}')
echo "[INFO] using billing account $account"

billable=$(gcloud billing projects list --billing-account $account | (grep "^$project " || true) | (grep True || true) | wc -l)
if [ $billable -gt 0 ] ; then
    echo "[INFO] project is billabe on account $account"
else
    echo "[INFO] linking project($project) to billing account($account)"
    gcloud billing projects link $project --billing-account $account
fi

echo "[INFO] enabling project($project) api's"
gcloud services enable \
    --project $project \
    billingbudgets.googleapis.com \
    cloudresourcemanager.googleapis.com \
    run.googleapis.com \
    cloudbuild.googleapis.com \
    containerregistry.googleapis.com \
    iam.googleapis.com \
    storage.googleapis.com

echo "[INFO] set project($project) default quota's"
gcloud auth application-default set-quota-project $project

echo "[INFO] add project($project) iam-policy-binding for cloud build"
gcloud projects add-iam-policy-binding $project \
    --member=serviceAccount:${project_number}-compute@developer.gserviceaccount.com \
    --role=roles/cloudbuild.builds.builder

export GOOGLE_CLOUD_PROJECT=$project
