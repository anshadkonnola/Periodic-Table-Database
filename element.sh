
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

NOT_FOUND() {
  echo -e "I could not find that element in the database."
  exit
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      NOT_FOUND    
    fi
    SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "select name from elements where atomic_number=$ATOMIC_NUMBER")
  elif [[ ${#1} < 3 && ${#1} > 0 ]]
  then
    SYMBOL=$($PSQL "select symbol from elements where symbol='$1'")
    if [[ -z $SYMBOL ]]
    then
      NOT_FOUND
    fi
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1'")
    NAME=$($PSQL "select name from elements where symbol='$1'")
  else
    NAME=$($PSQL "select name from elements where name='$1'")
    if [[ -z $NAME ]]
    then
      NOT_FOUND
    fi
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$1'")
    SYMBOL=$($PSQL "select symbol from elements where name='$1'")
  fi
else
  echo -e "Please provide an element as an argument."
  exit
fi

ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER")
MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")
BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")
TYPE_ID=$($PSQL "select type_id from properties where atomic_number=$ATOMIC_NUMBER")
TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")

echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | sed -E 's/^ *| *$//g') is $(echo $NAME | sed -E 's/^ *| *$//g') ($(echo $SYMBOL | sed -E 's/^ *| *$//g')). It's a $(echo $TYPE | sed -E 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -E 's/^ *| *$//g') amu. $(echo $NAME | sed -E 's/^ *| *$//g') has a melting point of $(echo $MELTING_POINT | sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -E 's/^ *| *$//g') celsius."
