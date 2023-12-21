#!/bin/bash

onerr(){ while caller $((n++)); do :; done; }
trap onerr ERR

flags_found=false

while getopts 's:g:n:r:u:l:df' opt; do
    flags_found=true
    case $opt in
    s) runner_scope="${OPTARG}";; # scope: repo (:owner/:repo), org (:organization), or ent (enterprises/:enterprise)
    r) runner_group="${OPTARG}";;
    u) user="${OPTARG}";;
    l) labels="${OPTARG}";;
    f) replace='true';;
    d) disableupdate='true';;
    e) ephemeral='true';;
    esac
done

shift "$((OPTIND - 1))"

if ! "$flags_found"; then
    runner_scope=${1}
    github_pat=${2}
    user=${3}
    labels=${4}
    runner_group=${5}
fi

cd /home/$user

## Create the service file
cat > create-latest-svc.sh << \EOF100 
#/bin/bash

set -e

# Notes:
# PATS over envvars are more secure
# Downloads latest runner release (not pre-release)
# Configures it as a service more secure
# Should be used on VMs and not containers
# Works on OSX and Linux
# Assumes x64 arch (support arm64)
# See EXAMPLES below

flags_found=false

while getopts 's:g:n:r:u:l:df' opt; do
    flags_found=true

    case $opt in
    s)
        runner_scope=$OPTARG
        ;;
    g)
        ghe_hostname=$OPTARG
        ;;
    n)
        runner_name=$OPTARG
        ;;
    r)
        runner_group=$OPTARG
        ;;
    u)
        svc_user=$OPTARG
        ;;
    l)
        labels=$OPTARG
        ;;
    f)
        replace='true'
        ;;
    d)
        disableupdate='true'
        ;;
    e)
        ephemeral='true'
        ;;
    *)
        echo "
Runner Service Installer
Examples:
RUNNER_CFG_PAT=<yourPAT> ./create-latest-svc.sh myuser/myrepo my.ghe.deployment.net
RUNNER_CFG_PAT=<yourPAT> ./create-latest-svc.sh -s myorg -u user_name -l label1,label2
Usage:
    export RUNNER_CFG_PAT=<yourPAT>
    ./create-latest-svc scope [ghe_domain] [name] [user] [labels]
    -s          required  scope: repo (:owner/:repo) or org (:organization)
    -g          optional  ghe_hostname: the fully qualified domain name of your GitHub Enterprise Server deployment
    -n          optional  name of the runner, defaults to hostname
    -r          optional  name of the runner group to add the runner to, defaults to the Default group
    -u          optional  user svc will run as, defaults to current
    -l          optional  list of labels (split by comma) applied on the runner
    -d          optional  allow runner to remain on the current version for one month after the release of a newer version
    -f          optional  replace any existing runner with the same name"
        exit 0
        ;;
    esac
done

shift "$((OPTIND - 1))"

if ! "$flags_found"; then
    runner_scope=${1}
    ghe_hostname=${2}
    runner_name=${3:-$(hostname)}
    svc_user=${4:-$USER}
    labels=${5}
    runner_group=${6}
fi

# apply defaults
runner_name=${runner_name:-$(hostname)}
svc_user=${svc_user:-$USER}

echo "Configuring runner @ ${runner_scope}"
sudo echo

#---------------------------------------
# Validate Environment
#---------------------------------------
runner_plat=linux
[ ! -z "$(which sw_vers)" ] && runner_plat=osx;

runner_arch=x64
[ ! -z "$(arch | grep arm64)" ] && runner_arch=arm64

function fatal()
{
   echo "error: $1" >&2
   exit 1
}

if [ -z "${runner_scope}" ]; then fatal "supply scope as argument 1"; fi
if [ -z "${RUNNER_CFG_PAT}" ]; then fatal "RUNNER_CFG_PAT must be set before calling"; fi

which curl || fatal "curl required.  Please install in PATH with apt-get, brew, etc"
which jq || fatal "jq required.  Please install in PATH with apt-get, brew, etc"

# bail early if there's already a runner there. also sudo early
if [ -d ./runner ]; then
    fatal "Runner already exists.  Use a different directory or delete ./runner"
fi

sudo -u ${svc_user} mkdir runner

# TODO: validate not in a container
# TODO: validate systemd or osx svc installer

#--------------------------------------
# Get a config token
#--------------------------------------
echo
echo "Generating a registration token..."

base_api_url="https://api.github.com"
if [ -n "${ghe_hostname}" ]; then
    base_api_url="https://${ghe_hostname}/api/v3"
fi

# if the scope has a slash, it's a repo runner
orgs_or_repos="orgs"
runner_scope2=${runner_scope}
if [[ "$runner_scope" == *enterprises\/* ]]; then
    orgs_or_repos="enterprises"
    runner_scope2=${runner_scope/enterprises\//}
elif [[ "$runner_scope" == *\/* ]]; then
    orgs_or_repos="repos"
fi

export RUNNER_TOKEN=$(curl -s -X POST ${base_api_url}/${orgs_or_repos}/${runner_scope2}/actions/runners/registration-token -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${RUNNER_CFG_PAT}" | jq -r '.token')

if [ "null" == "$RUNNER_TOKEN" -o -z "$RUNNER_TOKEN" ]; then fatal "Failed to get a token"; fi

#---------------------------------------
# Download latest released and extract
#---------------------------------------
echo
echo "Downloading latest runner ..."

# For the GHES Alpha, download the runner from github.com
latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
latest_version=$(echo ${latest_version_label:1})
runner_file="actions-runner-${runner_plat}-${runner_arch}-${latest_version}.tar.gz"

if [ -f "${runner_file}" ]; then
    echo "${runner_file} exists. skipping download."
else
    runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}"

    echo "Downloading ${latest_version_label} for ${runner_plat} ..."
    echo $runner_url

    curl -O -L ${runner_url}
fi

ls -la *.tar.gz

#---------------------------------------------------
# extract to runner directory in this directory
#---------------------------------------------------
echo
echo "Extracting ${runner_file} to ./runner"

tar xzf "./${runner_file}" -C runner

# export of pass
sudo chown -R $svc_user ./runner

pushd ./runner

#---------------------------------------
# Unattend config
#---------------------------------------
runner_url="https://github.com/${runner_scope}"
if [ -n "${ghe_hostname}" ]; then
    runner_url="https://${ghe_hostname}/${runner_scope}"
fi

echo
echo "Configuring ${runner_name} @ $runner_url"
echo "./config.sh --unattended --url $runner_url --token *** ${replace:+--replace} --name $runner_name ${labels:+--labels $labels} ${runner_group:+--runnergroup \"$runner_group\"} ${disableupdate:+--disableupdate}" ${ephemeral:+--ephemeral}
sudo -E -u ${svc_user} ./config.sh --unattended --url $runner_url --token $RUNNER_TOKEN ${replace:+--replace} --name $runner_name ${labels:+--labels $labels} ${runner_group:+--runnergroup "$runner_group"} ${disableupdate:+--disableupdate} ${ephemeral:+--ephemeral}

#---------------------------------------
# Configuring as a service
#---------------------------------------
echo
echo "Configuring as a service ..."
prefix=""
if [ "${runner_plat}" == "linux" ]; then
    prefix="sudo "
fi

${prefix}./svc.sh install ${svc_user}
${prefix}./svc.sh start
EOF100

## Create the remove service file
cat > remove-svc.sh << \EOF200 
#/bin/bash

set -e

#
# Removes a runner running as a service
# Must be run on the machine where the service is run
#
# Examples:
# RUNNER_CFG_PAT=<yourPAT> ./remove-svc.sh myuser/myrepo
# RUNNER_CFG_PAT=<yourPAT> ./remove-svc.sh myorg
#
# Usage:
#     export RUNNER_CFG_PAT=<yourPAT>
#     ./remove-svc scope name
#
#      scope required  repo (:owner/:repo) or org (:organization)
#      name  optional  defaults to hostname.  name to uninstall and remove
# 
# Notes:
# PATS over envvars are more secure
# Should be used on VMs and not containers
# Works on OSX and Linux 
# Assumes x64 arch
#

runner_scope=${1}
runner_name=${2:-$(hostname)}

echo "Uninstalling runner ${runner_name} @ ${runner_scope}"
sudo echo

function fatal()
{
   echo "error: $1" >&2
   exit 1
}

if [ -z "${runner_scope}" ]; then fatal "supply scope as argument 1"; fi
if [ -z "${RUNNER_CFG_PAT}" ]; then fatal "RUNNER_CFG_PAT must be set before calling"; fi

which curl || fatal "curl required.  Please install in PATH with apt-get, brew, etc"
which jq || fatal "jq required.  Please install in PATH with apt-get, brew, etc"

runner_plat=linux
[ ! -z "$(which sw_vers)" ] && runner_plat=osx;

#--------------------------------------
# Get a remove token
#--------------------------------------
echo
echo "Generating a registration token..."

base_api_url="https://api.github.com"
if [ -n "${ghe_hostname}" ]; then
    base_api_url="https://${ghe_hostname}/api/v3"
fi

# if the scope has a slash, it's a repo runner
orgs_or_repos="orgs"
runner_scope2=${runner_scope}
if [[ "$runner_scope" == *enterprises\/* ]]; then
    orgs_or_repos="enterprises"
    runner_scope2=${runner_scope/enterprises\//}
elif [[ "$runner_scope" == *\/* ]]; then
    orgs_or_repos="repos"
fi

export REMOVE_TOKEN=$(curl -s -X POST ${base_api_url}/${orgs_or_repos}/${runner_scope2}/actions/runners/remove-token -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${RUNNER_CFG_PAT}" | jq -r '.token')

if [ "null" == "$REMOVE_TOKEN" -o -z "$REMOVE_TOKEN" ]; then fatal "Failed to get a token"; fi

#---------------------------------------
# Stop and uninstall the service
#---------------------------------------
echo
echo "Uninstall the service ..."
pushd ./runner
prefix=""
if [ "${runner_plat}" == "linux" ]; then 
    prefix="sudo "
fi 
${prefix}./svc.sh stop
${prefix}./svc.sh uninstall
./config.sh remove --token $REMOVE_TOKEN
EOF200

## Create the monitor
cat > monitor.sh << \EOF300 
#/bin/bash

set -e
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

basedir=$(dirname "$0")
cd "$basedir"

## Monitor the service
# Azure Metadata Service endpoint
endpoint="http://169.254.169.254/metadata/scheduledevents?api-version=2020-07-01"
instance_endpoint="http://169.254.169.254/metadata/instance?api-version=2020-09-01"
instance_id=$(curl -s -H Metadata:true "$instance_endpoint" | jq -r .compute.name)
echo "Instance ID: $instance_id"

for i in {1..2}; do
  # Make a request to the Azure Metadata Service
  response=$(curl -s -H Metadata:true "$endpoint")


  # Check if the response contains a termination event
  if (echo "$response" | grep -q "$instance_id") && (echo "$response" | grep -q "Terminate") && [ ! -f "./.runner-kill" ]; then
    echo "Termination event detected"
    eventid=$(echo "$response" | jq -r "[.Events | .[] | select((.EventType==\"Terminate\") and (.Resources[] | contains(\"$instance_id\")))][0] | .EventId" | tr -d '"')
    # Perform any cleanup operations here
    # Get the VMSS instance ID

    github_scope=$(cat ./runner/.runner | jq .gitHubUrl | cut -d/ -f 4- | tr -d '"')
    github_pat=$(cat ./.github)

    # Remove the runner
    RUNNER_CFG_PAT=${github_pat} ./remove-svc.sh $github_scope

    # Respond to the event
    curl -s -H Metadata:true -X POST -d "{\"StartRequests\": [{\"EventId\": \"${eventid}\"}]}" "$endpoint"
    touch ./.runner-kill

    break
  else
      echo "No termination event detected"
  fi

  # Check if a process is running and a file exists
  if ! pgrep -x "Runner.Listener" > /dev/null && [ -f "./.runner-done" ]; then
      echo "Process is not running and file exists"
  fi

  # Wait for a while before the next request
  sleep 20
done
EOF300

chown $user:$user ./create-latest-svc.sh
chown $user:$user ./remove-svc.sh
chown $user:$user ./monitor.sh
chmod 750 ./create-latest-svc.sh
chmod 750 ./remove-svc.sh
chmod 750 ./monitor.sh
usermod -a -G docker $user
echo "${github_pat}" > ./.github
chown $user:$user ./.github
chmod 600 ./.github

(crontab -u $user -l; echo "* * * * * /home/$user/monitor.sh >> /home/$user/monitor.sh.log 2>&1") | crontab -u $user -

RUNNER_CFG_PAT=${github_pat} "./create-latest-svc.sh" -u $user ${runner_scope:+-s "$runner_scope"} ${labels:+-l "$labels"} ${runner_group:+-r "$runner_group"} ${ephemeral:+-e} ${replace:+-f} ${disableupdate:+-d}
touch ./.runner-done
chown $user:$user ./.runner-done
chmod 600 ./.runner-done
