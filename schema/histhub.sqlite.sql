CREATE TABLE peer (
       id INTEGER NOT NULL PRIMARY KEY,
       uid TEXT NOT NULL,
       access_time INTEGER NOT NULL
);
CREATE UNIQUE INDEX uid ON peer (uid);

CREATE TABLE hist_queue (
       id INTEGER NOT NULL PRIMARY KEY,
       peer INTEGER NOT NULL,
       data TEXT NOT NULL,
       timestamp INTEGER NOT NULL
);
