# SOSA - Simple Open Standardized Attestations

Sosa is a protocol implemented on Ethereum (for now on Optimism) which allows parties to provide attestations about each other. Its name comes from some of the properties it strives for:

Simple - Sosa strives to serve as a relatively unopinionated data layer. It leaves interpretation to data consumers.
Open - Sosa is permissionless to both write to and read from.
Standardized - Sosa encodes attestation data consistently accross different parties and types of claims.

## What is an attestation?

An attestation is a declaration made by one party about another. Examples: A university attests you have completed its graduation requirements. A conference organizer attests you attend an event. You attest that your co-worker has competency in a programming language.

Sosa allows parties to make *scalar attestations*, which have five properties:
- Attestation type: The declaration being made
- Attester: An Ethereum address representing the party making the declaration
- Recipient: An Ethereum address representing the party the declaration is about
- Magnitude: A numeric value normalized between 0 and 100 intepreted according to the attestation type
- Message: A free text property 

The magnitude of an attestation can be used to represent the strength of the declaration i.e. how competent someone is with a programming language, or the confidence in a declaration i.e. how likely you think it is that someone is honest. In cases where no magnitude makes sense, such as a simple attestation that parties attended an event, the magnitude can be set to a constant value.

Attestation types can be permisionlessly generated. A description of the claim made by the attestation type and the meaning of its magnitude is written on chain when a new type is created. Parties have an incentive to use existing attestation types instead of creating duplicates because their claims benefit from network effects when joining sets of attestations that already have social buy-in.

## The protocol

Sosa's underlying data structure is a weighted directed multigraph where each node is a party represented by an Ethereum address. Each edge is an attestation from an attester to a recipient and is labeled by an attestation type with the magnitude as its weight. 

By selecting the edges for a specific attestation type, you can isolate a single attestation graph which can be useful for analysis i.e. to rank nodes with an algorithm such as PageRank.

The smart contract implementation of Sosa can be [viewed here](Sosa.sol).

The open nature of Sosa means edges can be written as spam or with the intent to mislead. It is the responsibility of data consumers to apply their own data sanitization techniques when performing analysis. Some of these sanitization techniques may rely on Sosa itself i.e. creating an attestation graph G where parties declaring other parties can be trusted to provide attestations, selecting nodes in G you have prior trust in, and filtering other graphs to nodes which received attestations in G from your trusted nodes.

