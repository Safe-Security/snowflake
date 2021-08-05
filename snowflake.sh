# Load variables from .env file

echo "Loading .env file"
source <(sed 's/\(=[[:blank:]]*\)\(.*\)/\1"\2"/' "$PWD/.env")

# Create a copy of stored procedure template

echo "Copying template to a new file"
cp snowflakeStoredProcedure.template $SQL_SCRIPT_NAME

# Replace strings in Snowflake SQL Script with values from .env

echo "Replacing variables"
sed -i "s/{DB_NAME}/${DB_NAME}/" $SQL_SCRIPT_NAME
sed -i "s/{DB_SCHEMA}/${DB_SCHEMA}/" $SQL_SCRIPT_NAME
sed -i "s/{WAREHOUSE}/${WAREHOUSE}/" $SQL_SCRIPT_NAME
sed -i "s/{Procedure_name}/${Procedure_name}/" $SQL_SCRIPT_NAME
sed -i "s/{USER}/${USER}/" $SQL_SCRIPT_NAME
sed -i "s/{TASK_NAME}/${TASK_NAME}/" $SQL_SCRIPT_NAME
sed -i "s/{ROLE}/${ROLE}/" $SQL_SCRIPT_NAME
sed -i "s/{PROC_FREQ}/${PROC_FREQ}/" $SQL_SCRIPT_NAME