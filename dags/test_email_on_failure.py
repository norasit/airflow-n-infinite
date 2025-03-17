from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.utils.email import send_email

# Function to force a failure
def fail_task():
    raise ValueError("This task has failed on purpose!")

# Email function for failure notifications
def notify_email(context):
    subject = f"Airflow Alert: DAG {context['task_instance'].dag_id} Failed"
    body = f"""
    <h3>DAG: {context['task_instance'].dag_id}</h3>
    <p>Task {context['task_instance'].task_id} failed.</p>
    <p>Execution Time: {context['execution_date']}</p>
    <p>Log URL: <a href="{context['task_instance'].log_url}">{context['task_instance'].log_url}</a></p>
    """
    send_email(to="k.norasit@gmail.com", subject=subject, html_content=body)

# Define DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 0,
    'email_on_failure': True,  # Enable email on failure
    'on_failure_callback': notify_email,  # Call the email function on failure
}

with DAG(
    dag_id="test_email_on_failure",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False
) as dag:

    failing_task = PythonOperator(
        task_id="failing_task",
        python_callable=fail_task
    )

    failing_task  # Run the task

