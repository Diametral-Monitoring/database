-- Character set used to store emojis in the tables
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE diametral CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE diametral;

DROP TABLE IF EXISTS country;
CREATE TABLE country (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(2) NOT NULL,

    UNIQUE INDEX (name),
    UNIQUE INDEX (alias)
);
INSERT INTO country(name, alias) VALUES ('Switzerland', 'ch');
INSERT INTO country(name, alias) VALUES ('USA', 'us');
INSERT INTO country(name, alias) VALUES ('Germany', 'de');

DROP TABLE IF EXISTS language;
CREATE TABLE language (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(2) NOT NULL,

    UNIQUE INDEX (name),
    UNIQUE INDEX (alias)
);
INSERT INTO language(name, alias) VALUES ('German', 'de');
INSERT INTO language(name, alias) VALUES ('English', 'en');

DROP TABLE IF EXISTS subject_type;
CREATE TABLE subject_type (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(100) NOT NULL,

    UNIQUE INDEX (name),
    UNIQUE INDEX (alias)
);
INSERT INTO subject_type(name, alias) VALUES ('Person', 'person');
INSERT INTO subject_type(name, alias) VALUES ('News Magazine', 'news');

DROP TABLE IF EXISTS subject;
CREATE TABLE subject (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type_id INT UNSIGNED NOT NULL,
    country_id INT UNSIGNED NOT NULL,

    INDEX (type_id),
    INDEX (country_id)
);

DROP TABLE IF EXISTS post;
CREATE TABLE post (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subject_id INT UNSIGNED NOT NULL,
    content TEXT NOT NULL,
    language_id INT UNSIGNED NOT NULL,
    timestamp DATETIME NOT NULL,
    url VARCHAR(2048),
    external_id VARCHAR(255),

    INDEX (subject_id),
    INDEX (url),
    INDEX (timestamp),
    UNIQUE INDEX (external_id)
);

DROP TABLE IF EXISTS score_type;
CREATE TABLE score_type (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS score;
CREATE TABLE score (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT UNSIGNED NOT NULL,
    type_id INT UNSIGNED NOT NULL,
    score DECIMAL(10,10) NOT NULL,

    UNIQUE INDEX (post_id, type_id)
);
