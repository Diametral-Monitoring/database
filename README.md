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