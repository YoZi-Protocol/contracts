pragma solidity >=0.7.0 <0.9.0;

contract MockVerifier {
    function verifyProof(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[38] calldata _pubSignals
    ) public view returns (bool) {
        return true;
    }
}
