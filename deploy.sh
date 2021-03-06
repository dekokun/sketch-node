DEVELOP_URL=http://127.0.0.1:3000/
PRODUCT_URL=http://deep-dusk-9615.herokuapp.com/
TRAVIS_URL=http://travis-ci.org/#!/dekokun/sketch-node
NOW_BRANCH=`cat .git/HEAD | cut -d'/' -f3`
DEVELOP_BRANCH=development
MASTER_BRANCH=master
COV_FILE=cov.html
if ! type -P jscoverage >/dev/null
then npm install -g jscoverage
fi
if ! type -P mocha >/dev/null
then npm install -g mocha
fi
if ! type -P coffee >/dev/null
then npm install -g coffee-script
fi
if ! type -P node-dev >/dev/null
then npm install -g node-dev
fi

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
    open $TRAVIS_URL || exit
    echo "deployしますか y/n"
    read ANSWER
    if [ $ANSWER = 'y' ]; then
      git push heroku $MASTER_BRANCH || exit 1
      open -a Firefox $PRODUCT_URL
    fi
    ;;
  test)
    npm test
    jscoverage lib lib-cov
    TEST_COV=1 mocha -R html-cov test/*.js > coverage.html && open coverage.html
    rm -rf lib-cov
    ;;
  develop)
    git checkout $DEVELOP_BRANCH || exit 1
    coffee -wc app.coffee &
    coffee -wc lib/routes/ &
    coffee -wc lib/model/ &
    coffee -wc public/javascript/ &
    coffee -wc test/ &
    mongo_run=`ps aux | grep '[m]ongo'`
    if [ -z "$mongo_run" ]; then
      mongod run &
    fi
    node-dev app.js
    ;;
   *)
     echo merge deploy test develop
     exit 1
esac
