module MyModule::StudyNotesRegistry {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use std::vector;

    /// Struct representing a study note entry
    struct StudyNote has store, key {
        title: String,
        content: String,
        author: address,
        timestamp: u64,
    }

    /// Struct to hold all notes for a user
    struct NotesRegistry has store, key {
        notes: vector<StudyNote>,
        total_notes: u64,
    }

    /// Function to initialize a new notes registry for a user
    public fun create_registry(user: &signer) {
        let registry = NotesRegistry {
            notes: vector::empty<StudyNote>(),
            total_notes: 0,
        };
        move_to(user, registry);
    }

    /// Function to add a new study note to the registry
    public fun add_study_note(
        user: &signer, 
        title: String, 
        content: String, 
        timestamp: u64
    ) acquires NotesRegistry {
        let user_addr = signer::address_of(user);
        
        // Create new study note
        let note = StudyNote {
            title,
            content,
            author: user_addr,
            timestamp,
        };

        // Get the user's registry and add the note
        let registry = borrow_global_mut<NotesRegistry>(user_addr);
        vector::push_back(&mut registry.notes, note);
        registry.total_notes = registry.total_notes + 1;
    }

    /// View function to get total number of notes for a user
    #[view]
    public fun get_total_notes(user_addr: address): u64 acquires NotesRegistry {
        let registry = borrow_global<NotesRegistry>(user_addr);
        registry.total_notes
    }
}