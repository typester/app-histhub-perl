CREATE TABLE peer (
       uid TEXT NOT NULL PRIMARY KEY,
       created INTEGER NOT NULL,
       cursor INTEGER
);

CREATE TABLE hist_queue (
       id INTEGER NOT NULL PRIMARY KEY,
       timestamp INTEGER NOT NULL,
       body TEXT NOT NULL
);
