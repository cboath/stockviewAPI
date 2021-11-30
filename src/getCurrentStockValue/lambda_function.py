from alpha_vantage.timeseries import TimeSeries
ts = TimeSeries(key='D3F0HVMFLMPCVLRN')

import json
import boto3

def lambda_handler(event, context):
    
    print('COnt: ', context)
    
    print('EVENT: ', event)