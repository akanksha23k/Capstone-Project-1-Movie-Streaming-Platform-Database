-- Create database
CREATE DATABASE movie_streaming;
USE movie_streaming;

-- USERS
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    country_code CHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SUBSCRIPTION PLANS
CREATE TABLE plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,   -- Basic, Standard, Premium
    monthly_price DECIMAL(10,2) NOT NULL,
    max_devices INT NOT NULL
);

-- SUBSCRIPTIONS
CREATE TABLE subscriptions (
    sub_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    plan_id INT,
    status ENUM('active','canceled','expired') DEFAULT 'active',
    start_at DATETIME,
    end_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

-- CONTENT (movies/shows)
CREATE TABLE content (
    content_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('movie','show') NOT NULL,
    title VARCHAR(200) NOT NULL,
    release_year INT,
    is_available BOOLEAN DEFAULT TRUE
);

-- GENRES
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE content_genres (
    content_id BIGINT,
    genre_id INT,
    PRIMARY KEY (content_id, genre_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- DIRECTORS
CREATE TABLE directors (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE content_directors (
    content_id BIGINT,
    director_id INT,
    PRIMARY KEY (content_id, director_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id),
    FOREIGN KEY (director_id) REFERENCES directors(director_id)
);

-- LANGUAGES
CREATE TABLE content_languages (
    content_id BIGINT,
    language_code VARCHAR(10),
    PRIMARY KEY (content_id, language_code),
    FOREIGN KEY (content_id) REFERENCES content(content_id)
);

-- WATCH EVENTS
CREATE TABLE watch_events (
    event_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    content_id BIGINT,
    event_type ENUM('start','complete'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id)
);

-- RATINGS
CREATE TABLE ratings (
    user_id BIGINT,
    content_id BIGINT,
    stars INT CHECK(stars BETWEEN 1 AND 5),
    review_text TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, content_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id)
);

-- WATCHLIST
CREATE TABLE watchlist (
    user_id BIGINT,
    content_id BIGINT,
    PRIMARY KEY (user_id, content_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id)
);

-- PAYMENTS
CREATE TABLE payments (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    sub_id BIGINT,
    amount DECIMAL(10,2),
    status ENUM('succeeded','failed') DEFAULT 'succeeded',
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (sub_id) REFERENCES subscriptions(sub_id)
);
-- USERS
INSERT INTO users (email, password_hash, country_code) VALUES
('aditya@example.com', 'hash1', 'US'),
('amrapali@example.com', 'hash2', 'IN'),
('kajal@example.com', 'hash3', 'US'),
('vaishnavi@example.com', 'hash4', 'IN'),
('sagarika@example.com', 'hash5', 'KR');

-- PLANS
INSERT INTO plans (name, monthly_price, max_devices) VALUES
('Basic', 5.99, 1),
('Standard', 9.99, 2),
('Premium', 14.99, 4);

-- SUBSCRIPTIONS
INSERT INTO subscriptions (user_id, plan_id, status, start_at, end_at) VALUES
(1, 2, 'active', '2025-06-01', '2025-09-01'),
(2, 1, 'active', '2025-07-01', '2025-10-01'),
(3, 3, 'canceled', '2025-01-01', '2025-04-01'),
(4, 2, 'active', '2025-07-15', '2025-10-15'),
(5, 3, 'active', '2025-08-01', '2025-11-01');

-- CONTENT (Movies & Shows from Bollywood, Hollywood, Korean, Marathi)
INSERT INTO content (type, title, release_year, is_available) VALUES
('movie', 'Inception', 2010, TRUE),            -- Hollywood
('movie', 'The Dark Knight', 2008, TRUE),      -- Hollywood
('movie', 'Interstellar', 2014, TRUE),         -- Hollywood
('movie', 'Train to Busan', 2016, TRUE),       -- Korean
('movie', 'Parasite', 2019, TRUE),             -- Korean
('movie', 'Dangal', 2016, TRUE),               -- Bollywood
('movie', '3 Idiots', 2009, TRUE),             -- Bollywood
('movie', 'Sairat', 2016, TRUE),               -- Marathi
('movie', 'Natsamrat', 2016, TRUE),            -- Marathi
('movie', 'Conjuring', 2013, TRUE),            -- Hollywood Horror
('movie', 'Bhool Bhulaiyaa', 2007, TRUE),      -- Bollywood Horror-Comedy
('movie', 'Andhadhun', 2018, TRUE),            -- Bollywood Thriller
('show', 'Stranger Things', 2016, TRUE),       -- Hollywood
('show', 'Money Heist', 2017, TRUE),           -- Spanish/Korean remake popular
('show', 'Sacred Games', 2018, TRUE);          -- Bollywood

-- GENRES
INSERT INTO genres (name) VALUES
('Action'),
('Drama'),
('Thriller'),
('Sci-Fi'),
('Comedy'),
('Horror');

-- CONTENT-GENRES
INSERT INTO content_genres VALUES
(1,1), (1,4),        -- Inception (Action, Sci-Fi)
(2,1), (2,3),        -- Dark Knight (Action, Thriller)
(3,4),               -- Interstellar (Sci-Fi)
(4,1), (4,3),        -- Train to Busan (Action, Thriller, Horror)
(4,6),
(5,2), (5,3),        -- Parasite (Drama, Thriller)
(6,2),               -- Dangal (Drama)
(7,2), (7,5),        -- 3 Idiots (Drama, Comedy)
(8,2), (8,5),        -- Sairat (Drama, Comedy)
(9,2),               -- Natsamrat (Drama)
(10,6),              -- Conjuring (Horror)
(11,5), (11,6),      -- Bhool Bhulaiyaa (Comedy, Horror)
(12,3),              -- Andhadhun (Thriller)
(13,2), (13,3),      -- Stranger Things (Drama, Thriller)
(14,3), (14,1),      -- Money Heist (Thriller, Action)
(15,2), (15,3);      -- Sacred Games (Drama, Thriller)

-- DIRECTORS
INSERT INTO directors (name) VALUES
('Christopher Nolan'),
('Yeon Sang-ho'),
('Bong Joon-ho'),
('Nitesh Tiwari'),
('Rajkumar Hirani'),
('Nagraj Manjule'),
('Mahesh Manjrekar'),
('James Wan'),
('Priyadarshan'),
('Sriram Raghavan'),
('Duffer Brothers'),
('Álex Pina'),
('Anurag Kashyap');

-- CONTENT-DIRECTORS
INSERT INTO content_directors VALUES
(1,1), (2,1), (3,1),            -- Nolan movies
(4,2),                          -- Train to Busan - Yeon Sang-ho
(5,3),                          -- Parasite - Bong Joon-ho
(6,4),                          -- Dangal - Nitesh Tiwari
(7,5),                          -- 3 Idiots - Rajkumar Hirani
(8,6),                          -- Sairat - Nagraj Manjule
(9,7),                          -- Natsamrat - Mahesh Manjrekar
(10,8),                         -- Conjuring - James Wan
(11,9),                         -- Bhool Bhulaiyaa - Priyadarshan
(12,10),                        -- Andhadhun - Sriram Raghavan
(13,11),                        -- Stranger Things - Duffer Brothers
(14,12),                        -- Money Heist - Álex Pina
(15,13);                        -- Sacred Games - Anurag Kashyap

-- LANGUAGES (multi-language support)
INSERT INTO content_languages VALUES
(1,'en'),(1,'es'),
(2,'en'),
(3,'en'),
(4,'ko'),(4,'en'),
(5,'ko'),(5,'en'),
(6,'hi'),(6,'en'),
(7,'hi'),
(8,'mr'),(8,'hi'),
(9,'mr'),
(10,'en'),
(11,'hi'),
(12,'hi'),(12,'en'),
(13,'en'),
(14,'es'),(14,'en'),
(15,'hi'),(15,'en');

-- WATCH EVENTS (simulate viewing)
INSERT INTO watch_events (user_id, content_id, event_type, created_at) VALUES
(1,1,'complete','2025-07-01 10:00:00'),
(1,2,'complete','2025-07-15 12:00:00'),
(1,7,'complete','2025-08-01 18:00:00'),
(2,6,'complete','2025-08-02 09:00:00'),
(2,8,'complete','2025-08-03 19:00:00'),
(3,4,'start','2025-08-05 20:00:00'),
(4,10,'complete','2025-08-10 22:00:00'),
(5,5,'complete','2025-08-11 14:00:00'),
(5,14,'complete','2025-08-12 16:00:00');

-- RATINGS
INSERT INTO ratings VALUES
(1,1,5,'Amazing sci-fi!',NOW()),
(1,2,4,'Great Batman movie',NOW()),
(1,7,5,'Best comedy-drama!',NOW()),
(2,6,5,'Inspiring!',NOW()),
(2,8,4,'Beautiful story',NOW()),
(3,2,2,'Too dark',NOW()),
(4,10,4,'Scary!',NOW()),
(5,5,5,'Masterpiece',NOW());

-- WATCHLIST
INSERT INTO watchlist VALUES
(1,13),
(1,14),
(2,12),
(2,11),
(3,1),
(3,9),
(4,6),
(5,7);

-- PAYMENTS
INSERT INTO payments (user_id, sub_id, amount, status, paid_at) VALUES
(1,1,9.99,'succeeded','2025-06-01'),
(2,2,5.99,'succeeded','2025-07-01'),
(3,3,14.99,'failed','2025-01-01'),
(4,4,9.99,'succeeded','2025-07-15'),
(5,5,14.99,'succeeded','2025-08-01');

-- Indexes for fast lookups
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_content_title ON content(title);
CREATE INDEX idx_watch_user ON watch_events(user_id);
CREATE INDEX idx_watch_content ON watch_events(content_id);
CREATE INDEX idx_rating_content ON ratings(content_id);
CREATE INDEX idx_watchlist_user ON watchlist(user_id);

-- Activate/extend subscription when a payment succeeds

DELIMITER //

CREATE TRIGGER trg_payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
  -- Only act on successful payments
  IF NEW.status = 'succeeded' THEN
    -- Make sure subscription exists
    IF NEW.sub_id IS NOT NULL THEN
      UPDATE subscriptions
      SET status = 'active',
          -- if subscription end_at is in past or NULL, start from now else extend from existing end_at
          end_at = CASE
                    WHEN end_at IS NULL OR end_at < NOW() THEN DATE_ADD(NOW(), INTERVAL 1 MONTH)
                    ELSE DATE_ADD(end_at, INTERVAL 1 MONTH)
                   END
      WHERE sub_id = NEW.sub_id;
    END IF;

   
  END IF;
END//

DELIMITER ;

-- Revoke access & stop streaming when subscription becomes canceled/expired

DELIMITER //

CREATE TRIGGER trg_subscriptions_after_update
AFTER UPDATE ON subscriptions
FOR EACH ROW
BEGIN
  -- If new status is canceled or expired, end streams
  IF NEW.status IN ('canceled','expired') THEN
    -- stop all streaming sessions for the user
    UPDATE device_session
    SET is_streaming = FALSE, last_seen_at = NOW()
    WHERE user_id = NEW.user_id;

    -- Optional: insert notification
    INSERT INTO notifications (user_id, title, body)
    VALUES (NEW.user_id, 'Subscription cancelled', CONCAT('Your subscription is ', NEW.status, '. Access revoked.'));
  END IF;
END//

DELIMITER ;

-- Enforce verified creators before mapping content -> creator
DELIMITER //

CREATE TRIGGER trg_content_creators_before_insert
BEFORE INSERT ON content_creators
FOR EACH ROW
BEGIN
  DECLARE v_verified INT;
  SELECT is_verified INTO v_verified FROM creators WHERE creator_id = NEW.creator_id;
  IF v_verified IS NULL OR v_verified = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Creator not verified — cannot assign content';
  END IF;
END//

DELIMITER ;

-- Stored function to check region licensing (use in application before allowing streaming)
DELIMITER //

CREATE FUNCTION fn_is_content_allowed_for_user(p_content_id BIGINT, p_user_id BIGINT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE v_region CHAR(2);
  DECLARE v_exists INT;

  SELECT country_code INTO v_region FROM users WHERE user_id = p_user_id LIMIT 1;

  SELECT COUNT(*) INTO v_exists
  FROM region_license rl
  WHERE rl.content_id = p_content_id
    AND rl.region_code = v_region
    AND CURDATE() BETWEEN rl.window_start AND rl.window_end;

  RETURN v_exists > 0;
END//

DELIMITER ;

DELIMITER ;

-- SQL Queries

-- Task  — Retrieve all movies & TV shows in 'Action'

SELECT c.content_id, c.type, c.title, c.release_year
FROM content c
JOIN content_genres cg ON c.content_id = cg.content_id
JOIN genres g ON g.genre_id = cg.genre_id
WHERE g.name = 'Action' AND c.is_available = TRUE;

-- Task  - All registered users with current subscription plan
SELECT u.user_id, u.email, p.name AS plan_name
FROM users u
LEFT JOIN subscriptions s ON s.user_id = u.user_id AND s.status = 'active'
LEFT JOIN plans p ON p.plan_id = s.plan_id
ORDER BY u.user_id;

-- Task  - Most-watched movie in the last 3 months

SELECT c.content_id, c.title, COUNT(*) AS completes
FROM watch_events w
JOIN content c ON c.content_id = w.content_id
WHERE w.event_type = 'complete'
  AND w.created_at >= NOW() - INTERVAL 3 MONTH
  AND c.type = 'movie'
GROUP BY c.content_id, c.title
ORDER BY completes DESC
LIMIT 1;

-- Task  - All movies directed by Christopher Nolan
SELECT c.content_id, c.title, c.release_year
FROM content c
JOIN content_directors cd ON cd.content_id = c.content_id
JOIN directors d ON d.director_id = cd.director_id
WHERE d.name = 'Christopher Nolan' AND c.type = 'movie' AND c.is_available = TRUE;

-- Task  — Watch history of a specific user (titles + timestamps)
SELECT w.user_id, c.title, w.event_type, w.created_at
FROM watch_events w
JOIN content c ON c.content_id = w.content_id
WHERE w.user_id = 1
ORDER BY w.created_at DESC;

-- Task  — Users who rated at least 5 movies and avg rating
SELECT r.user_id, COUNT(*) AS num_rated, ROUND(AVG(r.stars),2) AS avg_rating
FROM ratings r
JOIN content c ON c.content_id = r.content_id AND c.type = 'movie'
GROUP BY r.user_id
HAVING COUNT(*) >= 5
ORDER BY num_rated DESC;


-- Task  — Upcoming movies to be released on platform within next 6 months

SELECT content_id, title, release_year
FROM content
WHERE type = 'movie'
  AND (STR_TO_DATE(CONCAT(release_year,'-01-01'),'%Y-%m-%d') BETWEEN CURDATE() AND CURDATE() + INTERVAL 6 MONTH);


-- Task  — Movies available in both English and Spanish
SELECT DISTINCT c.content_id, c.title
FROM content c
JOIN content_languages l1 ON l1.content_id = c.content_id AND l1.language_code = 'en'
JOIN content_languages l2 ON l2.content_id = c.content_id AND l2.language_code = 'es'
WHERE c.type = 'movie';

-- Task  — Movies rated < 3 stars by more than 50 users
SELECT c.content_id, c.title, COUNT(*) AS low_raters
FROM ratings r
JOIN content c ON c.content_id = r.content_id AND c.type = 'movie'
WHERE r.stars < 3
GROUP BY c.content_id, c.title
HAVING COUNT(*) > 50;

-- Task  — Subscription renewal dates for all users with active plans
SELECT s.user_id, p.name AS plan_name, s.end_at AS renewal_date
FROM subscriptions s
JOIN plans p ON p.plan_id = s.plan_id
WHERE s.status = 'active'
ORDER BY s.end_at;

-- Task  — Users who added >=5 movies to watchlist but haven't watched any
SELECT w.user_id, COUNT(*) AS watchlist_count
FROM watchlist w
LEFT JOIN watch_events e ON e.user_id = w.user_id AND e.content_id = w.content_id
GROUP BY w.user_id
HAVING COUNT(*) >= 5 AND SUM(CASE WHEN e.event_id IS NULL THEN 0 ELSE 1 END) = 0;

-- Task  — Top 5 directors whose movies have highest average ratings (min 100 ratings)

SELECT d.director_id, d.name,
       ROUND(AVG(r.stars),2) AS avg_stars, COUNT(r.stars) AS rating_count
FROM content_directors cd
JOIN directors d ON d.director_id = cd.director_id
JOIN ratings r ON r.content_id = cd.content_id
JOIN content c ON c.content_id = cd.content_id AND c.type = 'movie'
GROUP BY d.director_id, d.name
HAVING COUNT(r.stars) >= 100
ORDER BY avg_stars DESC
LIMIT 5;

-- Task  — Subscription cancellations in last 6 months and trend (monthly)
SELECT DATE_FORMAT(canceled_at, '%Y-%m-01') AS month, COUNT(*) AS cancellations
FROM subscriptions
WHERE status = 'canceled' AND canceled_at >= NOW() - INTERVAL 6 MONTH
GROUP BY month
ORDER BY month;


-- Task  — Revenue generated from subscriptions in the last year (monthly)
SELECT DATE_FORMAT(p.paid_at, '%Y-%m-01') AS month,
       SUM(CASE WHEN p.status = 'succeeded' THEN p.amount ELSE 0 END) AS revenue
FROM payments p
WHERE p.paid_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY month
ORDER BY month;


-- Task  — Ensure when new movie is added, its genre, director, release_year are recorded

CALL sp_add_movie('Bollywood New Film', 2026, 140, TRUE, '2,5', 4, 'movie');


-- Task  — Identify users sharing login credentials (multiple devices streaming simultaneously)
SELECT ds.user_id, COUNT(*) AS streaming_devices, pl.max_devices
FROM device_session ds
JOIN subscriptions s ON s.user_id = ds.user_id AND s.status = 'active'
JOIN plans pl ON pl.plan_id = s.plan_id
WHERE ds.is_streaming = TRUE AND ds.last_seen_at >= NOW() - INTERVAL 5 MINUTE
GROUP BY ds.user_id, pl.max_devices
HAVING COUNT(*) > pl.max_devices;

-- __________________________________________________________________________________________________________________________

-- Views

-- All Action Movies

CREATE VIEW view_action_movies AS
SELECT c.content_id, c.title, c.release_year, c.type
FROM content c
JOIN content_genres cg ON c.content_id = cg.content_id
JOIN genres g ON cg.genre_id = g.genre_id
WHERE g.name = 'Action';

-- Users with Their Current Subscription Plan

CREATE VIEW view_user_subscriptions AS
SELECT u.user_id, u.email, p.name AS plan_name, s.status, s.end_at
FROM users u
JOIN subscriptions s ON u.user_id = s.user_id
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.status = 'active';

-- Most-Watched Movie in the Last 3 Months

CREATE VIEW view_most_watched_last3months AS
SELECT c.content_id, c.title, COUNT(w.event_id) AS watch_count
FROM watch_events w
JOIN content c ON w.content_id = c.content_id
WHERE w.event_type = 'complete'
  AND w.created_at >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY c.content_id, c.title
ORDER BY watch_count DESC
LIMIT 1;

-- Movies Directed by Christopher Nolan
CREATE VIEW view_nolan_movies AS
SELECT c.content_id, c.title, c.release_year, c.type
FROM content c
JOIN content_directors cd ON c.content_id = cd.content_id
JOIN directors d ON cd.director_id = d.director_id
WHERE d.name = 'Christopher Nolan';

-- Watch History of Each User

CREATE VIEW view_user_watch_history AS
SELECT u.user_id, u.email, c.title, w.event_type, w.created_at
FROM watch_events w
JOIN users u ON w.user_id = u.user_id
JOIN content c ON w.content_id = c.content_id
ORDER BY u.user_id, w.created_at;
