// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity 0.8.19;

import { IDAOResource } from "@q-dev/gdk-contracts/interfaces/IDAOResource.sol";

enum VotingType {
    NON_RESTRICTED,
    RESTRICTED,
    PARTIALLY_RESTRICTED
}

/**
 * @title IDAOVoting
 * @dev Interface for a contract that manages voting and proposals for a DAO.
 */
interface IDAOVoting is IDAOResource {
    enum ProposalStatus {
        NONE,
        PENDING,
        REJECTED,
        ACCEPTED,
        PASSED,
        EXECUTED,
        EXPIRED
    }

    enum VotingOption {
        NONE,
        FOR,
        AGAINST
    }

    struct DAOVotingKeys {
        string votingPeriodKey;
        string vetoPeriodKey;
        string proposalExecutionPeriodKey;
        string requiredQuorumKey;
        string requiredMajorityKey;
        string requiredVetoQuorumKey;
        string votingTypeKey;
        string votingTargetKey;
        string votingMinAmountKey;
    }

    struct DAOVotingValues {
        uint256 votingPeriod;
        uint256 vetoPeriod;
        uint256 proposalExecutionPeriod;
        uint256 requiredQuorum;
        uint256 requiredMajority;
        uint256 requiredVetoQuorum;
        uint256 votingType;
        string votingTarget;
        uint256 votingMinAmount;
    }

    struct InitialSituation {
        string votingSituationName;
        DAOVotingValues votingValues;
    }

    struct ConstructorParams {
        string panelName;
        address votingToken;
    }

    struct VotingParams {
        VotingType votingType;
        uint256 votingStartTime;
        uint256 votingEndTime;
        uint256 vetoEndTime;
        uint256 proposalExecutionPeriod;
        uint256 requiredQuorum;
        uint256 requiredMajority;
        uint256 requiredVetoQuorum;
    }

    struct VotingCounters {
        uint256 votedFor;
        uint256 votedAgainst;
        uint256 vetoesCount;
    }

    struct VotingStats {
        uint256 requiredQuorum;
        uint256 currentQuorum;
        uint256 requiredMajority;
        uint256 currentMajority;
        uint256 currentVetoQuorum;
        uint256 requiredVetoQuorum;
    }

    struct DAOProposal {
        uint256 id;
        string remark;
        string relatedExpertPanel;
        string relatedVotingSituation;
        bytes callData;
        address target;
        VotingParams params;
        VotingCounters counters;
        bool executed;
    }

    event VotingSituationCreated(string indexed name, DAOVotingValues values);

    event VotingSituationRemoved(string indexed name);

    event ProposalCreated(uint256 indexed id, DAOProposal proposal);

    event UserVoted(
        uint256 indexed id,
        address indexed voter,
        uint256 votingPower,
        VotingOption option
    );

    event UserVetoed(uint256 indexed id, address indexed voter);

    event ProposalExecuted(uint256 indexed id);

    /**
     * @dev Initializes the DAO voting contract with the specified voting keys and values.
     */
    function createDAOVotingSituation(IDAOVoting.InitialSituation memory conf_) external;

    /**
     * @dev Removes a voting situation from the DAO.
     * @param situation_ The name of the voting situation to remove.
     */
    function removeVotingSituation(string memory situation_) external;

    /**
     * @dev Returns an array of all voting situations in the DAO.
     * @return An array of all voting situations in the DAO.
     */
    function getVotingSituations() external view returns (string[] memory);

    /**
     * @dev Creates a new proposal for the DAO.
     * @param situation_ The name of the voting situation for the proposal.
     * @param remark_ A brief description of the proposal.
     * @param callData_ The data to pass in the call to the target contract.
     * @return The ID of the new proposal.
     */
    function createProposal(
        string calldata situation_,
        string calldata remark_,
        bytes calldata callData_
    ) external returns (uint256);

    /**
     * @dev Casts a vote in favor of the specified proposal.
     * @param proposalId_ The ID of the proposal to vote for.
     */
    function voteFor(uint256 proposalId_) external;

    /**
     * @dev Casts a vote against the specified proposal.
     * @param proposalId_ The ID of the proposal to vote against.
     */
    function voteAgainst(uint256 proposalId_) external;

    /**
     * @dev Vetoes the specified proposal.
     * @param proposalId_ The ID of the proposal to veto.
     */
    function veto(uint256 proposalId_) external;

    /**
     * @dev Executes the specified proposal.
     * @param proposalId_ The ID of the proposal to execute.
     */
    function executeProposal(uint256 proposalId_) external;

    /**
     * @dev Retrieves the proposal with the specified ID.
     * @param proposalId_ The ID of the proposal to retrieve.
     * @return A DAOProposal struct representing the proposal.
     */
    function getProposal(uint256 proposalId_) external view returns (DAOProposal memory);

    /**
     * @dev Retrieves a list of proposals.
     * @param offset_ The offset from which to start retrieving proposals.
     * If set to 0, the most recent proposal will be retrieved.
     * @param limit_ The maximum number of proposals to retrieve.
     * @return A list of DAOProposal structs representing the proposals.
     */
    function getProposalList(
        uint256 offset_,
        uint256 limit_
    ) external view returns (DAOProposal[] memory);

    /**
     * @dev Retrieves the status of the proposal with the specified ID.
     * @param proposalId_ The ID of the proposal to retrieve the status for.
     * @return A ProposalStatus enum value indicating the current status of the proposal.
     */
    function getProposalStatus(uint256 proposalId_) external view returns (ProposalStatus);
}
