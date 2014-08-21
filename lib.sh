function update() {
  branches=$(git branch | grep '^\s' | cut -f 2- -d :)
  select branch in $branches; do
    git checkout $branch && git pull origin $branch && git checkout - && git rebase $branch
    break
  done
}

function update_feature_branch() {
  git checkout $1 && git pull origin $1 && git checkout - && git rebase $1
}

alias ufb='update_feature_branch'