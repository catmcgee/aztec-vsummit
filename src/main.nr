contract Voting {
    use dep::aztec::prelude::{AztecAddress, FunctionSelector, PrivateContext, Map, PublicMutable, SharedImmutable};
    use dep::aztec::keys::getters::get_historical_public_keys;

    #[aztec(storage)]
    struct Storage {
        admin: PublicMutable<AztecAddress>, // admin can end vote
        tally: Map<Field, PublicMutable<Field>>, // we will store candidate as key and number of votes as value
        vote_ended: PublicMutable<bool>, // vote_ended is boolean
        active_at_block: SharedImmutable<u32>, // when people can start voting
    }

    #[aztec(public)]
    #[aztec(initializer)] // annotation to mark function as a constructor
    fn constructor(admin: AztecAddress) {
        storage.admin.write(admin);
        storage.vote_ended.write(false);
        storage.active_at_block.initialize(context.block_number() as u32);
      }

    #[aztec(private)] // annotation to mark function as private and expose private context
    fn cast_vote(candidate: Field) {
        // Below, we make sure to get our nullifier public key at a specific block. By pinning the nullifier public key at a specific block,
        // rotating keys will have no effect on the nullifier being produced, and voting again after will fail because the same nullifier is computed each time the user votes.
    }
  
    #[aztec(public)]
    #[aztec(internal)]
    fn add_to_tally_public(candidate: Field) {
    }

    #[aztec(public)] 
    fn end_vote() {
        assert(storage.admin.read().eq(context.msg_sender()), "Only admin can end votes"); // assert that caller is admin
        storage.vote_ended.write(true);
    }

    unconstrained fn get_vote(candidate: Field) -> pub Field {
        storage.tally.at(candidate).read()
    }
}