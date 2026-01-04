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
  subject.name AS subject_name
 ,post.timestamp
 ,post.content
 ,post.url
 ,score_type.alias AS score_type
 ,score.score
 ,language.alias AS language
FROM
  subject
  JOIN post ON post.subject_id = subject.id
  JOIN language ON language.id = post.language_id
  JOIN score ON score.post_id = post.id
  JOIN score_type ON score_type.id = score.type_id
WHERE
  post.timestamp >= '2025-01-01 00:00:00'
  AND timestamp < '2026-01-01 00:00:00';
;
```