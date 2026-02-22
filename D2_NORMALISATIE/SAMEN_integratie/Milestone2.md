Milestone 2: Normalisatie/Integratie
--

Stap 1 Normalisatie
--

    S1
[S1_normalisatie_computergames.pdf](..%2FS1_normalisatie%2FS1_normalisatie_computergames.pdf)

![S1_normalisatie.png](..%2FS1_normalisatie%2FS1_normalisatie.png)
![S1_na_normalisatie.png](..%2F..%2FD1_ERD%2FS1%2FS1_na_normalisatie.png)


    S2
[S2_normalisatie_computergames.pdf](..%2FS2_normalisatie%2FS2_normalisatie_computergames.pdf)

![S2_normalisatie.png](..%2FS2_normalisatie%2FS2_normalisatie.png)
![S2_na_normalisatie.png](..%2F..%2FD1_ERD%2FS2%2FS2_na_normalisatie.png)



Stap 2: integratie
--
[S1S2_computergames_Integration.pdf](S1S2_computergames_Integration.pdf)

![SAMEN_integratie.png](SAMEN_integratie.png)
![Finaal_ERD.png](..%2F..%2FD1_ERD%2FSAMEN%2FFinaal_ERD.png)


Stap 3: Domeinen - constraints
--- 
    S1
- Player: zipcodes - minimum 4 characters
- Computergame: release_date < last_updated


    S2
- Genre_Origin_Year moet in de vergangenis liggen.
- Performance_Start_Time moet voor Performance_End_Time liggen.


Tijd
---
- S1: Game_session: De gamesession start_date en end_date houdt de historiek bij.
- S2: Genre_Origin_Year moet voor Festival_Date zijn.


