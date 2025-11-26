if test "$1" = ""
then
  source ./.env
else
  export GIT_REVISION=$1
fi
