#required_pkgs = ['alpha_vantage', 'pandas']
#installed_pkgs = [pkg.key for pkg in pkg_resources.working_set]

#for package in required_pkgs:
    #if package not in installed_pkgs:
#        print('Installing', package)
#        subprocess.check_call(["python", '-m', 'pip', 'install', package])
        
        
from alpha_vantage.timeseries import TimeSeries
ts = TimeSeries(key='D3F0HVMFLMPCVLRN')

import sys
import json

headers = {
    "X-Requested-With": "*",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
      "Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with",
    "Access-Control-Allow-Methods": "PUT,POST,GET,OPTIONS",
}
statusCode = 0
body = []

def lambda_handler(event, context):
    bunch = []
    with open('list.txt', 'r') as stocks:
        for x in stocks:
            currentSym = x.rstrip()
            # print('The stock is ', x)
            data, meta_data = ts.get_intraday(symbol=currentSym, interval='1min', outputsize='compact')
            currstock = ''
            for datestr, stockdata in data.items():
                counter = 0
                for openy, high in stockdata.items():
                    counter = counter + 1
                    if (counter == 4):
                        currstock = high
                break

            print('\nThe value of', x, 'is', currstock)
            igor = [x, currstock]
            print('IGOR', igor)
            bunch.insert(0, igor)
    nbv = bunch #{x, currstock}
    #bodyval = json.dumps(nbv)
    #print('NEW BUNCH', bodyval)
    return nbv
            
