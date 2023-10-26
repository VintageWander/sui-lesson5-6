module lesson5::discount_coupon {
    use sui::tx_context::{Self,TxContext};
    use sui::object::{Self, UID};
    use sui::coin::Coin;
    use sui::sui::SUI;
    use sui::transfer;

    struct DiscountCoupon has key {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    public fun owner(coupon: &DiscountCoupon): address {
        coupon.owner
    }

    public fun discount(coupon: &DiscountCoupon): u8 {
        coupon.discount
    }

    public entry fun mint_and_topup(
        coin: Coin<SUI>,
        discount: u8,
        expiration: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coupon = DiscountCoupon {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            discount,
            expiration
        };
        transfer::transfer(coupon, recipient);
        transfer::public_transfer(coin, recipient);
    }

    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {
        transfer::transfer(coupon, recipient);
    }

    public fun burn(coupon: DiscountCoupon): bool {
        let DiscountCoupon { id, owner: _, discount: _, expiration: _ } = coupon;
        object::delete(id);
        true
    }

    public entry fun scan(nft: DiscountCoupon) {
        burn(nft);
    }
}
