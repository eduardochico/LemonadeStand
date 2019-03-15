pragma solidity ^0.4.24;

contract LemonadeStand {
	//variable owner
	address owner;

	//variable sku count
	uint skuCount;

	//event state with value forsale
	enum State { ForSale , Sold, Shipped }

	//struct: item, name, sku, price, state, seller, buyer
	struct Item {
		string name;
		uint sku;
		uint price;
		State state;
		address seller;
		address buyer;

	}

//define mapping items that maps the sku to an item
	mapping(uint => Item) items;

	//events
	event ForSale(uint skuCount);

	event Sold(uint sku);

	event Shipped(uint sku);

	//modifier: Only owner to see if msg.sender == owner of the contract
	modifier onlyOwner() {
		require(msg.sender == owner);
		_; 
	}

	//define a modifier that verifies the caller
	modifier verifyCaller(address _address) {
		require(msg.sender == _address);
		_;
	}

	//define a modifier that checks if the paid amount is sufficient to cover the price
	modifier paidEnough(uint _price) {
		require(msg.value >= _price);
		_;
	}

	//define a modifier that checks if an item.state of a sku is ForSale
	modifier forSale(uint _sku) {
		require(items[_sku].state == State.ForSale);
		_;
	}

	//define a modifier that checks if an item.state of a sku is Sold
	modifier sold(uint _sku) {
		require(items[_sku].state == State.Sold);
		_;
	}

	constructor() public {
		owner = msg.sender;
		skuCount = 0;
	}

	function addItem(string _name, uint _price) onlyOwner public {
		//increment sku
		skuCount = skuCount + 1;

//emit the appropriate event
		emit ForSale(skuCount);

		//add the new item into inventory and mark it for sale;

		items[skuCount] = Item({name:_name, sku:skuCount, price:_price, state:State.ForSale, seller:msg.sender, buyer:0});
	}

	function buyItem(uint sku) forSale(sku) paidEnough(items[sku].price) public payable {
		address buyer = msg.sender;
		uint price = items[sku].price;
		

		//update buyer
		items[sku].buyer = buyer;
		//update state
		items[sku].state = State.Sold;

		//transfer money to seller
		items[sku].seller.transfer(price);

		if(price > items[sku].price) {
			uint refund = price - items[sku].price;
			items[sku].buyer.transfer(refund);
		}


		//emit the appropriate event
		emit Sold(sku);
	}

	function shipItem(uint sku) sold(sku) verifyCaller(items[sku].seller) public {

		//update state
		items[sku].state = State.Shipped;

		//emit the appropriate event
		emit Shipped(sku);
	}


	function fetchItem(uint _sku) public view returns (string name, uint sku, uint price, string stateIs, address seller, address buyer) {
		uint state;
		name = items[_sku].name;
		sku = items[_sku].sku;
		price = items[_sku].price;
		state = uint(items[_sku].state);

		if(state == 0) {
			stateIs = "For Sale";
		} 
		if(state == 1) {
			stateIs = "Sold";
		}
		if(state == 2) {
			stateIs = "Shipped";
		}

		seller = items[_sku].seller;
		buyer = items[_sku].buyer;
	}

}