#!/bin/sh -e


# Check If we need to skip CI
cd ../1-Skip-CI
sh should_skip_continuous_integration.sh
if [ $? == 1 ]
  then
    exit 0
  else
    cd -
fi


echo ""
echo "-------------------------------------------------------------"
echo "   Generate TestApp iOS Test Execution Report "
echo "-------------------------------------------------------------"
echo ""



# "Run Unit + UI Test-Cases using fastlane."
cd ../6-Run-Test-Cases
sh run_all_test_cases_ios11.sh


# "Generate Test-Cases Execution Report."
cd -
sh test_execution_report_ios11.sh
