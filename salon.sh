#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  Available_Services=$($PSQL "SELECT * FROM services")
  echo "$Available_Services" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  # if answer is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      MAIN_MENU "I could not find that service. What would you like today?"
  # if answer is not a vaild number
  else
    SERVICE_AVAILABLE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_AVAILABLE ]]
    then
      MAIN_MENU "I could not find that service. What would you like today?"
    fi
    BOOK 
  fi


  
}

BOOK() {

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]] 
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

echo -e "\nWhat time would you like your$SERVICE_NAME_SELECTED, $CUSTOMER_NAME? "
read SERVICE_TIME

INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id,time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME') ")

echo -e "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."

EXIT

}





EXIT() {
  echo -e "\nThank you for your visit.\n"
}















MAIN_MENU "Welcome to My Salon, how can I help you?"
