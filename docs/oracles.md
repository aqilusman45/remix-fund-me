blockchains are deterministic systems, they cannot interact with external systems. this is to avoid any randomness in the system as external data could be variable and might hinder the process consensus b/w the nodes.

This is know as Smart Contract Connectivity Problem. This is where we introduce Oracles. Now would it make sense to have centralised oracle server? I don't think so. It defeats the purpose that blockchain serves. If the Oracle itself is centralised and it goes down the smart contract will also stop functioning. This problem is solved by ChainLink. It is a decentralised Oracle Network that allows to develop feature rich smart contracts.

Blockchain nodes cannot make API calls as the data could variate between nodes and the nodes won't be able to reach concensus.
Chainlink networks can be customised that allows are us do fetch any kind of data but that is an advanced topic. We currently want to use off the shelve ChainLink solutions such as data feeds, we are going to be using price feeds.

When we consume APIs/Services from ChainLink we need to pay a fees that is in Link ( token for ChainLink ).