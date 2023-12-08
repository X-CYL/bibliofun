-- Active: 1701946869658@@mysql-x-cyl.alwaysdata.net@3306@x-cyl_bibliofun
CREATE DATABASE bibliofun;

SHOW DATABASES;

use bibliofun

SHOW TABLES;

# creating tables 

CREATE TABLE users (`users_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                   `name` VARCHAR(50) NOT NULL,
                   `surname` VARCHAR(50) NOT NULL,
                   `e_mail` VARCHAR(60) NOT NULL,
                   `password` VARCHAR(255) NOT NULL,
                   `pseudo` VARCHAR(50) NOT NULL);

CREATE TABLE books (`book_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                   `titre` VARCHAR(50) NOT NULL,
                   `nombre_de_pages` INT,
                   `numero_IBSN` VARCHAR(100),
                   `pitch` LONGTEXT,
                   `couverture` BLOB,
                   `date_enregistrement` DATETIME,
                   `partage` BOOLEAN);

CREATE TABLE genre (`genre_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                    `genre` VARCHAR(80) NOT NULL);

CREATE TABLE `format` (`format_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                    `format` VARCHAR(20) NOT NULL);

CREATE TABLE `edition` (`edition_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                    `edition` VARCHAR(50) NOT NULL);

CREATE TABLE `auteur` (`auteur_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                    `nom` VARCHAR(50) NOT NULL,
                    `prenom` VARCHAR(50) NOT NULL);

CREATE TABLE `likes` (like_id INT PRIMARY KEY AUTO_INCREMENT,
                      user_id INT,
                      book_id INT);

CREATE TABLE book_genre (
                        book_genre_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                        book_id INT,
                        genre_id INT,
                        CONSTRAINT FK_1 FOREIGN KEY(book_id) REFERENCES books(book_id),
                        CONSTRAINT FK_2 FOREIGN KEY(genre_id) REFERENCES genre(genre_id));

CREATE TABLE format_maison_edition (
                        format_maison_edition_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
                        format_id INT,
                        edition_id INT,
                        CONSTRAINT FK_3 FOREIGN KEY(format_id) REFERENCES format(format_id),
                        CONSTRAINT FK_4 FOREIGN KEY(edition_id) REFERENCES edition(edition_id));

CREATE TABLE sizes
 (size_id INT PRIMARY KEY AUTO_INCREMENT,
  size VARCHAR(30) NOT NULL);

#execute alter table for adding columns

ALTER TABLE `books`
    ADD (auteur_id INT);

ALTER TABLE `books`
    ADD (user_id INT);

ALTER TABLE `auteur`
    ADD (edition_id INT);

ALTER TABLE format_size
ADD size VARCHAR(30) NOT NULL;

ALTER TABLE format
DROP size_id;

ALTER TABLE format_maison_edition
ADD size_id INT NOT NULL;


ALTER TABLE format
CHANGE type_format  VARCHAR(20) NOT NULL;

#adding foreingn keys to the relative tables

ALTER TABLE `books`
    ADD CONSTRAINT FK5 FOREIGN KEY(auteur_id) REFERENCES auteur(auteur_id);

ALTER TABLE `books`
    ADD CONSTRAINT FK6 FOREIGN KEY(user_id) REFERENCES users(users_id);


ALTER TABLE `auteur`
    ADD CONSTRAINT FK7 FOREIGN KEY(edition_id) REFERENCES edition(edition_id);

ALTER TABLE `auteur`
DROP FOREIGN KEY FK7;

ALTER TABLE `format_maison_edition`
    ADD CONSTRAINT FK8 FOREIGN KEY(size_id) REFERENCES sizes(size_id);

ALTER TABLE `likes`
    ADD CONSTRAINT FK9 FOREIGN KEY(users_id) REFERENCES users(users_id),
    ADD CONSTRAINT FK10 FOREIGN KEY(book_id) REFERENCES books(book_id);

ALTER TABLE `likes`
DROP CONSTRAINT FK10;

ALTER TABLE `likes`
CHANGE user_id users_id INT;

ALTER TABLE `likes`
ADD liked BOOLEAN DEFAULT FALSE;

#adding datas for test functionalities and requests

INSERT INTO auteur(nom, prenom)
VALUES ("CHAVANNE", "Philippe");

INSERT INTO edition(edition)
VALUES ("DE NOYELLES");

INSERT INTO genre(genre)
VALUES ("MUSIQUE");

INSERT INTO format(type_format)
VALUES ("Bande dessinée");

INSERT INTO users (name, surname, e_mail, password, pseudo, date)
VALUES ("DELANOE","Romain","rdelanoe@compuserve.com","politique12","LA LOI",now());


INSERT INTO books (titre, nombre_de_pages, numero_IBSN, pitch, date_enregistrement, partage, auteur_id, user_id)
VALUES ("Quitter le monde", 694, "978-2-266-19996-4","Je ne marierais jamais et je n'aurais jamais d'enfants", now(),TRUE, 11, 2 ),
       ("Les désarrois de Ned Allen", 529, "2-266-10028-9","Un responsable d'espace publicitaire est remercié et, sa descente aux enferts commence", now(),FALSE, 11, 2),
       ("Pardonnez nos offences", 509, "2-266-13395-0", "Hiver 1284 n cette période de peurs irraisonnées, la découverte de restes de corps suppliciés près de la rivière", now(), TRUE, 12, 1),
       ("Géohistoire", 447, "979-10-375-1015-0", "L'histoire de l'humanité racontée avec la géographie", now(), TRUE, 9, 2),
       ("Itinéraire d'un naufragé", 473, "978-2-7578-9507-8", "Intégrale de ses chansons précédé d'un entretient exclusif", now(), TRUE, 10, 1);

INSERT INTO sizes(size)
VALUES("21 X 29,7"),
      ("10 X 10"),
      ("15,5 X 23,5"),
      ("11,5 X 15,5"),
      ("12,5 X 20");

INSERT INTO format_maison_edition (format_id, edition_id, size_id)
VALUES(3, 1, 3),
      (3, 10, 6),
      (2, 10, 5),
      (2, 6, 5),
      (3, 8, 8);

INSERT INTO book_genre (book_id, genre_id)
VALUES(1, 4),
      (2, 10),
      (3, 11),
      (4, 10),
      (5, 2),
      (6, 1),
      (7, 12),
      (8, 13),
      (9, 14);

DELETE FROM likes;

INSERT INTO likes (users_id, book_id, liked)
VALUES (2, 1, 1),
       (2, 4, 1),
       (1, 4, 1),
       (5, 6, 1),
       (5, 2, 1),
       (7, 9, 1),
       (1, 9, 1),
       (1, 7, 1),
       (6, 9, 1),
       (7, 1, 1);

#select all datas from tables request

SELECT * FROM users;

SELECT * FROM edition;

SELECT * FROM books;

SELECT * FROM genre;

SELECT * FROM auteur;

SELECT * FROM format;

SELECT * FROM sizes;

SELECT * FROM format_maison_edition;

SELECT * FROM likes;

#update datas request

UPDATE books
SET auteur_id = 16
WHERE auteur_id = 1;

UPDATE auteur
SET edition_id = 5
WHERE auteur_id = 16;


UPDATE format
SET type_format = "Broché"
WHERE format_id = 3;


#renaiming table request

RENAME TABLE format_size TO sizes;

#creating requests for product

#liste de tous les livres filtrés par auteur par ordre croissant
SELECT 
b.titre,
a.nom, 
a.prenom
FROM `books` AS b
INNER JOIN `auteur` AS a ON a.auteur_id = b.auteur_id
ORDER BY b.titre;

#liste de tous les livres filtrés par format dans l ordre croissant

SELECT 
b.titre,
a.nom, 
a.prenom,
f.type_format
FROM `books` AS b
INNER JOIN `auteur` AS a ON a.auteur_id = b.auteur_id
INNER JOIN `edition` AS ed ON a.edition_id = ed.edition_id
INNER JOIN `format_maison_edition` AS fme ON ed.edition_id = fme.edition_id
INNER JOIN `format` AS f ON fme.format_id = f.format_id
INNER JOIN `sizes` AS s ON fme.size_id = s.size_id
ORDER BY f.type_format;

#sortir les livres par auteur, format, edition et size, trier par edition croissant

SELECT 
b.titre,
a.nom, 
a.prenom,
ed.edition,
f.type_format,
s.size
FROM `books` AS b
INNER JOIN `auteur` AS a ON a.auteur_id = b.auteur_id
INNER JOIN `edition` AS ed ON a.edition_id = ed.edition_id
INNER JOIN `format_maison_edition` AS fme ON ed.edition_id = fme.edition_id
INNER JOIN `format` AS f ON fme.format_id = f.format_id
INNER JOIN `sizes` AS s ON fme.size_id = s.size_id
ORDER BY ed.edition;

#sortir les livres enregistrés par pseudo et trier par pseudo dans l'ordre croissant

SELECT
b.titre,
u.pseudo
FROM `books` AS b
INNER JOIN `users` AS u ON b.user_id = u.users_id
ORDER BY u.pseudo;

#sortir la liste des livres likes filtrer par auteur dans l'ordre croissant
#condenser les lignes likées avec le total de likes par titre

SELECT 
a.nom,
a.prenom,
b.titre,
u.name,
u.surname,
l.liked
FROM likes AS l
INNER JOIN `books` AS b ON l.book_id = b.book_id
INNER JOIN `users` AS u ON l.users_id = u.users_id
INNER JOIN `auteur` AS a ON b.auteur_id = a.auteur_id
ORDER BY a.nom;

#Condenser les lignes les plus likées avec somme des likes par ligne

SELECT 
a.nom,
a.prenom,
b.titre,
u.name,
u.surname,
l.liked,
COUNT(l.liked) AS total_likes
FROM likes AS l
INNER JOIN `books` AS b ON l.book_id = b.book_id
INNER JOIN `users` AS u ON l.users_id = u.users_id
INNER JOIN `auteur` AS a ON b.auteur_id = a.auteur_id
ORDER BY a.nom;







