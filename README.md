# zkdoc-action

**Auto-Generate Professional TwinCAT Documentation in CI/CD**: Generate API docs from your TwinCAT source code automatically. Deploy to GitHub Pages or your own server.

zkdoc-action is a GitHub Action that builds professional HTML documentation from TwinCAT PLC source code using DocFX. Write docs alongside your code, push to GitHub, get beautiful docs automatically.

<div align="center">
  <a href="https://doc.zeugwerk.dev/">
    <img width="800px" src="https://user-images.githubusercontent.com/16437661/168259196-e93cb6cf-f6a4-4035-baab-859a80ea0eda.png" />
  </a>
</div>


## Why You Need This

- **Auto-generated from source**: Keep docs in sync with code (no manual updates)
- **Professional output**: API docs, examples, and architecture in one place
- **Zero maintenance**: Builds automatically on every push
- **Search-friendly**: Fully indexed, searchable docs
- **Deploy anywhere**: GitHub Pages, your own server, or anywhere HTTP works

## The Problem It Solves

Most PLC projects have no documentation. Or they have Word docs that get out of sync.

TwinCAT code often looks like:
```iec61131-st
FUNCTION_BLOCK Valve
  (*TODO: explain what this does*)
  nState : INT;
  bOpen : BOOL;
END_FUNCTION_BLOCK
```

Nobody documents it because it's extra work. By the time a new engineer joins, the code is a mystery.

zkdoc-action fixes this: **Write comments in your code → zkdoc generates searchable docs → Deploy to GitHub Pages → Done.**

## Quick Start

1. **Register (Free for Open Source)**:
  [Register here](https://zeugwerk.dev/wp-login.php?action=register) to get credentials. 30 free builds/month for public repos.

2. **Create a GitHub Workflow**:
  Add `.github/workflows/docs.yml`:

  ```yaml
  name: Documentation
  on:
    push:
      branches: [main, develop]
    workflow_dispatch:

  jobs:
    build-docs:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
      
        - name: Generate Documentation
          uses: Zeugwerk/zkdoc-action@v1
          with:
            username: ${{ secrets.ZEUGWERK_USERNAME }}
            password: ${{ secrets.ZEUGWERK_PASSWORD }}
            filepath: '.'
      
        - name: Deploy to GitHub Pages
          uses: peaceiris/actions-gh-pages@v3
          with:
            deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
            publish_dir: archive/docs/html
  ```

3. **Generate deploy key**: Follow [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) for setup
4. **Push**: Your docs now build and deploy automatically

## How It Works

```
Your TwinCAT Code (with comments)
        ↓
    Git Push
        ↓
zkdoc-action (GitHub Action)
        ↓
  Zeugwerk CI/CD
        ↓
  - Parses PLC source
  - Extracts comments/symbols
  - Generates HTML with DocFX
        ↓
  HTML documentation site
        ↓
  Deploy to GitHub Pages
```

## Writing Docs (In Your Code)

Just add comments above your function blocks and methods:

```iec61131-st
/// Xy contains some variables to showcase how to write documentation 
/// Write a detailed description here, each method or property can be documented by using `///` as well
FUNCTION_BLOCK Xy
VAR
  _var1 : REAL; //< description about var1, use //< to write the documentation next to a member variable
  
  /// description about var2, use /// to write the documentation about a member variable
  _var2 : INT;
  
  /// the description may use
  /// multiple lines
  /// as well
  _var3 : DINT;
  
  _var4 : INT; //< even if the //< delimiter is used
               //< multiple lines are supported
                                         
  /// Also mixing of delimiter 
  _var5 : ZEquipment.ActuatorDigitalDurations; //< is possible
                                               //< with multiple lines
END_VAR
```

See [zkdoc syntax guide](https://doc.zeugwerk.dev/contribute/contribute_documentation.html) for more options.

## Configuration

### Minimal (Single PLC)

```yaml
filepath: 'MyPlcProject/MyPlcProject.plcproj'
```

### With Zeugwerk Projects

If you use [Zeugwerk Framework](https://doc.zeugwerk.dev) or [Twinpack](https://github.com/Zeugwerk/Twinpack), put:

```yaml
filepath: '.'
```

This will automatically discover and use your `.Zeugwerk/config.json` file.


## Inputs

| Input | Required | Description |
|---|---|---|
| `username` | Yes | Zeugwerk account username |
| `password` | Yes | Zeugwerk account password |
| `filepath` | Yes | Path to `.plcproj` or folder containing `.Zeugwerk/config.json` |
| `doc-folder` | No | Folder with custom `docfx.json` (e.g., `docs/`) |

## Outputs

| Artifact | Location |
|---|---|
| HTML documentation | `archive/docs/html/` |
| Build logs | GitHub Actions UI |

## Real Example

See [struckig](https://github.com/stefanbesler/struckig):
- **Repo**: https://github.com/stefanbesler/struckig
- **Auto-generated docs**: https://stefanbesler.github.io/struckig/
- **Workflow file**: [.github/workflows/documentation.yml](https://github.com/stefanbesler/struckig/blob/main/.github/workflows/documentation.yml)

Notice how the docs stay in sync with code automatically.

## Pricing

- **Free**: 30 builds/month for public repositories
- **Commercial**: Custom pricing for private repos. [Contact us](mailto:info@zeugwerk.at)

## Alternatives

| Solution | Setup | Maintenance | Cost |
|---|---|---|---|
| Manual Word docs | 1 day | High (outdated) | Free |
| Doxygen | 2-3 days | High (Parsing Structured Text correctly is not simple) | Free |
| **zkdoc-action** | **1 hour** | **None** | **Free (*)** |

## Troubleshooting

**"Docs aren't generating"**
- Ensure `filepath` points to a valid `.plcproj` or `.Zeugwerk/config.json`
- Check GitHub Actions logs for details

**"GitHub Pages not deploying"**
- Verify `deploy_key` secret is set correctly (see peaceiris docs)
- Check that GitHub Pages is enabled in repository settings

**"Documentation looks wrong"**
- Check your `docfx.json` config
- Ensure comments use the right syntax (see [zkdoc guide](https://doc.zeugwerk.dev/contribute/contribute_documentation.html))

## Further Reading

- [TwinCAT Build Tools Landscape 2026](https://zeugwerk.at/blog/twincat-build-tools-landscape-2026/) -- How cloud CI/CD, self-hosted Jenkins, and GitHub Actions compare for TwinCAT teams.
- [Distributing TwinCAT DevTools On-Prem with Scoop](https://zeugwerk.at/blog/distributing-devtools-with-scoop/) -- How we handle versioned, authenticated distribution of zkmake and zkdoc to on-premises Jenkins nodes.
