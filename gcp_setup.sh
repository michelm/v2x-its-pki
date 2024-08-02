#!/bin/bash
#
# Setup Google Cloud Platform (GCP) project
# and assure the required API's are enabled.
#
set -e -o pipefail

project=${V2XPKI_PROJECT_ID:-'v2x-its-pki'}
name=${V2XPKI_PROJECT_NAME:-$poject}
folder=$V2XPKI_FOLDER_ID
organization=$V2XPKI_ORGANIZATION_ID

args="--enable-cloud-apis --name=$name $args"

if [ ! -z "$folder" ] ; then
    args="$args --folder=$folder"
fi

if [ ! -z "$organization" ] ; then
    args="$args --organization=$organization"
fi

# Create the project if it does not exist
project_count=$(gcloud projects list | (grep "^$project " || true) | wc -l)
if [ $project_count -gt 0 ] ; then
    echo "[INFO] project $project exists"
else
    echo "[INFO] creating project($project $args)"
    gcloud projects create $project $args
fi

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

echo "[INFO] set project($project) default quota's"
gcloud auth application-default set-quota-project $project
