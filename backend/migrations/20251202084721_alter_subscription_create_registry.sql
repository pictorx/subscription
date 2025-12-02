-- +goose Up
-- +goose StatementBegin
ALTER TABLE subscriptions DROP COLUMN admin;
CREATE TABLE IF NOT EXISTS registries ( 
    id BLOB PRIMARY KEY,
    admin BLOB NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS registries;
-- +goose StatementEnd
