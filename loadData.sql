INSERT INTO USERS (user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender)
SELECT DISTINCT user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender 
FROM project1.Public_User_Information;

INSERT INTO FRIENDS (user1_id, user2_id) 
SELECT DISTINCT user1_id, user2_id 
FROM project1.Public_Are_Friends WHERE user1_id < user2_id;

INSERT INTO PROGRAMS (institution, concentration, degree) 
SELECT DISTINCT institution_name, program_concentration, program_degree 
FROM project1.Public_User_Information WHERE institution_name IS NOT NULL;

INSERT INTO CITIES (city_name, state_name, country_name)
SELECT DISTINCT current_city, current_state, current_country
FROM project1.Public_User_Information;
UNION
SELECT DISTINCT hometown_city, hometown_state, current_country
FROM project1.Public_User_Information;
UNION
SELECT DISTINCT event_city, event_state, event_country
FROM project1.Public_Event_Information;

INSERT INTO USER_CURRENT_CITIES (user_id, current_city_id)
SELECT DISTINCT user_id, CITIES.city_id
FROM project1.Public_User_Information pro
INNER JOIN CITIES 
ON pro.current_country = CITIES.country_name
AND  pro.current_state = CITIES.state_name
AND  pro.current_city = CITIES.city_name;

INSERT INTO USER_HOMETOWN_CITIES (user_id, hometown_city_id)
SELECT DISTINCT user_id, CITIES.city_id
FROM project1.Public_User_Information pro
INNER JOIN CITIES 
ON pro.hometown_country = CITIES.country_name
AND  pro.hometown_state = CITIES.state_name
AND  pro.hometown_city = CITIES.city_name;

INSERT INTO EDUCATION (user_id, program_id, program_year)
SELECT DISTINCT user_id, PROGRAMS.program_id, program_year 
FROM project1.Public_User_Information pro
INNER JOIN PROGRAMS 
ON pro.institution_name = PROGRAMS.institution
AND pro.program_concentration = PROGRAMS.concentration
AND pro.program_degree = PROGRAMS.degree;

INSERT INTO USER_EVENTS (event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, event_city_id, event_start_time, event_end_time)
SELECT DISTINCT event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, Cities.city_id, event_start_time, event_end_time
FROM project1.Public_Event_Information pro
INNER Join CITIES 
ON pro.event_country = CITIES.country_name
AND pro.event_state = CITIES.state_name
AND pro.event_city = CITIES.city_name;

SET AUTOCOMMIT OFF;

INSERT INTO PHOTOS (photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link)
SELECT DISTINCT photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link 
FROM project1.Public_Photo_Information;

INSERT INTO ALBUMS (album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id)
SELECT DISTINCT album_id, owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id 
FROM project1.Public_Photo_Information;

SET AUTOCOMMIT ON;

INSERT INTO TAGS (tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y)
SELECT DISTINCT photo_id, tag_subject_id, tag_created_time, tag_x_coordinate, tag_y_coordinate 
FROM project1.Public_Tag_Information;