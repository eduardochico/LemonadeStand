pragma solidity ^0.4.24;

contract LemonadeStand {
	//variable owner
	address owner;

	//variable sku count
	uint skuCount;

	//event state with value forsale
	enum State { ForSale , Sold }

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

}