#!/bin/bash

echo '################### Xharness start ###################'

set -ex

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir $here/workdir

# TODO - Call: dotnet xharness ios package ...
# For now we download it:
# curl "https://prvysokyexperiment.blob.core.windows.net/ios-apps/DummyTestProject.app.zip?sp=r&st=2020-04-22T09:38:37Z&se=2020-10-22T17:38:37Z&spr=https&sv=2019-10-10&sr=b&sig=h54BDrAf%2BenDyPbFhbCjj%2FiBLFMS4taHJ1dlrDDTxSs%3D" --output $here/app.zip
#app_name='DummyTestProject.app'

# curl "https://prvysokyexperiment.blob.core.windows.net/ios-apps/Program.Tests.app.zip?sp=r&st=2020-04-23T18:57:58Z&se=2020-06-19T02:57:58Z&spr=https&sv=2019-10-10&sr=b&sig=BRVEKgPp2WMpJNSFpNssMg4oyMX8VbcsOwpRdgqbujY%3D" --output $here/app.zip
#app_name='Program.Tests.app'

# curl "https://prvysokyexperiment.blob.core.windows.net/ios-apps/com.xamarin.bcltests.BCL%20tests%20group%203.zip?sp=r&st=2020-04-24T14:50:45Z&se=2021-04-24T22:50:45Z&spr=https&sv=2019-10-10&sr=b&sig=vQglB83jgTQoSfI42qrjgzPzIDD03X2T2vD%2BicNtuQE%3D" --output $here/app.zip
#app_name='com.xamarin.bcltests.BCL tests group 3.app'

curl "https://prvysokyexperiment.blob.core.windows.net/ios-apps/System.Numerics.Vectors.Tests.app.zip?sp=r&st=2020-04-28T08:40:27Z&se=2020-10-08T16:40:27Z&spr=https&sv=2019-10-10&sr=b&sig=EZ2n5i7ea6nccjStWMLmgzoMbIDpA0MREGVK%2Bg7c050%3D" --output $here/app.zip
app_name='System.Numerics.Vectors.Tests.app'

tar -xzf app.zip

mkdir $here/tools
cd $here/tools

dotnet new tool-manifest

dotnet tool install --version 1.0.0-ci --add-source .. Microsoft.DotNet.XHarness.CLI

export XHARNESS_DISABLE_COLORED_OUTPUT=true
export XHARNESS_LOG_WITH_TIMESTAMPS=true

dotnet xharness ios test \
    --working-directory="$here/workdir" \
    --output-directory="$HELIX_WORKITEM_UPLOAD_ROOT" \
    --app="$here/$app_name" \
    --targets=ios-simulator-64 \
    --timeout=400 \
    --launch-timeout=180

echo '#################### Xharness end ####################'
