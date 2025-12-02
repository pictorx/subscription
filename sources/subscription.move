module subscription::subscription;

use sui::derived_object;
use sui::balance::Balance;
use payment_kit::payment_kit;

#[error(code = 1)]
const EInvalidDiscount: vector<u8> = b"Discount cannot be equal or greater than 100";

public struct UserRegistry has key {
    id: UID,
    total_users: u64,
}

fun init(ctx: &mut TxContext) {
    let registry = UserRegistry {
        id: object::new(ctx),
        total_users: 0,
    };

    transfer::share_object(registry);
}

public struct User has key {
    id: UID,
    address: address,
    created_at: u64,
}

public fun new_user(registry: &mut UserRegistry, ctx: &mut TxContext, created: u64): User {
    let sender = ctx.sender();
    let derived_id = derived_object::claim(&mut registry.id, sender);

    registry.total_users = registry.total_users + 1;

    let user = User {
        id: derived_id,
        address: sender,
        created_at: created,
    };

    (user)
}

public struct Subscription<phantom T> has key, store {
    id: UID,
    amount: u64,
    coin: Balance<T>,
    discount: u64,
    registryadmin: payment_kit::RegistryAdminCap,
}

public fun new_subscription<T>(
    registryadmin: payment_kit::RegistryAdminCap, 
    amount: u64, 
    coin: Balance<T>, 
    discount: u64 ,
    ctx: &mut TxContext): Subscription<T> {
    assert!(discount >= 100 , EInvalidDiscount);

    let subscription = Subscription{
        id: object::new(ctx),
        amount: amount,
        coin: coin,
        discount: discount,
        registryadmin: registryadmin,
    };
   
    subscription
}

public fun update_amount_subscription<T>(sub: &mut Subscription<T>, amount: u64, _ctx: &mut TxContext) {
    sub.amount = amount
}

public fun update_discount_subscription<T>(sub: &mut Subscription<T>, discount: u64, _ctx: &mut TxContext) {
    assert!(discount >= 100 , EInvalidDiscount);

    sub.discount = discount
}

public struct Payment has store {
    user: address,
    subscription: ID,
    exp: u64,
    receipt: Option<payment_kit::PaymentReceipt>,
}

public fun new_payment<T>(user: &User, sub: &Subscription<T>, exp: u64, _ctx: &mut TxContext): Payment {
    let payment = Payment{
        user: user.id.to_address(),
        subscription: sub.id.to_inner(),
        exp: exp,
        receipt: option::none(),
    };

    payment

}

// pay
// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
