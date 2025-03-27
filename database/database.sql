CREATE TABLE event (
      id              INT PRIMARY KEY AUTO_INCREMENT,
      name            VARCHAR(255) NOT NULL,
      location        VARCHAR(255) NOT NULL,
      opening_date    DATETIME NOT NULL,
      closing_date    DATETIME NOT NULL,
      preparation_date      DATETIME,
      dismantle_date DATETIME,
      estimated_audience BIGINT DEFAULT 0,
      total_audience  BIGINT DEFAULT 0,
      notes     TEXT,
      status ENUM('PLANNED', 'ONGOING', 'COMPLETED', 'CANCELED') NOT NULL DEFAULT 'PLANNED',
      created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at       DATETIME ON UPDATE CURRENT_TIMESTAMP,
      INDEX (opening_date),
      INDEX (closing_date)
  );

CREATE TABLE person (
    id                     INT PRIMARY KEY AUTO_INCREMENT,
    full_name              VARCHAR(255) NOT NULL,
    birth_date             DATE NOT NULL,
    cpf                    VARCHAR(14) UNIQUE NOT NULL,
    rg                     VARCHAR(20),
    gender                 ENUM('Male', 'Female', 'Other'),
    email                  VARCHAR(255) UNIQUE NOT NULL,
    notes            TEXT,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME ON UPDATE CURRENT_TIMESTAMP,
    photo_url              VARCHAR(255), -- Changed from BLOB to VARCHAR
    address                TEXT,
    INDEX (email),
    INDEX (cpf)
);

CREATE TABLE contact (
    id             INT PRIMARY KEY AUTO_INCREMENT,
    person_id      INT NOT NULL,
    contact_type   ENUM('Mobile', 'Home', 'Work', 'Other', 'Email') NOT NULL,
    contact_label  VARCHAR(255), -- Identificação personalizada (ex.: "Telefone Trabalho", "Email Principal")
    contact_value  VARCHAR(255) NOT NULL,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
);

CREATE TABLE user (
    id               INT PRIMARY KEY AUTO_INCREMENT,
    person_id        INT NOT NULL,
    username         VARCHAR(50) UNIQUE NOT NULL,
    password_hash    VARCHAR(255) NOT NULL,
    salt             VARCHAR(255) NOT NULL,
    email_verified   BOOLEAN DEFAULT FALSE,
    phone_verified   BOOLEAN DEFAULT FALSE,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status                 ENUM('Active', 'Inactive', 'Suspended', 'Terminated') NOT NULL,
    last_login				DATETIME, -- Added
    FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
);

CREATE TABLE job (
      id          INT PRIMARY KEY AUTO_INCREMENT,
      event_id   INT NOT NULL,
      person_id   INT NOT NULL,
      name        VARCHAR(100) NOT NULL,
      description   TEXT,
      salary     DECIMAL(10,2) CHECK (salary >= 0), -- Added constraint
	    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
	    updated_at       DATETIME ON UPDATE CURRENT_TIMESTAMP,
    	status                 ENUM('Assigned', 'Completed', 'Cancelled') NOT NULL,
      FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE,
      FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
  );

CREATE TABLE time_log (
      id          INT PRIMARY KEY AUTO_INCREMENT,
      person_id   INT NOT NULL,
      clock_in     DATETIME NOT NULL,
      clock_out       DATETIME CHECK (clock_out >= clock_in), -- Added constraint
      note  TEXT,
      FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
);

CREATE TABLE audit_log (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    user_id     INT NOT NULL,
    action        VARCHAR(100) NOT NULL,
    timestamp     DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_address    VARCHAR(45),
    user_agent    TEXT CHECK (LENGTH(user_agent) <= 255), -- Added constraint
		notes TEXT,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);
