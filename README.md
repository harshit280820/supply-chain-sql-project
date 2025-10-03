
# 📦 Supply Chain Management - SQL Case Study

## 📖 Project Overview
This project is based on a **Supply Chain Management Case Study**.  
The goal is to analyze supplier performance, customer distribution, product demand, and order trends using SQL.

The analysis helps businesses:
- Identify high-demand products 📈
- Evaluate supplier contributions 🏭
- Understand customer demographics 👥
- Optimize pricing and order strategies 💰

---

## 🗄️ Database Schema
The database consists of the following tables:

- **Supplier**: Supplier details (CompanyName, Contact, Country, etc.)
- **Product**: Product details (Name, Price, Supplier, etc.)
- **Customer**: Customer information (Name, City, Country, Phone, etc.)
- **OrderItem**: Individual items in each order (Quantity, Price, Product, etc.)
- **Orders**: Order-level details (OrderDate, Customer, TotalAmount, etc.)

![Schema](schema.png)

---

## ⚙️ Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/supply-chain-sql-project.git
   cd supply-chain-sql-project
   ```

2. Open **MySQL Workbench** or any SQL client.

3. Run the script `supply_chain_project.sql` to create schema & insert data.

4. Open `case_study_report.pdf` to see queries with results.

---

## 📑 Files in this Repository

- `supply_chain_project.sql` → SQL script to create schema + sample data
- `case_study_report.pdf` → Report with queries + outputs
- `README.md` → This file

---

## 📝 Example Queries

- List suppliers by country
- Find top 3 products by price
- Get customers from Spain
- Calculate total sales by supplier

---

## 🚀 Future Enhancements
- Add advanced queries (joins, window functions, subqueries)
- Create visual dashboards using PowerBI/Tableau
- Automate data loading from CSV files

---

👨‍💻 **Author**: Harshit  
📌 *Made as part of SQL learning & practice*
