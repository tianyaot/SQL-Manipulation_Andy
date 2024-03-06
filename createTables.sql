CREATE TABLE USERS(
    user_id INTEGER PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    year_of_birth INTEGER,
    month_of_birth INTEGER,
    day_of_birth INTEGER,
    gender VARCHAR2(100)
);

CREATE TABLE FRIENDS(
    user1_id INTEGER NOT NULL,
    user2_id INTEGER NOT NULL,
    PRIMARY KEY (user1_id, user2_id),
    FOREIGN KEY (user1_id) REFERENCES USERS(user_id),
    FOREIGN KEY (user2_id) REFERENCES USERS(user_id),
    CHECK (user1_id != user2_id)
);

CREATE TRIGGER Order_Friend_Pairs
    BEFORE INSERT ON Friends
    FOR EACH ROW
        DECLARE temp INTEGER;
        BEGIN
            IF :NEW.user1_id > :NEW.user2_id THEN
                temp := :NEW.user2_id;
                :NEW.user2_id := :NEW.user1_id;
                :NEW.user1_id := temp;
            END IF;
        END;
/

CREATE TABLE CITIES(
    city_id INTEGER PRIMARY KEY,
    city_name VARCHAR2(100) NOT NULL,
    state_name VARCHAR2(100) NOT NULL,
    country_name VARCHAR2(100) NOT NULL,
    UNIQUE(city_name,state_name,country_name)
);

CREATE SEQUENCE City_Seq
    START WITH 1
    INCREMENT BY 1;
CREATE TRIGGER Trigger_City_ID
    BEFORE INSERT ON CITIES
    FOR EACH ROW
        BEGIN
            SELECT City_SEQ.NEXTVAL INTO :NEW.city_id FROM DUAL;
        END;
/

CREATE TABLE USER_CURRENT_CITIES(
    user_id INTEGER PRIMARY KEY,
    current_city_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (current_city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE USER_HOMETOWN_CITIES(
    user_id INTEGER PRIMARY KEY,
    hometown_city_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (hometown_city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE MESSAGES(
    message_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message_content VARCHAR2(2000) NOT NULL,
    sent_time TIMESTAMP NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES USERS(user_id),
    FOREIGN KEY (receiver_id) REFERENCES USERS(user_id)
);

CREATE TABLE PROGRAMS(
    program_id INTEGER PRIMARY KEY,
    institution VARCHAR2(100) NOT NULL,
    concentration VARCHAR2(100) NOT NULL,
    degree VARCHAR2(100) NOT NULL,
    UNIQUE(institution,concentration,degree)
);

CREATE SEQUENCE Program_Seq
    START WITH 1
    INCREMENT BY 1;
CREATE TRIGGER Trigger_Program_ID
    BEFORE INSERT ON PROGRAMS
    FOR EACH ROW
        BEGIN
            SELECT Program_Seq.NEXTVAL INTO :NEW.program_id FROM DUAL;
        END;
/

CREATE TABLE EDUCATION(
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    program_year INTEGER NOT NULl,
    PRIMARY KEY(user_id, program_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (program_id) REFERENCES PROGRAMS(program_id)
);

CREATE TABLE USER_EVENTS(
    event_id INTEGER PRIMARY KEY,
    event_creator_id INTEGER NOT NULL,
    event_name VARCHAR2(100) NOT NULL,
    event_tagline VARCHAR2(100),
    event_description VARCHAR2(100),
    event_host VARCHAR2(100),
    event_type VARCHAR2(100),
    event_subtype VARCHAR2(100),
    event_address VARCHAR2(2000),
    event_city_id INTEGER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    FOREIGN KEY (event_creator_id) REFERENCES USERS(user_id),
    FOREIGN KEY (event_city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE PARTICIPANTS(
    event_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    confirmation VARCHAR2(100) NOT NULL,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES USER_EVENTS(event_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CHECK (confirmation IN (
    'Attending', 
    'Unsure', 
    'Declines', 
    'Not_Replied'))
);

CREATE TABLE ALBUMS(
  album_id INTEGER PRIMARY KEY,
  album_owner_id INTEGER NOT NULL,
  album_name VARCHAR2(100) NOT NULL,
  album_created_time TIMESTAMP NOT NULL,
  album_modified_time TIMESTAMP,
  album_link VARCHAR2(2000) NOT NULL,
  album_visibility VARCHAR2(100) NOT NULL,
  cover_photo_id INTEGER NOT NULL,
  FOREIGN KEY (album_owner_id) REFERENCES USERS(user_id),
  CHECK (
    album_visibility IN(
      'Everyone',
      'Friends',
      'Friends_Of_Friends',
      'Myself'
    )
  )
);


CREATE TABLE PHOTOS(
  photo_id INTEGER PRIMARY KEY,
  album_id INTEGER NOT NULL,
  photo_caption VARCHAR2(2000),
  photo_created_time TIMESTAMP NOT NULL,
  photo_modified_time TIMESTAMP,
  photo_link VARCHAR2(2000) NOT NULL
);

ALTER TABLE ALBUMS
ADD CONSTRAINT ALBUM_constraint
FOREIGN KEY (cover_photo_id) REFERENCES PHOTOS(photo_id)
INITIALLY DEFERRED DEFERRABLE;

ALTER TABLE PHOTOS
ADD CONSTRAINT PHOTO_constraint
FOREIGN KEY (album_id) REFERENCES ALBUMS (album_id)
INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE TAGS(
    tag_photo_id INTEGER NOT NULL,
    tag_subject_id INTEGER NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMBER NOT NULL,
    tag_y NUMBER NOT NULL,
    PRIMARY KEY (tag_photo_id, tag_subject_id),
    FOREIGN KEY (tag_photo_id) REFERENCES PHOTOS(photo_id),
    FOREIGN KEY (tag_subject_id) REFERENCES USERS(user_id)
);
