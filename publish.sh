git config --global user.email 'waldio.webdesign@gmail.com'
git config --global user.name 'WouterJ.nl bot'

git branch -D master
git checkout -b master

touch output_prod/.nojekyll

git add -f output_prod
git commit -m "Build website"

git filter-branch --subdirectory-filter output_prod/ -f

git push "https://github.com/WouterJ/wouterj.github.com" -f master
