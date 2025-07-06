## Create Pull Request

Create a GitHub pull request with the following steps:

1. Check current branch status and uncommitted changes
2. Review all commits that will be included in the PR
3. Push the branch to remote if needed
4. Create PR with appropriate title and description

When creating a PR:
- Run `git status` to check for uncommitted changes
- Run `git log main..HEAD` to see commits to be included
- Run `git diff main...HEAD` to understand all changes
- Push branch with `git push -u origin <branch-name>`
- Create PR using `gh pr create` with a descriptive title and body that includes:
  - Summary of changes (1-3 bullet points)
  - Detailed list of changes by file/component
  - Test plan or checklist