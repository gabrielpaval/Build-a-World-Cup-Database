#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #INSERT TEAMS IN TABLE

    #GET WINNER TEAM
    if [[ $WINNER != "winner" ]]
      then
        #get team name
        TEAM_W_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
          #if team not found
          if [[ -z $TEAM_W_NAME ]]
            then
            #insert new team
            INSERT_TEAM_W_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_TEAM_W_NAME == "INSERT 0 1" ]]
              then
                echo Inserted team $WINNER
            fi
          fi
    fi

    #GET OPPONENT TEAM
    if [[ $OPPONENT != "opponent" ]]
      then
        #get team name
        TEAM_O_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
          #if team not found
          if [[ -z $TEAM_O_NAME ]]
            then
            #insert new team
            INSERT_TEAM_O_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_TEAM_O_NAME == "INSERT 0 1" ]]
              then
                echo Inserted team $OPPONENT
            fi
          fi
    fi

  #INSERT GAMES IN TABLE
    if [[ $YEAR != "year" ]]
      then
        #get winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        #get opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        #insert new game row
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
          then
            echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
        fi
    fi
  done