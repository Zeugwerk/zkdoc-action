# zkdoc-action

This [GitHub Action](https://github.com/features/actions) will build [DocFX](https://dotnet.github.io/docfx/) docs from the specified TwinCAT PLC.

For public repositories 30 doc builds per month are allowed. [Contact us](mailto:info@zeugwerk.at) to retrieve a subscription if you need more builds per month or use Zeugwerk Doc for private repositories.

Use with an action such as [actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) to deploy to your project's GitHub pages site!

## Inputs

### 'username'

**Required** [Register](https://zeugwerk.at/) to create a user account to use Zeugwerk Doc. Fill-in the username you have chosen here. 

### 'password'

**Required** [Register](https://zeugwerk.at/) to create a user account to use Zeugwerk Doc. Fill-in the password you have chosen here. 

### 'filepath'

**Required** Path to on or more plcproj files, relative to the working directory. Alternatively for applications that are developed with the
*Zeugwerk Development Kit*, which contain a `.Zeugwerk/config.json` file, the folder of the application can be used. In the later case,
usually `filepath=.`

### 'working-directory'

**Optional** Path of the working directory to change to before running zkdoc. Default: `.`

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
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          publish_dir: archive/documentation/html
```
