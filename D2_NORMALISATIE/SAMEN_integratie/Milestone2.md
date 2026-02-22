Milestone 2: Normalisation/Integration
--

Step 1 Normalisation
--

    S1
[S1_normalisatie.pdf](..%2FS1_normalisatie%2FS1_normalisatie.pdf)

![S1_normalisatie.png](..%2FS1_normalisatie%2FS1_normalisatie.png)
![S1_na_normalisatie.png](..%2F..%2FD1_ERD%2FS1%2FS1_na_normalisatie.png)


    S2
[S2_normalisatie.pdf](..%2FS2_normalisatie%2FS2_normalisatie.pdf)

![S2_normalisatie.png](..%2FS2_normalisatie%2FS2_normalisatie.png)
![S2_na_normalisatie.png](..%2F..%2FD1_ERD%2FS2%2FS2_na_normalisatie.png)



Step 2: Integration
--
[SAMEN_integratie.pdf](SAMEN_integratie.pdf)

![SAMEN_integratie.png](SAMEN_integratie.png)
![Finaal_ERD.png](..%2F..%2FD1_ERD%2FSAMEN%2FFinaal_ERD.png)


Step 3: Domain - constraints
--- 
    S1
- Ticket: price > 0
- Ticket: barcode between 8 and 14 characters
- Visitor: birthdate - (positive) integer & < current_date
- Festival: end_date > start_date
- Festival: closing_hour > opening_hour
- Festival: capacity > 0
- Company: founding_year < current_year
- Permit: reception_date < expiration_date
- Permit: application_date < reception_date

TODO:

    S2
- Genre_Origin_Year moet in de vergangenis liggen.
- Performance_Start_Time moet voor Performance_End_Time liggen.


Time
---
- S1: Festival: The festival start_date and end_date keep track of the history.
- S1: Permit: The permit reception_date and expiration_date keep track of the history.
TODO:
- S2: Genre_Origin_Year moet voor Festival_Date zijn.


