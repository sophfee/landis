sql.Query("CREATE TABLE IF NOT EXISTS `landis_user` ( `steamid` VARCHAR(20) NOT NULL, `rpname` TEXT, `xp` NUMBER, `usergroup` TEXT )")
sql.Query("CREATE TABLE IF NOT EXISTS `landis_warns` ( `steamid` VARCHAR(20) NOT NULL, `moderator` VARCHAR(20) NOT NULL, `reason` TEXT, `date` NUMBER  )")
sql.Query("CREATE TABLE IF NOT EXISTS `landis_bans` ( `steamid` VARCHAR(20) NOT NULL, `moderator` VARCHAR(20) NOT NULL, `reason` TEXT, `date` NUMBER, `end_date` NUMBER )")
