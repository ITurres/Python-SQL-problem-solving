-- Keep a log of any SQL queries you execute as you solve the mystery.
-------------------------------------------------------------------------
--? 1) filter the crime scene description needed
SELECT
    crime_scene_reports.description
FROM
    crime_scene_reports
WHERE
    crime_scene_reports.year = 2021
    AND crime_scene_reports.month = 7
    AND crime_scene_reports.day = 28;

--? 1) DATA RETRIEVED:
--?  Theft of the CS50 duck took place at ****10:15am**** at the Humphrey Street bakery.
--?  Interviews were conducted today with three witnesses who were present at 
--?  the time – each of their interview transcripts mentions the bakery.
----------------------
--? 2) Given the data above, ill proceed to filter and check for the names and
--?    the statement of all the witnesses who where at the time and place.
SELECT
    interviews.name,
    interviews.transcript
FROM
    interviews
WHERE
    interviews.year = 2021
    AND interviews.month = 7
    AND interviews.day = 28;

--? 2) DATA RETRIEVED: 
--? | Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car
--? in the bakery parking lot and drive away. If you have security footage from the bakery parking lot,
--?  you might want to look for cars that left the parking lot in that time frame.
--?                                               
--? | Eugene | I don't know the thief's name, but it was someone I recognized. 
--? Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM 
--? on Leggett Street and saw the thief there withdrawing some money.
--?                                                                                   
--? | Raymond | As the thief was leaving the bakery, they called someone who talked to them
--?  for less than a minute. In the call, I heard the thief say that they were planning to take
--?  the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other
--?  end of the phone to purchase the flight ticket.
--
--? MAY BE IMPORTANT, or not... ===== >| Lily | Our neighboring courthouse has a very annoying rooster that crows loudly at 6am every day.
--?                                      My sons Robert and Patrick took the rooster to a city far, far away,
--?                                      so it may never bother us again. My sons have successfully arrived in Paris.  
--------------------------
--? 3) I will now continue by first AKA "A", check the bakery security logs between
--? 10:15 and 10:25
--? 3 - A) 
SELECT
    bakery_security_logs.activity,
    bakery_security_logs.license_plate
FROM
    bakery_security_logs
WHERE
    bakery_security_logs.year = 2021
    AND bakery_security_logs.month = 7
    AND bakery_security_logs.day = 28
    AND bakery_security_logs.hour = 10
    AND bakery_security_logs.minute BETWEEN 15
    AND 25;

--? 3 - A) DATA RETRIEVED: 
--! | activity | license_plate |
--! +----------+---------------+
--! | exit     | 5P2BI95       |
--! | exit     | 94KL13X       |
--! | exit     | 6P58WS2       |
--! | exit     | 4328GD8       |
--! | exit     | G412CB7       |
--! | exit     | L93JTIZ       |
--! | exit     | 322W7JE       |
--! | exit     | 0NTHK55       |
---------
--? 3 - B) Check people names with those license plates
SELECT
    people.id,
    people.name,
    people.phone_number,
    people.passport_number
FROM
    people
WHERE
    people.license_plate = "5P2BI95"
    OR people.license_plate = "94KL13X"
    OR people.license_plate = "6P58WS2"
    OR people.license_plate = "4328GD8"
    OR people.license_plate = "G412CB7"
    OR people.license_plate = "L93JTIZ"
    OR people.license_plate = "322W7JE"
    OR people.license_plate = "0NTHK55";

--? B) DATA RETRIEVED:
--! +--------+---------+----------------+-----------------+
--! |   id   |  name   |  phone_number  | passport_number |
--! +--------+---------+----------------+-----------------+
--! | 221103 | Vanessa | (725) 555-4692 | 2963008352  X   |
--! | 243696 | Barry   | (301) 555-4174 | 7526138472  X   |
--! | 396669 | Iman    | (829) 555-5269 | 7049073643  X   |
--! | 398010 | Sofia   | (130) 555-0289 | 1695452385      |
--! | 467400 | Luca    | (389) 555-5198 | 8496433585  X   |
--! | 514354 | Diana   | (770) 555-1861 | 3592750733      |
--! | 560886 | Kelsey  | (499) 555-9472 | 8294398571      |
--! | 686048 | Bruce   | (367) 555-5533 | 5773159633      |
--! +--------+---------+----------------+-----------------+
-------
--? 3 - C) Now it is time to check phonecalls, for a call less than a minute after the
--?        robbery and compare numbers with the one above.
SELECT
    phone_calls.caller,
    phone_calls.receiver,
    phone_calls.duration
FROM
    phone_calls
WHERE
    phone_calls.year = 2021
    AND phone_calls.month = 7
    AND phone_calls.day = 28
    AND phone_calls.duration < 60;

--? C) DATA RETRIEVED:
--! +----------------+----------------+----------+
--! |     caller     |    receiver    | duration |
--! +----------------+----------------+----------+
--! | (130) 555-0289 | (996) 555-8899 | 51       |
--! | (499) 555-9472 | (892) 555-8872 | 36       |
--! | (367) 555-5533 | (375) 555-8161 * | 45       | * -- likely accomplice./
--! | (499) 555-9472 | (717) 555-1342 | 50       |
--! | (286) 555-6063 | (676) 555-6554 | 43       |
--! | (770) 555-1861 | (725) 555-3243 * | 49       | * -- likely accomplice./
--! | (031) 555-6622 | (910) 555-3251 | 38       |
--! | (826) 555-1652 | (066) 555-9701 | 55       |
--! | (338) 555-6650 | (704) 555-2131 | 54       |
--! +----------------+----------------+----------+
--? C) SUSPECTS:
--! +--------+---------+----------------+-----------------+
--! | 398010 | Sofia   | (130) 555-0289 | 1695452385   X  |
--! | 514354 | Diana   | (770) 555-1861 | 3592750733      |
--! | 560886 | Kelsey  | (499) 555-9472 | 8294398571   X  |
--! | 686048 | Bruce   | (367) 555-5533 | 5773159633      |
--! +--------+---------+----------------+-----------------+
------
--? 3 - D) Ill proceed to check The BANK account of all the individuals above,
--?        in order to get their details and later comopare it on the ATM transactions.
SELECT
    people.name,
    bank_accounts.account_number,
    bank_accounts.creation_year
FROM
    bank_accounts
    JOIN people ON people.id = bank_accounts.person_id
WHERE
    people.id = 398010
    OR people.id = 514354
    OR people.id = 560886
    OR people.id = 686048;

--? D) DATA RETRIEVED:
--? SUSPECTS:
--! +-------+----------------+---------------+
--! | name  | account_number | creation_year |
--! +-------+----------------+---------------+
--! | Diana | 26013199       | 2012          |
--! | Bruce | 49610011       | 2010          |
--! +-------+----------------+---------------+
----
--? 3 - E) As or last step regarding Witnesses information, I will check and store the ATM on
--?        Leggett Street, and I will compare its data with the data above.
SELECT
    atm_transactions.account_number,
    atm_transactions.transaction_type,
    atm_transactions.amount
FROM
    atm_transactions
WHERE
    atm_transactions.year = 2021
    AND atm_transactions.month = 7
    AND atm_transactions.day = 28
    AND atm_transactions.atm_location = "Leggett Street"
    AND atm_transactions.account_number = 26013199
    OR atm_transactions.account_number = 49610011;

--? E) DATA RETRIEVED:
--! +----------------+------------------+--------+
--! | account_number | transaction_type | amount |
--! +----------------+------------------+--------+
--! | 49610011       | withdraw         | 10     |
--! | 49610011       | withdraw         | 50     |
--! | 26013199       | withdraw         | 35     |
--! +----------------+------------------+--------+
-----
--? 4) It is time to verify the Suspects's accomplice tel number, to get name
--?    and bank details.
SELECT
    people.name,
    people.passport_number,
    people.phone_number
FROM
    people
WHERE
    people.phone_number = "(375) 555-8161"
    OR people.passport_number = "(725) 555-3243";

--? 4) DATA RETRIVED:
--! +-------+-----------------+----------------+
--! | name  | passport_number |  phone_number  |
--! +-------+-----------------+----------------+
--! | Robin |                 | (375) 555-8161 | => NO PASSPORT NUMBER!. (maybe only the suspect traveled)
--! +-------+-----------------+----------------+
-----* WHO CALL THAT NUMBER? => BRUCE!
--? 5) So...it is time to move to the passengers table and check
--?    wether BRUCE of matches the passenger database.
--! +--------+---------+-----------------+
--! |   id   |  name   | passport_number |
--! +--------+---------+-----------------+
--! | 686048 | Bruce   | 5773159633      |
--! +--------+---------+-----------------+
SELECT
    people.name AS passenger_name,
    passengers.flight_id,
    passengers.seat
FROM
    passengers
    JOIN people ON passengers.passport_number = people.passport_number
WHERE
    passengers.passport_number = 5773159633;

--? 5) DATA RETRIEVED:
--! +----------------+-----------+------+
--! | passenger_name | flight_id | seat |
--! +----------------+-----------+------+
--! | Bruce          | 36        | 4A   |
--! +----------------+-----------+------+
--? 5 - A) Given this data, I will move to the flights table, and check
--?        from which airport did Bruce leave.
SELECT
    people.name AS passenger_name,
    flights.origin_airport_id,
    flights.destination_airport_id
FROM
    people
    JOIN passengers ON people.passport_number = passengers.passport_number
    JOIN flights ON flights.id = passengers.flight_id
WHERE
    flights.year = 2021
    AND flights.month = 7
    AND flights.day = 29
    AND flights.id = 36
    AND people.name = "Bruce";

--? 5 - A) DATA RETRIEVED:
--! +----------------+-------------------+------------------------+
--! | passenger_name | origin_airport_id | destination_airport_id |
--! +----------------+-------------------+------------------------+
--! | Bruce          | 8                 | 4                      |
--! +----------------+-------------------+------------------------+
-----
--? 6) TIME TO CHECK WHERE THE SUSPECT FLEW TO!:
SELECT
    airports.city AS suspect_flew_to
FROM
    airports
WHERE
    airports.id = 4;

----
--? The Suspect is: BRUCE.
--? His accomplice is: Robin.
--? AND THE SUSPECT FLEW TO...
--* +-----------------+
--* | suspect_flew_to |
--* +-----------------+
--* | New York City   |
--* +-----------------+