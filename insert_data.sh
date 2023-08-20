#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Delete previous data
echo $($PSQL "TRUNCATE TABLE games, teams")

# connect game .csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENTS_GOALS

# loop through it
do
  # to ignore csv header winner
  if [[ $WINNER != 'winner' ]]
  then

    # get team_id of winners
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then

      # insert team from winners
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      # print inserted value
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo $WINNER inserted into teams
      fi
    fi
  fi

  # to ignore csv header opponent
  if [[ $OPPONENT != 'opponent' ]]
  then

    # get team_id of opponent
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then

      # insert team from opponents
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      # print inserted value
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo $OPPONENT inserted into teams
      fi
    fi
  fi
done

# insert all data in games table
# connect games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENTS_GOALS
do
  # get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # insert rows in teams table
  GAME_ROW=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENTS_GOALS')")

    # print inserted value
  if [[ $GAME_ROW == "INSERT 0 1" ]]
  then
    echo $GAME_ROW inserted into games
  fi
done