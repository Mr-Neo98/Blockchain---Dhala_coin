
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Dhalacoins {
    // Introducing the total number of Dhalacoins for sale 
    uint public max_dhalacoin = 1000000;

    // Introducing the USD to Dhalacoin rate
    uint public usd_to_dhalacoins = 1000;

    // Total number of Dhalacoins bought by investors 
    uint public total_dhalacoins_bought = 0;

    // Mapping from investor address to equity in Dhalacoins and USD
    mapping(address => uint) equity_in_dhalacoin;
    mapping(address => uint) equity_in_usd;

    // Modifier to check if the investor can buy Dhalacoins
    modifier can_buy_dhalacoins(uint usd_invested) {
        require(
            usd_invested * usd_to_dhalacoins + total_dhalacoins_bought <= max_dhalacoin,
            "Purchase exceeds maximum Dhalacoins limit"
        );
        _; // Continue execution of the function using the modifier
    }

    // Getting the equity in Dhalacoins of an investor 
    function get_equity_in_dhalacoin(address investor) external view returns (uint) {
        return equity_in_dhalacoin[investor];
    }

    // Getting the equity in USD of an investor 
    function get_equity_in_usd(address investor) external view returns (uint) {
        return equity_in_usd[investor];
    } 
    //buying dhalacoins 
    function buy_dhalacoin(address investor, uint usd_invested) external 
    can_buy_dhalacoins(usd_invested) { 
        // Calculate the number of Dhalacoins bought
        uint dhalacoins_bought = usd_invested * usd_to_dhalacoins;

        // Update the investor's equity in Dhalacoins
        equity_in_dhalacoin[investor] += dhalacoins_bought;

        // Update the investor's equity in USD
        equity_in_usd[investor] = equity_in_dhalacoin[investor]/1000;

        // Update the total Dhalacoins bought globally
        total_dhalacoins_bought += dhalacoins_bought;
    } 

   function sell_dhalacoin(address investor, uint dhalacoin_sold) external {
    // Check if the investor has enough Dhalacoins to sell
    require(equity_in_dhalacoin[investor] >= dhalacoin_sold, 
            "Not enough Dhalacoins to sell");

    // Subtract the sold Dhalacoins from the investor's equity
    equity_in_dhalacoin[investor] -= dhalacoin_sold;

    // Update the investor's equity in USD, calculated by dividing remaining Dhalacoins by the conversion rate
    equity_in_usd[investor] = equity_in_dhalacoin[investor] / 1000;

    // Reduce the total number of Dhalacoins bought globally by the amount sold
    total_dhalacoins_bought -= dhalacoin_sold;
}

}