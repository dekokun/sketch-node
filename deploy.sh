DEVELOP_URL=
PRODUCT_URL=
NOW_BRANCH=`cat .git/HEAD | cut -d'/' -f3`
DEVELOP_BRANCH=development
MASTER_BRANCH=master
COV_FILE=cov.html

case $1 in
  merge)
    git push origin $DEVELOP_BRANCH || exit 1
    git checkout $MASTER_BRANCH || exit 1
    git merge $DEVELOP_BRANCH || exit 1
    open -a Firefox $DEVELOP_URL
    echo "ブランチを $DEVELOP_BRANCH に戻しますか y/n"
    read ANSWER
    if [ $ANSWER = 'y' ]; then
      git checkout $DEVELOP_BRANCH
      git branch
      echo "ブランチを $DEVELOP_BRANCH に戻しました"
    fi
    ;;
  deploy)
    git push origin $MASTER_BRANCH || exit 1
    open -a Firefox $PRODUCT_URL
    ;;
  test)
    npm test
    mocha -s 1 -R html-cov > $COV_FILE
    open $COV_FILE
    open -a Firefox $DEVELOP_URL
    sleep 5
    rm cov.html
    ;;
  develop)
    git checkout $DEVELOP_BRANCH || exit 1
    coffee -wc app.coffee &
    coffee -wc routes/ &
    coffee -wc model/ &
    coffee -wc public/javascript/ &
    coffee -wc test/ &
    mongod run &
    node-dev app.js
    ;;
   *)
     echo merge deploy test develop
     exit 1
esac
