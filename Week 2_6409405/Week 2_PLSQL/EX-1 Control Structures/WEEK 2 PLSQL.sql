---Create table Customer

CREATE TABLE CUSTOMERS (
    CUSTOMERID   NUMBER PRIMARY KEY,
    NAME         VARCHAR2(100),
    DOB          DATE,
    BALANCE      NUMBER,
    LASTMODIFIED DATE
);
---Create table Loans

CREATE TABLE LOANS (
    LOANID       NUMBER PRIMARY KEY,
    CUSTOMERID   NUMBER,
    LOANAMOUNT   NUMBER,
    INTERESTRATE NUMBER,
    STARTDATE    DATE,
    ENDDATE      DATE,
    FOREIGN KEY ( CUSTOMERID )
        REFERENCES CUSTOMERS ( CUSTOMERID )
);

---Insert into Customers val1

INSERT INTO CUSTOMERS (CUSTOMERID, NAME, DOB, BALANCE, LASTMODIFIED)
VALUES (1, 'John Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 1000, SYSDATE);

---Insert into Customers val2

INSERT INTO CUSTOMERS (CUSTOMERID, NAME, DOB, BALANCE, LASTMODIFIED)
VALUES (2, 'Jane Smith', TO_DATE('1990-07-20', 'YYYY-MM-DD'), 1500, SYSDATE);

---Insert into Loans val1

INSERT INTO LOANS (LOANID, CUSTOMERID, LOANAMOUNT, INTERESTRATE, STARTDATE, ENDDATE)
VALUES (1, 1, 5000, 5, SYSDATE, ADD_MONTHS(SYSDATE, 60));




---Exercise 1 : Control Structures – Loan Discount:

DECLARE
    CURSOR cur_customer IS
        SELECT customerid, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM dob) AS age
        FROM customers;
    v_id customers.customerid%TYPE;
    v_age NUMBER;
BEGIN
    OPEN cur_customer;
    LOOP
        FETCH cur_customer INTO v_id, v_age;
        EXIT WHEN cur_customer%NOTFOUND;

        IF v_age > 60 THEN
            UPDATE loans
            SET interestrate = interestrate - 1
            WHERE customerid = v_id;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_id || ' | Age: ' || v_age);
            DBMS_OUTPUT.PUT_LINE('Customer not eligible for interest discount');
        END IF;
    END LOOP;
    CLOSE cur_customer;
    COMMIT;
END;
/

---Exercise 2 : Mark Vip Customers 

ALTER TABLE customers ADD isvip VARCHAR2(10);

BEGIN
    FOR user_rec IN (
        SELECT customerid, balance FROM customers
    ) LOOP
        IF user_rec.balance > 10000 THEN
            UPDATE customers
            SET isvip = 'TRUE'
            WHERE customerid = user_rec.customerid;
        ELSE
            UPDATE customers
            SET isvip = 'FALSE'
            WHERE customerid = user_rec.customerid;
        END IF;
    END LOOP;
    COMMIT;
END;
/

---Exercise 3 : Loan Due To Be Remainded

SET SERVEROUTPUT ON;

DECLARE
    CURSOR cur_loans IS
        SELECT l.loanid, l.customerid, c.name, l.enddate
        FROM loans l
        JOIN customers c ON c.customerid = l.customerid
        WHERE l.enddate BETWEEN SYSDATE AND SYSDATE + 30;

    v_loanid  loans.loanid%TYPE;
    v_custid  loans.customerid%TYPE;
    v_name    customers.name%TYPE;
    v_due     loans.enddate%TYPE;
    found     BOOLEAN := FALSE;

BEGIN
    OPEN cur_loans;
    LOOP
        FETCH cur_loans INTO v_loanid, v_custid, v_name, v_due;
        EXIT WHEN cur_loans%NOTFOUND;

        found := TRUE;
        DBMS_OUTPUT.PUT_LINE(
            'Reminder: Loan ' || v_loanid ||
            ' for ' || v_name || 
            ' (ID: ' || v_custid || 
            ') is due on ' || TO_CHAR(v_due, 'DD-Mon-YYYY')
        );
    END LOOP;
    CLOSE cur_loans;

    IF NOT found THEN
        DBMS_OUTPUT.PUT_LINE('No loans are nearing due date in next 30 days.');
    END IF;
END;
/















