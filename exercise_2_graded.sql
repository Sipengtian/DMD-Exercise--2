/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */
 \c smart_old_age_home;


 

 -- Q!: List all patients name and ages 
SELECT name, age FROM patients;

 -- Q2: List all doctors specializing in 'Cardiology'

SELECT name FROM doctors WHERE specialization = 'Cardiology';
 
 -- Q3: Find all patients that are older than 80

SELECT * FROM patients WHERE age > 80;


-- Q4: List all the patients ordered by their age (youngest first)

SELECT * FROM patients ORDER BY age ASC;


-- Q5: Count the number of doctors in each specialization

SELECT specialization, COUNT(*) as doctor_count FROM doctors GROUP BY specialization;

-- Q6: List patients and their doctors' names

SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: Show treatments along with patient names and doctor names

SELECT t.treatment_id, p.name AS patient_name, d.name AS doctor_name, t.treatment_type, t.treatment_time
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q8: Count how many patients each doctor supervises

SELECT d.name AS doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q9: List the average age of patients and display it as average_age

SELECT AVG(age) AS average_age FROM patients;

-- Q10: Find the most common treatment type, and display only that

SELECT treatment_type, COUNT(*) as count
FROM treatments
GROUP BY treatment_type
ORDER BY count DESC
LIMIT 1;

-- Q11: List patients who are older than the average age of all patients

SELECT * FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: List all the doctors who have more than 5 patients

SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 5;


-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well. 

SELECT t.treatment_id, p.name AS patient_name, t.treatment_type, t.treatment_time
FROM treatments t
JOIN nurses n ON t.nurse_id = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'Morning';


-- Q14: Find the latest treatment for each patient

SELECT t.*
FROM treatments t
JOIN (
    SELECT patient_id, MAX(treatment_time) AS latest_treatment_time
    FROM treatments
    GROUP BY patient_id
) latest ON t.patient_id = latest.patient_id AND t.treatment_time = latest.latest_treatment_time;

-- Q15: List all the doctors and average age of their patients

SELECT d.name AS doctor_name, AVG(p.age) AS average_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q16: List the names of the doctors who supervise more than 3 patients

SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 3;

-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)

SELECT * FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);


-- Q18: List all the medicines whose stock (quantity) is less than the average stock

SELECT medication_name 
FROM medication_stock 
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);


-- Q19: For each doctor, rank their patients by age

SELECT p.name AS patient_name, d.name AS doctor_name, p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age) AS age_rank
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q20: For each specialization, find the doctor with the oldest patient


SELECT d.specialization, d.name AS doctor_name, MAX(p.age) AS oldest_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.specialization, d.name;



