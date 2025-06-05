CREATE TABLE
  public.appointment (
    appointment_id uuid NOT NULL DEFAULT gen_random_uuid (),
    staff_id uuid,
    ticket_id uuid,
    patient_id uuid,
    created_date timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    meeting_date timestamp with time zone,
    content text,
    visible boolean NOT NULL DEFAULT false,
    status USER - DEFINED DEFAULT 'pending'::appointment_status,
    duration smallint NOT NULL DEFAULT '30'::smallint,
    CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id),
    CONSTRAINT appointment_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES auth.users (id),
    CONSTRAINT appointment_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket (ticket_id),
    CONSTRAINT appointment_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES auth.users (id)
  );

CREATE TABLE
  public.customizedregimen (
    cus_regimen_id uuid NOT NULL DEFAULT gen_random_uuid (),
    name character varying,
    description text,
    create_time date,
    CONSTRAINT customizedregimen_pkey PRIMARY KEY (cus_regimen_id)
  );

CREATE TABLE
  public.customizedregimendetail (
    cus_regimen_detail_id uuid NOT NULL DEFAULT gen_random_uuid (),
    cus_regimen_id uuid,
    prescription_id uuid,
    start_date date,
    end_date date,
    total_dosage double precision,
    frequency integer,
    note text,
    CONSTRAINT customizedregimendetail_pkey PRIMARY KEY (cus_regimen_detail_id),
    CONSTRAINT customizedregimendetail_prescription_id_fkey FOREIGN KEY (prescription_id) REFERENCES public.prescriptions (prescription_id),
    CONSTRAINT customizedregimendetail_cus_regimen_id_fkey FOREIGN KEY (cus_regimen_id) REFERENCES public.customizedregimen (cus_regimen_id)
  );

CREATE TABLE
  public.intakehistory (
    intake_id uuid NOT NULL DEFAULT gen_random_uuid (),
    patient_uid uuid,
    prescription_id uuid,
    take_time timestamp with time zone,
    missed boolean,
    note text,
    remind_inc_appointment boolean,
    CONSTRAINT intakehistory_pkey PRIMARY KEY (intake_id),
    CONSTRAINT intakehistory_prescription_id_fkey FOREIGN KEY (prescription_id) REFERENCES public.prescriptions (prescription_id)
  );

CREATE TABLE
  public.medicines (
    medicine_id uuid NOT NULL DEFAULT gen_random_uuid (),
    name character varying,
    description text,
    is_available boolean,
    med_time USER - DEFINED,
    CONSTRAINT medicines_pkey PRIMARY KEY (medicine_id)
  );

CREATE TABLE
  public.prescription_details (
    prescription_detail_id uuid NOT NULL DEFAULT gen_random_uuid (),
    prescription_id uuid,
    medicine_id uuid,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    dosage double precision,
    interval integer,
    note text,
    CONSTRAINT prescription_details_pkey PRIMARY KEY (prescription_detail_id),
    CONSTRAINT prescriptiondetail_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES public.medicines (medicine_id),
    CONSTRAINT prescriptiondetail_prescription_id_fkey FOREIGN KEY (prescription_id) REFERENCES public.prescriptions (prescription_id)
  );

CREATE TABLE
  public.prescriptions (
    prescription_id uuid NOT NULL DEFAULT gen_random_uuid (),
    name character varying,
    note text,
    CONSTRAINT prescriptions_pkey PRIMARY KEY (prescription_id)
  );

CREATE TABLE
  public.random_name_pool (
    id integer NOT NULL DEFAULT nextval('random_name_pool_id_seq'::regclass),
    name text NOT NULL,
    CONSTRAINT random_name_pool_pkey PRIMARY KEY (id)
  );

CREATE TABLE
  public.regimen_details (
    regimen_detail_id uuid NOT NULL DEFAULT gen_random_uuid (),
    regimen_id uuid,
    medicine_id uuid,
    start_date date,
    end_date date,
    total_dosage double precision,
    frequency integer,
    note text,
    CONSTRAINT regimen_details_pkey PRIMARY KEY (regimen_detail_id),
    CONSTRAINT regimendetail_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES public.medicines (medicine_id),
    CONSTRAINT regimendetail_regimen_id_fkey FOREIGN KEY (regimen_id) REFERENCES public.regimens (regimen_id)
  );

CREATE TABLE
  public.regimens (
    regimen_id uuid NOT NULL DEFAULT gen_random_uuid (),
    name character varying,
    create_date date,
    description text,
    CONSTRAINT regimens_pkey PRIMARY KEY (regimen_id)
  );

CREATE TABLE
  public.specification_ownerships (
    staff_id uuid NOT NULL,
    specification_id uuid NOT NULL,
    CONSTRAINT specification_ownerships_pkey PRIMARY KEY (staff_id, specification_id),
    CONSTRAINT specification_ownerships_specification_id_fkey FOREIGN KEY (specification_id) REFERENCES public.specifications_types (specification_id),
    CONSTRAINT specification_ownerships_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staffs (user_id)
  );

CREATE TABLE
  public.specifications_types (
    specification_id uuid NOT NULL DEFAULT gen_random_uuid (),
    name text,
    description text,
    CONSTRAINT specifications_types_pkey PRIMARY KEY (specification_id)
  );

CREATE TABLE
  public.staffs (
    user_id uuid NOT NULL,
    join_date date NOT NULL DEFAULT (now())::date,
    is_active boolean NOT NULL DEFAULT true,
    leave_date date,
    CONSTRAINT staffs_pkey PRIMARY KEY (user_id),
    CONSTRAINT staffs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id)
  );

CREATE TABLE
  public.ticket (
    ticket_id uuid NOT NULL DEFAULT gen_random_uuid (),
    assigned_to uuid,
    date_created date DEFAULT now(),
    content text,
    title text,
    ticket_type USER - DEFINED NOT NULL DEFAULT 'other'::ticket_type,
    created_by uuid,
    status USER - DEFINED NOT NULL DEFAULT 'pending'::ticket_status,
    CONSTRAINT ticket_pkey PRIMARY KEY (ticket_id),
    CONSTRAINT ticket_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users (id),
    CONSTRAINT ticket_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.staffs (user_id)
  );

CREATE TABLE
  public.ticket_interaction_history (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
    ticket_id uuid NOT NULL,
    time timestamp with time zone NOT NULL DEFAULT now(),
    action USER - DEFINED NOT NULL DEFAULT 'other'::ticket_interaction_type,
    note text,
    by uuid DEFAULT auth.uid (),
    CONSTRAINT ticket_interaction_history_pkey PRIMARY KEY (id),
    CONSTRAINT ticket_interaction_history_by_fkey FOREIGN KEY (by) REFERENCES auth.users (id),
    CONSTRAINT ticket_interaction_history_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket (ticket_id)
  );

CREATE TABLE
  public.user_details (
    user_id uuid NOT NULL,
    full_name text NOT NULL DEFAULT get_random_name (),
    birth_date date,
    profile_image_url text,
    roles ARRAY NOT NULL,
    CONSTRAINT user_details_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id)
  );