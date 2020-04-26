fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios ensure_clear_deriveddata
```
fastlane ios ensure_clear_deriveddata
```
This lane will ensure Derived Data is cleaned.
### ios ensure_clean_git_status
```
fastlane ios ensure_clean_git_status
```
This lane will ensure that there is no local changes in Git Repo.
### ios clean_pod_frameworks
```
fastlane ios clean_pod_frameworks
```
Clean and Update Pods
### ios run_unit_test_cases
```
fastlane ios run_unit_test_cases
```
This lane will run unit test-cases of project.
### ios run_ui_test_cases
```
fastlane ios run_ui_test_cases
```
This lane will run UI test-cases of project.
### ios getCodeCoverage
```
fastlane ios getCodeCoverage
```
Generate Code coverage report using gcovr
### ios run_all_test_cases_ios10
```
fastlane ios run_all_test_cases_ios10
```
This lane will run Unit and UI both type test-cases of project in iOS10 simulator.
### ios run_all_test_cases_ios11
```
fastlane ios run_all_test_cases_ios11
```
This lane will run Unit and UI both type test-cases of project in iOS11 simulator.
### ios generate_code_coverage_report
```
fastlane ios generate_code_coverage_report
```
This lane will generate code-coverage report of project.
### ios bump_version_for_alpha_release
```
fastlane ios bump_version_for_alpha_release
```
This lane will bump the minor/patch version of project.
### ios create_build_for_development
```
fastlane ios create_build_for_development
```
This lane will Create Build for development branch in Git Repo.
### ios add_git_tag_for_alpha_release
```
fastlane ios add_git_tag_for_alpha_release
```
This lane will add Git Tag for Alpha Release of project.
### ios git_commit_reports_for_alpha_release
```
fastlane ios git_commit_reports_for_alpha_release
```
This lane will do Git commit for Reports of project.
### ios git_commit_ipa_for_alpha_release
```
fastlane ios git_commit_ipa_for_alpha_release
```
This lane will do Git commit for ipa-file of project.
### ios create_build_for_AdHoc
```
fastlane ios create_build_for_AdHoc
```
This lane will Create Build for AdHoc in project Git Repo.
### ios git_commit_AdHoc_ipa_for_alpha_release
```
fastlane ios git_commit_AdHoc_ipa_for_alpha_release
```
This lane will do Git commit for Ad-hoc ipa-file of project.
### ios create_build_for_TestFlight_Upload
```
fastlane ios create_build_for_TestFlight_Upload
```
This lane will Create Build for TestFlight upload
### ios upload_build_to_testflight
```
fastlane ios upload_build_to_testflight
```
This lane will upload Build to TestFlight
### ios git_commit_TestFlight_ipa
```
fastlane ios git_commit_TestFlight_ipa
```
This lane will do Git commit for TestFlight build ipa-file of TestApp project.
### ios get_lint_report
```
fastlane ios get_lint_report
```
This lane is to get SwiftLint report
### ios lint_autocorrect
```
fastlane ios lint_autocorrect
```
Run lint autocorrect
### ios get_oclint_report
```
fastlane ios get_oclint_report
```
This lane will get OCLint report

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
