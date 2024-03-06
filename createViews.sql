CREATE VIEW View_User_Information AS
SELECT U.user_id, U.first_name, U.last_name, U.year_of_birth, U.month_of_birth, U.day_of_birth, U.gender,
CI.city_name AS current_city, CI.state_name AS current_state, CI.country_name AS current_country,
HO.city_name AS hometown_city, HO.state_name AS hometown_state, HO.country_name AS hometown_country,
PROGRAMS.institution AS institution_name, EDUCATION.program_year, PROGRAMS.concentration AS program_concentration, PROGRAMS.degree AS program_degree
FROM USERS U
LEFT JOIN USER_CURRENT_CITIES ON U.user_id = USER_CURRENT_CITIES.user_id
LEFT JOIN USER_HOMETOWN_CITIES ON U.user_id = USER_HOMETOWN_CITIES.user_id
LEFT JOIN CITIES CI ON CI.city_id = USER_CURRENT_CITIES.current_city_id
LEFT JOIN CITIES HO On HO.city_id = USER_HOMETOWN_CITIES.hometown_city_id
LEFT JOIN EDUCATION On EDUCATION.user_id = U.user_id
LEFT JOIN PROGRAMS ON EDUCATION.program_id = PROGRAMS.program_id;


CREATE VIEW View_Are_Friends AS 
SELECT user1_id, user2_id 
FROM Friends;

CREATE VIEW View_Tag_Information AS
SELECT tag_photo_id, tag_subject_id, tag_created_time, tag_x AS tag_x_coordinate, tag_y AS tag_y_coordinate
FROM Tags;

CREATE VIEW View_Photo_Information AS
SELECT ALBUMS.album_id, ALBUMS.album_owner_id, ALBUMS.cover_photo_id, ALBUMS.album_name, ALBUMS.album_created_time, ALBUMS.album_modified_time, ALBUMS.album_link, ALBUMS.album_visibility,
PHOTOS.photo_id, PHOTOS.photo_caption, PHOTOS.photo_created_time, PHOTOS.photo_modified_time, PHOTOS.photo_link
FROM PHOTOS JOIN ALBUMS ON ALBUMS.album_id = PHOTOS.album_id;

CREATE VIEW View_Event_Information AS
SELECT event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address,
city_name AS event_city, state_name AS event_state, country_name AS event_country, event_start_time, event_end_time
FROM USER_EVENTS JOIN CITIES ON USER_EVENTS.event_city_id = CITIES.city_id;
