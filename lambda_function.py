import boto3
import json

def lambda_handler(event, context):
    # Connect to the database
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('city_table')

    # Retrieve data from the city_table database
    response = table.scan()
    data = response['Items']
    
    # Format the data as an HTML table
    table_rows = ""
    for row in data:
        name = row.get('name', 'N/A')
        city = row.get('city', 'N/A')
        table_rows += f"<tr><td>{name}</td><td></td><td>{city}</td></tr>"
    
    # Create the HTML page
    html_page = f"""
        <html>
        <head>
            <title>City Table</title>
        </head>
        <body>
            <h1>City Table</h1>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th></th>
                        <th>City</th>
                    </tr>
                </thead>
                <tbody>
                    {table_rows}
                </tbody>
            </table>
        </body>
        </html>
    """
    
    # Return the HTML page as the response
    return {
        "statusCode": 200,
        "body": html_page,
        "headers": {
            "Content-Type": "text/html"
        }
    }
