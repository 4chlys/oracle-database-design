Milestone 2: Normalisatie/Integratie
--

Stap 1 Normalisatie
--

    S1
[S1_normalisatie.pdf](..%2FS1_normalisatie%2FS1_normalisatie.pdf)

![S1_normalisatie.png](..%2FS1_normalisatie%2FS1_normalisatie.png)
![S1_na_normalisatie.png](..%2F..%2FD1_ERD%2FS1%2FS1_na_normalisatie.png)


    S2
[S2_normalisatie_computergames.pdf](..%2FS2_normalisatie%2FS2_normalisatie_computergames.pdf)

![S2_normalisatie.png](..%2FS2_normalisatie%2FS2_normalisatie.png)
![S2_na_normalisatie.png](..%2F..%2FD1_ERD%2FS2%2FS2_na_normalisatie.png)



Stap 2: integratie
--
[SAMEN_integratie.pdf](SAMEN_integratie.pdf)

![SAMEN_integratie.png](SAMEN_integratie.png)
![Finaal_ERD.png](..%2F..%2FD1_ERD%2FSAMEN%2FFinaal_ERD.png)


Stap 3: Domeinen - constraints
--- 
    S1
- Ticket: price > 0
- Ticket: barcode tussen 8 en 14 tekens
- Visitor: birthdate - (positief) integer & < current_date
- Festival: end_date > start_date
- Festival: closing_hour > opening_hour
- Festival: capacity > 0
- Company: founding_year < current_year
- Permit: reception_date < expiration_date
- Permit: application_date < reception_date


    S2
- Genre_Origin_Year moet in de vergangenis liggen.
- Performance_Start_Time moet voor Performance_End_Time liggen.


Tijd
---
- S1: Festival: De festival start_date en end_date houdt de historiek bij.
- S1: Permit: De permit reception_date en expiration_date houdt de historiek bij.
- S2: Genre_Origin_Year moet voor Festival_Date zijn.


