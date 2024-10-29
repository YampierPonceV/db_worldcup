#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

ARCHIVO="games.csv"
# Do not change code above this line. Use the PSQL variable above to query your database.
tail -n +2 "$ARCHIVO" | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  #INSERTAR EQUIPO
  EXIST_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  if [[ -z $EXIST_WINNER ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$winner')"
  fi
  #INSERTAR EQUIPO 
  EXIST_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  if [[ -z $EXIST_OPPONENT ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$opponent')"
  fi

done

tail -n +2 "$ARCHIVO" | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  #INSERTA GAMES
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
done