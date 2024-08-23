// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract GoldSand {
    address public owner;
    IERC20 public usdcToken;

    constructor(address _usdcTokenAddress) {
        owner = msg.sender;
        usdcToken = IERC20(_usdcTokenAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function distributeReward(
        address topPlayer,
        uint256 amount
    ) external onlyOwner {
        require(usdcToken.transfer(topPlayer, amount), "USDC transfer failed");
    }

    function withdrawEther(uint256 amount) external onlyOwner {
        require(address(this).balance > amount, "Not enough funds");
        payable(owner).transfer(amount);
    }

    function withdrawUSDC(uint256 amount) external onlyOwner {
        uint256 contractBalance = usdcToken.balanceOf(address(this));
        require(contractBalance >= amount, "Not enough USDC in contract");
        require(usdcToken.transfer(msg.sender, amount), "USDC transfer failed");
    }

    function depositUSDC(uint256 amount) external {
        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "USDC transfer failed"
        );
    }

    receive() external payable {}

    fallback() external payable {}
}
