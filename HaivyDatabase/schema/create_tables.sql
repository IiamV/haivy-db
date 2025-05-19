-- account ascosiated
create table AccountDetails(-- contains basic information of an account
  account_uid serial primary key,
  first_name varchar(50), -- can be null and dummy name is auto-generated
  last_name varchar(50), -- can be null and dummy name is auto-generated
  dob date, -- can be null
  profile_picrure text, -- can be null
  phone varchar(13) not null
);
--patient accociated
create table Patient(
  patient_uid serial primary key, 
  account_uid integer references AccountDetails(account_uid),
  anonymous_status boolean default true, -- when a patient has an account, can be use to set visibility of patient information
);
create table Staff(
  staff_id serial primary key,
  account_uid integer references AccountDetails(account_uid),
  role varchar(20),
  join_date date,
  status boolean  
);
create table Ticket(
  ticket_id serial primary key,
  assigned_to integer references Staff(staff_id),
  date_created date,
  content text,
  status boolean
);
create table Appointment(
  appointment_id serial primary key,
  staff_id integer references Staff(staff_id), 
  ticket_id integer references Ticket(ticket_id),
  patient_id integer references Patient(patient_id),
  created_date date,
  meeting_date date,
  content text,
  visibility boolean,
  status boolean
);
--Doctor accociated
create table Specification(
  specification_id serial primary key,
  name varchar(50);
  achieved_date date,
  level integer
);
-- create type week_day as enum ('Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
-- create type session_day as enum ('Morning', 'Afternoon', 'Evening', 'Midnight');

create table DoctorSpecification(
  staff_id integer references Staff(staff_id),
  specification_id integer references Specification(specification_id),
  primary key (staff_id, specification_id),
);
create table DaySession(
  day_session varchar(20) primary key,
  start_time time,
  end_time time,
  location varchar(50),
  status boolean -- true for Available and false for Busy
);
create table WeekDay(
  day_of_week varchar(20),
  day_session varchar(20),
  primary key(day_of_week, day_session),
  foreign key(day_session) references DaySession(day_session)
);
create table DoctorSchedule(
  staff_id integer references Staff(staff_id),
  day_of_week varchar(20),
  day_session varchar(20),
  primary key (staff_id, day_of_week, day_session),
  foreign key (day_of_week, day_session) references WeekDay(day_of_week, day_session)
);
-- --regimen ascociated
--version 1
create table Medicine(
  medicine_id serial primary key,
  name varchar(50),
  description text,
  is_available boolean
);
create table Prescription(
  prescription_id serial primary key,
  name varchar(50),
  note text
);
create table PrescriptionDetail(
  prescription_detail_id serial primary key,
  prescription_id integer references Prescription(prescription_id),
  medicine_id integer references Medicine(medicine_id),
  start_time timestamp,
  end_time timestamp,
  dosage float,
  interval integer,
  note text
);
create table CustomizedRegimen(
  cus_regimen_id serial primary key,
  name varchar(50),
  description text,
  create_time date
);
create table CustomizedRegimenDetail(
  cus_regimen_detail_id serial primary key,
  cus_regimen_id integer references Regimen(cus_regimen_id),
  prescription_id integer references Prescription(prescription_id),
  start_date date,
  end_date date,
  total_dosage float,
  frequency integer,
  note text
);
create table IntakeHistory(
  intake_id serial primary key,
  prescription_id integer references Prescription(prescription_id),
  dosage_time timestamp not null,
  actual_time timestamp,
  note text
);
create table Regimen(
  regimen_id serial primary key,
  name varchar(50),
  create_date date,
  description text
);
create table RegimenDetail(
  regimen_detail_id serial primary key,
  regimen_id integer references Regimen(regimen_id),
  medicine_id integer references Medicine(medicine_id),
  start_date date,
  end_date date,
  total_dosage float,
  frequency integer,
  note text
);
create table IntakeHistory(
  intake_id serial primary key,
  patient_id integer references Patient(patient_id),
  prescription_id integer references Prescription(prescription_id),
  take_time timestamp,
  missed boolean,
  note text,
  remind_inc_appointment boolean
);
--version 2: failure
-- create table RegimenVersion(
--   regimen_version_id serial primary key,
--   version_number varchar(50),
--   create_date date,
--   status boolean
-- );
-- create table Regimen(
--   regimen_id serial primary key,
--   regimen_version_id integer references RegimenVersion(regimen_version_id),
--   name varchar(50),
--   description text,
--   create_date date,
--   status boolean
-- );
-- create table RegimenDetail(
--   regimen_detail_id serial primary key,
--   medicine_id integer references Medicine(medicine_id),

-- )