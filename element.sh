#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# if executed without argument, 'require arg' text and finish
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # check if argument is an atomic_number, symbol, or name in database
  if [[  $1 =~ ^[0-9]+$ ]]
  then 
    ATOMIC_NUMBER=$1
    else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1';")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    # text if arg is not found in database fir atomic_number, symbol, or name
    echo "I could not find that element in the database."
  else 
    ELEMENT_DATA=$($PSQL "SELECT name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
    echo "$ELEMENT_DATA" | while IFS='|' read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
