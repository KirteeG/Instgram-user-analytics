-- Five oldest users of the Instagram 
WITH base as
( select
username ,
created_at
FROM
ig_clone.users
order by created_at
limit 5
)
SELECT * FROM base;

-- Users who have never posted a single photo on Instagram 
select
   u.username
from
   ig_clone.users u
left join
   ig_clone.photos p
on u.id = p.user_id
where
   p.user_id is null
order by
   u.username;

--  Identify the winner of the contest and provide their details to the team 
with base as
(
  select
   likes.photo_id,
   users.username,
   count(likes.user_id) as like_user
  from
   ig_clone.likes likes
  inner join
   ig_clone.photos photos
   	on likes.photo_id = photos.id
  inner join
   ig_clone.users users
   	on photos.user_id = users.id
  group by
   likes.photo_id, users.username
  order by
   like_user desc
  limit 1
)  
select username from base;

-- Identify and suggest the top 5 most commonly used hashtags on the platform 
select
 t.tag_name,
 count(p.photo_id) as num_tags
from
 ig_clone.photo_tags p
inner join
 ig_clone.tags t
on p.tag_id = t.id
group by
 tag_name
order by
 num_tags desc
limit 5;

-- What day of the week do most users register on? Provide insights on when to schedule an ad campaign
select 
 weekday(created_at) as weekday,
 count(username) as num_users
from  ig_clone.users
group by 
 weekday(created_at)
order by 
num_users desc;

-- Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).
With photo_count as
(
  Select 
    user_id,
    Count(photo_id) as num_like
  From
    ig_clone.likes
  Group by
    user_id
  Order by
    num_like desc
 )
 
 Select *
 From 
  photo_count
 where 
  num_like = (select count(*) from ig_clone.photos);


    


