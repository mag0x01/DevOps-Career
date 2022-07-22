# GitFlow Workflow

## The Git Flow Diagram

![GitFlowDiagram](assets/gitkraken-git-flow.svg)

Credits: GitKraken.com

## Branches

### Master/main

The **master** branch should always contain code that has been deemed ready to be released in production.

### Develop

The **develop** branch is the integration branch. This is where all contributors merge their code changes the rest of the team. This is code that still requires testing and is not production ready.

### Features

The **features/** branch folder contains branches that are meant to hold the work in progress code. When developers start implementing a new feature, they generally create a new feature branch out of **develop** and start making changes to the code base there. When they're done, the can integrate these changes through a Pull Request which will merge the commits from the **feature** branch to the **develop** one.

### Releases

The **releases/** branch folder contains branches that are meant to hold code in progress of being deployed to production. When the **develop** branch is in a stable state (features have been tested, bugs have been fixed, etc) and the team decides a new release to production is in order, a new **release** branch can be created out of **develop**, tested thoroughly, then deployed onto the production environment.

### Hotfix

The **hotfix** branch folder contains short-lived branches that are meant to fix issues on the **master** branch. This should be created from the **master** branch and merged back into **master** and **develop** when issues are fixed.
