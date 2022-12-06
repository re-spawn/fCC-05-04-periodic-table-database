#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]]
then
  if [[ $1 =~ [0-9]+ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  else
    NUMBER_FROM_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';")
    if [[ $NUMBER_FROM_SYMBOL =~ [0-9]+ ]]
    then
      ATOMIC_NUMBER=$NUMBER_FROM_SYMBOL
    else
      NUMBER_FROM_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1';")
      if [[ $NUMBER_FROM_NAME =~ [0-9]+ ]]
      then
        ATOMIC_NUMBER=$NUMBER_FROM_NAME
      fi
    fi
  fi
  if [[ $ATOMIC_NUMBER =~ [0-9]+ ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    SYMBOL=$(echo $SYMBOL | sed 's/^\s*(.*)\s*$/$1/')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    NAME=$(echo $NAME | sed 's/^\s*(.*)\s*$/$1/')
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MASS=$(echo $MASS | sed 's/^\s*(.*)\s*$/$1/')
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING=$(echo $MELTING | sed 's/^\s*(.*)\s*$/$1/')
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING=$(echo $BOILING | sed 's/^\s*(.*)\s*$/$1/')
    TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING (type_id) WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE=$(echo $TYPE | sed 's/^\s*(.*)\s*$/$1/')
    ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/^\s*(.*)\s*$/$1/')
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else
    echo I could not find that element in the database.
  fi
else
  echo Please provide an element as an argument.
fi

