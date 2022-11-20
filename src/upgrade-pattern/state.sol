pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract StateContract is Ownable {
    uint256 public contractVariable = 3;
    address public proxy_contract;

    // 프록시만 호출 가능한 함수로 지정
    modifier onlyApprovedProxy() {
        require(msg.sender == proxy_contract);
        _;
    }

    // 프록시 변경
    function changeProxyAddress(address _proxy_contract) public onlyOwner returns(bool) {
        proxy_contract = _proxy_contract;
        return true;
    }

    // 변수 값 수정정
    function editContractVariable(uint256 _conrtactVariable) external onlyApprovedProxy returns(bool) {
         contractVariable = _conrtactVariable;
         return true;
    }

    function getContractVariable() public view returns(uint256) {
        return contractVariable;
    }
}
