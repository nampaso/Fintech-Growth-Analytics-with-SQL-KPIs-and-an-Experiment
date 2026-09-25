# PLP Data Analytics Assignment 7: PesaPap Growth Analytics (`plp-da-a7-pesapap-growth-analytics`)

## Project Summary
PesaPap is a Kenyan digital payments start-up. This project evaluates platform transaction performance, computes an executive KPI scorecard, runs advanced SQL analytical queries, segments users using RFM and cohort retention, and evaluates a randomized onboarding experiment (A/B test).

## Table Descriptions & Schema

### 1. `users` Table
* `user_id` (INTEGER, **Primary Key**): Unique identifier for each user.
* `signup_date` (TEXT): Date of user registration (`YYYY-MM-DD`).
* `county` (TEXT): Kenyan county of residence.
* `acquisition_channel` (TEXT): Channel through which user registered.

### 2. `transactions` Table
* `txn_id` (INTEGER, **Primary Key**): Unique identifier for each transaction.
* `user_id` (INTEGER, **Foreign Key** $\rightarrow$ `users.user_id`): User initiating transaction.
* `txn_date` (TEXT): Date transaction was executed.
* `product` (TEXT): Product type (`Airtime`, `Bill Pay`, `Send Money`, `Merchant Pay`).
* `amount` (REAL): Transaction monetary value in KES.

### 3. `experiment` Table
* `user_id` (INTEGER, **Primary Key / Foreign Key** $\rightarrow$ `users.user_id`): Enrolled user ID.
* `group` (TEXT): Experiment group (`A` = Control, `B` = Variant).
* `converted` (INTEGER): Conversion flag (`1` = converted, `0` = otherwise).

---

## Headline Recommendation
**Roll out Onboarding Variant B to 100% of users.** The simplified sign-up flow delivered a **+31.8% relative conversion lift** ($p < 0.01$), generating an estimated **+340 additional converted users per 10,000 signups**.

---

## How to Run

1. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
