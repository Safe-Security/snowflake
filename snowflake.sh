# Load variables from .env file

echo "Loading .env file"
source <(sed 's/\(=[[:blank:]]*\)\(.*\)/\1"\2"/' "$PWD/.env")

# Create a copy of stored procedure template

echo "Copying template to a new file"
cp snowflakeStoredProcedure.template snowflakeStoredProcedureScript.txt

# Replace strings in snowflakeStoredProcedureScript.txt with values from .env

echo "Replacing variables"
sed -i "s/{DB_NAME}/${DB_NAME}/" snowflakeStoredProcedureScript.txt
sed -i "s/{DB_SCHEMA}/${DB_SCHEMA}/" snowflakeStoredProcedureScript.txt
sed -i "s/{WAREHOUSE}/${WAREHOUSE}/" snowflakeStoredProcedureScript.txt
sed -i "s/{Procedure_name}/${Procedure_name}/" snowflakeStoredProcedureScript.txt
sed -i "s/{USER}/${USER}/" snowflakeStoredProcedureScript.txt
sed -i "s/{TASK_NAME}/${TASK_NAME}/" snowflakeStoredProcedureScript.txt
sed -i "s/{ROLE}/${ROLE}/" snowflakeStoredProcedureScript.txt
sed -i "s/{PROC_FREQ}/${PROC_FREQ}/" snowflakeStoredProcedureScript.txt