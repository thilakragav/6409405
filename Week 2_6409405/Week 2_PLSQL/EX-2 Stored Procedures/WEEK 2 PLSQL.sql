---Create Table Accounts:

CREATE TABLE ACCOUNTS (
    ACCOUNTID    NUMBER PRIMARY KEY,
    CUSTOMERID   NUMBER,
    ACCOUNTTYPE  VARCHAR2(20),
    BALANCE      NUMBER,
    LASTMODIFIED DATE,
    FOREIGN KEY ( CUSTOMERID )
        REFERENCES CUSTOMERS ( CUSTOMERID )
);
---Create Table Transactions:

CREATE TABLE TRANSACTIONS (
    TRANSACTIONID   NUMBER PRIMARY KEY,
    ACCOUNTID       NUMBER,
    TRANSACTIONDATE DATE,
    AMOUNT          NUMBER,
    TRANSACTIONTYPE VARCHAR2(10),
    FOREIGN KEY ( ACCOUNTID )
        REFERENCES ACCOUNTS ( ACCOUNTID )
);


---Create Table Employees:


CREATE TABLE EMPLOYEES (
    EMPLOYEEID NUMBER PRIMARY KEY,
    NAME       VARCHAR2(100),
    POSITION   VARCHAR2(50),
    SALARY     NUMBER,
    DEPARTMENT VARCHAR2(50),
    HIREDATE   DATE
);

---Insert val1 into Accounts:

INSERT INTO ACCOUNTS (ACCOUNTID, CUSTOMERID, ACCOUNTTYPE, BALANCE, LASTMODIFIED)
VALUES (1, 1, 'Savings', 1000, SYSDATE);

---Insert val2 into Accounts:

INSERT INTO ACCOUNTS (ACCOUNTID, CUSTOMERID, ACCOUNTTYPE, BALANCE, LASTMODIFIED)
VALUES (2, 2, 'Checking', 1500, SYSDATE);

---Insert val1 into Transactions:

INSERT INTO TRANSACTIONS (TRANSACTIONID, ACCOUNTID, TRANSACTIONDATE, AMOUNT, TRANSACTIONTYPE)
VALUES (1, 1, SYSDATE, 200, 'Deposit');

---Insert val2 into Transactions:

INSERT INTO TRANSACTIONS (TRANSACTIONID, ACCOUNTID, TRANSACTIONDATE, AMOUNT, TRANSACTIONTYPE)
VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

---Insert val1 into Employees:

INSERT INTO EMPLOYEES (EMPLOYEEID, NAME, POSITION, SALARY, DEPARTMENT, HIREDATE)
VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15', 'YYYY-MM-DD'));

---Insert val2 into Employees:

INSERT INTO EMPLOYEES (EMPLOYEEID, NAME, POSITION, SALARY, DEPARTMENT, HIREDATE)
VALUES (2, 'Bob Brown', 'Developer', 60000, 'IT', TO_DATE('2017-03-20', 'YYYY-MM-DD'));

---Scenerio 1 - CREATE OR REPLACE PROCEDURE :

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
    UPDATE accounts
    SET balance = balance * 1.01,
        lastmodified = SYSDATE
    WHERE UPPER(accounttype) = 'SAVINGS';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('1% interest successfully added to all savings accounts.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Something went wrong: ' || SQLERRM);
END;
/

---Scenerio – 2:Update Employee Bonus

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_dept IN employees.department%TYPE,
    p_bonus_percent IN NUMBER
) IS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_bonus_percent / 100),
        hiredate = SYSDATE
    WHERE department = p_dept;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Bonus of ' || p_bonus_percent || '% successfully applied to employees in department "' || p_dept || '".');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error while applying bonus to department "' || p_dept || '": ' || SQLERRM);
END;
/

---Scenerio – 3:Transfer Funds:

CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from   IN accounts.accountid%TYPE,
    p_to     IN accounts.accountid%TYPE,
    p_amount IN NUMBER
) IS
    v_balance_from accounts.balance%TYPE;
BEGIN
    SELECT balance INTO v_balance_from
    FROM accounts
    WHERE accountid = p_from
    FOR UPDATE;

    IF v_balance_from < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transfer failed: Insufficient balance in account ' || p_from || '.');
    END IF;

    UPDATE accounts
    SET balance = balance - p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_from;

    UPDATE accounts
    SET balance = balance + p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_to;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Successfully transferred ₹' || p_amount || ' from Account ' || p_from || ' to Account ' || p_to || '.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transfer failed due to error: ' || SQLERRM);
END;
/














