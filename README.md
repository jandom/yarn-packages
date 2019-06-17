# yarn-packages

Manage semi-automatic package.json updates

- Supports a deny-list of packages to not update
- Uses 'yarn outdated' to identify branches out of date
- Creates a branch per each outdated dependancy
- Pushes each branch to Github as a PR (requires Github token)

## Installation

Nothing! Python standard library and BASH does the trick.

## Step 1: Define what to update

First, run 'yarn outdated' to see how much work you have ahead.

    $ yarn outdated
    yarn outdated v1.16.0
    info Color legend :
     "<red>"    : Major Update backward-incompatible updates
     "<yellow>" : Minor Update backward-compatible features
     "<green>"  : Patch Update backward-compatible bug fixes
    Package               Current Wanted  Latest      Package Type URL                                                     
    @bugsnag/js           6.3.0   6.3.0   6.3.1       dependencies                          
    ... and so on...

Second create a 'disallowed_packages.txt' with packages you don't want to touch. Ours looks like this

    $ cat packages/disallowed-packages.txt
    slate
    redux-persist
    serve
    react-linkify
    react-images
    react-form
    react-alert
    immutable
    handsontable
    css-loader

Then pipe the output of what you've create to the 'define-packages.py' script

    $ yarn outdated | python ~/workspace/londonhackandtell/hacks/yarn-packages/scripts/define-branches.py
    @bugsnag/js@6.3.1
    @types/jest@24.0.15
    babel-eslint@10.0.2
    core-js@3.1.4
    semantic-ui-react@0.87.2

When you're happy with the result, redirect to a file

    $ yarn outdated | python ~/workspace/londonhackandtell/hacks/yarn-packages/scripts/define-branches.py > packages/packages.txt

## Step 2: Create github branches

In this step, we'll take the package.txt with your updates and convert this to a series of git branches.
One branch per updated package, one commit per branch.
This should be very simple, assuming your packages.txt is in order.

    $ bash ~/workspace/londonhackandtell/hacks/yarn-packages/scripts/create-branches.sh
    [Packages] Creating branches...
    Already on 'package-updates'
    Switched to a new branch 'packages/@types/react@16.8.20'
    Switched to branch 'package-updates'
    Switched to a new branch 'packages/eslint-plugin-flowtype@3.10.3'
    Switched to branch 'package-updates'
    Switched to a new branch 'packages/typescript@3.5.2'
    Switched to branch 'package-updates'
    Switched to a new branch 'packages/webpack@4.34.0'
    Switched to branch 'package-updates'
    [Packages] Running yarn updates and commiting...

You can inspect if everything was created okay by using tools such as 'gitk'

## Step 3: Publish branches

In this step, the branches created locally are pushed to origin.

Then, pull requests are created pointing to those branches.

This step requires a Github token.

    $ bash ~/workspace/londonhackandtell/hacks/yarn-packages/scripts/publish-branches.sh $GH_TOKEN
    [Packages] Pushing branch name to remote...
    Switched to branch 'packages/@bugsnag/js@6.3.1'
    Everything up-to-date
    Switched to branch 'package-updates'
    Switched to branch 'packages/@types/jest@24.0.15'
    Enumerating objects: 7, done.
    Counting objects: 100% (7/7), done.
    Delta compression using up to 8 threads
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 570 bytes | 570.00 KiB/s, done.
    Total 4 (delta 3), reused 0 (delta 0)
    remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
    remote:
    remote: Create a pull request for 'packages/@types/jest@24.0.15' on GitHub by visiting:
    remote:      https://github.com/Labstep/web/pull/new/packages/@types/jest@24.0.15
    remote:
    To github.com:Labstep/web.git
     * [new branch]          packages/@types/jest@24.0.15 -> packages/@types/jest@24.0.15
