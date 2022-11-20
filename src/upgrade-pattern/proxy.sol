pragma solidity ^0.8.4;

contract ProxyConract {
    address public stateAddress;
    StateContract state;

    // 가리킬 state 컨트랙트를 기반으로 생성
    constructor(address _stateAddress) public {
        stateAddress = _stateAddress;
        state = StateContract(stateAddress);
    }

    event logSuccessfulStateEdit(uint256 _conractVariable);

    // 핵심 가변성 로직 처리
    // 여기서는 단순 값 변경 
    function changeStateData(uint256 _stateData) public returns(bool) {
        require(state.editContractVariable(_stateData));
        return true;
    }

    function getStateData() public view returns(uint256) {
        return state.getContractVariable();
    }
}

// 그냥 StateContract의 메서드를 부르기 위한 캐스팅 전용 타입 
interface StateContract {
    function getContractVariable() external view returns(uint256);

    function editContractVariable(uint256 _conrtactVariable) external returns(bool);
}
