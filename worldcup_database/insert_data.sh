#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#print title
echo -e "\nInsert data to database"
#delete Table
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Insert Team names
  if [[ $WINNER != "winner" ]]
  then
    NAME_WINNER=$($PSQL "SELECT name FROM teams WHERE name LIKE '$WINNER' ")
    NAME_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name LIKE '$OPPONENT' ")
    # If winner N/A
    if [[ -z $NAME_WINNER ]] 
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted, $WINNER
      fi
    fi
    # if opponent N/A
    if [[ -z $NAME_OPPONENT ]] 
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted, $OPPONENT
      fi
    fi
  fi
done

# Insert in games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#year,round,winner,opponent,winner_goals,opponent_goals
  
  if [[ $WINNER != "winner" ]]  
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # INSERT games.csv data in games table
    INSERT_GAMES_RESULT=$($PSQL " INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS) ")

    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done





#get winner
#echo "$($PSQL "SELECT winner FROM games")"
