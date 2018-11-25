param (
    [string] $m = "", #commit name
    [bool] $b = 1 # push to public website
)
if ($b) {
    hugo
    cd ./public
    git pull --force
    cd ..
}
git add -A
$d = Get-Date -Format g
git commit -m "$m $d"
git push origin master
if ($b) {
    hugo
    cd ./public
    git add .
    $d = Get-Date -Format g
    git commit -m "website update $d"
    git push origin master
    cd ..
}