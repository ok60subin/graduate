import pymongo
from pymongo import MongoClient
from datetime import datetime

connecip = 'mongodb+srv://graduate:graduate@graduate.gw2nh.mongodb.net/<dbname>?retryWrites=true&w=majority'

cluster = MongoClient(connecip)
db = cluster["graduate"]

pill=db["pill"]
reception=db["reception"]
sell = db["sell"]

allpill = pill.find()
allsell= sell.find()
allrecep = reception.find()

# allpill = list(allpill)
print(allpill[1])

print(allpill[0]["stock"])