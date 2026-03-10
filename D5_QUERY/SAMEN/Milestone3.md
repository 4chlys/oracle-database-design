
Milestone 3: Creatie Databank en Security
---

    Identity columns
---
- Mandatory
    - A: players: player_id
    - B/X: computergames: game_id
    - Y: youtubevideos: video_id
    - Z: youtubechannels: channel_id
- other:
    - C: gameservers: server_id
    - W: videocategories: category_id
    - gamestudios: studio_id
    - Locations: location_id

      Table Counts
---
     Tablecounts
![count_result.png](screenshots%2Fcount_result.png)

Queries
--- 
    S1 @query 1: GAMESTUDIO - COMPUTERGAMES (B/X) - PLAYERS (A) - GAMESESSIONS (D) 
![S1_query1_studios_games_players.png](screenshots%2FS1_query1_studios_games_players.png)

    S1 @query 2: PLAYER (A) - GAMESERVERS (C)
![S1_query3_gameservers.png](screenshots%2FS1_query3_gameservers.png)

    S2 @query 1: COMPUTERGAMES (B/X) - youtubechannels (Y) - youtubevideos (Z) - VIDEOCATEGORIES (W)
![S2_query1_game_videos.png](screenshots%2FS2_query1_game_videos.png)

    S2 @query 2: PLAYER (A) - LOCATION - ZIPCODES
![S1_query2_player_locations.png](screenshots%2FS1_query2_player_locations.png)

Bewijs Domeinen - constraints M2
--- 

    S1
- Player: zipcodes - minimum 4 characters

![S1_bewijs_zipcodes.png](screenshots%2FS1_bewijs_zipcodes.png)

- Computergame: release_date < last_updated

![S1_bewijs_computergames_date.png](screenshots%2FS1_bewijs_computergames_date.png)

    S2
- Influencer_youtubevideo duration between 1 minute and 24 hours

![S2_bewijs_video_duration.png](screenshots%2FS2_bewijs_video_duration.png)

- Videos category name must start with a capital.

![S2_bewijs_videocategorie_name.png](screenshots%2FS2_bewijs_videocategorie_name.png)


Security
---
IntelliJ Tree View

![tables_views.png](screenshots%2Ftables_views.png)

    S1: 

- User Sys privs S1
```
SELECT *
FROM USER_SYS_PRIVS
WHERE USERNAME = (SELECT USER FROM dual);
```

![S1_user_sys_privs.png](..%2FS1%2FS1_user_sys_privs.png)
- User tab privs S1
```
  SELECT *
  FROM USER_TAB_PRIVS
  WHERE GRANTEE = (SELECT USER FROM dual);
```
![S1_user_tab_privs.png](..%2FS1%2FS1_user_tab_privs.png)
- User col privs S1
```
SELECT *
FROM USER_COL_PRIVS;
```
![S1_user_col_privs.png](..%2FS1%2FS1_user_col_privs.png)
- view S1 (synonym) 
![S1_view_topscores.png](..%2FS1%2FS1_view_topscores.png)


    S2:
- User tab privs
```
  SELECT *
  FROM USER_TAB_PRIVS
  WHERE GRANTEE = (SELECT USER FROM dual);
```
![S2_user_tab_privs.png](..%2FS2%2FS2_user_tab_privs.png)
- User Role privs S2
```
SELECT *
FROM USER_ROLE_PRIVS;
```
![S2_user_role_privs.png](..%2FS2%2FS2_user_role_privs.png)
- Role Tab privs S2
```
  SELECT *
  FROM role_tab_privs
  WHERE role = 'ROLE_INFLUENCERS'
  ORDER BY TABLE_name;
  ```
![S2_Role_tab_privs.png](..%2FS2%2FS2_Role_tab_privs.png)

- view v_gams_chans
![s2_view_v_game_chans.png](..%2FS2%2Fs2_view_v_game_chans.png)

- INSERT VIEW - key preserved table
![S2_key_preserved_table.png](..%2FS2%2FS2_key_preserved_table.png)