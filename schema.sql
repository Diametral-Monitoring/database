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
    active TINYINT(1) NOT NULL DEFAULT 1,

    UNIQUE INDEX (name),
    UNIQUE INDEX (alias),
    INDEX (active)
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

DROP TABLE IF EXISTS subject_twitter_config;
CREATE TABLE subject_twitter_config (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    subject_id INT UNSIGNED NOT NULL,
    account_key VARCHAR(255) NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,

    INDEX (subject_id),
    INDEX (active),
    INDEX (account_key)
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
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(100) NOT NULL,

    UNIQUE INDEX (name),
    UNIQUE INDEX (alias)
);
INSERT INTO score_type(name, alias) VALUES ('Perspective Severe Toxicity', 'perspective_severe_toxicity');
INSERT INTO score_type(name, alias) VALUES ('Perspective Toxicity', 'perspective_toxicity');
INSERT INTO score_type(name, alias) VALUES ('Perspective Profanity', 'perspective_profanity');
INSERT INTO score_type(name, alias) VALUES ('Perspective Identity Attack', 'perspective_identity_attack');
INSERT INTO score_type(name, alias) VALUES ('Perspective Insult', 'perspective_insult');
INSERT INTO score_type(name, alias) VALUES ('Perspective Threat', 'perspective_threat');

DROP TABLE IF EXISTS score;
CREATE TABLE score (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT UNSIGNED NOT NULL,
    type_id INT UNSIGNED NOT NULL,
    score DECIMAL(10,10) NOT NULL,

    UNIQUE INDEX (post_id, type_id)
);



---- VIEWS ----
CREATE OR REPLACE VIEW v_monthly_rolling_score AS
WITH monthly AS (
  SELECT
    CAST(DATE_FORMAT(p.timestamp, '%Y-%m-01 00:00:00') AS DATETIME) AS time,
    p.subject_id,
    s.type_id,
    AVG(s.score) AS month_avg
  FROM post p
  JOIN score s ON s.post_id = p.id
  GROUP BY
    CAST(DATE_FORMAT(p.timestamp, '%Y-%m-01 00:00:00') AS DATETIME),
    p.subject_id,
    s.type_id
)
SELECT
  time,
  subject_id,
  type_id,
  AVG(month_avg) OVER (
    PARTITION BY subject_id, type_id
    ORDER BY time
    ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
  ) AS value
FROM monthly;