var Gpio = require('onoff').Gpio;

var Web3 = require ('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));

var contractABI = [{"constant": true,"inputs": [],"name": "status","outputs": [{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "myid",
				"type": "bytes32"
			},
			{
				"name": "result",
				"type": "string"
			}
		],
		"name": "__callback",
		"outputs": [],
		"payable": false,
		"type": "function",
		"stateMutability": "nonpayable"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ULimit",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "myid",
				"type": "bytes32"
			},
			{
				"name": "result",
				"type": "string"
			},
			{
				"name": "proof",
				"type": "bytes"
			}
		],
		"name": "__callback",
		"outputs": [],
		"payable": false,
		"type": "function",
		"stateMutability": "nonpayable"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "SP",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getStatus",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getSP",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "update",
		"outputs": [],
		"payable": true,
		"type": "function",
		"stateMutability": "payable"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "LLimit",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getLimit",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "balance",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"type": "function",
		"stateMutability": "view"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_LLimit",
				"type": "uint256"
			},
			{
				"name": "_ULimit",
				"type": "uint256"
			}
		],
		"name": "setLimits",
		"outputs": [],
		"payable": true,
		"type": "function",
		"stateMutability": "payable"
	},
	{
		"inputs": [],
		"type": "constructor",
		"payable": true,
		"stateMutability": "payable"
	},
	{
		"payable": true,
		"type": "fallback",
		"stateMutability": "payable"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "status",
				"type": "uint256"
			}
		],
		"name": "SPUpdated",
		"type": "event"
	}
];

var contract= web3.eth.contract(contractABI).at('0x585949a3ffbfea2a49dafff78114361d1c3df811');

var RedLED = new Gpio(22,'out');// 8th PIN
var BlueLED = new Gpio(26, 'out'); // Second to Last PIN

var SPUpdated = contract.SPUpdated();

SPUpdated.watch(function(error,result) {
if(!error) {
  IOT_Switch();
}
});

function IOT_Switch() {

  var status = contract.getStatus.call();

  if (status == 1){
    BlueLED.writeSync(0);
    RedLED.writeSync(1);
  }

  if (status == 0){
    BlueLED.writeSync(1);
    RedLED.writeSync(0);
  }

};


  process.on('SIGINT', ExitReset);

  function ExitReset() {
    BlueLED.writeSync(0);
    BlueLED.unexport();

    RedLED.writeSync(0);
    RedLED.unexport();
    console.log('Farewell!');
    process.exit();
  };
