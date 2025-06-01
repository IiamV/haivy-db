## Overview

This repository holds all database-related files for the **haivy** platform, including schema definitions, functions, and triggers. Maintaining consistency in naming and structure is essential for team collaboration and future maintainability.

---

## Naming Conventions

All identifiers (tables, fields, files) must follow a standardized naming format to ensure clarity and consistency.

### General Naming Scheme

Use **snake\_case** and follow this format:

```
[adjective]_[verb]_[auxiliary noun]_<main noun>
```

* **\[adjective]**, **\[verb]**, and **\[auxiliary noun]** are optional components, but **main noun** is required.
* This applies to:

  * Function names
  * Field names
  * Any general-purpose identifiers

#### Examples:

* `recent_update_user_status`
* `calculate_order_total`
* `is_active_flag`

---

### Table Naming

* Use **snake\_case**
* Use **plural nouns** to represent collections

#### Examples:

* `users`
* `order_items`
* `payment_methods`

---

### Field Naming

* Follow the **general naming scheme** as described above.

#### Examples:

* `created_at_timestamp`
* `user_id`
* `is_deleted_flag`

---

### File Naming

* Use **snake\_case**
* Name files according to the **main function or purpose** they implement.

#### Examples:

* `insert_new_order.sql`
* `validate_user_login.sql`

---

## Folder Structure

Please follow this strict structure for organizing database files:

```
/
├── fns/              # All database functions
├── schemas/          # Table and view definitions
├── triggers/         # Trigger definitions
├──── <trigger_name>.sql  # Contains both trigger function and trigger statement
```

### fns/

* Place all standalone functions here.
* Each function should reside in a separate `.sql` file.

### schemas/

* Include all schema definitions (CREATE TABLE, CREATE VIEW, etc.)
* Separate files for each table/view.

### triggers/

* All triggers must reside here.
* **Each trigger** should be in its own `.sql` file, containing:

  * The trigger **function**
  * The **CREATE TRIGGER** statement

---


