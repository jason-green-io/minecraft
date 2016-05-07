CREATE TABLE players (name, UUID);
CREATE TABLE status (name PRIMARY KEY, status, twitter, youtube, twitch, reddit);
CREATE TABLE activity (datetime, name);
CREATE TABLE joins(date, name, UUID, IP);
CREATE TABLE slackusers (ID primary key, name);
CREATE TABLE lag (ts DEFAULT CURRENT_TIMESTAMP, tps);
CREATE TABLE achievements (ts, name, achievement);
CREATE TABLE loglag (ts, ticks);
CREATE TABLE location (datetime DEFAULT CURRENT_TIMESTAMP, UUID, dim, x, y, z);
CREATE TABLE process (ts DEFAULT CURRENT_TIMESTAMP, process, id, end);
CREATE TABLE stats (datetime DEFAULT CURRENT_TIMESTAMP, UUID, stats);
CREATE TABLE slackemails (ID primary key, email);
CREATE TABLE emailtoUUID (email primary key, UUID);
CREATE TABLE builds (coords primary key, name, text, ts default CURRENT_TIMESTAMP);
CREATE TABLE whitelist (name, UUID, ts default CURRENT_TIMESTAMP, UNIQUE(UUID));
CREATE TABLE chests (coords, chest, ts default CURRENT_TIMESTAMP);
CREATE TABLE polylines (dim, color, id, coords);
CREATE TABLE flyway (dim, coords, text1, text2, code, destination);
CREATE TABLE maildrop (coords primary key, name, slots, hidden);
CREATE VIEW playerUUID as select name, UUID from (select * from joins order by date asc) group by UUID;
CREATE VIEW groups as select name, UUID, datetime as "ts [timestamp]", status, twitter, twitch, youtube, reddit from (select *, count(datetime) as count from activity WHERE (datetime > datetime('now', '-14 day') AND name != '') group by name order by datetime ) natural join playerUUID natural left join status order by count desc;
CREATE VIEW onlineplayers as select name from activity where datetime >= DATETIME("now", "-2 minutes") group by name;
CREATE VIEW shame as select * from (select * from (select * from joins order by date asc) group by UUID) natural join whitelist where date < datetime("now", "-14 days") group by name order by date asc;
CREATE VIEW playertimes as select strftime('%Y-%m-%d %H:00:00', datetime) AS start, strftime("%Y-%m-%d %H:00:00", DATETIME(datetime, "+1 hour")) as end, UUID, count(datetime) from activity natural join playerUUID where datetime > datetime("now", "-14 days") group by uuid, start;
CREATE VIEW achievementsfinal as select ts, UUID, achievement from achievements natural join playerUUID where ts > datetime("now", "-14 days");
CREATE VIEW lagfinal as select datetime(ts), ticks from loglag where ts > datetime("now", "-1 day");
CREATE VIEW quickie as select name, count(datetime) from activity where datetime > datetime("now", "-7 days") group by name order by count(datetime) desc;
CREATE VIEW playernum as select datetime(ts,"unixepoch"), count(name) from (select distinct (strftime("%s", datetime) - (strftime("%s", datetime)%(15*60))) as ts, name from activity where datetime > datetime("now", "-1 day")) group by ts;
