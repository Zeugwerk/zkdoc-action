# zkdoc-action

This [GitHub Action](https://github.com/features/actions) will build [DocFX](https://dotnet.github.io/docfx/) docs from the specified TwinCAT PLC. Use with an action such as [actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) to deploy to your project's GitHub pages site!

[Register](https://zeugwerk.dev/wp-login.php?action=register) to use this action for public repositories, this will allow you to run this action 30 times per month. [Contact us](mailto:info@zeugwerk.at) to retrieve a subscription if you need more builds per month or use Zeugwerk Doc for private repositories either on GitHub or any CI/CD server hosted in the cloud or on-premise or need support.

## Demonstration

See this github repository to see how to use zkdoc - https://github.com/stefanbesler/struckig

The resulting documentation can be uploaded either as [github pages](https://stefanbesler.github.io/struckig/) or to a private webserver
which is showcased by the [Zeugwerk Development Kit](https://doc.zeugwerk.dev/)

<div align="center">
  <a href="https://doc.zeugwerk.dev/">
    <img width="800px" src="https://user-images.githubusercontent.com/16437661/168259196-e93cb6cf-f6a4-4035-baab-859a80ea0eda.png" />
  </a>
</div>

## Inputs

* `username`: Username of a Zeugwerk Useraccount (Required)

* `password`: Password of a Zeugwerk Useraccount (Required)

* `filepath`: Path to one or more plcproj files, relative to the working directory. Alternatively for applications that are developed with the
*Zeugwerk Development Kit*, which contain a `.Zeugwerk/config.json` file, the folder of the application can be used. In the latter case,
usually `filepath=.` (Required)

* `working-directory`: Path of the working directory to change to before running zkdoc (Optional, defaults to '.')


### Creating secrets

We highly recommend to store the value for `username` and `password` in GitHub as secrets. GitHub Secrets are encrypted and allow you to store sensitive information, such as access tokens, in your repository. Do these steps for `username` and `password`

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click on the "Settings" tab.
3. In the left sidebar, click Secrets.
4. On the right bar, click on "Add a new secret" 
5. Type a name for your secret in the "Name" input box. (i.e. `ACTIONS_ZGWK_USERNAME`, `ACTIONS_ZGWK_PASSWORD`)
6. Type the value for your secret.
7. Click Add secret. 

## Config

This action requires a configuration file that is places in the folder `.Zeugwerk/config.json`. The simplest way to generate a configuration file is by using the [Twinpack Package Manager](https://github.com/Zeugwerk/Twinpack/blob/main/README.md#configuration-file-zeugwerkconfigjson).

A typcial configuration file for a solution with 1 PLC looks like this (Twinpack generates this for you automatically)

```json
{
  "fileversion": 1,
  "solution": "TwinCAT Project1.sln",
  "projects": [
    {
      "name": "TwinCAT Project1",
      "plcs": [
        {
          "version": "1.0.0.0",
          "name": "Untitled1",
          "type": "Application",
          "packages": [
            {
              "version": "1.2.19.0",
              "repository": "bot",
              "name": "ZCore",
              "branch": "release/1.2",
              "target": "TC3.1",
              "configuration": "Distribution",
              "distributor-name": "Zeugwerk GmbH"
            }
          ],
          "references": {
            "*": [
              "Tc2_Standard=*",
              "Tc2_System=*",
              "Tc3_Module=*"
            ]
          }
        }
      ]
    }
  ]
}
```

## Example usage

```yaml
name: Documentation
on:
  workflow_dispatch:
jobs:
  Build:
    name: Documentation
    runs-on: ubuntu-latest
    steps:
      - name: Build
        uses: Zeugwerk/zkdoc-action@1.0.0
        with:
          username: ${{ secrets.ACTIONS_ZGWK_USERNAME }}
          password: ${{ secrets.ACTIONS_ZGWK_PASSWORD }}
          filepath: 'Untitled1/Untitled1.plcproj'
          doc-folder: 'docs'
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          publish_dir: archive/docs/html
```

Note that the parameter valu for 'doc-folder' appears again in 'publish_dir'


Please see the documentation of [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages#%EF%B8%8F-set-ssh-private-key-deploy_key) for generating the secret `ACTIONS_DEPLOY_KEY`.
