//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Sosa {
    event TypeCreated(uint256 attestationTypeId, string description, address creator);
    event Updated(uint256 attestationTypeId, address attester, address recipient, uint256 weight);
    event Removed(uint256 attestationTypeId, address attester, address recipient);

    uint256 private lastAttestationTypeId = 0;

    mapping (uint256 => string) public descriptions;
    // attestationType => attester => recipient => exists
    mapping (uint256 => mapping(address => mapping(address => bool))) public hasAttested;
    // attestationType => attester => recipient => weight
    mapping (uint256 => mapping(address => mapping(address => uint256))) public weight;

    function createAttestationType(string calldata description) public returns (uint256) {
        lastAttestationTypeId++;
        descriptions[lastAttestationTypeId] = description;
        emit TypeCreated(lastAttestationTypeId, description, msg.sender);
        return lastAttestationTypeId;
    }

    function updateAttestation(uint256 attestationTypeId, address attester, address recipient, uint256 _weight) public {
        weight[attestationTypeId][recipient][attester] = _weight;
        if (!hasAttested[attestationTypeId][attester][recipient]) {
            hasAttested[attestationTypeId][attester][recipient] = true;
        }
        emit Updated(attestationTypeId, attester, recipient, _weight);
    }

    function revokeAttestation(uint256 attestationTypeId, address attester, address recipient) public {
        delete weight[attestationTypeId][attester][recipient];
        hasAttested[attestationTypeId][attester][recipient] = false;
        emit Removed(attestationTypeId, attester, recipient);
    }
}

