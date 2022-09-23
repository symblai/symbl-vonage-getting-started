# Symbl+Vonage - Getting Started

Use the [standalone-device](https://github.com/symblai/symbl-vonage-getting-started/blob/main/standalone-device) project as a starting point when you want to do everything on a single self-contained laptop. You can use this project simulate multiple users, but using a single device and single video call.

## Prerequisite

- [Node.js is installed](https://docs.symbl.ai/docs/set-up-your-test-environment#nodejs)
- You must have a Symbl Platform account. [Sign Up Here][symbl_signup]
- You must have a Vonage TokBox account. [Sign Up Here][vonage_signup]

## How to Launch the App Locally

You first should export the following Symbl and Vonage API values in your console:

```bash
# Symbl Platform keys
export APP_ID=AAAAA
export APP_SECRET=BBBB

# Vonage TokBox keys
export API_KEY=XXXXX
export API_SECRET=YYYYY
```

Then just run the `setup.sh` script to configure everything and also start the application. Modify some code, then run `setup.sh` to restart the application.

When you are ready to migrate off this `symbl-vonage-getting-started` repo, lift this code you have been modifying into your own repo.

## Community

If you have any questions, feel free to reach out to us at devrelations@symbl.ai or through our [Community Slack][slack] or our [forum][developer_community].

This guide is actively developed, and we love to hear from you! Please feel free to [create an issue][issues] or [open a pull request][pulls] with your questions, comments, suggestions and feedback.  If you liked our integration guide, please star our repo!

This library is released under the [MIT License][license]

[developer_community]: https://community.symbl.ai/?_ga=2.134156042.526040298.1609788827-1505817196.1609788827
[slack]: https://join.slack.com/t/symbldotai/shared_invite/zt-4sic2s11-D3x496pll8UHSJ89cm78CA
[issues]: https://github.com/symblai/getting-started-samples/issues
[pulls]: https://github.com/symblai/getting-started-samples/pulls
[license]: LICENSE
[symbl_signup]: https://platform.symbl.ai/signup?utm_source=symbl&utm_medium=blog&utm_campaign=devrel&_ga=2.226597914.683175584.1662998385-1953371422.1659457591&_gl=1*mm3foy*_ga*MTk1MzM3MTQyMi4xNjU5NDU3NTkx*_ga_FN4MP7CES4*MTY2MzEwNDQyNi44Mi4xLjE2NjMxMDQ0MzcuMC4wLjA.
[vonage_signup]: https://www.tokbox.com/account/user/signup
