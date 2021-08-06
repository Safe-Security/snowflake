# Snowflake

## Description

Snowflake only allows ACCOUNTADMIN users to be able to execute commands on the behalf of any other user. From one perspective, this is a very useful feature, but from an auditor's perspective it makes their life a little bit complex as they don't want to use highest privileges for their audit but for snowflake they don't have a choice. It's already very difficult to find automation scripts to perform automated assessment of SaaS applications and if you create any script/tool to perform auditing of snowflake's configuration then executing scripts/tools on SaaS application with highest privileges is the biggest mistake.

We tried to implement a solution that offers a workaround to this situation by creating a stored procedure* in your snowflake account which will run with account admin privileges, will extract the required information from all users and store it in a separate schema which can be accessed by any non-privileged read only user.

## How it works

![Architecture](screenshots/SnowflakeArch.jpg)

- Create a procedure to extract required information (This step will require ACCOUNTADMIN privileges)
- Store the information in separate tables
- Create a custom read-only role and provide access to the created tables
- Create a user and assign the custom read-only role
- Create a task in your Snowflake account to execute the procedure on a periodic basis (24/48 hours)

## How to Use

### Creating the procedure



NOTE: The below-mentioned steps are only supported on linux/unix machines

**STEP 1**: Copy the `.env.example` contents to `.env`

```
cp .env.example .env
```

**STEP 2**: Edit the variables in `.env` file (all variables are configured with default values)

**STEP 3**: Execute snowflake.sh to create a snowflakeStoredProcedureScript

Output should look like

```
Loading .env file
Copying template to a new file
Replacing variables
```

### Upload and Execute the created procedure on Snowflake account



NOTE: Please use ACCOUNTADMIN Credentials for the below-mentioned steps 

**STEP 1**: Login to your Snowflake account with Account Admin privileges

![Login](screenshots/ss_snowflakeSignin.png)

**STEP 2**: Load the script on a fresh worksheet

![Load Script](screenshots/ss_loadScript.png)

**STEP 3**: Check "All Queries" and then Run

![Execute](screenshots/ss_runQueries.png)

**STEP 4**: After execution of the script is complete, you username and password will be displayed on the screen

![Credentials](screenshots/ss_userCredentials.png)

## How to troubleshoot?

#### **1. Check whether the non-privileged tables contain the most recent data**

Execute the command mentioned below to retrieve the current date on the system:

- **select current_date();**

![image](screenshots/current_date.png)


Execute the commands mentioned below and check whether the column **CREATED_AT** is in sync with the current date on the system

- **select * from safe_db.safe_schema.policies;**

![image](screenshots/policy_table.png)

- **select * from safe_db.safe_schema.user_details;**

![image](screenshots/user_table.png)

- **select * from safe_db.safe_schema.user_policies;**

![image](screenshots/user_policy_table.png)


#### **2. Check the time duration scheduled for the execution of the stored procedure**

Execute the command mentioned below with ACCOUNTADMIN role and look for the column **schedule**

- **show terse tasks;**

![image](screenshots/tasks.png)


#### **3. Check the state of the task and its next scheduled time**

Execute the commands mentioned below with ACCOUNTADMIN role to check the state of the task running the stored procedure and its next scheduled time.

- **use safe_db;**
- **select name, state, scheduled_time, next_scheduled_time from table( information_schema.task_history( task_name=>'TASK_SAFE' ,scheduled_time_range_start=>dateadd('hour',-1,current_timestamp())));**

![image](screenshots/task_details.png)


#### **4. Check whether the Stored Procedure executed successfully**

Execute the command mentioned below and check for the Logs, if they are similar to the one in the picture below then the execution was successful

- **select * from safe_db.safe_schema.safe_security_procedure_logs;**

![image](screenshots/safe_security_procedure_logs.png)

_note_: _The logs shown in the image above are for a particular timestamp_

## What kind of information is made available to the Auditor?

Snowflake stored procedure was built with the intentions of performing security auditng of the SaaS application. To do that the below mentioned information is being fetched by the procedure to store in the tables accessible by the auditor:

- Configured network policies
- List of Disabled users
- Every user's Client session keepalive
- Every user's client session keep-alive heartbeat frequency
- Every Users's password expiration policy
- MFA status corresponding to every user
- Acive network policies against every user
- List of Inactive users
- Password authentication status for every user
- List of users with Accountadmin role

NOTE: The procedure only shares the configuration details with non-privileged tables and no intellectual or proprietary data is shared to the auditor. This information can be verified at any time by the Snowflake administrators by accessing the data in the non-privileged tables.
