import time
import signal
import contract_abi_3
import sys
from mpmath import *
from pulp import *
from web3 import Web3, HTTPProvider

contract_address=Web3.toChecksumAddress('0x91cb0d066d4196a172f592e78488ec20a2a420e0')

w3= Web3(HTTPProvider('http://localhost:8545'))

contract=w3.eth.contract(address=contract_address, abi=contract_abi_3.abi)

w3.eth.defaultAccount = w3.eth.accounts[0]

mp.dps = 50

print(mp)

def startOPT():
    time.sleep(60)

    capacities = contract.functions.getCapacities().call()
    Xrates = contract.functions.getXrates().call()
    Xrates = [mpf(i) for i in Xrates]
    UC = contract.functions.getUC().call()
    UC = [mpf(i) for i in UC]

    demand=contract.functions.getDemand().call()

    print("Data received. Commencing optimization!")

    UCPUSD=UC[0]*Xrates[0]
    UCYUSD=UC[1]*Xrates[1]
    UCRUSD=UC[2]*Xrates[2]
    UCZUSD=UC[3]*Xrates[3]

    print("USD/MXN: %.2f" % (Xrates[0]),"USD/CNY:%.2f" % (Xrates[1]),"USD/INR: %.2f" % (Xrates[2]), "USD/POL: %.2f" % (Xrates[3]))
    print("UC MXN: %.2f" % (UC[0]), "UC CNY: %.2f" %(UC[1]), "UC INR: %.2f" % (UC[2]), "UC POL: %.2f" % (UC[3]))
    print("Mexico USD: %.2f " % (UCPUSD), "China USD: %.2f" % (UCYUSD), "India USD: %.2f" % (UCRUSD), "Poland USD: %.2f" % (UCZUSD))

    time.sleep(10)

    SmartOPT = pulp.LpProblem("Cost minimization", pulp.LpMinimize)

    P = pulp.LpVariable('P', lowBound=0, upBound= capacities[0], cat='Integer')
    Y = pulp.LpVariable('Y', lowBound=0, upBound=capacities[1], cat='Integer')
    R = pulp.LpVariable('R', lowBound=0, upBound=capacities[2], cat='Integer')
    Z = pulp.LpVariable('Z', lowBound=0, upBound=capacities[3], cat='Integer')

    SmartOPT += P*UCPUSD+Y*UCYUSD+R*UCRUSD+Z*UCZUSD, "Total Cost"

    SmartOPT += P+Y+R+Z == demand, "Demand Constraint"

    SmartOPT.solve()

    print("Production in:", "Mexico: %d" %(P.varValue),"China: %d" %(Y.varValue), "India: %d" % (R.varValue), "Poland: %d" %(Z.varValue))
    print ("Total Cost: $ %.2f" %(SmartOPT.objective.value()))

    time.sleep(2)

    print("Transmitting optimal capacities!")

    time.sleep(2)

    contract.functions.setOptCap(int(P.varValue), int(Y.varValue), int(R.varValue), int(Z.varValue)).transact()

    return

def signal_handler(signal, frame):
    print ("Optimization terminated. Farewell!")
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

event_filter = contract.events.rdy4opt.createFilter(fromBlock='latest')
while True:
    for event in event_filter.get_new_entries():
        startOPT()
