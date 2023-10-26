module lesson6::hero_game {
    use sui::object::{UID,Self};
    use sui::tx_context::{TxContext,Self};
    use sui::transfer;
    use std::string::String;
    use std::option::Option;

    struct Hero has key {
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
    }

    struct Sword has key, store{
        id: UID,
        attack: u64,
        strength: u64,
	skin: String,
    }

    struct Armor has key, store{
        id: UID,
        defense: u64,
    }

    struct Monster has key{
        id: UID,
        hp: u64,
        strenght: u64,
    }

    struct GameInfo has key {
        id: UID,
        admin: address
    }

    fun init(ctx: &mut TxContext) {
	let game = GameInfo {
	    id:  object::new(ctx),
	    admin: tx_context::sender(ctx),
	};

    	transfer::transfer(game, tx_context::sender(ctx));
    }

    public entry fun create_hero(name: String, ctx: &mut TxContext) {
	let hero = Hero {
	    id:  object::new(ctx),
	    name,
	    hp: 100,
	    experience: 0,
	};
    	transfer::transfer(hero, tx_context::sender(ctx));
    }

    public entry fun create_sword(attack: u64, strength: u64, skin: String, receive: address, ctx: &mut TxContext) {
	let sword = Sword {
	    id:  object::new(ctx),
	    attack,
	    strength,
	    skin,
	};
    	transfer::transfer(sword, receive);
    }
    
    public fun create_armor(defense: u64, receive: address, ctx: &mut TxContext) {
	let armor = Armor {
	    id:  object::new(ctx),
	    defense,
	};
    	transfer::transfer(sword, receive);
    }

    public entry fun create_monster(_game: GameInfo, ctx: &mut TxContext) {
	let monster = Monster {
	    id:  object::new(ctx),
	    hp: 100,
	    experience: 0,
	};

    	transfer::share_object(monster);
    }

    public entry fun level_up_hero(_game: GameInfo, amount: u64, hero: Hero) {
	hero.experience = hero.experience + amount;
    }

    public entry fun level_up_sword(sword: Sword, amount: u64, sword: Sword, skin: String ) {
	sword.skin = skin;
    }

    public entry fun level_up_armor(armor: Armor, amount: u64 ) {
	armor.defence = armor.defence + amount;
    }

    public entry fun attack_monter(hero: &mut Hero, monster: &mut Monter) {
	monster.hp = monster.hp - hero.attack;
    }
}
