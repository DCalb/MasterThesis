import time
import signal
import contract_abi_3
import sys
import threading
import RPi.GPIO as GPIO
from web3 import Web3, HTTPProvider

contract_address=Web3.toChecksumAddress('0x91cb0d066d4196a172f592e78488ec20a2a420e0')

w3= Web3(HTTPProvider('http://localhost:8545'))

contract= w3.eth.contract(address= contract_address, abi= contract_abi_3.abi)

w3.eth.defaultAccount = w3.eth.accounts[0]

GPIO.setmode(GPIO.BOARD)

GPIO.setwarnings(False)

GPIO.setup(31, GPIO.OUT)#Red LED
GPIO.setup(33, GPIO.OUT)#Yellow LED
GPIO.setup(35, GPIO.OUT)#Green LED
GPIO.setup(37, GPIO.OUT)#Blue LED

def data_handler(x):
    demand = contract.functions.getDemand().call()
    OptCap = contract.functions.getOptCaps().call()
    counter= [int(round(OptCap[0]/demand *100)),int(round(OptCap[1]/demand *100)),int(round(OptCap[2]/demand *100)),int(round(OptCap[3]/demand *100))]
    return counter[x]

def requester():
    while not threading.active_count() == 2:
        pass
    else:
        print("Tasks completed. Sending Request")
        contract.functions.StartUpdate().transact()


def blinkBlue():
    counter= data_handler(0)
    while not counter == 0:
        GPIO.output(37,1)
        time.sleep(0.5)
        GPIO.output(37,0)
        time.sleep(0.5)
        counter = counter - 1
    else:
        print("Task Blue completed. Standing by")

def blinkGreen():
    counter = data_handler(1)
    while not counter == 0:
        GPIO.output(35,1)
        time.sleep(0.5)
        GPIO.output(35,0)
        time.sleep(0.5)
        counter = counter - 1
    else:
        print("Task Green completed. Standing by")

def blinkYellow():
    counter = data_handler(2)
    while not counter == 0:
        GPIO.output(33,1)
        time.sleep(0.5)
        GPIO.output(33,0)
        time.sleep(0.5)
        counter = counter - 1
    else:
        print("Task Yellow completed. Standing by")

def blinkRed():
    counter = data_handler(3)
    while not counter == 0:
        GPIO.output(31,1)
        time.sleep(0.5)
        GPIO.output(31,0)
        time.sleep(0.5)
        counter = counter - 1
    else:
        print("Task Red completed. Standing by")

def startBlinking():
    threading.Thread(target=blinkBlue).start()
    threading.Thread(target=blinkGreen).start()
    threading.Thread(target=blinkYellow).start()
    threading.Thread(target=blinkRed).start()
    threading.Thread(target=requester).start()

print("Initilizing First Request")
contract.functions.StartUpdate().transact()

def signal_handler(signal, frame):
    print ("LED Script Terminated")
    print("GPIO PINS Reset")
    GPIO.cleanup()
    print("Farewell!")
    time.sleep(10)
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

event_filter = contract.events.OptCapUpdated.createFilter(fromBlock='latest')
while True:
    for event in event_filter.get_new_entries():
        startBlinking()
