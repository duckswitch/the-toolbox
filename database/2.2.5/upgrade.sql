-- SEED Script. DB Creation.

CREATE SCHEMA IF NOT EXISTS `hours_count` DEFAULT CHARACTER SET utf8 ;
USE `hours_count` ;

CREATE TABLE IF NOT EXISTS `hours_count`.`client` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `hours_count`.`project` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `client` INT NOT NULL,
  `provisioned_hours` INT NULL,
  `started_at` DATETIME NOT NULL DEFAULT NOW(),
  `code` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_client1_idx` (`client` ASC),
  CONSTRAINT `fk_project_client1`
    FOREIGN KEY (`client`)
    REFERENCES `hours_count`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));


CREATE TABLE IF NOT EXISTS `hours_count`.`_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `min_hours_per_week` INT NOT NULL DEFAULT 40,
  `default_role` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk__user_role1_idx` (`default_role` ASC),
  CONSTRAINT `fk__user_role1`
    FOREIGN KEY (`default_role`)
    REFERENCES `hours_count`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `hours_count`.`hour` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `issue` TEXT NULL,
  `started_at` DATETIME NOT NULL,
  `minutes` INT NOT NULL,
  `comments` VARCHAR(255) NULL,
  `project` INT NOT NULL,
  `affected_to` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hour_project_idx` (`project` ASC),
  INDEX `fk_hour_user1_idx` (`affected_to` ASC),
  CONSTRAINT `fk_hour_project`
    FOREIGN KEY (`project`)
    REFERENCES `hours_count`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hour_user1`
    FOREIGN KEY (`affected_to`)
    REFERENCES `hours_count`.`_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`project_assignement` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `project` INT NOT NULL,
  `user` INT NOT NULL,
  `role` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_has_user_user1_idx` (`user` ASC),
  INDEX `fk_project_has_user_project1_idx` (`project` ASC),
  UNIQUE INDEX `project_user_UNIQUE` (`project` ASC, `user` ASC),
  INDEX `fk_project_assignement_role1_idx1` (`role` ASC),
  CONSTRAINT `fk_project_has_user_project1`
    FOREIGN KEY (`project`)
    REFERENCES `hours_count`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_has_user_user1`
    FOREIGN KEY (`user`)
    REFERENCES `hours_count`.`_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_assignement_role1`
    FOREIGN KEY (`role`)
    REFERENCES `hours_count`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`task_list` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `project` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `completed` TINYINT NOT NULL DEFAULT 0,
  `end_date` DATETIME NULL,
  INDEX `fk_project_has_user_project2_idx` (`project` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_project_has_user_project2`
    FOREIGN KEY (`project`)
    REFERENCES `hours_count`.`project` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`project_file` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `url` TEXT NOT NULL,
  `project` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_file_project1_idx` (`project` ASC),
  CONSTRAINT `fk_project_file_project1`
    FOREIGN KEY (`project`)
    REFERENCES `hours_count`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`task` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `description` MEDIUMTEXT NULL,
  `completed` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `task_list` INT NOT NULL,
  `author` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_task_task_list1_idx` (`task_list` ASC),
  INDEX `fk_task_user1_idx` (`author` ASC),
  CONSTRAINT `fk_task_task_list1`
    FOREIGN KEY (`task_list`)
    REFERENCES `hours_count`.`task_list` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_user1`
    FOREIGN KEY (`author`)
    REFERENCES `hours_count`.`_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`user_has_task` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user` INT NOT NULL,
  `task` INT NOT NULL,
  INDEX `fk_user_has_task_task1_idx` (`task` ASC),
  INDEX `fk_user_has_task_user1_idx` (`user` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_task_unique` (`user` ASC, `task` ASC),
  CONSTRAINT `fk_user_has_task_user1`
    FOREIGN KEY (`user`)
    REFERENCES `hours_count`.`_user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_task_task1`
    FOREIGN KEY (`task`)
    REFERENCES `hours_count`.`task` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `hours_count`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `description` MEDIUMTEXT NOT NULL,
  `task` INT NOT NULL,
  `author` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_comment_task1_idx` (`task` ASC),
  INDEX `fk_comment_user1_idx` (`author` ASC),
  CONSTRAINT `fk_comment_task1`
    FOREIGN KEY (`task`)
    REFERENCES `hours_count`.`task` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`author`)
    REFERENCES `hours_count`.`_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `hours_count`.`tag` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `color` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`id`));


CREATE TABLE IF NOT EXISTS `hours_count`.`task_has_tag` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `task` INT NOT NULL,
  `tag` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_task_has_tag_tag1_idx` (`tag` ASC),
  INDEX `fk_task_has_tag_task1_idx` (`task` ASC),
  UNIQUE INDEX `task_tag_UNIQUE` (`task` ASC, `tag` ASC),
  CONSTRAINT `fk_task_has_tag_task1`
    FOREIGN KEY (`task`)
    REFERENCES `hours_count`.`task` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_has_tag_tag1`
    FOREIGN KEY (`tag`)
    REFERENCES `hours_count`.`tag` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE OR REPLACE VIEW hour_extended 
AS
(
    SELECT 
    sub_1.id, 
    sub_1.issue, 
    sub_1.started_at, 
    sub_1.minutes, 
    sub_1.comments,
    (sub_1.`project.provisioned_hours` - sub_2.`consumed`) AS 'project.hours_left',
    sub_1.`affected_to.id` , 
    sub_1.`affected_to.email` , 
    sub_1.`affected_to.name`,
    sub_1.`project.id` , 
    sub_1.`project.name`, 
    sub_1.`project.client.id`, 
    sub_1.`project.client.name`
    FROM
    (
        SELECT 
        H.id, 
        H.issue, 
        H.started_at, 
        H.minutes, 
        H.comments, 
        P.provisioned_hours AS 'project.provisioned_hours', 
        U.id AS 'affected_to.id' , 
        U.email AS 'affected_to.email',
        U.name AS 'affected_to.name' ,
        P.id AS 'project.id' , 
        P.name AS 'project.name',
        C.id AS 'project.client.id' , 
        C.name AS 'project.client.name'
        FROM hour H 
        JOIN project P 
        ON H.project = P.id
        JOIN _user U 
        ON H.affected_to = U.id
        JOIN client C
        ON P.client = C.id
    ) AS sub_1
    LEFT JOIN
    (
        SELECT 
        H.project AS 'project.id',
        SUM(H.minutes / 60) AS 'consumed'
        FROM hour H
        GROUP BY H.project
    ) AS sub_2
    ON sub_1. `project.id` = sub_2.`project.id`
);

CREATE  OR REPLACE VIEW project_load
AS
(
    SELECT
    UNIX_TIMESTAMP(PL.day) AS 'timestamp',
    DAY(PL.day) AS 'dayNumber',
    MONTH(PL.day) AS 'monthNumber',
    YEAR(PL.day) AS 'yearNumber',
    P.id AS 'project_id',
    P.name AS 'project_name',
    U.id AS 'affected_to_id',
    U.name AS 'affected_to_name',
    PL.hour AS 'hours'
    FROM
    (
        SELECT
        DATE(H.started_at) AS 'day',
        H.project,
        H.affected_to,
        ROUND(SUM(H.minutes) / 60, 1) as 'hour'
        FROM hour H
        GROUP BY DATE(H.started_at), H.affected_to, H.project
        ORDER BY H.project, H.affected_to, day
    )
    PL
    JOIN project P
    ON PL.project = P.id
    JOIN _user U
    ON PL.affected_to = U.id
)
;

CREATE  OR REPLACE VIEW cra AS
(
    SELECT
    U.email,
    C.name AS 'client',
    P.name AS 'project',
    H.started_at,
    MONTH(H.started_at) as 'month',
    H.minutes,
    H.minutes / 60 AS 'hour',
    H.issue
    FROM
    hour H
    JOIN project P
    ON H.project = P.id
    JOIN client C
    ON P.client = C.id
    JOIN _user U
    ON H.affected_to = U.id
);

CREATE  OR REPLACE VIEW clients_affected_to_users AS
(
    SELECT
    U.id AS `user_id`,
    C.id,
    C.name
    FROM project_assignement PA
    JOIN project P
    ON PA.project = P.id
    JOIN client C
    ON P.client = C.id
    JOIN _user U
    ON PA.user = U.id
    GROUP BY C.id, C.name, U.id
)
;

CREATE  OR REPLACE VIEW project_consumption
AS (
    SELECT
    P.id AS 'project_id',
    P.name AS 'project_name',
    P.provisioned_hours AS 'provisioned',
    ROUND(SUM(H.minutes) /60) AS 'consumed'
    FROM hour H
    JOIN project P
    ON H.project = P.id
    GROUP BY P.id, P.name, P.provisioned_hours
);

CREATE  OR REPLACE VIEW project_consumption_per_user AS 
(
    SELECT
    P.id AS 'project_id',
    P.name AS 'project_name',
    U.id AS 'user_id',
    U.name AS 'user_name',
    consumed,
    ROUND(P.provisioned_hours / 8) AS 'provisioned'
    FROM
    (
        SELECT
        ROUND((SUM(H.minutes) / 60.0) / 8.0 ) AS 'consumed',
        H.affected_to,
        H.project
        FROM hour H
        GROUP BY H.affected_to, H.project
    ) H
    JOIN project P
    ON H.project = P.id
    JOIN _user U
    ON H.affected_to = U.id
);

CREATE OR REPLACE VIEW task_sum_up
AS (
    SELECT
    T.id,
    T.title,
    IF(T.description != '{"ops":[{"insert":"\\n"}]}' AND T.description != '', 1, 0) AS 'has_description',
    T.completed,
    IF(M.affected_users IS NULL, 0, M.affected_users) AS 'affected_users',
    IF(C.comments IS NULL, 0, C.comments) AS 'comments',
    T.task_list,
    IF(TGS.tag_names IS NULL, "", TGS.tag_names) AS 'tag_names',
    IF(TGS.tag_colors IS NULL, "", TGS.tag_colors) AS 'tag_colors'
    FROM task T
    LEFT JOIN (
        SELECT
        COUNT(UHT.user) AS 'affected_users',
        task
        FROM user_has_task UHT
        GROUP BY task
    ) AS M
    ON T.id = M.task
    LEFT JOIN (
        SELECT
        COUNT(*) AS 'comments',
        comment.task AS 'task'
        FROM
        comment
        GROUP BY task
    ) AS C
    ON T.id = C.task
    LEFT JOIN (
        SELECT
        THT.task,
        GROUP_CONCAT(T.name) AS 'tag_names',
        GROUP_CONCAT(T.color) AS 'tag_colors'
        FROM task_has_tag THT
        LEFT JOIN tag T
        ON THT.tag = T.id
        GROUP BY THT.task
    ) AS TGS
    ON T.id = TGS.task
);

CREATE OR REPLACE VIEW tasks_left AS
(
    SELECT
    T.id,
    T.title,
    P.id AS 'project_id',
    P.name AS 'project_name',
    UHT.user AS 'user_id',
    CONCAT("projects/", P.id, "/tasks/", T.id) AS 'link'
    FROM task T
    JOIN user_has_task UHT
    ON T.id = UHT.task
    JOIN task_list TL
    ON T.task_list = TL.id
    JOIN project P
    ON TL.project = P.id
    WHERE T.completed = 0
    ORDER BY T.created_at
)
;

CREATE OR REPLACE VIEW task_notification AS 
(
    SELECT
    T.id AS 'TASK_ID',
    T.title AS 'TASK_TITLE',
    P.name AS 'PROJECT_NAME',
    P.id AS 'PROJECT_ID',
    CONCAT("projects/", P.id, "/tasks/", T.id) AS 'TASK_LINK'
    FROM task T
    JOIN task_list TL
    ON T.task_list = TL.id
    JOIN project P
    ON TL.project = P.id
);

CREATE OR REPLACE VIEW comment_notification AS
(
    SELECT
	T.id AS 'TASK_ID',
	T.title AS 'TASK_TITLE',
	P.name AS 'PROJECT_NAME',
	P.id AS 'PROJECT_ID',
	IF(U.id IS NULL, U3.id , U.id) AS 'USER_ID',
	IF(U.id IS NULL, U3.email , U.email) AS 'USER_EMAIL',
	U3.email AS 'TASK_AUTHOR_EMAIL',
	CONCAT("projects/", P.id, "/tasks/", T.id) AS 'TASK_LINK'
	FROM task T
	JOIN task_list TL
	ON T.task_list = TL.id
	JOIN project P
	ON TL.project = P.id
	LEFT JOIN user_has_task UHT
	ON T.id = UHT.task
	LEFT JOIN _user U
	ON UHT.user = U.id
	LEFT JOIN _user U3
	ON T.author = U3.id



);

CREATE OR REPLACE VIEW task_status_change_notification AS
(
    SELECT
    T.id AS 'TASK_ID',
    T.title AS 'TASK_TITLE',
    P.name AS 'PROJECT_NAME',
    P.id AS 'PROJECT_ID',
    U.email AS 'USER_EMAIL',
    U2.email AS 'AUTHOR_EMAIL',
    CONCAT("projects/", P.id, "/tasks/", T.id) AS 'TASK_LINK'
    FROM task T
    JOIN task_list TL
    ON T.task_list = TL.id
    JOIN project P
    ON TL.project = P.id
    LEFT JOIN user_has_task UHT
    ON T.id = UHT.task
    LEFT JOIN _user U
    ON UHT.user = U.id
    JOIN _user U2
    ON T.author = U2.id
);
