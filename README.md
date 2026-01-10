# Database schema

## Delete posts by one subject:
```sql
delete from post where subject_id = 5;
```

## Clean scores from non-existant subjects
```sql
delete from score where id in (
select score.id from score left join post on post.id = score.post_id where post.id is null
);
```

## Report scores for one year
```sql
SELECT
  subject.id AS subject_id
 ,subject.name AS subject_name
 ,post.id AS post_id
 ,post.timestamp
 ,post.content
 ,post.url
 ,score_type.alias AS score_type
 ,score.score
 ,language.alias AS language
FROM
  post
  LEFT JOIN subject ON post.subject_id = subject.id
  LEFT JOIN language ON language.id = post.language_id
  LEFT JOIN score ON score.post_id = post.id
  LEFT JOIN score_type ON score_type.id = score.type_id
WHERE
  subject.active = 1
  AND post.timestamp >= '2025-01-01 00:00:00'
  AND post.timestamp <  '2026-01-01 00:00:00'
;
```

All reported subjects:
```sql
SELECT
  subject.name
 ,subject_twitter_config.account_key
FROM
  subject
  LEFT JOIN subject_twitter_config ON subject_twitter_config.subject_id = subject.id
WHERE
  subject.active = 1
;
```