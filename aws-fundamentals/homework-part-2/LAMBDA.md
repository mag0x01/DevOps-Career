# LAMBDA HOMEWORK

Use Cloud Formation - CF for deployment. 

## Homework 1

1. Creating scheduled events to execute AWS Lambda functions using CF. Cron to be once a month at 6 AM. The lambda can be simple as printing hello world or print the event itself.

2. Create a lambda and test it with event as key to be "name" and value to be "your_name" - screen shoot of cloud watch as a result. 


## Homework 2

Build a serverless WebPage

Steps:
1. Create a lambda (Python Runtime) - with the Environment variable to be setit up as "YOUR_NAME" and value to be your name 
2. Create a API Gateway that will trigger the same or the above lambda Lambda
3. Get the result on a browser

![topology](static/lambda_api.png)

Use the following code for the lambda:

```
name = os.environ.get('YOUR_NAME')


def lambda_handler(event, context):
    print("In lambda handler")

    resp = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": name
    }

    return resp

```

Use CloudFormation template to deploy this lambda and API Gateway too. 