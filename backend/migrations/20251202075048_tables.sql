-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS users ( address BLOB PRIMARY KEY );

CREATE TABLE IF NOT EXISTS subscriptions (
    id BLOB PRIMARY KEY,
    admin BLOB NOT NULL,
    coin BLOB NOT NULL,
    amount INTEGER NOT NULL,
    discount INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY,
    user BLOB NOT NULL,
    subscriptions BLOB NOT NULL,
    expiration INTEGER NOT NULL,
    receipt BLOB
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS payments;
-- +goose StatementEnd
