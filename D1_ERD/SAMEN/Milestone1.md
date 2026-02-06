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

- artist_name
- artist_birthdate
- artist_price
- artist_land_of_birth
- performance_festival
- performance_genre
- performance_start_time
- performance_end_time
- performance_description
- performance_date
- festival_name
- festival_location
- festival_description
- genre_name
- stage_name
- stage_style
- stage_standing_capacity
- stage_toilet_count
- stage_description
- stage_roofed_status
- genre_origin_year
- genre_origin_place
- genre_BPM