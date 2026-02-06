Milestone 1: analyse 0NF
--

* **teamnaam:**  `INF202_4_TDR_romeo_jonas`
* **S1:** `Romeo Weyns`
* **S2:** `<insert naam student 2>`

Student S1 - Veel op veel - `Romeo Weyns`
--

1 Conceptueel model
--
S1:

- **A:** Bezoekers
- **B:** Festivals
- **C:** TicketPlatformen
- **D:** Ticket

![S1_conceptueel.png](../S1/S1_conceptueel-model.png)

ONF S1
--

- **Ticket_ID** (PK)
- Ticket_Price
- Ticket_Date
- Ticket_Purchase_Date
- Ticket_Description
- Ticket_Barcode
- Ticket_Type
- Ticket_Status
- Ticket_QR_Code
- TicketPlatform_ID
- TicketPlatform_Name
- TicketPlatform_URL
- Visitor_ID
- Visitor_Firstname
- Visitor_Lastname
- Visitor_Birthdate
- Visitor_Email
- Visitor_Street
- Visitor_Zipcode
- Visitor_City
- Visitor_Country
- Visitor_Gender
- Festival_ID
- Festival_Company
- Festival_Founding_Year
- Festival_Name
- Festival_StartDate
- Festival_EndDate
- Festival_Location
- Festival_Country
- Festival_Opening_Hour
- Festival_Closing_Hour
- Festival_Capacity

---

- **Festival_ID**(PK)
- Festival_Company
- Festival_Founding_Year
- Festival_Name
- Festival_StartDate
- Festival_EndDate
- Festival_Location
- Festival_Country
- Festival_Opening_Hour
- Festival_Closing_Hour
- Festival_Capacity
- Permit_ID
- Permit_Category
- Permit_Description
- Permit_Reception_Date
- Permit_Expiration_Date
- Permit_Application_Date

---



Student 2 - 2 niveau's diep - `<insert name Here>`
--

Conceptueel model
--

![S2_conceptueel.png](..%2FS2%2FS2_conceptueel.png)

- **W:** Artiesten
- **X:** Festivals
- **Y:** Stages
- **Z:** Optreden

3 ONF S2
--

- **festival_id(PK) : VARCHAR**
- Festival_Name : VARCHAR
- Festival_Description : VARCHAR
- Festival_Location : VARCHAR
- Festival_Price : NUMBER
- Festival_Visitor_Count : INTEGER
- Festival_Date : DATE
- Stage_Name : VARCHAR
- Stage_Style_Description : VARCHAR
- Stage_Standing_Capacity : INTEGER
- Stage_Toilet_Count : INTEGER
- Stage_Description : VARCHAR
- Stage_Roofed_Status  : BOOLEAN
- Artist_Name : VARCHAR
- Artist_Birthdate : DATE
- Artist_Price : NUMBER
- Artist_Land_Of_Birth : VARCHAR
- Performance_Start_Time : NUMBER
- Performance_End_Time : NUMBER
- Performance_Description : VARCHAR
- Genre_Name : VARCHAR
- Genre_Origin_Year : INTEGER
- Genre_Origin_Place : VARCHAR
- Genre_BPM : INTEGER