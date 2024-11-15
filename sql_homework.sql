-- 1 - topshiriq

DROP TABLE IF EXISTS authors CASCADE;

CREATE TABLE IF NOT EXISTS authors(
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  bio TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO authors(first_name, last_name, bio) VALUES
('Toxir', 'Toxirov', 'Mening ismim Toxir Toxirov!');

SELECT id, first_name, last_name, TO_CHAR(created_at, 'mm.dd.yyyy, hh24:mi:ss') AS created_time FROM authors;

-- ----------------------------------------------------------------------

-- 2 - topshiriq

DROP TABLE IF EXISTS books;

CREATE TABLE IF NOT EXISTS books(
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title VARCHAR(100),
  summary TEXT,
  published_date DATE DEFAULT CURRENT_DATE,
  metadata JSON,
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO books(title, summary, metadata) VALUES
('Otkan kunlar', 'Written by Abdulla Qodiriy', '{"genre": "Novel", "format": "Ordinary book", "pages": 450, "Main heroes": "Otabek and Kumush"}');

SELECT id, title, summary, published_date, metadata ->> 'genre' AS janr, metadata ->> 'Main heroes' AS main_heroes FROM books;

-- ----------------------------------------------------------------------

-- 3 - topshiriq

DROP TABLE IF EXISTS publishers;

CREATE TABLE IF NOT EXISTS publishers(
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100),
  country CHAR(2),
  founded_year INTEGER NOT NULL,
  details JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO publishers(name, country, founded_year, details) VALUES
('Toxir Toxirov', 'UZ', 2020, '{"website": "toxir.uz", "address": "Ferghana", "since": 2020}');

SELECT id, name, country, founded_year, details ->> 'address' AS address, details ->> 'website' AS website, TO_CHAR(created_at, 'mm.dd.yyyy, hh24:mi:ss') FROM publishers;

-- ----------------------------------------------------------------------

-- 4 - topshirq

DROP TABLE IF EXISTS libraries;

CREATE TABLE IF NOT EXISTS libraries(
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(100),
  location TEXT,
  open_time TIME,
  close_time TIME,
  facilities JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO libraries(name, location, open_time, close_time, facilities) VALUES
('Uzbekistan national library', 'Tashkent', '8:00', '22:00', '{"wifi": "available", "reading_rooms": "provided with cosy furnitures", "lightning": "great", "far_from_road": "yes"}');

SELECT id, name, location, TO_CHAR(open_time, 'hh24.mi') AS opening_time, TO_CHAR(close_time, 'hh24.mi') AS closing_time, facilities ->> 'reading_rooms' AS reading_rooms FROM libraries;

-- ----------------------------------------------------------------------

-- 5 - topshiriq

-- Many to Many bog'lanish jadvallari

-- 1 - vazifa

DROP TABLE IF EXISTS author_book; 

CREATE TABLE IF NOT EXISTS author_book(
	author_id UUID REFERENCES authors(id),
	book_id UUID REFERENCES books(id),
	PRIMARY KEY(author_id, book_id)
);

INSERT INTO author_book(author_id, book_id) VALUES
('f76b77bf-26bc-4110-a7b5-9347a862ad4e', '15b1ac6d-1ebd-4509-a032-cc41f574e928');

SELECT authors.first_name, authors.last_name, books.title FROM author_book
JOIN authors ON author_book.author_id = authors.id
JOIN books ON books.id = author_book.book_id;

-- 2 - vazifa

DROP TABLE IF EXISTS book_publisher;

CREATE TABLE IF NOT EXISTS book_publisher(
	book_id UUID REFERENCES books(id),
	publisher_id UUID REFERENCES publishers(id),
	PRIMARY KEY(book_id, publisher_id)
);

INSERT INTO book_publisher(book_id, publisher_id) VALUES
('15b1ac6d-1ebd-4509-a032-cc41f574e928', 'cbe68e5c-a513-488d-9ee4-07348d38ded6');


SELECT publishers.name AS publisher_name, books.title AS book_name, books.published_date FROM book_publisher
JOIN books ON book_publisher.book_id = books.id
JOIN publishers ON book_publisher.publisher_id = publishers.id

-- 3 - vazifa

DROP TABLE IF EXISTS library_book;

CREATE TABLE IF NOT EXISTS library_book(
	library_id UUID REFERENCES libraries(id),
	book_id UUID REFERENCES books(id)
);

INSERT INTO library_book(library_id, book_id) VALUES
('44277fa1-32d0-4255-9f3e-244e84b0118f', '15b1ac6d-1ebd-4509-a032-cc41f574e928');

SELECT libraries.name AS library_name, libraries.location, books.title AS book_title FROM library_book
JOIN libraries ON libraries.id = library_book.library_id
JOIN books ON books.id = library_book.book_id;


