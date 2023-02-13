NB. jdserver
NB.

coclass 'qtdemo'
coinsert 'jqtide'

jdsvr_handler=: 3 : 0
'evt sk'=. y
if. evt = jws_onMessage do.
  try.
    smoutput res=. jd dec_json wss0_jrx_
    r_jrx_=: enc_json res
  catch.
    r_jrx_=: enc_json 13!:12 ''
  end.
  r=. 0 ". wd 'ws send ',(":sk),' *', r_jrx_
  assert. _1 ~: r
elseif. evt = jws_onOpen do.
  smoutput 'connected'
elseif. evt = jws_onClose do.
  smoutput 'disconnected'
elseif. evt = jws_onError do.
  smoutput wss0_jrx_
elseif. evt = jws_onSslError do.
  smoutput wss0_jrx_
end.
EMPTY
)

wssvr_handler_z_=: jdsvr_handler_qtdemo_

NB. =========================================================
smoutput 0 : 0
also try type in browser
  read Address,City from Suppliers where Country="UK"
  read ProductName,Categories.CategoryName from Products,Products.Categories where Categories.CategoryName="Beverages"
  read Products.ProductName,Suppliers.City from Products,Products.Suppliers where Suppliers.CompanyName="Exotic Liquids"
  read ProductName,UnitPrice from Products where UnitPrice<10
  read Suppliers.Country,Categories.CategoryName from Products,Products.Categories,Products.Suppliers where Suppliers.Country="UK"
  read CustomerID from Customers where Country="UK"
  read Country,HireDate from Employees where Country<>"UK" and HireDate>19930000
  read from Shippers
  read Customers.Country,Employees.Country,Shippers.ShipperID from Orders,Orders.Customers,Orders.Employees,Orders.Shippers where Customers.Country="UK" and Employees.Country="UK" and Shippers.ShipperID=1
  read Customers.Country,OrderDetails.Quantity from OrderDetails,OrderDetails.Orders.Customers where Customers.Country="UK" and OrderDetails.Quantity>60
  read count:count Country by Country from Suppliers
)

NB. start websocket server
3 : 0''
if. -. checkrequire 'data/jd';'convert/json' do. return. end.
NB. require '~Jddev/jd.ijs'
require 'data/jd'
require 'convert/json'
'run jdtests_jd_ to create demos' assert 'database'-:fread'~temp/jd/northwind/jdclass'
jdadmin'northwind'
wd 'ws listen 3030'

browse_j_ file2url jpath '~addons/demos/qtdemo/jdclient.htm'
)
