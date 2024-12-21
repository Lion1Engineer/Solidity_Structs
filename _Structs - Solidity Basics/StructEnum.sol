// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract StrucEnum
{
    // We will share enums as a new data type that indicates the status of the order.
    enum Status{
        Taken,       //order received
        Preparing,   //order is being prepared
        Boxed,       //order is boxed
        Shipped      //order is in cargo
    }

    //Let's create an order system
    //Data structure that holds different data types together and allows us to package them and handle them as a whole

    struct Order{
        address customer; // customer
        string zipCode;   //postal code of where to reach
        uint256[] products; //An array based on which products were ordered
        Status status;
    }

    Order[] public orders;
    // We create an orders array to access all orders later.

    address public owner;
    // We keep the owner variable so that our code understands that the store manager is performing the operations.
    // We need to check whether the person sending the message is the owner.
    
    // msg.sender in the constructor is the person who creates the contract and we will treat it as the store owner.
    constructor()
    {
        owner = msg.sender;
    }

    // Let's make a function as the customer who creates the order.
    function createOrder(string memory _zipCode, uint256[] memory _products) public returns (uint256)
    {
        require(_products.length > 0, "No products.");
    /*  
        Order memory order ;
        order.customer =msg.sender;
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;

        orders.push(order);
        // We add the order we created to orders
    */
        // Another option for creating structs
        orders.push(
            Order({
                customer: msg.sender,
                zipCode: _zipCode,
                products: _products,
                status: Status.Taken
            })
        );

        return orders.length -1;
        // We can think of the returns value we receive as a parameter as the ID of the order.
        // We decrease the id by -1 to place it at the 0th index in the array.
    }

    // A function to advance order statuses
    function advanceOrder(uint256 _orderId) external {
        require(owner == msg.sender, "You are not authorized.");
        require(_orderId < orders.length, "Not a valid order id.");

        Order storage order = orders[_orderId];
        require(order.status != Status.Shipped, "Order is already shipped.");

        if (order.status == Status.Taken) {
            order.status = Status.Preparing;
        } else if (order.status == Status.Preparing) {
            order.status = Status.Boxed;
        } else if (order.status == Status.Boxed) {
            order.status = Status.Shipped;
        }
    }

    function getOrder(uint256 _orderId) external view returns (Order memory) {
        require(_orderId < orders.length, "Not a valid order id.");
        
        /*
        Order memory order = orders[_orderId];
        return order;
        */

        return orders[_orderId];
    }

    function updateZip(uint256 _orderId, string memory _zip) external {
        require(_orderId < orders.length, "Not a valid order id.");
        Order storage order = orders[_orderId];
        require(order.customer == msg.sender, "You are not the owner of the order.");
        order.zipCode = _zip;
    }

}


