import pymongo
from pymongo import MongoClient
from datetime import datetime

connecip = 'mongodb+srv://graduate:graduate@graduate.gw2nh.mongodb.net/<dbname>?retryWrites=true&w=majority'

cluster = MongoClient(connecip)
db = cluster["graduate"]

pill=db["pill"]
reception=db["reception"]
sell = db["sell"]


#  pill.find({}) == select * from pill
#  pill.delete_one({"pill_id":1}) delete pill where pill_id=1
#  pill.update_one({"pill_id":1},{"$set":{"name":"AA"}})
#  pill.count_documents({})

# data1={"_id":1,"name":"A","category":"전문의약품","price":320,"company":"A corp","stock":100}
# data2={"_id":2,"name":"B","category":"전문의약품","price":330,"company":"B corp","stock":100}
# data3={"_id":3,"name":"C","category":"전문의약품","price":340,"company":"C corp","stock":100}

# pill.insert_many([data1,data2,data3])

# results=pill.find({})

# for result in results:
#     print(result)

sell.delete_many({})
reception.delete_many({})

def insert_recep(pre_id,pre_date,sell_date,total):
    data={"_id":pre_id,"pre_date":pre_date,"sell_date":sell_date,"total":total}
    reception.insert_one(data)

def insert_sell(pre_id,pill_id,num):
    sid = sell.count_documents({})+1
    data={"_id":{"pre_id":pre_id,"pill":pill_id},"num":num}
    sell.insert_one(data)

def add_stock(pill_id,num):
    for i in range(len(pill_id)):
        pstock = pill.find({"_id":pill_id[i]},{"_id":0,"stock":1})[0]["stock"]
        astock = pstock + num[i]
        print("이전 재고: ",pstock)
        print("현재 재고: ",astock)
        pill.update_one({"_id":pill_id[i]},{"$set":{"stock":astock}})

def routine(pre_id,pre_date,pill_id,num): #(처방전번호, 처방일, 판매일, )
    total=0
    sell_date = datetime.today().strftime("%Y-%m-%d")
    for i in range(len(pill_id)):
        # check pill and cal total 
        try:
            perprice=pill.find({"_id":pill_id[i]},{"_id":0,"price":1})
            perprice = perprice[0]["price"]
            total = total + (perprice * num[i])
        except :
            print("!! 존재하지 않는 제품")
            break
        # update stock
        stock = pill.find({"_id":pill_id[i]},{"_id":0,"stock":1})
        pstock = stock[0]["stock"]
        astock = pstock - num[i]
        print(pill_id[i]," 제품 판매 이전재고: ",pstock)
        print(pill_id[i]," 제품 판매 이후재고: ",astock)
        if astock<0 :
            print("!!",pill_id[i],"번 약품 재고부족으로 취소합니다.")
            return;

        insert_sell(pre_id,pill_id[i],num[i])
        pill.update_one({"_id":pill_id[i]},{"$set":{"stock":astock}})

    insert_recep(pre_id,pre_date,sell_date,total)


routine('12345','2020-00-00',[1,2,3],[5,5,5])
print('routine1 finish')
routine('12346','2020-00-00',[1,2],[6,90])
print('routine2 finish')

add_stock([1,2,3],[20,30,40])
# results=sell.find({"_id.pre_id":"12345"})
# for result in results:
#     print(result)
