#!/bin/bash

set -ex

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO - Call: dotnet xharness ios package ...
# For now we download it:
curl "https://xharnesstestapps.blob.core.windows.net/apps/System.Numerics.Vectors.Tests.app.zip?sp=r&st=2020-04-28T13:19:11Z&se=2021-04-28T21:19:11Z&spr=https&sv=2019-10-10&sr=b&sig=HMFFNt%2BmNCqw83sKwKRPmg7MW0DuMMe6%2F0ymAnakxiQ%3D" --output $here/app.zip
app_name='System.Numerics.Vectors.Tests.app'

tar -xzf app.zip

mkdir $here/tools
cd $here/tools

dotnet new tool-manifest

dotnet tool install --no-cache --version 1.0.0-ci --add-source .. Microsoft.DotNet.XHarness.CLI

export XHARNESS_DISABLE_COLORED_OUTPUT=true
export XHARNESS_LOG_WITH_TIMESTAMPS=true

dotnet xharness ios test \
    --output-directory="$HELIX_WORKITEM_UPLOAD_ROOT" \
    --app="$here/$app_name" \
    --targets=ios-simulator-64 \
    --timeout=400 \
    --launch-timeout=180
