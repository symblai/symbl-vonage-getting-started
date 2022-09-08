# Symbl+Vonage - Getting Started

Use the [multiple-devices](https://github.com/symblai/symbl-vonage-getting-started/blob/main/multiple-devices) project as a starting point when you want to do either:
 
- Run a video conference session **where everyone is on the same network** using multiple devices/laptops logging into a single video call
- Run a video conference session **where this app is deployed to a publically accessible cloud** and users will be using multiple devices/laptops logging into a single video call

## Prerequisite

- [Node.js is installed](https://docs.symbl.ai/docs/set-up-your-test-environment#nodejs)
- You must have a Symbl Platform account. [Sign Up Here][symbl_signup]
- You must have a Vonage TokBox account. [Sign Up Here][vonage_signup]

> **RECOMMENDED:_** If you plan on deploying to Heroku for dev/test, you are going to need to install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#install-the-heroku-cli).

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

Then just run the `local-setup.sh` script to configure everything and also start the application. Modify some code, then run `local-setup.sh` to restart the application. You may have notied the `local-setup.sh` is actually available in `ANGULAR`, `REACT`, and `VUE` flavors. This will build the desired client in the `opentok-web-samples` submodule/project based on which UI framework you are most comfortable with. Each is effectively the same starting point, just in it's own native UI framework.

To stop any applications executed by the `local-setup.sh`, just run `local-stop.sh` to kill any processes that were created.

> **IMPORTANT:_** To also clean everything up, run the `local-clean-up.sh` script to reset and delete everything contained with in any of the subprojects. This effectively does a `git reset --hard` so don't forget to commit or save your code somewhere.

When you are ready to migrate off this `symbl-vonage-getting-started` repo, lift this code you have been modifying into your own fork.

> **IMPORTANT:_** If you run locally, you will need to bypass Chrome's security settings which only allows Video and Mic access on HTTPS websites. Since you will be running locally, you will be running these service under HTTP. To ignore Chrome’s secure origin policy, follow these steps. Navigate to [chrome://flags/#unsafely-treat-insecure-origin-as-secure](chrome://flags/#unsafely-treat-insecure-origin-as-secure) in Chrome, then add in the local address (for example, `http://127.0.0.1:8081`).

## Quick deploy to Heroku

Heroku is a PaaS (Platform as a Service) that can be used to deploy simple and small applications for free. If you are interested in deploying to Heroku for your dev/test (in my opinion, it's **SIGNIFICANTLY** easier), you are going to need to fork the following repos in order to commit your own modified code to Heroku:

- [https://github.com/symblai/symbl-vonage-getting-started](https://github.com/symblai/symbl-vonage-getting-started) aka this Repo!
- [https://github.com/dvonthenen/opentok-web-samples](https://github.com/dvonthenen/opentok-web-samples)
- [https://github.com/dvonthenen/learning-opentok-node](https://github.com/dvonthenen/learning-opentok-node)

The reason why these forks are required is due to the mechanism for deploying to Heroku from GitHub. Heroku will only deploy code from a `commit` within a GitHub repo. That requires a fork and a commit with your changes/alterations/etc in your fork. So if you make a change, don't forget to update the `git submodule` in your fork of this Repo!

To deploy this repository to Heroku, it's pretty easy. Just run the following script:

```bash
./deploy-to-heroku.sh
```

When the deploy is finished, you should be able to host and serve up a meeting by going to the following URL which is dependent on your username: `https://${USERNAME}-symbl-vonage-client.herokuapp.com/`. You should see this as the last URL in the deploy process.

To clean everything up in Heroku, simply run the following script:

```bash
./deploy-clean-up.sh
```

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
