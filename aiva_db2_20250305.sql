--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bpkp; Type: SCHEMA; Schema: -; Owner: bpkp_aiva
--

CREATE SCHEMA bpkp;


ALTER SCHEMA bpkp OWNER TO bpkp_aiva;

--
-- Name: hr; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hr;


ALTER SCHEMA hr OWNER TO postgres;

--
-- Name: ref; Type: SCHEMA; Schema: -; Owner: bpkp_aiva
--

CREATE SCHEMA ref;


ALTER SCHEMA ref OWNER TO bpkp_aiva;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: employee_activity; Type: TABLE; Schema: bpkp; Owner: bpkp_aiva
--

CREATE TABLE bpkp.employee_activity (
    id integer,
    tanggal_aktivitas text,
    unitkerja text,
    pegawai text,
    usia text,
    jabatan text,
    nama_aktivitas text,
    id_penugasan text,
    jenis_pkpt_pkau text,
    year_month text
);


ALTER TABLE bpkp.employee_activity OWNER TO bpkp_aiva;

--
-- Name: attendance; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.attendance (
    id integer NOT NULL,
    employee integer NOT NULL,
    date date NOT NULL,
    check_in time without time zone,
    check_out time without time zone,
    status integer DEFAULT 0 NOT NULL,
    work_hours interval GENERATED ALWAYS AS ((check_out - check_in)) STORED,
    remarks text,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    leave_type integer
);


ALTER TABLE hr.attendance OWNER TO postgres;

--
-- Name: COLUMN attendance.status; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.attendance.status IS '0 : absent
    1 : present
    2 : late
    3 : leave
    4 : remote
    5 : business trip';


--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.attendance_id_seq OWNED BY hr.attendance.id;


--
-- Name: dependents; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.dependents (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    relationship character varying(25) NOT NULL,
    employee integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone
);


ALTER TABLE hr.dependents OWNER TO postgres;

--
-- Name: dependents_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.dependents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.dependents_id_seq OWNER TO postgres;

--
-- Name: dependents_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.dependents_id_seq OWNED BY hr.dependents.id;


--
-- Name: employees; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.employees (
    id integer NOT NULL,
    id_number character varying(18),
    first_name character varying(50),
    last_name character varying(50) NOT NULL,
    citizen_number character varying(16),
    birth_place character varying(50),
    birth_date date,
    address character varying(200),
    email character varying(50) NOT NULL,
    phone_number character varying(20),
    tax_number character varying(20),
    hire_date date NOT NULL,
    resignation_date date,
    rank integer,
    job integer NOT NULL,
    unit integer,
    manager integer,
    salary integer DEFAULT 0 NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    sex integer
);


ALTER TABLE hr.employees OWNER TO postgres;

--
-- Name: COLUMN employees.sex; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.employees.sex IS '1 : Male
2 : Female';


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.employees_id_seq OWNED BY hr.employees.id;


--
-- Name: jobs; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.jobs (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    echelon integer,
    min_salary integer,
    max_salary integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    rank integer
);


ALTER TABLE hr.jobs OWNER TO postgres;

--
-- Name: jobs_job_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.jobs_job_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.jobs_job_seq OWNER TO postgres;

--
-- Name: jobs_job_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.jobs_job_seq OWNED BY hr.jobs.id;


--
-- Name: kpi; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.kpi (
    id integer NOT NULL,
    employee integer NOT NULL,
    category integer NOT NULL,
    target_value numeric(10,2) NOT NULL,
    achieved_value numeric(10,2) DEFAULT 0,
    unit character varying(50) NOT NULL,
    period_fr date NOT NULL,
    period_to date NOT NULL,
    status integer DEFAULT 4,
    performance numeric(5,2) GENERATED ALWAYS AS (
CASE
    WHEN (achieved_value >= target_value) THEN 100.00
    ELSE ((achieved_value / target_value) * (100)::numeric)
END) STORED,
    remarks text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone
);


ALTER TABLE hr.kpi OWNER TO postgres;

--
-- Name: COLUMN kpi.status; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.kpi.status IS '1 : Achieved
    2 : Not met
    3 : In progess
    4 : Pending';


--
-- Name: kpi_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.kpi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.kpi_id_seq OWNER TO postgres;

--
-- Name: kpi_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.kpi_id_seq OWNED BY hr.kpi.id;


--
-- Name: leave_entitlements; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.leave_entitlements (
    id integer NOT NULL,
    year character varying(4),
    employee integer,
    leave_type integer,
    entitlement integer,
    used integer,
    remaining integer GENERATED ALWAYS AS ((entitlement - used)) STORED,
    valid_fr date,
    valid_thru date,
    status integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    description character varying(100)
);


ALTER TABLE hr.leave_entitlements OWNER TO postgres;

--
-- Name: COLUMN leave_entitlements.status; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.leave_entitlements.status IS '1 : Active
2 : Pending
3 : Expired
4 : Depleted/fully used
5 : Exceeded';


--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.leave_entitlements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.leave_entitlements_id_seq OWNER TO postgres;

--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.leave_entitlements_id_seq OWNED BY hr.leave_entitlements.id;


--
-- Name: leaves; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.leaves (
    id bigint NOT NULL,
    employee integer,
    leave_type integer,
    start_date date,
    end_date date,
    total_days integer NOT NULL,
    paid integer,
    status integer,
    approved_by integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone
);


ALTER TABLE hr.leaves OWNER TO postgres;

--
-- Name: COLUMN leaves.paid; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.leaves.paid IS '1 : paid
2 : partial
3 : unpaid';


--
-- Name: COLUMN leaves.status; Type: COMMENT; Schema: hr; Owner: postgres
--

COMMENT ON COLUMN hr.leaves.status IS '1 : approved
2 : rejected
3 : pending';


--
-- Name: leaves_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.leaves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.leaves_id_seq OWNER TO postgres;

--
-- Name: leaves_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.leaves_id_seq OWNED BY hr.leaves.id;


--
-- Name: leaves_total_days_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.leaves_total_days_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.leaves_total_days_seq OWNER TO postgres;

--
-- Name: leaves_total_days_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.leaves_total_days_seq OWNED BY hr.leaves.total_days;


--
-- Name: units; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.units (
    id integer NOT NULL,
    name character varying(100),
    echelon integer,
    office integer,
    managing_unit integer,
    head integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on integer
);


ALTER TABLE hr.units OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.units_id_seq OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.units_id_seq OWNED BY hr.units.id;


--
-- Name: leave_types; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.leave_types (
    id integer NOT NULL,
    name character varying(50),
    max_days integer,
    cycle character varying(20)
);


ALTER TABLE ref.leave_types OWNER TO postgres;

--
-- Name: v_employee_leave_details; Type: VIEW; Schema: hr; Owner: postgres
--

CREATE VIEW hr.v_employee_leave_details AS
 SELECT a.id,
    a.first_name,
    a.last_name,
    a.id_number,
    b.year,
    b.valid_fr AS start_date,
    b.valid_thru AS end_date,
    b.entitlement AS total_days,
    b.used,
    b.remaining,
    c.name AS leave_type,
    b.description
   FROM ((hr.employees a
     JOIN hr.leave_entitlements b ON ((b.employee = a.id)))
     JOIN ref.leave_types c ON ((c.id = b.leave_type)));


ALTER VIEW hr.v_employee_leave_details OWNER TO postgres;

--
-- Name: v_employee_leaves_remaining; Type: VIEW; Schema: hr; Owner: postgres
--

CREATE VIEW hr.v_employee_leaves_remaining AS
 SELECT a.id,
    a.first_name,
    a.last_name,
    a.id_number,
    b.year,
    sum(COALESCE(b.entitlement, 0)) AS total_entitlement,
    sum(COALESCE(b.used, 0)) AS total_used,
    sum(COALESCE(b.remaining, 0)) AS total_remaining
   FROM (hr.employees a
     JOIN hr.leave_entitlements b ON ((a.id = b.employee)))
  GROUP BY a.id, a.first_name, a.last_name, a.id_number, b.year;


ALTER VIEW hr.v_employee_leaves_remaining OWNER TO postgres;

--
-- Name: echelons; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.echelons (
    id integer NOT NULL,
    name character varying(50),
    min_rank integer,
    max_rank integer,
    min_salary integer,
    max_salary integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    code character varying(5)
);


ALTER TABLE ref.echelons OWNER TO postgres;

--
-- Name: ranks; Type: TABLE; Schema: ref; Owner: bpkp_aiva
--

CREATE TABLE ref.ranks (
    id integer NOT NULL,
    code character varying(5),
    name character varying(50),
    min_salary integer,
    max_salary integer
);


ALTER TABLE ref.ranks OWNER TO bpkp_aiva;

--
-- Name: v_employee_profiles; Type: VIEW; Schema: hr; Owner: postgres
--

CREATE VIEW hr.v_employee_profiles AS
 SELECT a.id,
    a.first_name,
    a.last_name,
    a.id_number,
        CASE
            WHEN (a.sex = 1) THEN 'Male'::text
            ELSE 'Female'::text
        END AS sex,
    a.citizen_number,
    a.tax_number,
    a.birth_place,
    a.birth_date,
    a.address,
    a.email,
    a.phone_number,
    a.hire_date,
    b.id AS job_id,
    b.title AS job_title,
    e.id AS rank_id,
    e.name AS rank,
    f.id AS echelon_id,
    COALESCE(f.name, '-'::character varying) AS echelon,
        CASE
            WHEN (c.first_name IS NULL) THEN '-'::text
            ELSE (((c.first_name)::text || ' '::text) || (c.last_name)::text)
        END AS manager,
    d.id AS unit_id,
    d.name AS unit
   FROM (((((hr.employees a
     JOIN hr.jobs b ON ((a.job = b.id)))
     LEFT JOIN hr.employees c ON ((a.manager = c.id)))
     JOIN hr.units d ON ((a.unit = d.id)))
     JOIN ref.ranks e ON ((a.rank = e.id)))
     LEFT JOIN ref.echelons f ON ((b.echelon = f.id)))
  ORDER BY f.code, e.code DESC;


ALTER VIEW hr.v_employee_profiles OWNER TO postgres;

--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    employee_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cities; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.cities (
    id integer NOT NULL,
    province integer,
    code character varying(4),
    type integer,
    name character varying(50)
);


ALTER TABLE ref.cities OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: ref; Owner: bpkp_aiva
--

CREATE TABLE ref.countries (
    id integer NOT NULL,
    name character varying(40),
    region integer NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    code character varying(2)
);


ALTER TABLE ref.countries OWNER TO bpkp_aiva;

--
-- Name: echelons_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.echelons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.echelons_id_seq OWNER TO postgres;

--
-- Name: echelons_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.echelons_id_seq OWNED BY ref.echelons.id;


--
-- Name: kpi_categories; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.kpi_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    unit character varying(50),
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone
);


ALTER TABLE ref.kpi_categories OWNER TO postgres;

--
-- Name: kpi_categories_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.kpi_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.kpi_categories_id_seq OWNER TO postgres;

--
-- Name: kpi_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.kpi_categories_id_seq OWNED BY ref.kpi_categories.id;


--
-- Name: leave_types_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.leave_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.leave_types_id_seq OWNER TO postgres;

--
-- Name: leave_types_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.leave_types_id_seq OWNED BY ref.leave_types.id;


--
-- Name: offices; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.offices (
    id integer NOT NULL,
    name character varying(100),
    address character varying(200),
    postal_code character varying(12),
    city integer,
    province integer,
    country integer
);


ALTER TABLE ref.offices OWNER TO postgres;

--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.offices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.offices_id_seq OWNER TO postgres;

--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.offices_id_seq OWNED BY ref.offices.id;


--
-- Name: provinces; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.provinces (
    id integer NOT NULL,
    country integer,
    code character varying(2),
    name character varying(50)
);


ALTER TABLE ref.provinces OWNER TO postgres;

--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.provinces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.provinces_id_seq OWNER TO postgres;

--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.provinces_id_seq OWNED BY ref.provinces.id;


--
-- Name: rank_id_seq; Type: SEQUENCE; Schema: ref; Owner: bpkp_aiva
--

CREATE SEQUENCE ref.rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.rank_id_seq OWNER TO bpkp_aiva;

--
-- Name: rank_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: bpkp_aiva
--

ALTER SEQUENCE ref.rank_id_seq OWNED BY ref.ranks.id;


--
-- Name: regions; Type: TABLE; Schema: ref; Owner: bpkp_aiva
--

CREATE TABLE ref.regions (
    region_id integer NOT NULL,
    region_name character varying(25)
);


ALTER TABLE ref.regions OWNER TO bpkp_aiva;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: ref; Owner: bpkp_aiva
--

CREATE SEQUENCE ref.regions_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.regions_region_id_seq OWNER TO bpkp_aiva;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: bpkp_aiva
--

ALTER SEQUENCE ref.regions_region_id_seq OWNED BY ref.regions.region_id;


--
-- Name: regulation_categories; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.regulation_categories (
    id integer NOT NULL,
    name character varying(100),
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    is_active integer DEFAULT 1
);


ALTER TABLE ref.regulation_categories OWNER TO postgres;

--
-- Name: regulation_categories_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.regulation_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.regulation_categories_id_seq OWNER TO postgres;

--
-- Name: regulation_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.regulation_categories_id_seq OWNED BY ref.regulation_categories.id;


--
-- Name: regulations; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.regulations (
    id integer NOT NULL,
    category integer,
    name character varying(100),
    description text,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    status integer,
    file_path text
);


ALTER TABLE ref.regulations OWNER TO postgres;

--
-- Name: COLUMN regulations.status; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.regulations.status IS '1 : valid
2 : invalid';


--
-- Name: regulations_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.regulations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.regulations_id_seq OWNER TO postgres;

--
-- Name: regulations_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.regulations_id_seq OWNED BY ref.regulations.id;


--
-- Name: attendance id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.attendance ALTER COLUMN id SET DEFAULT nextval('hr.attendance_id_seq'::regclass);


--
-- Name: dependents id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.dependents ALTER COLUMN id SET DEFAULT nextval('hr.dependents_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees ALTER COLUMN id SET DEFAULT nextval('hr.employees_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.jobs ALTER COLUMN id SET DEFAULT nextval('hr.jobs_job_seq'::regclass);


--
-- Name: kpi id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.kpi ALTER COLUMN id SET DEFAULT nextval('hr.kpi_id_seq'::regclass);


--
-- Name: leave_entitlements id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leave_entitlements ALTER COLUMN id SET DEFAULT nextval('hr.leave_entitlements_id_seq'::regclass);


--
-- Name: leaves id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves ALTER COLUMN id SET DEFAULT nextval('hr.leaves_id_seq'::regclass);


--
-- Name: leaves total_days; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves ALTER COLUMN total_days SET DEFAULT nextval('hr.leaves_total_days_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.units ALTER COLUMN id SET DEFAULT nextval('hr.units_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: echelons id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.echelons ALTER COLUMN id SET DEFAULT nextval('ref.echelons_id_seq'::regclass);


--
-- Name: kpi_categories id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.kpi_categories ALTER COLUMN id SET DEFAULT nextval('ref.kpi_categories_id_seq'::regclass);


--
-- Name: leave_types id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.leave_types ALTER COLUMN id SET DEFAULT nextval('ref.leave_types_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.offices ALTER COLUMN id SET DEFAULT nextval('ref.offices_id_seq'::regclass);


--
-- Name: provinces id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.provinces ALTER COLUMN id SET DEFAULT nextval('ref.provinces_id_seq'::regclass);


--
-- Name: ranks id; Type: DEFAULT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.ranks ALTER COLUMN id SET DEFAULT nextval('ref.rank_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.regions ALTER COLUMN region_id SET DEFAULT nextval('ref.regions_region_id_seq'::regclass);


--
-- Name: regulation_categories id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.regulation_categories ALTER COLUMN id SET DEFAULT nextval('ref.regulation_categories_id_seq'::regclass);


--
-- Name: regulations id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.regulations ALTER COLUMN id SET DEFAULT nextval('ref.regulations_id_seq'::regclass);


--
-- Data for Name: employee_activity; Type: TABLE DATA; Schema: bpkp; Owner: bpkp_aiva
--

COPY bpkp.employee_activity (id, tanggal_aktivitas, unitkerja, pegawai, usia, jabatan, nama_aktivitas, id_penugasan, jenis_pkpt_pkau, year_month) FROM stdin;
4117965	2024-01-30	19	2498.0	58.0	12.0	Zoom tentang GWS	-1.0	\N	2024-01
4118347	2024-01-30	15	2021.0	35.0	2.0	Telaah pembangunan jalan tol	-1.0	\N	2024-01
4123323	2024-01-31	48	5413.0	35.0	2.0	Isu strategis	75469.0	PKAU-NG	2024-01
4116026	2024-01-30	29	3854.0	23.0	10.0	mempelajari materi apd	-2	\N	2024-01
4112740	2024-01-29	13	1769.0	25.0	10.0	Notulensi ppm bersinergi, siskeudes	130683.0	PKPT-NG	2024-01
4116080	2024-01-30	28	3734.0	28.0	3.0	Pengumpulan data	130296	PKPT-NG	2024-01
4109616	2024-01-28	15	1957.0	30.0	188.0	Pemasangan LED di ruang IPP dan tarik kabel genset ged C	-1.0	\N	2024-01
4110311	2024-01-29	13	1702.0	56.0	115.0	melakukan tugas kepegawaian	74677.0	PKAU-NG	2024-01
4120754	2024-01-31	29	3932.0	30.0	2.0	ppm permendagri	-3	\N	2024-01
4122995	2024-01-31	10	1354.0	34.0	2.0	Rapat persiapan Raker pusbin 2024	-1	\N	2024-01
4111767	2024-01-29	25	3413.0	35.0	2.0	Menyusun laporan TL	-1.0	\N	2024-01
4118700	2024-01-30	37	4593	25	10.0	Melakukan ppm ZI dan menyusun notula	-1	\N	2024-01
4116278	2024-01-30	38	4658.0	25.0	10.0	Ngulang	74754	PKAU-NG	2024-01
4114696	2024-01-30	16	2042.0	49.0	12.0	E-learning diklat ahli pertama	-1.0	\N	2024-01
4120448	2024-01-31	13	1713.0	53.0	7.0	Melakukan monitoring	130893.0	PKPT-NG	2024-01
4121587	2024-01-31	19	2413.0	52.0	18.0	Menerima surat masuk/keluar, menscan, menggandakan, memproses pengiriman surat serta mengarsipkan	74753.0	PKAU-NG	2024-01
4110119	2024-01-29	17	2189.0	57.0	7.0	Persiapan penugasan	-1.0	\N	2024-01
4120904	2024-01-31	25	3459.0	23.0	10.0	Menyusun laporan keuangan	-1.0	\N	2024-01
4121098	2024-01-31	38	4650.0	37.0	12.0	Menyusun KKA	74754	PKAU-NG	2024-01
4123366	2024-01-31	45	5165.0	36.0	73.0	Verifikasi dokumen pkd	74764.0	PKAU-NG	2024-01
4117428	2024-01-30	4	645.0	60.0	7.0	Diklat MPP	76252.0	PKAU-NG	2024-01
4112396	2024-01-29	35	4440	24	10.0	penugasan rutin IPP	-1	\N	2024-01
4110752	2024-01-29	21	2746.0	59.0	7.0	Koordinasi dengan pemda ampuan	-3.0	\N	2024-01
4110490	2024-01-29	45	4506.0	36.0	26.0	Fgggghjjjkkkklll	75977.0	PKAU-NG	2024-01
4114278	2024-01-29	47	5301.0	37.0	16.0	melaksanakan fungsi perencanaan dan rekrutmen	74973.0	PKAU-NG	2024-01
4120684	2024-01-31	22	2937.0	56.0	12.0	Audit Investigasif Dugaan Tndak Pidana Korupsi atas Pengadaan Peralatan Teknologi Informasi dan Komunikasi (TIK) untuk SD di Dinas Pendidikan Kabupaten Gunungkidul TA 2022	130735.0	PKPT-NG	2024-01
4113897	2024-01-29	16	2172.0	33.0	2.0	Kajian penyertaan BSB	-1.0	\N	2024-01
4117619	2024-01-30	16	2112.0	36.0	2.0	Audit Investigatif	129595.0	PKPT-NG	2024-01
4112207	2024-01-29	24	3309.0	24.0	20.0	Rekap transaksi pajak, menyiapkan daftar nominatif translok	-2.0	\N	2024-01
4119248	2024-01-30	15	1991.0	28.0	10.0	Permintaan data gasing	130792.0	PKPT-NG	2024-01
4111793	2024-01-29	20	2559.0	38.0	3.0	Penyusunan memori jabatan	-1.0	\N	2024-01
4119109	2024-01-30	23	3274.0	36.0	3.0	monitoring TL	-1.0	\N	2024-01
4115432	2024-01-30	42	4952.0	29.0	10.0	Rapat pembahasan SKHK	75361.0	PKAU-NG	2024-01
4122896	2024-01-31	12	1558.0	60.0	7.0	Mon T L	130805	PKPT-NG	2024-01
4115565	2024-01-30	18	2352.0	38.0	12.0	ATT preservasi jalan	129616.0	PKPT-NG	2024-01
4111397	2024-01-29	31	4116.0	53.0	2.0	CC LKPD  Boltim	-1	\N	2024-01
4120671	2024-01-31	34	4324	34	2.0	Mengolah data	130833	PKPT-NG	2024-01
4115011	2024-01-30	12	1592.0	59.0	7.0	Audit pekerjaan pjn1	130692	PKPT-NG	2024-01
4110751	2024-01-29	14	1843.0	58.0	7.0	Melaksanakan pelayanan konsultasi Kimpraswil Kab Inhil terkait pengelolaan dan pemanfaatan rumah susun	-1.0	\N	2024-01
4114440	2024-01-29	1	204	36.0	2.0	Audit	130625	PKPT-NG	2024-01
4111626	2024-01-29	34	4344	51	12.0	pelaksanaan maping MR	130282	PKPT-NG	2024-01
4112721	2024-01-29	20	2639.0	57.0	7.0	Tugas rutin kantor	-2.0	\N	2024-01
4117633	2024-01-30	15	1952.0	31.0	134.0	Laporan  zi	-1.0	\N	2024-01
4111421	2024-01-29	44	5106.0	24.0	10.0	Pedoman	-1.0	\N	2024-01
4119841	2024-01-31	18	2309.0	33.0	2.0	PM ZI	-1.0	\N	2024-01
4116015	2024-01-30	27	3679.0	35.0	3.0	membuat kka	130269.0	PKPT-NG	2024-01
4114530	2024-01-29	44	5087.0	27.0	115.0	"-membuat konsep pak konversi	\N	\N	2024-01
4120271	2024-01-31	19	2405.0	36.0	2.0	Pendampingan skoring dan AOI PT PID	129778.0	PKPT-NG	2024-01
4114176	2024-01-29	16	2125.0	51.0	245.0	Verifikasi dan vakidasi data pembinaan kepegawaian	-1.0	\N	2024-01
4114632	2024-01-29	23	3264.0	35.0	2.0	kerja	-1.0	\N	2024-01
4121330	2024-01-31	29	3877.0	27.0	16.0	Buat kka	129775	PKPT-NG	2024-01
4114568	2024-01-29	7	1075.0	49.0	180.0	Koordinasi pd pmd apip	-2	\N	2024-01
4114423	2024-01-29	20	2540.0	38.0	2.0	Penyusunan SHP	-2.0	\N	2024-01
4117415	2024-01-30	22	3033.0	35.0	12.0	Persiapan PP 39	-1.0	\N	2024-01
4116850	2024-01-30	47	5320.0	35.0	329.0	Melaksanakan Mapping Potensi Pegawai	75644.0	PKAU-NG	2024-01
4116392	2024-01-30	26	3547.0	55.0	11.0	"Meneruskan surat masuk dan keluar dari sekretaris Bidang k Korwas, dalnis	\N	\N	2024-01
4121032	2024-01-31	25	3481.0	34.0	2.0	Konsep laporan	130769.0	PKPT-NG	2024-01
4111240	2024-01-29	29	3897.0	53.0	67.0	Pengadaan ASN 2023, TL tema kesehatan, pendidikan dan stunting	-1	\N	2024-01
4120035	2024-01-31	12	1614.0	24.0	10.0	Penugasan harian	-2	\N	2024-01
4119179	2024-01-30	2	344	48.0	7.0	Penyusunan pedoman pengawasan	129664	PKPT-NG	2024-01
4116951	2024-01-30	31	2378.0	29.0	3.0	Pelaksanaan Monitoring TLHP Bolmut	130502	PKPT-NG	2024-01
4110423	2024-01-29	2	248	47.0	7.0	Supervisi tim	129724	PKPT-NG	2024-01
4111685	2024-01-29	26	3533.0	24.0	10.0	Rapat Persiapan Penugasan AN	-1.0	\N	2024-01
4122910	2024-01-31	22	3016.0	37.0	2.0	fasilitasi penyusunan LKPD	-1.0	\N	2024-01
4118461	2024-01-30	23	3281.0	35.0	2.0	penyusunan kka	129661.0	PKPT-NG	2024-01
4115292	2024-01-30	23	3105.0	54.0	206.0	Rekonsiliasi lap keuangan tahun 2023	75947.0	PKAU-NG	2024-01
4109478	2024-01-28	20	2617.0	58.0	83.0	Input arsip bidang ipp	74665.0	PKAU-NG	2024-01
4110106	2024-01-29	20	2526.0	56.0	2.0	Laporan dan PPM	-2.0	\N	2024-01
4117878	2024-01-30	29	596.0	28.0	16.0	Bimtek siskeudes pinrang	-1	\N	2024-01
4224659	2024-03-06	46	5219.0	24.0	10.0	diskusi	77613.0	PKAU-NG	2024-03
4121671	2024-01-31	22	2984.0	39.0	176.0	Update website laporan pp39, memyiapkan dan membereskan zoom lc, membaca koran mencari berita bpkp	74790.0	PKAU-NG	2024-01
4122380	2024-01-31	7	1115.0	49.0	7.0	Menyiapkan dok wisuda	-1	\N	2024-01
4113313	2024-01-29	39	4768.0	37.0	2.0	Buat laporan raker ppkd	130361	PKPT-NG	2024-01
4119095	2024-01-30	32	4166.0	27.0	10.0	"Membaca referensi	\N	\N	2024-01
4122934	2024-01-31	4	684.0	56.0	112.0	Rapat kick off eva EBT di Kemen ESDM	-2.0	\N	2024-01
4120850	2024-01-31	29	3857.0	59.0	7.0	Reviu konsep penugasan	130017	PKPT-NG	2024-01
4115755	2024-01-30	33	2388.0	35.0	3.0	Monit tl	129936	PKPT-NG	2024-01
4119388	2024-01-30	42	4964.0	35.0	2.0	Kegiatan rutin	-1.0	\N	2024-01
4112063	2024-01-29	3	479.0	24.0	10.0	flipbook pengawasan	-1.0	\N	2024-01
4122361	2024-01-31	21	2772.0	34.0	2.0	Tugas rutin	-2.0	\N	2024-01
4111325	2024-01-29	38	4663.0	28.0	19.0	Melengkapi dokumen persiapan pengangkatan PNS dan JFA	74830	PKAU-NG	2024-01
4116765	2024-01-30	7	1118.0	53.0	12.0	Verifikasi pertanggungjawaban keuangan diklat	75475	PKAU-NG	2024-01
4117644	2024-01-30	12	1648.0	30.0	3.0	Menyusun SKP	-1	\N	2024-01
4115940	2024-01-30	26	3593.0	33.0	3.0	Tugas harian kantor	-1.0	\N	2024-01
4118629	2024-01-30	49	5468.0	24.0	10.0	Analisis fitur srikandi	-1.0	\N	2024-01
4113603	2024-01-29	4	660.0	48.0	7.0	Pembahasan laporan hasil reviu	129817.0	PKPT-NG	2024-01
4110493	2024-01-29	32	4134.0	29.0	10.0	pelaksanaan	75845	PKAU-NG	2024-01
4118957	2024-01-30	5	873.0	57.0	13.0	Menyelesaikan kegiatan kesekretariatan di Direktorat Investigasi III	-2.0	\N	2024-01
4114468	2024-01-29	45	5169.0	25.0	10.0	Tusi lk	-2.0	\N	2024-01
4116733	2024-01-30	19	2439.0	38.0	3.0	Merapihkan kertas kerja	-3.0	\N	2024-01
4112179	2024-01-29	14	1829.0	50.0	7.0	Persiapan Telaah Sejawat	-2.0	\N	2024-01
4116403	2024-01-30	32	2385.0	36.0	2.0	Persiapan workshop PPBR	130380	PKPT-NG	2024-01
4116778	2024-01-30	10	1308.0	56.0	7.0	Melakukan konsultasi online dan menyiapkan materi raker	74766	PKAU-NG	2024-01
4115789	2024-01-30	32	4168.0	58.0	115.0	Monitoring surat masuk surat keluar	-2	\N	2024-01
4116055	2024-01-30	38	4675.0	38.0	2.0	.......	-2	\N	2024-01
4110788	2024-01-29	34	428	40	7.0	Masuk kantor	130524	PKPT-NG	2024-01
4111551	2024-01-29	27	3685.0	40.0	2.0	Menyusun KKE TL	130616.0	PKPT-NG	2024-01
4115298	2024-01-30	16	2070.0	25.0	10.0	Lapgub	129646.0	PKPT-NG	2024-01
4122314	2024-01-31	16	2147.0	24.0	10.0	Notulensi Konsultasi DPRD Kabupaten Musi Rawas Utara	-1.0	\N	2024-01
4120090	2024-01-31	30	3976.0	48.0	12.0	Mengikuti Library Cafe Orcestrasi Riset Nasional	-3	\N	2024-01
4113580	2024-01-29	5	822.0	43.0	28.0	Troubleshooting sima ng	-1.0	\N	2024-01
4156167	2024-02-13	31	3605.0	50.0	67.0	Supervisi	130336	PKPT-NG	2024-02
4189676	2024-02-25	40	4501.0	29.0	3.0	Melakukan perjalanan	132158	PKPT-NG	2024-02
4204012	2024-02-29	38	4695.0	24.0	10.0	Evaluasi transformasi layanan primer dan SDMK pada kab. Lobar	131423	PKPT-NG	2024-02
4175975	2024-02-20	12	1549.0	58.0	7.0	Merrencanakan penugasan PSN	-1	\N	2024-02
4137586	2024-02-05	44	5094.0	24.0	10.0	Entry meeting dengan Inspektorat Kota Tarakan	130870.0	PKPT-NG	2024-02
4150499	2024-02-12	4	629.0	58.0	11.0	Memperbaiki spj2, dan menginput CS dalam kota dan Luar kota	-2.0	\N	2024-02
4166918	2024-02-17	23	3105.0	54.0	206.0	Melengkapi dukumen untuk pemeriksaan BPK	77205.0	PKAU-NG	2024-02
4158282	2024-02-15	19	2429.0	52.0	115.0	Koordinasi diklat fungsional auditor pertama	76886.0	PKAU-NG	2024-02
4159136	2024-02-15	40	4813.0	32.0	2.0	Persiapan diklat	-1	\N	2024-02
4175657	2024-02-20	12	1639.0	35.0	3.0	Perencanaan	131011	PKPT-NG	2024-02
4180455	2024-02-22	33	4222.0	53.0	20.0	Melaksanakan tugas keuangan	-1	\N	2024-02
4200916	2024-02-28	24	3322.0	34.0	16.0	Koordinasi dengan apip Sintang untuk pengisian kertas kerja monitoring	132027.0	PKPT-NG	2024-02
4186416	2024-02-23	38	4691.0	25.0	10.0	Identifikasi item pekerjaan, resume PSN Mandalika	132705	PKPT-NG	2024-02
4194206	2024-02-27	34	4367	51	247.0	Melakukan pengelolaan arsip dinamis	-1	\N	2024-02
4158064	2024-02-15	46	5243.0	33.0	3.0	Narasumber pelatihan MR	77061.0	PKAU-NG	2024-02
4152558	2024-02-12	48	5424.0	28.0	351.0	Mengerjakan Pendapat Hukum LSM Kalibrasi	-1.0	\N	2024-02
4139266	2024-02-06	6	956.0	52.0	159.0	Telaah rekam jejak peserta bea siswa Brunei Darussalam	75422	PKAU-NG	2024-02
4185335	2024-02-23	43	5013.0	24.0	10.0	Mengola data	132195.0	PKPT-NG	2024-02
4163508	2024-02-16	44	430.0	30.0	3.0	persiapan diklat	-3.0	\N	2024-02
4168893	2024-02-19	34	4378	53	16.0	Aktifitas apd 2	-1	\N	2024-02
4184839	2024-02-23	49	5502.0	34.0	134.0	Pengumuman paket RUP Perw. Banten pada aplikasi SiRUP	77359.0	PKAU-NG	2024-02
4142284	2024-02-06	47	5294.0	26.0	20.0	Hadir	-1.0	\N	2024-02
4191336	2024-02-26	1	62	55.0	7.0	penerapan draf pedoman	132675	PKPT-NG	2024-02
4142863	2024-02-06	40	4219.0	50.0	288.0	Perencanaan kehumasan	-1	\N	2024-02
4175772	2024-02-20	13	1786.0	25.0	10.0	Evran	131386.0	PKPT-NG	2024-02
4169757	2024-02-19	12	1568.0	59.0	7.0	Persiapan	132332	PKPT-NG	2024-02
4168807	2024-02-19	34	4318	25	10.0	belajar mandiri	-1	\N	2024-02
4170883	2024-02-19	49	5450.0	47.0	11.0	Merapikan berkas persetujuan	76631.0	PKAU-NG	2024-02
4131842	2024-02-02	37	4576	29	13.0	Proses administrasi persuratan, update monitoring DL4, melaksanakan perintah lainnya	-2	\N	2024-02
4130119	2024-02-02	41	4880.0	25.0	10.0	Zoom APP Kesehatan	-1	\N	2024-02
4174128	2024-02-20	31	4114.0	38.0	2.0	Penugasan	131613	PKPT-NG	2024-02
4200131	2024-02-28	5	934.0	34.0	2.0	App supply chain	131440	PKPT-NG	2024-02
4190610	2024-02-26	42	4505.0	32.0	35.0	Pekerjaan rutin	-2.0	\N	2024-02
4134125	2024-02-04	47	5260.0	30.0	51.0	Menyusun laporan	-1.0	\N	2024-02
4193645	2024-02-26	43	4996.0	33.0	2.0	Pedoman	-3.0	\N	2024-02
4183619	2024-02-22	37	4584	34	2.0	Evaluasi transformasi SDM Kesehatan	131492	PKPT-NG	2024-02
4185439	2024-02-23	43	1939.0	60.0	124.0	Evaluasi suplai cen	132185.0	PKPT-NG	2024-02
4125856	2024-02-01	49	5489.0	28.0	13.0	Pengukuhan Kaper BPKP Prov Sulut	76285.0	PKAU-NG	2024-02
5041951	2024-12-23	16	2045.0	49.0	7.0	Evaluasi	159417.0	PKPT-NG	2024-12
4171852	2024-02-19	3	581.0	34.0	2.0	Persiapan pelaksanaan app topik isu kewilayahan kesehatan	131314.0	PKPT-NG	2024-02
4195183	2024-02-27	43	5052.0	25.0	10.0	belajar forsa	-1.0	\N	2024-02
4139133	2024-02-06	7	1016.0	53.0	168.0	Menyiapkan bahan ajar & sit in online	-2	\N	2024-02
4187574	2024-02-23	5	839.0	35.0	2.0	Stabilisasi Harga	131147	PKPT-NG	2024-02
4166259	2024-02-16	5	892.0	51.0	148.0	Review perencanaan dan laporan dan arahan	-2.0	\N	2024-02
4143545	2024-02-07	22	3035.0	31.0	3.0	mata ajar komunikasi audit intern (kai)	75923.0	PKAU-NG	2024-02
4172175	2024-02-19	31	4074.0	48.0	18.0	Dukungan TatA Usaha	-1	\N	2024-02
4187181	2024-02-23	13	1773.0	35.0	2.0	QA evren	131328.0	PKPT-NG	2024-02
4131114	2024-02-02	24	3353.0	37.0	2.0	Mempelajari EERM	-1.0	\N	2024-02
4167669	2024-02-18	37	4575	31	51.0	Scanning dokumen DRPP	-2	\N	2024-02
4205276	2024-02-29	1	12	34.0	2.0	Tripartid pt ebt	129585	PKPT-NG	2024-02
4205501	2024-02-29	13	1754.0	51.0	2.0	Penyelesaian laporan pendampingan pka	133160.0	PKPT-NG	2024-02
4174552	2024-02-20	16	2137.0	34.0	105.0	Layanan pengelolaan keuangan	76659.0	PKAU-NG	2024-02
4168384	2024-02-19	28	3802.0	25.0	10.0	Pengumpulan data di dinas kesehatan	131665	PKPT-NG	2024-02
4194327	2024-02-27	18	2271.0	58.0	48.0	Reviu PSN Kawasan Terintegrasi Bakauheni	-1.0	\N	2024-02
4152364	2024-02-12	37	4599	51	7.0	Pelaksanaan	131302	PKPT-NG	2024-02
4153845	2024-02-13	22	3049.0	38.0	2.0	Melaksanakan monotoring dan koordinasi pengawasan pengadaan PPPK Tahun 2023 Tahap Pengangkatan dan Usulan Formasi ASN Tahun 2024	-2.0	\N	2024-02
4134223	2024-02-04	30	1830.0	29.0	115.0	Inpassing Gaji Pokok	-1	\N	2024-02
4144270	2024-02-07	20	2647.0	48.0	62.0	Koordinasi peningkatan PK APIP	-3.0	\N	2024-02
4196330	2024-02-27	22	432.0	39.0	12.0	Pembahasan Hasil Evaluasi Transformasi Pembiayaan Kesehatan DIY	-1.0	\N	2024-02
4160596	2024-02-15	15	1969.0	35.0	13.0	"1. Mencatat surat masuk bidang IPP ke buku agenda	\N	\N	2024-02
4199108	2024-02-28	47	5296.0	36.0	2.0	Membahas progres metode pertukaran pegawai	76579.0	PKAU-NG	2024-02
4204571	2024-02-29	23	3176.0	38.0	12.0	Bai masjid	-1.0	\N	2024-02
4155476	2024-02-13	19	2413.0	52.0	18.0	Menerima surat masuk/keluar, menscan, menggandakan, memproses pengiriman surat serta mengarsipkan	76455.0	PKAU-NG	2024-02
4160085	2024-02-15	7	1044.0	65.0	39.0	Reviu dan update bahan paparan diklat MR	-1	\N	2024-02
4148107	2024-02-10	43	5053.0	27.0	10.0	Lembur	-2.0	\N	2024-02
4195122	2024-02-27	42	4932.0	24.0	10.0	Nugas spip	131893.0	PKPT-NG	2024-02
4147842	2024-02-09	16	2138.0	35.0	2.0	Lembur pemenuhan dokumen ZI	-2.0	\N	2024-02
4176670	2024-02-21	26	3505.0	59.0	34.0	Evaluasi efektivitas Pembinaan Peningkatan K-APIP Prov Kalsel	132098.0	PKPT-NG	2024-02
4196512	2024-02-27	18	2355.0	57.0	2.0	Mengisi kkp eksel	132754.0	PKPT-NG	2024-02
4171128	2024-02-19	21	2793.0	50.0	78.0	Evaluasi atas efektivitas pembinaan apip pada inspeltorat prov jawa tengah	132446.0	PKPT-NG	2024-02
4148546	2024-02-12	25	3447.0	36.0	2.0	Sosialisasi MRPN	131284.0	PKPT-NG	2024-02
4166372	2024-02-17	23	3148.0	54.0	11.0	Sekretaris Bidang APD	77103.0	PKAU-NG	2024-02
4147271	2024-02-07	14	1555.0	59.0	239.0	"Mengkoordinasikan penugasan pengawasan dan dukungan manajemen pengawasan	\N	\N	2024-02
4199248	2024-02-28	42	4946.0	23.0	10.0	monitoring pengisian kkm spip	131893.0	PKPT-NG	2024-02
4199388	2024-02-28	16	2066.0	52.0	7.0	"Penginputan sheets pengawasan	\N	\N	2024-02
4130140	2024-02-02	25	3491.0	27.0	10.0	Menyusun laporan	129803.0	PKPT-NG	2024-02
4160381	2024-02-15	20	2663.0	52.0	2.0	Mengikuti pelatihan mooc	76564.0	PKAU-NG	2024-02
4190195	2024-02-26	46	5226.0	36.0	19.0	Kekurangan berkas KP	-2.0	\N	2024-02
4189443	2024-02-25	48	5365.0	49.0	346.0	Pengelolaan JDIH dan penyempurnaan Daftar Pemusnahan Arsip.	77629.0	PKAU-NG	2024-02
4179038	2024-02-21	49	5475.0	33.0	41.0	Pembinaan kearsipan di Perekonomian	76803.0	PKAU-NG	2024-02
4195511	2024-02-27	25	3490.0	24.0	10.0	Penugasan	-1.0	\N	2024-02
4149283	2024-02-12	29	3949.0	36.0	2.0	PPM Dokumen Perencanaan Pemerintah Daerah	-1	\N	2024-02
4130619	2024-02-02	13	1728.0	55.0	2.0	Survey	130595.0	PKPT-NG	2024-02
4138836	2024-02-06	9	1192.0	53.0	11.0	Bebenah arsip di Pusinfowas	-2	\N	2024-02
4173910	2024-02-20	29	3927.0	24.0	10.0	spip barru	132400	PKPT-NG	2024-02
4188063	2024-02-23	42	2268.0	37.0	12.0	Mulai isi kertas kerja	131247.0	PKPT-NG	2024-02
4204366	2024-02-29	31	4086.0	58.0	287.0	reviu dan monitor	-2	\N	2024-02
4191876	2024-02-26	49	5455.0	35.0	2.0	QC laptop tahap 3	76889.0	PKAU-NG	2024-02
4146115	2024-02-07	22	3055.0	37.0	2.0	Pelatihan mooc	76518.0	PKAU-NG	2024-02
4126025	2024-02-01	30	3984.0	25.0	10.0	Membuat Pengajuan Uang Muka	-1	\N	2024-02
4147666	2024-02-08	4	652.0	56.0	83.0	"Penyelesaian kelengkapan	\N	\N	2024-02
4191239	2024-02-26	32	4212.0	54.0	84.0	Monitoring surat keluar dan scan surat	-2	\N	2024-02
4194023	2024-02-26	2	256	51.0	49.0	Bimtek SPIP dan MR Bakamla, koordinasi penugasan, waspon peparnas	131855	PKPT-NG	2024-02
4130372	2024-02-02	13	1806.0	35.0	2.0	Monitoring pelaksanaan rkt	130782.0	PKPT-NG	2024-02
4160851	2024-02-15	41	4862.0	51.0	82.0	Approve formulir PBJ	\N	\N	2024-02
4155532	2024-02-13	7	1076.0	37.0	3.0	Kaksosmssin	75961	PKAU-NG	2024-02
4167036	2024-02-17	29	3906.0	56.0	82.0	Monitoring kegiatan lembur TU dan PPNPN	\N	\N	2024-02
4179174	2024-02-21	3	589.0	49.0	100.0	Reviu pedoman	-1.0	\N	2024-02
4147477	2024-02-07	34	4319	25	10.0	Obrik	131205	PKPT-NG	2024-02
4168457	2024-02-19	1	32	54.0	4.0	Mengantar Pimpinan	-1	\N	2024-02
4150917	2024-02-12	17	2236.0	24.0	10.0	Melakukan penugasan	131414.0	PKPT-NG	2024-02
4260378	2024-03-20	5	809.0	56.0	136.0	Melakukam evaluasi hkp	133333	PKPT-NG	2024-03
4282741	2024-03-26	13	1738.0	51.0	7.0	Verifikasi DLI TBC	134565.0	PKPT-NG	2024-03
4279194	2024-03-25	29	596.0	28.0	16.0	Finalisasi data papbj	133407	PKPT-NG	2024-03
4234493	2024-03-10	30	3991.0	24.0	10.0	mengerjakan KKA	133766	PKPT-NG	2024-03
4269696	2024-03-22	13	1720.0	28.0	115.0	Korespondensi surat masuk dan surat keluar, Diklat, cuti, izin belajar, tugas belajar, pensiun, mutasi, etc.	-2.0	\N	2024-03
4221727	2024-03-06	16	2167.0	58.0	78.0	Evaluasi SPIP di Kba Ogan Ilir	132671.0	PKPT-NG	2024-03
4238458	2024-03-13	17	2193.0	55.0	78.0	Koordinasi pengawasan audit keuangan RSUD Rejang Lebong	133139.0	PKPT-NG	2024-03
4251493	2024-03-18	34	4340	23	10.0	Mengikuti apel pagi, mengikuti PPM tentang Desain dan Visualisasi Hasil Pengawasan dalam Laporan Eksekutif Daerah, dan reviu materi audit intern	-1	\N	2024-03
4248908	2024-03-15	39	4769.0	29.0	13.0	Melakukan fungsi kesekretariatan	-2	\N	2024-03
4207928	2024-03-01	27	3634.0	35.0	2.0	Outline lapgub	77449.0	PKAU-NG	2024-03
4260164	2024-03-20	35	4473	60	7.0	Melaksanakan kegiatan MOOC Digital workspace...	78655	PKAU-NG	2024-03
4278954	2024-03-25	2	382	24.0	10.0	emonev, laporan spip apip	-1	\N	2024-03
4282119	2024-03-26	16	2071.0	35.0	2.0	Kerja	134388.0	PKPT-NG	2024-03
4249201	2024-03-16	18	2288.0	55.0	231.0	Persiapan menentukan nilai limit BMN Peralatan dan Mesin	-2.0	\N	2024-03
4282934	2024-03-26	23	3185.0	37.0	2.0	0embuatan st	-1.0	\N	2024-03
4261210	2024-03-20	28	3727.0	23.0	10.0	Pembuatan spreadsheet	79138	PKAU-NG	2024-03
4290250	2024-03-28	44	5121.0	40.0	12.0	melaksanakan pekerjaan metode WFO	134787.0	PKPT-NG	2024-03
4275928	2024-03-25	12	1615.0	56.0	206.0	Mengerjakan tugas tugas sekbid Akuntan Negara	-2	\N	2024-03
4210404	2024-03-01	42	2924.0	31.0	3.0	Koordinasi dengan Bappeda Provinsi	133505.0	PKPT-NG	2024-03
4286427	2024-03-27	14	1921.0	25.0	10.0	Menyusun KKA	134351.0	PKPT-NG	2024-03
4259616	2024-03-19	37	4593.0	25.0	10.0	Persiapan MRPN dan penyelesaian KKA 2023	-1	\N	2024-03
4261281	2024-03-20	25	3402.0	23.0	10.0	Membuat notulensi	-1.0	\N	2024-03
4290960	2024-03-28	47	5311.0	35.0	2.0	Melimpah pns	-1.0	\N	2024-03
4228719	2024-03-07	29	3898.0	33.0	3.0	Persiapan Ujian	-1	\N	2024-03
4217142	2024-03-05	49	5448.0	57.0	224.0	mengantar surat	-2.0	\N	2024-03
4246102	2024-03-15	39	4724.0	59.0	7.0	Fmis barsel	79025	PKAU-NG	2024-03
4226228	2024-03-07	44	5084.0	28.0	16.0	sosialisasi mrpn	78603.0	PKAU-NG	2024-03
4218212	2024-03-05	44	2693.0	58.0	200.0	Melakukan aktivitas belanja	78603.0	PKAU-NG	2024-03
4246376	2024-03-15	19	2447.0	34.0	3.0	Sa GCG Jiep	131741.0	PKPT-NG	2024-03
4235360	2024-03-13	26	3583.0	34.0	2.0	Pendampingan itwasda di Brimob Polda Kalsel	133196.0	PKPT-NG	2024-03
4219609	2024-03-05	16	2138.0	35.0	2.0	Penyusunan shp	131729.0	PKPT-NG	2024-03
4274535	2024-03-23	29	3883.0	34.0	2.0	Lembur dan mendampingi pemda	133407	PKPT-NG	2024-03
4214850	2024-03-04	20	2626.0	55.0	4.0	Melakukan Pertelaan Arsip Inaktif	78409.0	PKAU-NG	2024-03
4289362	2024-03-28	2	279	27.0	10.0	Piloting	134671	PKPT-NG	2024-03
4244782	2024-03-15	14	1842.0	34.0	2.0	PPM MRPN	-1.0	\N	2024-03
4277703	2024-03-25	15	2013.0	33.0	2.0	Mengikuti mooc digital workspace	-1.0	\N	2024-03
4281754	2024-03-26	40	4834.0	38.0	2.0	Tugas rutin	-1	\N	2024-03
4293791	2024-03-30	7	1056.0	51.0	52.0	Labelisasi barcode bmn di lt 3 mes kampus 2	-1	\N	2024-03
4256096	2024-03-19	36	4553	35	2.0	MOOC Digital Workspace	78572	PKAU-NG	2024-03
4279397	2024-03-25	5	850.0	52.0	7.0	Mengedit laporan	133383	PKPT-NG	2024-03
4221506	2024-03-06	45	5061.0	47.0	48.0	Perjalanan pulang ke Jakarta	77649.0	PKAU-NG	2024-03
4271359	2024-03-22	47	5278.0	36.0	19.0	Monitoring pelaksanaan diklat pbj di pusdiklatwas bpkp	79276.0	PKAU-NG	2024-03
4219102	2024-03-05	15	2012.0	25.0	10.0	Koordinasi bersama Bank Jambi	-1.0	\N	2024-03
4219495	2024-03-05	12	1562.0	58.0	12.0	Mempelajari peraturan perundangan	78602	PKAU-NG	2024-03
4248171	2024-03-15	36	1940	56	34.0	Reviu laporan Kesehatan	133564	PKPT-NG	2024-03
4283213	2024-03-26	19	2427.0	35.0	2.0	Baca pedoman	-1.0	\N	2024-03
4231128	2024-03-08	29	429.0	28.0	3.0	Telaah pkkn	-1	\N	2024-03
4277477	2024-03-25	24	3324.0	24.0	10.0	Apel pagi	-1.0	\N	2024-03
4244658	2024-03-15	23	3175.0	54.0	7.0	Mengikuti MOOC	78640.0	PKAU-NG	2024-03
4283524	2024-03-26	2	322	25.0	10.0	penyusunan pedoman dikti	134268	PKPT-NG	2024-03
4224268	2024-03-06	5	890.0	35.0	2.0	Cek ba	129685	PKPT-NG	2024-03
4215418	2024-03-04	17	2227.0	47.0	26.0	Pekerjaan rutin layanan keuangan bagian umum.	-2.0	\N	2024-03
4272528	2024-03-22	18	2345.0	56.0	7.0	Penyelesaian MOOC WS	-1.0	\N	2024-03
4232092	2024-03-08	36	4563	25	10.0	Pelatihan mooc digital	78572	PKAU-NG	2024-03
4239355	2024-03-13	32	4180.0	57.0	20.0	Sekretaris bidang	-2	\N	2024-03
4278255	2024-03-25	21	2850.0	58.0	2.0	Melaksanakan tugas rutin kantor	-1.0	\N	2024-03
4270213	2024-03-22	40	4811.0	24.0	10.0	Monitoring TL	134320	PKPT-NG	2024-03
4241144	2024-03-14	33	4282.0	35.0	2.0	Penyelesaian laporan	131249	PKPT-NG	2024-03
4274634	2024-03-23	7	1120.0	39.0	187.0	Pulang	79009	PKAU-NG	2024-03
4268650	2024-03-21	4	670.0	34.0	3.0	Kerja	-1.0	\N	2024-03
4253324	2024-03-18	24	3336.0	24.0	10.0	melengkapi lampiran evran	-1.0	\N	2024-03
4228253	2024-03-07	1	133	52.0	7.0	analisis data	132985	PKPT-NG	2024-03
4238115	2024-03-13	3	451.0	35.0	2.0	Evaluasi Peningkatan Kualitas Perencanaan dan penganggaran sektor percepatan penurunan stunting pada BNPP	134058.0	PKPT-NG	2024-03
4266134	2024-03-21	30	4009.0	38.0	2.0	Merencanakan penugasan selanjutnya	-1	\N	2024-03
4226378	2024-03-07	28	3801.0	24.0	10.0	Membuat laporan evran mabar	132288	PKPT-NG	2024-03
4259274	2024-03-19	15	1946.0	52.0	7.0	Reviu laporan	134362.0	PKPT-NG	2024-03
4262468	2024-03-20	17	2211.0	56.0	2.0	Finalisasi laporan bimtek lebong	-1.0	\N	2024-03
4256504	2024-03-19	26	3575.0	31.0	3.0	Tugas rutin	78649.0	PKAU-NG	2024-03
4273741	2024-03-23	18	2281.0	35.0	3.0	lembur penyusunan kertas kerja dan laporan	131666.0	PKPT-NG	2024-03
4218532	2024-03-05	3	568.0	37.0	2.0	Sosialisasi pedoman MRPN	-1.0	\N	2024-03
4262345	2024-03-20	35	4422	34	2.0	Mengikuti pelatihan mooc	78655	PKAU-NG	2024-03
4251840	2024-03-18	38	4661.0	25.0	10.0	mooc digital workspace	-3	\N	2024-03
4242477	2024-03-14	46	5201.0	35.0	2.0	Menyusun modul diklat RMIS	-1.0	\N	2024-03
4269315	2024-03-22	47	5256.0	36.0	12.0	Pemrosesan SK Inpassing Maret 2024	78458.0	PKAU-NG	2024-03
4258271	2024-03-19	22	2960.0	35.0	199.0	Persiapan audit loan isdb	-1.0	\N	2024-03
4288654	2024-03-27	47	5296.0	36.0	2.0	Mengikuti pelatihan Penilai RMI	79680.0	PKAU-NG	2024-03
4214463	2024-03-04	15	1983.0	35.0	177.0	Anggaran	-2.0	\N	2024-03
4216842	2024-03-05	21	2908.0	36.0	2.0	Bekerja di kantor	-1.0	\N	2024-03
4281898	2024-03-26	19	2430.0	55.0	12.0	Merapikan kertas kerja	131580.0	PKPT-NG	2024-03
4262734	2024-03-20	3	496.0	34.0	2.0	Informasi Awal MRPN	-1.0	\N	2024-03
4281282	2024-03-26	34	4303	50	12.0	Menunggu undangan dan penetapan diklat Implementasi RMIS	-1	\N	2024-03
4217351	2024-03-05	20	2634.0	58.0	2.0	fisik	131883.0	PKPT-NG	2024-03
4281943	2024-03-26	12	1583.0	33.0	16.0	Mengerjakan tugas MOOC GWS	-1	\N	2024-03
4251271	2024-03-18	41	4865.0	23.0	10.0	"1. Mempersiapkan surat tugas	\N	\N	2024-03
4276877	2024-03-25	28	3815.0	28.0	71.0	Memproses Laporan GDN untuk Tukin April 2024	-2	\N	2024-03
4260672	2024-03-20	1	32	54.0	4.0	Memelihara kendaraan dinas	-1	\N	2024-03
4261719	2024-03-20	43	5005.0	24.0	10.0	kerja	-1.0	\N	2024-03
4291300	2024-03-28	35	4432	25	10.0	kerja	-1	\N	2024-03
4224723	2024-03-06	5	859.0	57.0	140.0	APP supply Chain TW 1	-2	\N	2024-03
4251425	2024-03-18	33	1140.0	27.0	3.0	work from office	-1	\N	2024-03
4222648	2024-03-06	20	2604.0	34.0	2.0	Menyusun kke	131954.0	PKPT-NG	2024-03
4229268	2024-03-08	23	3116.0	56.0	3.0	Persiapan pelaporan	132366.0	PKPT-NG	2024-03
4238577	2024-03-13	20	2582.0	29.0	3.0	MOOC GWS	78610.0	PKAU-NG	2024-03
4246501	2024-03-15	21	2753.0	55.0	113.0	"Monitor bimtek	\N	\N	2024-03
4287745	2024-03-27	1	171	36.0	16.0	Kka pnbp	129620	PKPT-NG	2024-03
4224237	2024-03-06	16	2106.0	36.0	3.0	Menyusun KKA	130760.0	PKPT-NG	2024-03
4274226	2024-03-23	14	1884.0	26.0	20.0	Proses THR 2024 Pegawai	79171.0	PKAU-NG	2024-03
4235365	2024-03-13	44	5062.0	42.0	2.0	Pretest	78603.0	PKAU-NG	2024-03
4268404	2024-03-21	7	1105.0	53.0	57.0	Mengajar MPD EL KD 0709, persiapan witness, persiapan cgre	78703	PKAU-NG	2024-03
4319418	2024-04-17	12	1530.0	32.0	238.0	Kroscek lembur ppnpn selama 4 minggu	-2	\N	2024-04
4329940	2024-04-22	44	5130.0	41.0	189.0	Menginput barang keluar di aplikasi sakti	-1.0	\N	2024-04
4300650	2024-04-02	35	4461	57	2.0	hadir bermanfaat	-1	\N	2024-04
4321585	2024-04-18	28	3808.0	53.0	7.0	Supervisi keg tim dan diskusi hasil laporan	79621	PKAU-NG	2024-04
4349189	2024-04-26	44	2918.0	28.0	193.0	Mengerjakan Penyusunan Laporan Eksekutif Daerah Triwulan I Perwakilan BPKP Provinsi Kalimantan Utara	134321.0	PKPT-NG	2024-04
4329099	2024-04-22	40	4812.0	23.0	10.0	Pertemuan dengan Kejati Sulbar, menyusun risalah pertemuan	-1	\N	2024-04
4299858	2024-04-02	31	4097.0	23.0	10.0	Melaksanakan tugas	-1	\N	2024-04
4338302	2024-04-24	25	3493.0	29.0	16.0	Evaluasi energi	135690.0	PKPT-NG	2024-04
4325068	2024-04-19	11	1474.0	34.0	2.0	Audit penyesuaian harga	133847	PKPT-NG	2024-04
4328393	2024-04-22	23	3252.0	55.0	272.0	MCU, reviu	-2.0	\N	2024-04
4299457	2024-04-02	42	4946.0	23.0	10.0	berpuasa	-1.0	\N	2024-04
4347325	2024-04-26	5	815.0	56.0	12.0	Kka analisis profil risiko	135117	PKPT-NG	2024-04
4322532	2024-04-18	47	5357.0	33.0	71.0	Menyusun Makalah Aktualisasi PPPK 2023	-3.0	\N	2024-04
4321291	2024-04-18	26	3593.0	33.0	3.0	Tugas harian kantor	-1.0	\N	2024-04
4353824	2024-04-29	15	2001.0	28.0	10.0	Menyusun surat tugas dana desa triwulan II	-1.0	\N	2024-04
4319887	2024-04-17	35	4453	38	2.0	Survey Pendahuluan	135723	PKPT-NG	2024-04
4343880	2024-04-25	1	12	34.0	2.0	Rapat di ditjen migas	130250	PKPT-NG	2024-04
4348571	2024-04-26	15	2017.0	37.0	26.0	Layanan kepegawaian	-1.0	\N	2024-04
4353709	2024-04-29	39	4719.0	57.0	78.0	Zoom isu kewilayahan bidang kesehatan	136559	PKPT-NG	2024-04
4295305	2024-04-01	44	3760.0	34.0	2.0	Epk pdam	134428.0	PKPT-NG	2024-04
4358662	2024-04-30	6	982.0	25.0	10.0	Evaluasi zi	80692	PKAU-NG	2024-04
4354460	2024-04-29	39	4503.0	31.0	3.0	Perencanaan penugasan isu kesehatan	-1	\N	2024-04
4322809	2024-04-18	14	1893.0	49.0	78.0	Probity Audit	135262.0	PKPT-NG	2024-04
4298909	2024-04-02	8	1151.0	54.0	2.0	Literasi	-1	\N	2024-04
4321323	2024-04-18	38	4678.0	24.0	10.0	pengawasan	-1	\N	2024-04
4346883	2024-04-26	18	2279.0	36.0	2.0	Menyusun laporan	134737.0	PKPT-NG	2024-04
4324711	2024-04-19	18	2286.0	31.0	3.0	Mempelajari peraturan terkait Cadangan pangan Pemerintah tahun 2023 dan merilis berita pengawasan bidang IPP sebagai bahan branding di instagram Perwakilan BPKP PROVINSI Lampung	-1.0	\N	2024-04
4335454	2024-04-23	19	2470.0	25.0	10.0	Mempelajari teknik pengambilan sampel dan aplikasi SPSS	-1.0	\N	2024-04
4339646	2024-04-24	18	2319.0	28.0	3.0	Mempersiapkan bimtek penilaian kinerja mandiri pdam	-1.0	\N	2024-04
4333096	2024-04-23	20	2678.0	60.0	7.0	Evkin Perumda Tirta Raharja Tahun 2023	135208.0	PKPT-NG	2024-04
4351252	2024-04-28	8	726.0	33.0	120.0	update pedoma  esg	136057	PKPT-NG	2024-04
4338823	2024-04-24	28	3742.0	29.0	3.0	Mengikuti diklat	134119	PKPT-NG	2024-04
4303834	2024-04-03	25	3443.0	35.0	163.0	membuat spby, kuitansi spj dan ppbj pada aplikasi sakti	-1.0	\N	2024-04
4347405	2024-04-26	17	2197.0	26.0	10.0	zoom dengan pusat	135669.0	PKPT-NG	2024-04
4359080	2024-04-30	22	3015.0	38.0	2.0	Rapat	-1.0	\N	2024-04
4333374	2024-04-23	43	5029.0	32.0	52.0	SPJ kegiatan	-1.0	\N	2024-04
4316880	2024-04-16	20	2602.0	54.0	7.0	Persiapan penugasan	-3.0	\N	2024-04
4340598	2024-04-24	5	878.0	37.0	2.0	Anakisis	134100	PKPT-NG	2024-04
4347676	2024-04-26	4	726.0	33.0	120.0	Laporan	-1.0	\N	2024-04
4294577	2024-04-01	21	2872.0	55.0	2.0	Reviu HAMBK.PDAM Wonosobo	135138.0	PKPT-NG	2024-04
4326736	2024-04-19	7	1068.0	49.0	82.0	pembimbingan p3k	-3	\N	2024-04
4299065	2024-04-02	13	1770.0	50.0	247.0	Melaksanakan tugas pengelolaan arsip dan pengiriman surat	80249.0	PKAU-NG	2024-04
4321852	2024-04-18	8	1181.0	47.0	7.0	Membaca literatur	-1	\N	2024-04
4320465	2024-04-17	33	4268.0	37.0	2.0	menelusuri skor IEPK Kab.Buru	-1	\N	2024-04
4296701	2024-04-01	46	5222.0	35.0	2.0	Penyusunan Bahan Paparan Sesma: Proses Bisnis	79392.0	PKAU-NG	2024-04
4341542	2024-04-25	17	2189.0	57.0	7.0	Bimtek siskeudes	136246.0	PKPT-NG	2024-04
4356747	2024-04-30	43	5003.0	24.0	10.0	Entry meeting Dinas PU	136646.0	PKPT-NG	2024-04
4349314	2024-04-26	32	4209.0	24.0	10.0	Pengumpulan data terkait evaluasi jalan jembatan sultra	136048	PKPT-NG	2024-04
4306887	2024-04-04	25	3397.0	58.0	35.0	1.Verifikasi sppd rampung	-2.0	\N	2024-04
4305949	2024-04-03	30	3985.0	57.0	286.0	"Memproses surat menyurat dan penugasan melalui aplikasi MAP, SIMA, Sadewa.	\N	\N	2024-04
4334038	2024-04-23	5	919.0	54.0	83.0	Input surat	135135	PKPT-NG	2024-04
4300124	2024-04-02	28	2574.0	42.0	12.0	Mempelajari SPIP	-3	\N	2024-04
4315013	2024-04-16	28	3736.0	24.0	10.0	Pelaksanaan raker	135316	PKPT-NG	2024-04
4316931	2024-04-16	49	5493.0	24.0	10.0	menyusun rencana kegiatan	-1.0	\N	2024-04
4299205	2024-04-02	20	2648.0	50.0	7.0	Persiapan PKKN Cisumdawu	-1.0	\N	2024-04
4298752	2024-04-02	16	2048.0	56.0	183.0	Mengecek sarana dan prasarana gedung Kantor	-2.0	\N	2024-04
4356160	2024-04-30	22	2943.0	56.0	12.0	Persiapan penugasan berikutnya	-3.0	\N	2024-04
4359221	2024-04-30	49	5506.0	33.0	361.0	Layanan Umum	81150.0	PKAU-NG	2024-04
4307095	2024-04-04	17	2186.0	53.0	200.0	Pengawasan dan kegiatan lain di bidang umum	-2.0	\N	2024-04
4298611	2024-04-02	28	3797.0	45.0	12.0	Pelaksanaan Lapangan	134412	PKPT-NG	2024-04
4333627	2024-04-23	32	4206.0	28.0	10.0	penugasan AN	-1	\N	2024-04
4305198	2024-04-03	21	2898.0	35.0	3.0	Tugas rutin	-1.0	\N	2024-04
4294932	2024-04-01	10	1356.0	34.0	71.0	Gladi Rakorbinwasin 2024	-1	\N	2024-04
4313386	2024-04-05	14	1863.0	31.0	3.0	Membuat laporan pka	135167.0	PKPT-NG	2024-04
4323893	2024-04-19	14	1895.0	58.0	7.0	Mengawasi pelaksanaan reviu SOP	135600.0	PKPT-NG	2024-04
4349375	2024-04-26	40	3715.0	28.0	10.0	menyusun kka	-1	\N	2024-04
4359373	2024-04-30	47	5270.0	30.0	25.0	Mempelajari query cuti	-1.0	\N	2024-04
4328063	2024-04-22	12	1498.0	53.0	7.0	Mengikuti MCU	-1	\N	2024-04
4344873	2024-04-25	1	13	35.0	2.0	Diskusi	135613	PKPT-NG	2024-04
4350993	2024-04-28	49	5433.0	54.0	234.0	Pengumpulan bukti dukung pengawasan kearsipan	81074.0	PKAU-NG	2024-04
4324369	2024-04-19	21	2788.0	52.0	250.0	Perawatan mobil dinas kaper.h 18	-1.0	\N	2024-04
4308701	2024-04-04	47	5261.0	32.0	19.0	Monitoring skp	-1.0	\N	2024-04
4317523	2024-04-17	25	3397.0	58.0	35.0	Mengerjakan potongan gaji ASN bulan Mei 2024	-2.0	\N	2024-04
4320051	2024-04-17	15	1946.0	52.0	7.0	Mempelajari spip	-1.0	\N	2024-04
4343499	2024-04-25	7	1048.0	31.0	172.0	Arahan	75951	PKAU-NG	2024-04
4319592	2024-04-17	18	2372.0	33.0	41.0	Melakukan pengecekan arsip bidang	-2.0	\N	2024-04
4329226	2024-04-22	43	5048.0	25.0	10.0	Pengumpulan data	135591.0	PKPT-NG	2024-04
4320744	2024-04-18	12	1487.0	55.0	234.0	Mencatat, mendistribusikan surat surat masuk tata usaha	-2	\N	2024-04
4356421	2024-04-30	4	700.0	58.0	7.0	Mengikuti MCU di RS Persahabatan	136116.0	PKPT-NG	2024-04
4314516	2024-04-12	9	1258.0	33.0	176.0	- piket DC monitoring jaringan dan server	80317	PKAU-NG	2024-04
4357031	2024-04-30	25	3476.0	24.0	10.0	membuat skp	-2.0	\N	2024-04
4313106	2024-04-05	16	2133.0	25.0	10.0	Proses kka	134106.0	PKPT-NG	2024-04
4341323	2024-04-25	26	3553.0	60.0	7.0	Sosialisasi pilar dan parameter IEPK di wilayah Provinsi Kalimantan Selatan	-1.0	\N	2024-04
4322254	2024-04-18	23	3220.0	36.0	233.0	Bendahara	-1.0	\N	2024-04
4310805	2024-04-05	21	2714.0	53.0	52.0	"Melakukan tugas administrasi barang persediaan	\N	\N	2024-04
4317565	2024-04-17	5	805.0	55.0	11.0	Mencatat surat masuk dan surat keluar	-1	\N	2024-04
4304260	2024-04-03	36	4552	29	188.0	Melakukan pemberkasan bisma	-2	\N	2024-04
4348427	2024-04-26	17	1686.0	31.0	10.0	Evaluasi UMKM	135868.0	PKPT-NG	2024-04
4302411	2024-04-02	1	85	54.0	23.0	FGD app tw 2	134303	PKPT-NG	2024-04
4307798	2024-04-04	26	3519.0	53.0	20.0	nput perjadin dan PBJ di sakti dan  bisma	-1.0	\N	2024-04
4301344	2024-04-02	11	1391.0	59.0	7.0	Finalisasi rpp	-1	\N	2024-04
4323170	2024-04-18	8	1164.0	39.0	197.0	Verifikasi SPM LS	-2	\N	2024-04
4326631	2024-04-19	2	259	48.0	50.0	Mengikuti raker ipp	-1	\N	2024-04
4337719	2024-04-24	43	5001.0	24.0	10.0	MCU-Tes Psikologi	-1.0	\N	2024-04
4298660	2024-04-02	25	2699.0	59.0	7.0	Mengendalikan kegiatan pengawasan	132794.0	PKPT-NG	2024-04
4294614	2024-04-01	23	3098.0	48.0	271.0	Penugasan Rutin	-2.0	\N	2024-04
4332587	2024-04-23	23	3104.0	36.0	2.0	Tugas rutin kantor	-2.0	\N	2024-04
4351540	2024-04-29	23	3106.0	50.0	11.0	"1. Mengadministrasikan Surat Tugas.	\N	\N	2024-04
4314703	2024-04-16	12	1591.0	30.0	19.0	Melaksanakan tugas umum kepegawaian	-2	\N	2024-04
4297837	2024-04-01	47	4129.0	38.0	34.0	Pemrosesan surat jawaban sumut lampung konsrp kp juni 2024	-1.0	\N	2024-04
4366694	2024-05-03	41	4893.0	28.0	52.0	Updatinf Data Siman	-1.0	\N	2024-05
4383247	2024-05-11	48	5266.0	42.0	28.0	Finalisasi Konten Website Baru Setma dan BPKP	-1.0	\N	2024-05
4438823	2024-05-31	40	4807.0	27.0	16.0	Evaluasi	138740	Reguler-NG	2024-05
4440121	2024-05-31	40	4811.0	24.0	10.0	Melengkapi KKE	-2	\N	2024-05
4391717	2024-05-14	45	4186.0	34.0	2.0	Proses SPP Gaji Bulan Juni 2024	81354.0	PKAU-NG	2024-05
4367900	2024-05-03	17	1682.0	31.0	52.0	Menyelesaikan Transaksi Keuangan	-2.0	\N	2024-05
4402951	2024-05-17	45	1526.0	33.0	51.0	"- bug fixing esign espd	\N	\N	2024-05
4378198	2024-05-07	20	2623.0	36.0	21.0	Pencatatan data spj perjalanan dinas ks dalam aplikasi sakti	81542.0	PKAU-NG	2024-05
4428813	2024-05-29	35	4416	56	52.0	Melakukan Verifikasi kwitansi GU. 5 dan melakukan penataan SPM yg sudah terkirim ke KPPN jakarta IV.	-2	\N	2024-05
4382345	2024-05-09	24	3372.0	28.0	3.0	Evaluasi Keuangan dan Pembangunan Desa	-1.0	\N	2024-05
4384395	2024-05-12	16	2146.0	25.0	10.0	Lembur isu kesehatan dan hut bpkp	-1.0	\N	2024-05
4377282	2024-05-07	2	381	35.0	7.0	PIA Desain was PAUD Kemendikbud	135565	PKPT-NG	2024-05
4429242	2024-05-29	41	4887.0	28.0	41.0	Melakukan pengisian formulir audit sistem kearsipan internal tahun 2024	81462.0	PKAU-NG	2024-05
4409321	2024-05-20	3	557.0	55.0	96.0	Memberikan materi implementasi MR di Ditjend Bina Desa Kemendagri	-3.0	\N	2024-05
4388414	2024-05-13	30	4029.0	34.0	41.0	Pelayanan pengobatan pegawai BPKP	-1	\N	2024-05
4388497	2024-05-13	35	4495	37	2.0	Penyusunan kertas kerja	136911	PKPT-NG	2024-05
4426152	2024-05-28	7	1026.0	55.0	83.0	Memberikan arsip keuangan dikalahkan terampik dana star	-2	\N	2024-05
4403694	2024-05-17	39	4770.0	29.0	3.0	Menyusun laporan PAD Sulung	-1	\N	2024-05
4420740	2024-05-27	19	2444.0	38.0	2.0	Reviu VP 205 MRT	136648.0	Reguler-NG	2024-05
4363678	2024-05-02	42	4941.0	27.0	3.0	Rutinitas	-1.0	\N	2024-05
4365548	2024-05-03	9	1251.0	55.0	18.0	"- Monitoring server Nutanix	\N	\N	2024-05
4429300	2024-05-29	26	3585.0	23.0	10.0	reviu lap	136887.0	Reguler-NG	2024-05
4380421	2024-05-08	25	3449.0	47.0	199.0	Pengadministrasian berkas keuangan	-1.0	\N	2024-05
4364742	2024-05-03	34	4345	49	67.0	Supervisi penugasan di Merauke	136180	PKPT-NG	2024-05
4406657	2024-05-20	12	1582.0	37.0	2.0	Menyusun laporan evaluasi konservasi energi	-3	\N	2024-05
4436322	2024-05-30	23	3185.0	37.0	2.0	Siap laksanakan	-1.0	\N	2024-05
4378290	2024-05-07	17	1828.0	28.0	10.0	Evaluasi DD	136573.0	PKPT-NG	2024-05
4410502	2024-05-21	49	5510.0	56.0	38.0	Pembuatan layout denah penyimpanan Arsip Deputi Bidang PIP Polhukam,  Inspektorat dan Biro Keuangan di Record Center Cibubur BPKP, Bekasi	82600.0	PKAU-NG	2024-05
4385182	2024-05-13	14	249.0	51.0	48.0	Entry meeting	136296.0	PKPT-NG	2024-05
4419636	2024-05-26	33	4262.0	29.0	13.0	Lembur	-2	\N	2024-05
4363422	2024-05-02	22	3007.0	59.0	7.0	Supervisi tim	135993.0	PKPT-NG	2024-05
4379753	2024-05-08	35	4446	54	7.0	Melakukan supervisi evaluasi isu kewilayahan kesehatan Th  2024 pd Prov Banten	137030	PKPT-NG	2024-05
4399968	2024-05-16	17	2190.0	33.0	2.0	Evaluasi atas Pembangunan Infrastruktur Sistem Pengelolaan Air Limbah (SPAL) Domestik dan Persampahan sampai dengan Triwulan II Tahun 2024 pada BPPW dan Pemerintah Daerah Kabupaten Bengkulu Utara (PE.09.02/ST-179/PW06/2/2024).	\N	\N	2024-05
4373225	2024-05-06	16	2107.0	23.0	10.0	"Mintoring sima	\N	\N	2024-05
4367726	2024-05-03	13	1485.0	38.0	30.0	Mendampingi korwas berkoordinasi dengan penyidik Polda sumbar	-1.0	\N	2024-05
4383555	2024-05-11	19	2511.0	28.0	51.0	Mengupdate, membackup laporan/data dari website lama dan mempelajari website resmi BPKP Perwakilan Provinsi DKI Jakarta yang baru	-2.0	\N	2024-05
4411562	2024-05-21	28	3751.0	24.0	10.0	Rekap Kuisioner	136939	Reguler-NG	2024-05
4434536	2024-05-30	22	3045.0	37.0	2.0	Evaluasi spam diy	136733.0	Reguler-NG	2024-05
4435083	2024-05-30	7	1076.0	37.0	3.0	Mengajar	82450	PKAU-NG	2024-05
4363246	2024-05-02	35	4421	36	2.0	Persiapan penugasan akuntabilitas desa dan SPIP	136584	PKPT-NG	2024-05
4374796	2024-05-07	1	2	32.0	2.0	Penyusunan Konsep Inovasi	135451	PKPT-NG	2024-05
4364168	2024-05-02	5	913.0	34.0	2.0	Proper pim 1 pimpinan	-1	\N	2024-05
4399082	2024-05-16	14	1864.0	35.0	206.0	Update data realisasi anggaran tahun 2024	-2.0	\N	2024-05
4414340	2024-05-22	20	2538.0	59.0	7.0	Cek fisik SD 2 cibeureum	137434.0	Reguler-NG	2024-05
4394441	2024-05-15	46	5198.0	38.0	2.0	"1. Mengikuti piloting tools assesment kompetensi teknis	\N	\N	2024-05
4414693	2024-05-22	19	2409.0	57.0	62.0	Mengikuti zoom Rakornaswasin 2024	-1.0	\N	2024-05
4405512	2024-05-19	49	5429.0	52.0	183.0	"1.  Melaksanakan Tugas Rutin.	\N	\N	2024-05
4385575	2024-05-13	5	832.0	58.0	7.0	Asistensi Penilaian Risiko Pembangunan Nasional atas FFS pada BUMN	136612	PKPT-NG	2024-05
4430084	2024-05-29	16	2148.0	56.0	2.0	Penyusan konsep laporan	138497.0	Reguler-NG	2024-05
4383943	2024-05-12	2	286	57.0	13.0	Melakukan pembenahan arsip	-2	\N	2024-05
4389581	2024-05-14	9	1229.0	28.0	51.0	Dokumentasi kegiatan kepala perwakilan dengan ojk dan bi, pila dan upload dokumentasi kegiatan dari tanggal 12-14 mei 2024	-1	\N	2024-05
4381092	2024-05-08	4	746.0	35.0	2.0	........	-1.0	\N	2024-05
4382471	2024-05-09	34	4383	25	10.0	Lembur TL investigasi	81979	PKAU-NG	2024-05
4408076	2024-05-20	47	5292.0	34.0	115.0	"Memproses SK Kenaikan Jabatan Pranata SDM Aparatur 4 orang	\N	\N	2024-05
4393474	2024-05-15	1	68	49.0	7.0	Supervisi audit Upland	136197	PKPT-NG	2024-05
4431032	2024-05-29	15	1960.0	24.0	10.0	"Mengikuti Gmeet AQ Pusat terkait MRPN	\N	\N	2024-05
4438953	2024-05-31	7	1082.0	59.0	168.0	Menyiapkan bahan ajar	-2	\N	2024-05
4365076	2024-05-03	39	4758.0	28.0	3.0	Diklat JFA	-1	\N	2024-05
4380567	2024-05-08	21	2827.0	34.0	2.0	mengikuti workshop spip	-2.0	\N	2024-05
4362726	2024-05-02	2	318	34.0	3.0	Penyusunan panduan tematik	-2	\N	2024-05
4367644	2024-05-03	20	2590.0	60.0	161.0	"1.Manajerial korwas	\N	\N	2024-05
4377277	2024-05-07	1	23	47.0	2.0	Konfirmasi dng transporte pt jpl dan pt dnr di kantor bulog	134448	PKPT-NG	2024-05
4434540	2024-05-30	17	2209.0	35.0	3.0	Hut dan kj	-2.0	\N	2024-05
4368756	2024-05-04	20	2523.0	56.0	11.0	Jalan	-1.0	\N	2024-05
4416364	2024-05-22	45	5144.0	35.0	309.0	Tersusunnya dipa bpkp	-1.0	\N	2024-05
4393076	2024-05-15	27	3699.0	37.0	16.0	Evaluasi Ketapang SC Tabanan	-1	\N	2024-05
4421855	2024-05-27	26	3591.0	25.0	10.0	belajar penugasan pembiayaan	-2.0	\N	2024-05
4373124	2024-05-06	1	29	25.0	10.0	Pengumpulan data	136153	PKPT-NG	2024-05
4398848	2024-05-16	27	3665.0	46.0	52.0	"Menginput ST di bisma	\N	\N	2024-05
4388783	2024-05-14	17	2185.0	52.0	73.0	Melaksanakan tugas rutin subkor keuangan	-2.0	\N	2024-05
4420909	2024-05-27	43	5033.0	34.0	26.0	Penyiapan data revisi halaman 3 dipa	-1.0	\N	2024-05
4434003	2024-05-30	12	1609.0	25.0	10.0	Pemyusunan SHP	137309	Reguler-NG	2024-05
4361265	2024-05-02	20	2576.0	53.0	2.0	Melaksanakan tugas rutin bidang P3A dan memgikuti pembukaan raker BPKP	-1.0	\N	2024-05
4410443	2024-05-21	4	720.0	40.0	2.0	Evaluasi Jalan Tol PT HK	137631.0	Reguler-NG	2024-05
4423606	2024-05-27	36	3356	34	2.0	entry meeting mrpn kota batam	139126	Reguler-NG	2024-05
4388628	2024-05-13	28	3791.0	24.0	10.0	pemda	136937	PKPT-NG	2024-05
4428480	2024-05-29	21	2845.0	56.0	2.0	Inventarisir data2 yg masih kurang	136870.0	Reguler-NG	2024-05
4378237	2024-05-07	13	1781.0	33.0	2.0	Bimtek	-1.0	\N	2024-05
4394569	2024-05-15	16	2085.0	27.0	3.0	Membaca peraturan	-1.0	\N	2024-05
4423695	2024-05-27	37	800.0	35.0	2.0	Entry meeting att sawit	137150	Investigasi-NG	2024-05
4394755	2024-05-15	5	857.0	49.0	7.0	Reviu	135816	PKPT-NG	2024-05
4373237	2024-05-06	14	1918.0	25.0	10.0	Menyusun Kertas Kerja	-1.0	\N	2024-05
4403607	2024-05-17	3	582.0	25.0	10.0	Mandiri	82195.0	PKAU-NG	2024-05
4369870	2024-05-05	21	2842.0	53.0	15.0	SK PAK DLL	-1.0	\N	2024-05
4406454	2024-05-20	22	3022.0	48.0	12.0	Peninjauan lapangan	136548.0	PKPT-NG	2024-05
4397020	2024-05-16	21	2749.0	42.0	175.0	Troubleshooting jaringan	-2.0	\N	2024-05
4419377	2024-05-25	4	664.0	23.0	10.0	Meeting hut 41	82703.0	PKAU-NG	2024-05
4367961	2024-05-03	6	980.0	58.0	2.0	Melaksanakan tugas sesuai ST	80692	PKAU-NG	2024-05
4439445	2024-05-31	3	474.0	24.0	10.0	Validasi KKE	-1.0	\N	2024-05
4420154	2024-05-27	14	1935.0	36.0	2.0	Mengisi Kertas Kerja Evaluasi (KKE)	137222.0	Reguler-NG	2024-05
4439003	2024-05-31	16	2149.0	38.0	3.0	Revisi	138400.0	Reguler-NG	2024-05
4379716	2024-05-08	32	2385.0	36.0	2.0	Pengumpulan data	136557	PKPT-NG	2024-05
4378815	2024-05-08	22	2958.0	50.0	11.0	Terima surat masuk	-2.0	\N	2024-05
4424680	2024-05-28	26	3086.0	50.0	2.0	Koordinasi dg P3AP2KB Sleman	138534.0	Reguler-NG	2024-05
4365445	2024-05-03	23	3198.0	34.0	2.0	......	136801.0	PKPT-NG	2024-05
4376427	2024-05-07	19	2491.0	48.0	177.0	Memproses pembayaran gaji pegawai bulan Juni 2024	-2.0	\N	2024-05
4429645	2024-05-29	42	4936.0	35.0	16.0	Evaluasi Kinerja	136552.0	Reguler-NG	2024-05
4373807	2024-05-06	22	3054.0	52.0	28.0	"Meliput pelantikan korwas dan subkor.	\N	\N	2024-05
4400709	2024-05-17	20	2644.0	38.0	2.0	Evaluasi di lapangan	136627.0	PKPT-NG	2024-05
4429674	2024-05-29	33	3958.0	29.0	10.0	Evaluasi spal spam	137409	Reguler-NG	2024-05
4460205	2024-06-07	5	809.0	56.0	136.0	Melakukan audit klaim	-2	\N	2024-06
4505610	2024-06-25	35	242	51	2.0	LC: corporate branding	-1	\N	2024-06
4444728	2024-06-03	20	2576.0	53.0	2.0	Mengikuti Sosialisasi teknis PM AKIP dan Finalisasi calon peserta Fiklat PM AKIP	-1.0	\N	2024-06
4518243	2024-06-28	1	117	37.0	16.0	Perhitungan audit	136924	Reguler-NG	2024-06
4519858	2024-06-28	23	3113.0	58.0	7.0	Penyembuhan pasca operasi mata	-1.0	\N	2024-06
4510476	2024-06-26	28	3798.0	23.0	10.0	Penyusunan Laporan Kinerja	84652	PKAU-NG	2024-06
4483232	2024-06-14	33	4267.0	24.0	10.0	kerja	-1	\N	2024-06
4488821	2024-06-19	22	3034.0	56.0	2.0	Menganalisis data yg diterima/diinput inspektorat di aplikasi siera	140236.0	Reguler-NG	2024-06
4449286	2024-06-04	10	1335.0	44.0	28.0	Mengolah data	-2	\N	2024-06
4515703	2024-06-27	23	3161.0	34.0	16.0	Budaya kerja	-1.0	\N	2024-06
4449189	2024-06-04	38	3463.0	35.0	2.0	Laporan pelabuhan Bima	139154	Reguler-NG	2024-06
4473958	2024-06-11	49	5480.0	28.0	10.0	Evaluasi	81284.0	PKAU-NG	2024-06
4502370	2024-06-24	37	4579.0	24.0	20.0	Memverifikasi berkas SPJ	-2	\N	2024-06
4469942	2024-06-11	7	1084.0	44.0	18.0	Diklat mrosp kemenag	83998	PKAU-NG	2024-06
4443863	2024-06-03	25	3481.0	34.0	2.0	Mengerjakan tugas	139189.0	Investigasi-NG	2024-06
4499908	2024-06-22	15	1983.0	35.0	177.0	Anggaran	-2.0	\N	2024-06
4479024	2024-06-13	34	1689	30	193.0	Kehumasan	-2	\N	2024-06
4488757	2024-06-19	32	4035.0	34.0	2.0	Evtakel BLUD RSUD Bahteramas	140195	Reguler-NG	2024-06
4490915	2024-06-19	35	2087	32	3.0	Kompilasi pembiayaan daerah	-1	\N	2024-06
4517947	2024-06-28	23	3253.0	36.0	2.0	Pengumpulan data Laporan Eksekutif Daerah Semester 1 2024	140162.0	Reguler-NG	2024-06
4484027	2024-06-14	17	2261.0	34.0	26.0	Puldata	-2.0	\N	2024-06
4489746	2024-06-19	20	2583.0	55.0	105.0	Verifikasi	83376.0	PKAU-NG	2024-06
4460761	2024-06-07	21	2708.0	38.0	2.0	Validasi aplikasi SiLPPD	138672.0	Reguler-NG	2024-06
4469555	2024-06-10	2	350	50.0	62.0	monitoring penugasan  pada mitra bidangan penanganan bencana	-2	\N	2024-06
4441184	2024-06-01	21	2719.0	58.0	7.0	Upacara hari Lahir Pancasila, 1 Juni 2024	-1.0	\N	2024-06
4456161	2024-06-06	19	2456.0	28.0	188.0	Koordinasi	83773.0	PKAU-NG	2024-06
4471774	2024-06-11	44	5122.0	25.0	10.0	Buat SHP	-1.0	\N	2024-06
4490419	2024-06-19	4	691.0	24.0	10.0	Piloting pedoman app	140125.0	Reguler-NG	2024-06
4503552	2024-06-24	16	2086.0	24.0	10.0	Telaah	-1.0	\N	2024-06
4505587	2024-06-25	1	191	34.0	2.0	monitoring	139736	Reguler-NG	2024-06
4482940	2024-06-14	20	2537.0	55.0	12.0	Bimtek SPIPT Kota Cimahi	140816.0	Reguler-NG	2024-06
4462586	2024-06-07	37	4594.0	24.0	10.0	Menyusun SHP	-1	\N	2024-06
4475086	2024-06-12	19	2507.0	34.0	3.0	Evaluasi Kinerja PAM	-2.0	\N	2024-06
4469436	2024-06-10	46	5191.0	39.0	30.0	Done narsum	83062.0	PKAU-NG	2024-06
4494355	2024-06-20	29	3874.0	36.0	2.0	Tator dl 4	140987	Reguler-NG	2024-06
4488631	2024-06-19	1	75	60.0	7.0	Finalisasi shp ikn upload ke simax	137797	Reguler-NG	2024-06
4507222	2024-06-25	39	4757.0	25.0	10.0	Pengumpulan data	-1	\N	2024-06
4520344	2024-06-28	21	2825.0	58.0	2.0	Perbaikan lap AI UPK	-1.0	\N	2024-06
4486855	2024-06-16	25	3495.0	32.0	134.0	Dukungan layanan umum	-1.0	\N	2024-06
4489013	2024-06-19	5	835.0	50.0	7.0	Mereviu shp ATT Sawit	135012	Investigasi-NG	2024-06
4441372	2024-06-01	20	2658.0	37.0	2.0	Upacara harlah Pancasila dan persiapan famgath	-1.0	\N	2024-06
4493878	2024-06-20	44	5096.0	24.0	10.0	papbj	140248.0	Reguler-NG	2024-06
4493114	2024-06-20	33	4241.0	24.0	10.0	Penyusunan ST	-1	\N	2024-06
4469102	2024-06-10	49	5435.0	39.0	360.0	Pemeliharaan	82607.0	PKAU-NG	2024-06
4486036	2024-06-14	47	5327.0	31.0	329.0	Meriviu sjt	83608.0	PKAU-NG	2024-06
4479934	2024-06-13	31	4083.0	54.0	7.0	EL Madya	-1	\N	2024-06
4458549	2024-06-06	2	274	28.0	3.0	Laporan mrpn	137824	Reguler-NG	2024-06
4458255	2024-06-06	20	2667.0	53.0	7.0	SHP Evaluasi Pembiayaan	138523.0	Reguler-NG	2024-06
4508662	2024-06-25	11	1423.0	28.0	41.0	Sekretaris Bidang IPP	-1	\N	2024-06
4463891	2024-06-08	21	2902.0	57.0	249.0	Famgath	-1.0	\N	2024-06
4510138	2024-06-26	2	357	55.0	13.0	Sekretaris	-2	\N	2024-06
4493641	2024-06-20	22	3024.0	29.0	41.0	input arsip apd	83662.0	PKAU-NG	2024-06
4461890	2024-06-07	18	2284.0	34.0	3.0	Analisis teo 2	139226.0	Reguler-NG	2024-06
4461416	2024-06-07	44	5120.0	37.0	12.0	Laporan	-1.0	\N	2024-06
4499001	2024-06-21	34	4329	38	291.0	Raker	141163	Reguler-NG	2024-06
4516436	2024-06-27	11	220.0	32.0	3.0	Pengumpulan data	85005	PKAU-NG	2024-06
4512646	2024-06-26	30	4012.0	37.0	2.0	wokshop desa	-1	\N	2024-06
4483299	2024-06-14	33	2388.0	35.0	3.0	Menyusun laporan	-1	\N	2024-06
4484214	2024-06-14	21	2847.0	49.0	12.0	Kegiatan rutin	138633.0	Reguler-NG	2024-06
4508409	2024-06-25	4	641.0	24.0	10.0	Mengerjakan tugas	-1.0	\N	2024-06
4444661	2024-06-03	34	4370	35	2.0	Melengkapi Dokumen Penugasan yang sebelumnya	-1	\N	2024-06
4516557	2024-06-27	16	2175.0	34.0	2.0	perencanaan penugasan	-1.0	\N	2024-06
4498260	2024-06-21	37	4631.0	36.0	2.0	Penyusunan Lapgub	-1	\N	2024-06
4494104	2024-06-20	23	3250.0	38.0	3.0	Perbaiki revisi laporan	-1.0	\N	2024-06
4490141	2024-06-19	36	1145	29	41.0	Penyelesaian mooc	83996	PKAU-NG	2024-06
4523171	2024-06-30	43	5041.0	41.0	2.0	Menyusun draft laporan gubernur	140429.0	Reguler-NG	2024-06
4475111	2024-06-12	26	3537.0	24.0	10.0	Mengkoordinasikan tempat acara bu deputi, menyelesaikan laporan	139122.0	Reguler-NG	2024-06
4441644	2024-06-01	39	4756.0	31.0	41.0	Mengikuti upacara kelahiran pancasila	-1	\N	2024-06
4515350	2024-06-27	4	720.0	40.0	2.0	Analisis Data	139121.0	Reguler-NG	2024-06
4506378	2024-06-25	29	3946.0	53.0	73.0	Konsep LK Neraca, LO, LPE, LRA semester 1 thn 2024	-2	\N	2024-06
4492834	2024-06-20	23	3164.0	35.0	2.0	Bikin ppt	139593.0	Reguler-NG	2024-06
4514608	2024-06-27	38	4689.0	26.0	188.0	SPK hotel dan infografis SKM PERIODE 2023	-1	\N	2024-06
4462271	2024-06-07	19	2467.0	54.0	18.0	Studi banding di Pusdiklatwas BPKP Ciawi Bogor	83443.0	PKAU-NG	2024-06
4453647	2024-06-05	20	1972.0	57.0	7.0	Membuat laporan telaahan	-2.0	\N	2024-06
4444225	2024-06-03	34	4385	37	30.0	Menyusun LHP	138110	Investigasi-NG	2024-06
4442972	2024-06-02	44	5069.0	28.0	231.0	Melakukan pengawasan kearsipan internal	-1.0	\N	2024-06
4513977	2024-06-27	27	3639.0	35.0	2.0	Evaluasi blu rs sanglah	-1	\N	2024-06
4475862	2024-06-12	10	1339.0	47.0	7.0	Melaksanakan kajian	-2	\N	2024-06
4488041	2024-06-19	43	5026.0	29.0	51.0	Kegiatan pranata komputer	-1.0	\N	2024-06
4447660	2024-06-04	28	3294.0	53.0	34.0	Reviu laporan	137543	Reguler-NG	2024-06
4479015	2024-06-13	33	4230.0	24.0	10.0	olah data	-1	\N	2024-06
4450818	2024-06-04	24	3366.0	28.0	3.0	Revisi laporan	-1.0	\N	2024-06
4494952	2024-06-20	42	2268.0	37.0	12.0	Bimtek	-1.0	\N	2024-06
4448172	2024-06-04	7	1072.0	50.0	52.0	Layanan operasional mess	-2	\N	2024-06
4509372	2024-06-26	20	2525.0	60.0	7.0	Perbaikan konsep laporan bimtek.	-2.0	\N	2024-06
4475965	2024-06-12	4	676.0	36.0	3.0	Evaluasi supply chain pada ptpn	138412.0	Reguler-NG	2024-06
4490714	2024-06-19	12	1547.0	58.0	200.0	melakukan koordinasi dan supervisi bagian umum	-2	\N	2024-06
4491689	2024-06-20	17	2187.0	52.0	28.0	melaksanakan tugas rutin di bagian umum	-2.0	\N	2024-06
4446070	2024-06-03	2	279	27.0	10.0	Spbe kominfo 2024	-1	\N	2024-06
4489512	2024-06-19	19	2424.0	36.0	3.0	Mengolah Data	140822.0	Investigasi-NG	2024-06
4450970	2024-06-04	1	111	23.0	10.0	pembuatan kertas kerja	137573	Reguler-NG	2024-06
4509406	2024-06-26	23	3127.0	57.0	12.0	Mengumpulkan Data	84835.0	PKAU-NG	2024-06
4497442	2024-06-21	16	2084.0	24.0	10.0	Kerja	-1.0	\N	2024-06
4509087	2024-06-25	43	5060.0	30.0	189.0	Monitoring	-1.0	\N	2024-06
4518896	2024-06-28	27	3703.0	58.0	11.0	Update absen, melaksanakan tugas kesekretarisan	-2	\N	2024-06
4449019	2024-06-04	5	806.0	58.0	7.0	Mempelajari BAP penyidik dan AHli  dari Bea Cukai	-1	\N	2024-06
4503147	2024-06-24	49	5501.0	56.0	370.0	Mengikuti kegiatan FGD Pembahasan Sinkronisasi Workplan dan Output Lintas Unit dalam Mendukung Pencapaian Target DMF STAR di Hotel Mercure Cikini	-2.0	\N	2024-06
4505678	2024-06-25	34	4389	43	2.0	Entry meeting Dinas P&K	-1	\N	2024-06
4497568	2024-06-21	14	1877.0	57.0	7.0	Supervisi	140672.0	Reguler-NG	2024-06
4518861	2024-06-28	29	3857.0	59.0	7.0	Penyiapan laporan	140407	Investigasi-NG	2024-06
4602207	2024-07-24	39	340.0	51.0	61.0	Koordinasi	-2	\N	2024-07
4609106	2024-07-26	33	4284	36	2.0	Ekspose panel jenjang 1 itkab wonogiri	142387	Reguler-NG	2024-07
4584348	2024-07-18	3	532.0	35.0	3.0	Mengerjakan balasan surat BPK	-1.0	\N	2024-07
4602871	2024-07-25	42	4387.0	34.0	26.0	Melaksanakan Tugas sebagai PPSPM	-1.0	\N	2024-07
4615478	2024-07-29	22	2972.0	35.0	2.0	pelakaanaan	145144.0	Reguler-NG	2024-07
4595016	2024-07-23	1	18	56.0	11.0	melakukan kegiatan pemrosesan penyelesaian dan pengarsipan Surat Tugas Cosheet SPPD pada Direktorat ITRP	-2	\N	2024-07
4586131	2024-07-19	29	3951.0	37.0	71.0	Membantu mengawasi peserta Diklat	-1	\N	2024-07
4525850	2024-07-01	23	3158.0	35.0	3.0	Rutin	-1.0	\N	2024-07
4527108	2024-07-01	2	312	37.0	2.0	Melakukan penugasan	-1	\N	2024-07
4526096	2024-07-01	22	3012.0	37.0	21.0	Membuat spj operasional	140813.0	Reguler-NG	2024-07
4555133	2024-07-10	17	2235.0	60.0	7.0	Entry meeting	-2.0	\N	2024-07
4587115	2024-07-19	45	5154.0	34.0	177.0	Membantu proses SPM	85903.0	PKAU-NG	2024-07
4544549	2024-07-05	1	60	36.0	2.0	Rutin Kantor	-2	\N	2024-07
4575724	2024-07-16	22	433.0	34.0	3.0	Ujian uasbk	85664.0	PKAU-NG	2024-07
4577961	2024-07-17	43	5034.0	23.0	10.0	Bedah KKE	143313.0	Reguler-NG	2024-07
4588690	2024-07-19	1	179	40.0	34.0	Penelitian awal terkait reviu tata kelola industri udang naional	142782	Reguler-NG	2024-07
4597674	2024-07-23	20	2677.0	39.0	2.0	Penyusunan laporan	141751.0	Reguler-NG	2024-07
4540534	2024-07-04	31	4120.0	36.0	3.0	Persiapan sidang dugaan TPK	-1	\N	2024-07
4532668	2024-07-03	19	2508.0	38.0	2.0	Rangkum hasil kunjungan lapangan	-1.0	\N	2024-07
4585587	2024-07-19	46	5238.0	37.0	322.0	Kerja	86705.0	PKAU-NG	2024-07
4546525	2024-07-08	21	2722.0	53.0	13.0	Telah melaksanakan tugas	-2.0	\N	2024-07
4562015	2024-07-11	49	5451.0	48.0	363.0	Supervisi	-2.0	\N	2024-07
4594574	2024-07-22	1	215	39.0	41.0	Mendampingi Deputi Pembukaan Diklat	-1	\N	2024-07
4551317	2024-07-09	21	2847.0	49.0	12.0	Kegiatan rutin	-1.0	\N	2024-07
4624063	2024-07-31	36	4517	36	26.0	Laporan siswaskeudes	-2	\N	2024-07
4601365	2024-07-24	22	2970.0	37.0	2.0	Persiapan penugasan	-1.0	\N	2024-07
4582294	2024-07-18	20	2627.0	57.0	2.0	Melaksanakan kegiatan rutin kantor	-1.0	\N	2024-07
4548132	2024-07-08	12	1572.0	35.0	16.0	asdfg	-1	\N	2024-07
4547071	2024-07-08	28	3731.0	34.0	16.0	kantor	84652	PKAU-NG	2024-07
4544521	2024-07-05	18	2335.0	56.0	245.0	Menyelenggarakan layanan kepegawaian	-1.0	\N	2024-07
4560590	2024-07-11	9	1235.0	36.0	28.0	Juri penilaian app sheet	-2	\N	2024-07
4561984	2024-07-11	27	3663.0	40.0	16.0	Koordinasi data dan industri udang	-2	\N	2024-07
4550118	2024-07-08	12	1578.0	28.0	16.0	Eskalasi Inkis	141722	Investigasi-NG	2024-07
4536361	2024-07-03	13	1762.0	37.0	30.0	Konsultasi penghapusan BMN	85390.0	PKAU-NG	2024-07
4580229	2024-07-17	9	1258.0	33.0	176.0	"- monitoring server dan jaringan	\N	\N	2024-07
4595466	2024-07-23	43	5017.0	54.0	7.0	Melaksanakan tugas pengawasan	143869.0	Reguler-NG	2024-07
4619652	2024-07-30	37	4600.0	28.0	3.0	Menysuun kke	144411	Reguler-NG	2024-07
4567214	2024-07-13	29	3827.0	58.0	152.0	Persiapan Diklat SAKIP	-1	\N	2024-07
4621081	2024-07-31	34	4353	38	41.0	Kearsipan	-1	\N	2024-07
4531982	2024-07-02	35	4464	54	7.0	Pembahasan dg TB	-1	\N	2024-07
4581637	2024-07-18	34	4309	23	10.0	mengerjakan spj	-1	\N	2024-07
4526351	2024-07-01	37	3745.0	55.0	34.0	Rutin kantor	-1	\N	2024-07
4569703	2024-07-15	25	3441.0	25.0	10.0	menyusun draf LED	140628.0	Reguler-NG	2024-07
4559946	2024-07-11	30	4009.0	38.0	2.0	Analisis dokumen tindak lanjut	142739	Reguler-NG	2024-07
4556976	2024-07-10	10	642.0	37.0	107.0	Usabk	85762	PKAU-NG	2024-07
4528738	2024-07-02	43	5034.0	23.0	10.0	Mengisi Survei Bantuan Kedinasan	-1.0	\N	2024-07
4539544	2024-07-04	22	3060.0	37.0	2.0	Gmeet KKE manual SPIPT	140813.0	Reguler-NG	2024-07
4542217	2024-07-05	1	12	34.0	2.0	Melakukan perhitungan kke	136592	Reguler-NG	2024-07
4538566	2024-07-04	35	4435	52	2.0	Menyusun laporan	-1	\N	2024-07
4571145	2024-07-15	46	5225.0	37.0	2.0	LKj BPKP TW II	86705.0	PKAU-NG	2024-07
4553494	2024-07-09	17	2263.0	32.0	71.0	Rekap absen harian, input dana kerohiman,,konsep surat keluar,input arsip aktif	-1.0	\N	2024-07
4536857	2024-07-04	16	2056.0	34.0	16.0	kerja	-2.0	\N	2024-07
4554184	2024-07-09	3	520.0	58.0	86.0	Rapat staf	-1.0	\N	2024-07
4551591	2024-07-09	27	3646.0	35.0	2.0	mengerjakan ppt entry	-1	\N	2024-07
4610207	2024-07-26	18	2367.0	29.0	188.0	Input data pbj	-1.0	\N	2024-07
4563540	2024-07-12	43	5016.0	38.0	2.0	Reviu kerja sama dan tunggakan PT MOW	142474.0	Reguler-NG	2024-07
4592735	2024-07-22	28	3089.0	34.0	2.0	Menyusun konsep laporan	143046	Reguler-NG	2024-07
4603251	2024-07-25	23	3134.0	49.0	2.0	Menyelesaikan penugasan evkin BLUD RSUD Ibnu Sina	142749.0	Reguler-NG	2024-07
4555400	2024-07-10	34	1689	30	193.0	lapgub	-3	\N	2024-07
4576769	2024-07-16	49	5492.0	26.0	188.0	Melaksanakan pekerjaan pemelihraan	-1.0	\N	2024-07
4526154	2024-07-01	5	819.0	35.0	2.0	Laporan	-1	\N	2024-07
4614220	2024-07-29	48	5376.0	29.0	193.0	Membuat manajemen isu	-2.0	\N	2024-07
4611930	2024-07-28	28	3780.0	58.0	283.0	Menyapu	-1	\N	2024-07
4558865	2024-07-11	49	5530.0	56.0	183.0	Tehnisi elektrical	-2.0	\N	2024-07
4529441	2024-07-02	25	3479.0	28.0	10.0	menyusun kk	-1.0	\N	2024-07
4538954	2024-07-04	2	276	27.0	3.0	KAPIP	-1	\N	2024-07
4559856	2024-07-11	3	464.0	48.0	7.0	Menyusun draft pedoman analisis fiskal dan kinerja keuangan daerah	-2.0	\N	2024-07
4586956	2024-07-19	19	2418.0	36.0	2.0	Bimtek iepk pemda dki	140932.0	Investigasi-NG	2024-07
4579540	2024-07-17	21	2911.0	28.0	19.0	Rekap st diklat penjejanganndan substantif	85818.0	PKAU-NG	2024-07
4613736	2024-07-29	28	3717.0	28.0	3.0	Evaluasi kap apip matim	-2	\N	2024-07
4605950	2024-07-25	12	1660.0	36.0	2.0	Kerja harian	141002	Investigasi-NG	2024-07
4549333	2024-07-08	2	326	29.0	51.0	Sosialisasi prakom	-1	\N	2024-07
4601333	2024-07-24	2	289	38.0	2.0	Penyusunan pedoman pendidikan	141933	Reguler-NG	2024-07
4619545	2024-07-30	37	4637.0	34.0	134.0	Monitoring surat masuk dan keluar	-2	\N	2024-07
4586650	2024-07-19	25	3421.0	52.0	7.0	Penyusunan laporan eksekutif daerah Sem 1	140628.0	Reguler-NG	2024-07
4612406	2024-07-29	23	3096.0	54.0	7.0	Supervisi rim	142767.0	Reguler-NG	2024-07
4602665	2024-07-24	3	453.0	35.0	13.0	Input sadewa, routing approval, filling mailing, pengarsipan	-2.0	\N	2024-07
4529172	2024-07-02	31	4047.0	23.0	10.0	Paparan ppm forsa bumdes	140459	Reguler-NG	2024-07
4582242	2024-07-18	39	4726.0	39.0	12.0	Anisis identifikai kerjaan tugas peebqntjN	-1	\N	2024-07
4558142	2024-07-10	14	1902.0	36.0	2.0	pengumpulan data dan informasi tata kelola industri udang	140672.0	Reguler-NG	2024-07
4570291	2024-07-15	21	2865.0	58.0	12.0	Mempersiapkan penugasan Suplay Chain prov jawa tengah	-1.0	\N	2024-07
4587935	2024-07-19	13	1725.0	56.0	7.0	SPIP Kota Padang	134814.0	Reguler-NG	2024-07
4590475	2024-07-22	1	143	55.0	7.0	Rapat dgn direktorat prasarana strategis	141620	Reguler-NG	2024-07
4545238	2024-07-06	39	4761.0	23.0	10.0	Penyusunan design lapgub	140281	Reguler-NG	2024-07
4549358	2024-07-08	39	4780.0	24.0	10.0	telaah	142444	Investigasi-NG	2024-07
4524147	2024-07-01	3	461.0	36.0	2.0	Penyusunan rencana penugasan OPAD 2024	-1.0	\N	2024-07
4524585	2024-07-01	29	3934.0	34.0	2.0	Rapat ipp	-1	\N	2024-07
4571084	2024-07-15	2	276	27.0	3.0	TUGAS	-1	\N	2024-07
4588995	2024-07-19	40	4844.0	30.0	52.0	Rekonsiliasi laporan keuangan semester I tahun 2024	86265	PKAU-NG	2024-07
4576840	2024-07-17	40	4800.0	49.0	2.0	Evaluasi atas Hasil Penilaian Mandiri Kapabilitas APIP pada Inspektorat Kabupaten Mamuju	142573	Reguler-NG	2024-07
4531448	2024-07-02	10	1292.0	34.0	2.0	Koordinasi Penyusunan Podcast	85571	PKAU-NG	2024-07
4607284	2024-07-25	18	2362.0	58.0	7.0	Evaluasi penilaian maturitas spip terintegrasi pd pem kab pesbar	142610.0	Reguler-NG	2024-07
4554934	2024-07-10	21	2716.0	53.0	2.0	Mengerjakan tugas kantor	-2.0	\N	2024-07
4575788	2024-07-16	20	2633.0	56.0	2.0	Menghitung item item pekwrjaa. Timpang	142490.0	Investigasi-NG	2024-07
4581439	2024-07-18	2	355	35.0	3.0	Evaluasi spip bsn	143471	Reguler-NG	2024-07
4543031	2024-07-05	22	3032.0	59.0	7.0	reviu segmen	83723.0	PKAU-NG	2024-07
4597466	2024-07-23	9	1250.0	29.0	51.0	"1. Mengisi data csm	\N	\N	2024-07
4601732	2024-07-24	23	3199.0	51.0	105.0	Mengadministrasi SPJ barang dan SPJ SPPD	-1.0	\N	2024-07
4536643	2024-07-04	27	2698.0	57.0	15.0	Monitoring Diklat n pekerjaan kepegawaian	85114	PKAU-NG	2024-07
4544705	2024-07-06	23	3222.0	38.0	2.0	Diklat Auditor Madya	85153.0	PKAU-NG	2024-07
4678114	2024-08-16	2	278	23.0	10.0	Pedoman APP	-1	\N	2024-08
4701949	2024-08-26	42	4929.0	23.0	10.0	Evaluasi penilaian mandiri kapabilitas apip tahun 2024	-1.0	\N	2024-08
4689904	2024-08-21	15	1977.0	47.0	250.0	Rekap potongan tukin	-1.0	\N	2024-08
4714471	2024-08-29	20	2581.0	29.0	3.0	mengisi kk	144134.0	Reguler-NG	2024-08
4645830	2024-08-07	10	1301.0	35.0	2.0	Menyusun draft pedoman laporan evaluasi tematik	-1	\N	2024-08
4627538	2024-08-01	23	3283.0	26.0	71.0	"Membuat sprin-63	\N	\N	2024-08
4634889	2024-08-05	16	2063.0	56.0	2.0	Melaksanakan cek fisik ke sekolah di kab. Oki	144479.0	Reguler-NG	2024-08
4647453	2024-08-08	47	5250.0	57.0	15.0	Memproses kenaikan pangkat pns per 1 Oktober 2024	87637.0	PKAU-NG	2024-08
4687350	2024-08-20	20	2527.0	60.0	7.0	Monitoring BUMDESA	-1.0	\N	2024-08
4655573	2024-08-10	34	4320	23	10.0	Mengerjakan kke	-1	\N	2024-08
4714390	2024-08-29	25	3417.0	56.0	7.0	Evaluasi Ketapang	143129.0	Investigasi-NG	2024-08
4683165	2024-08-19	47	5360.0	37.0	344.0	Reviu	-2.0	\N	2024-08
4634597	2024-08-04	34	4361	24	10.0	Mengisi KKE	144185	Reguler-NG	2024-08
4672551	2024-08-15	44	5083.0	23.0	10.0	SPIP dan Desa	88288.0	PKAU-NG	2024-08
4645233	2024-08-07	11	1470.0	59.0	7.0	Melakukan supervisi penugasan	144852	Reguler-NG	2024-08
4673293	2024-08-15	49	5429.0	52.0	183.0	"1. Melaksanakan tugas rutin	\N	\N	2024-08
4711920	2024-08-28	18	2336.0	52.0	11.0	Melakukan kordinasi dengan petugas kebersihan ruangan dan halaman kantor dalam situasi aman kondusif	-1.0	\N	2024-08
4693004	2024-08-22	17	2193.0	55.0	78.0	Koordinasi pengawasan	89300.0	PKAU-NG	2024-08
4640468	2024-08-06	31	4102.0	56.0	105.0	Membuat daftar uang makan bulan Juli tahun 2024	-2	\N	2024-08
4632441	2024-08-02	27	3394.0	41.0	2.0	Spip kota denpasar	-1	\N	2024-08
4689446	2024-08-21	25	3451.0	29.0	16.0	Evkin unmul	146617.0	Reguler-NG	2024-08
4679303	2024-08-17	18	2375.0	37.0	26.0	Mengoordinasikan pelaksanaan kegiatan di Subbagian Keuangan	-1.0	\N	2024-08
4639071	2024-08-05	1	67	24.0	10.0	Site visit	144664	Reguler-NG	2024-08
4692039	2024-08-21	23	3274.0	36.0	3.0	menyusun kertas kerja	146214.0	Reguler-NG	2024-08
4660272	2024-08-12	3	499.0	35.0	2.0	Penyusunan laporan ws bangka selatan	-2.0	\N	2024-08
4676739	2024-08-16	5	878.0	37.0	2.0	Analisis	88917	PKAU-NG	2024-08
4689556	2024-08-21	39	4758.0	28.0	3.0	pelaksanaan evaluasi	146438	Reguler-NG	2024-08
4677351	2024-08-16	47	5281.0	37.0	330.0	Cek sop	87033.0	PKAU-NG	2024-08
4667643	2024-08-14	21	2916.0	38.0	26.0	Mengkoordinir tugas-tugas keuangan	87879.0	PKAU-NG	2024-08
4700651	2024-08-25	24	3314.0	54.0	18.0	Lembur Subkoordinator Keuangan	89419.0	PKAU-NG	2024-08
4672307	2024-08-15	5	828.0	26.0	10.0	app dan iepk	143357	Reguler-NG	2024-08
4647427	2024-08-08	22	3076.0	33.0	3.0	Eval aneka usaha	144434.0	Reguler-NG	2024-08
4705964	2024-08-27	43	4983.0	26.0	10.0	Pengawasan	146243.0	Investigasi-NG	2024-08
4644247	2024-08-07	30	3970.0	54.0	11.0	Keber	-2	\N	2024-08
4678669	2024-08-17	31	4107.0	55.0	200.0	Upacara 17 Agustus 2024	-1	\N	2024-08
4641744	2024-08-06	32	4190.0	52.0	48.0	Evaluasi Bulog	144385	Reguler-NG	2024-08
4675315	2024-08-16	28	1683.0	31.0	3.0	Evaluasi	145006	Reguler-NG	2024-08
4676169	2024-08-16	22	3086.0	50.0	2.0	Koordinasi dg Dinkes DIY	145454.0	Reguler-NG	2024-08
4644614	2024-08-07	27	3688.0	38.0	2.0	Pengisian KKE Evaluasi Akuntabilitas Keuangan dan Pembangunan Desa	144653	Reguler-NG	2024-08
4663731	2024-08-13	15	2015.0	35.0	2.0	Evaluasi Kapabilitas apip Bungo	144785.0	Reguler-NG	2024-08
4661044	2024-08-12	4	687.0	35.0	2.0	Menyusun simpulan	140477.0	Reguler-NG	2024-08
4708467	2024-08-27	34	3988	53	53.0	Fgd papbj,diknas	145732	Reguler-NG	2024-08
4661347	2024-08-12	49	5478.0	38.0	366.0	Mengoordinasikan penugasan TUD	-3.0	\N	2024-08
4713629	2024-08-29	2	349	27.0	10.0	Monitoring atas Pembangunan Infrastruktur yang mendukung Transformasi Digital pada Kementerian Komunikasi dan Informatika	146342	Reguler-NG	2024-08
4625842	2024-08-01	22	3063.0	34.0	3.0	Monitoring	87888.0	PKAU-NG	2024-08
4648755	2024-08-08	4	609.0	49.0	7.0	"1) Reviu pelaksanaan evaluasi atas Tata Kelola Pupuk Nasional pd Pupuk Ind	\N	\N	2024-08
4650070	2024-08-08	23	3163.0	58.0	7.0	Evaluasi jenjang pertama Ngawi	143423.0	Reguler-NG	2024-08
4647474	2024-08-08	1	14	60.0	7.0	Persiapan penugasan	-1	\N	2024-08
4708207	2024-08-27	34	4303	50	12.0	Analisa Data Keuangan Pemda	146843	Reguler-NG	2024-08
4703951	2024-08-26	1	216	59.0	42.0	Mengikuti rapat manajemen D1	-1	\N	2024-08
4652258	2024-08-09	1	188	36.0	2.0	Evaluasi atas Penanganan Pasca Panen pada Kemenperin	143364	Reguler-NG	2024-08
4637607	2024-08-05	36	4518	29	3.0	Evkin bumd	145075	Reguler-NG	2024-08
4654261	2024-08-09	9	1210.0	58.0	18.0	@go home	-1	\N	2024-08
4671740	2024-08-15	18	2321.0	25.0	10.0	Evkin BUMD	145242.0	Reguler-NG	2024-08
4626291	2024-08-01	43	5049.0	30.0	3.0	Pengumpulan data dan pengisian kertas kerja	144515.0	Reguler-NG	2024-08
4681963	2024-08-19	23	3270.0	28.0	3.0	rekonsiliasi dan validasi progres pelaksanaan Perpres 80	144064.0	Reguler-NG	2024-08
4704434	2024-08-26	48	5399.0	29.0	13.0	Mengelola surat masuk dan surat keluar serta mendistribusikan surat	88663.0	PKAU-NG	2024-08
4689997	2024-08-21	25	3431.0	33.0	20.0	Verifikasi spj perjalanan dinas	-2.0	\N	2024-08
4707451	2024-08-27	37	4627.0	30.0	52.0	Menghadiri forum komunikasi umum	89275	PKAU-NG	2024-08
4638926	2024-08-05	2	276	27.0	3.0	CGAAA	145218	Reguler-NG	2024-08
4655739	2024-08-10	30	4006.0	29.0	13.0	Persiapan Budaya Kerja dalam rangka menyambut HUT Kemerdekaan RI ke-79 Tahun 2024	-1	\N	2024-08
4654115	2024-08-09	2	277	35.0	2.0	Evaluasi SPIP BIG	87960	PKAU-NG	2024-08
4721368	2024-08-31	44	5082.0	26.0	163.0	verifikasi spj	-1.0	\N	2024-08
4663095	2024-08-13	6	986.0	29.0	13.0	"- Penomoran ST	\N	\N	2024-08
4687391	2024-08-20	2	254	59.0	7.0	Paud hi bkkbn	145360	Reguler-NG	2024-08
4718073	2024-08-30	42	4937.0	26.0	10.0	Kertas Kerja	146779.0	Reguler-NG	2024-08
4711069	2024-08-28	40	4833.0	24.0	10.0	Menyusun kke	146320	Reguler-NG	2024-08
4643423	2024-08-07	5	805.0	55.0	11.0	Mencatat surat	-1	\N	2024-08
4634470	2024-08-04	15	1968.0	53.0	46.0	Menyelesaikan tugas tambahan	-1.0	\N	2024-08
4626819	2024-08-01	34	4344	51	12.0	penyusunlaplaporan kegiatan	-2	\N	2024-08
4667209	2024-08-14	25	3464.0	33.0	2.0	Pendidikan	145562.0	Reguler-NG	2024-08
4633506	2024-08-02	34	4308	24	10.0	senam	144219	Reguler-NG	2024-08
4631267	2024-08-02	20	2655.0	51.0	12.0	Menyusun KKA	144518.0	Investigasi-NG	2024-08
4693699	2024-08-22	26	3601.0	43.0	189.0	Input kwitansi pbj ke aplikasi bisma	-2.0	\N	2024-08
4697447	2024-08-23	1	98	30.0	3.0	Verifikasi dli sehat	146702	Reguler-NG	2024-08
4640047	2024-08-06	33	4274	56	152.0	Membuat daftar nominasi kenaikan pangkat TMT October 2024 dan upload pada owncloud BPKP	-1	\N	2024-08
4673790	2024-08-15	47	224.0	34.0	2.0	Melaksanakan tugas sebagai Tim Kawal BUMN pada Kementeria BUMN	-2.0	\N	2024-08
4672322	2024-08-15	26	3601.0	43.0	189.0	Input kwitansi ke aplikasi Bisma	-2.0	\N	2024-08
4711776	2024-08-28	20	2593.0	55.0	11.0	Surat tugas dll	87853.0	PKAU-NG	2024-08
4662136	2024-08-13	25	3473.0	26.0	10.0	kerja	-2.0	\N	2024-08
4703754	2024-08-26	23	3162.0	40.0	2.0	Penyusunan laporan dan rapat Mr dengan mkot	145854.0	Reguler-NG	2024-08
4638873	2024-08-05	44	5102.0	44.0	57.0	"Rapat pembahasan rencana pembinaan kontekstual SPIP	\N	\N	2024-08
4674328	2024-08-16	18	2303.0	53.0	7.0	Reviu tim	145311.0	Reguler-NG	2024-08
4717715	2024-08-30	16	2167.0	58.0	78.0	Opad provinsi	146797.0	Reguler-NG	2024-08
4647277	2024-08-07	1	128	39.0	2.0	Persiapan penugasan	-1	\N	2024-08
4642281	2024-08-06	49	5512.0	25.0	10.0	Revisi SOP	-1.0	\N	2024-08
4665197	2024-08-13	38	4689.0	26.0	188.0	Perbaikan laptop	-1	\N	2024-08
4644538	2024-08-07	32	4159.0	23.0	10.0	revisi laporan dan QA	-2	\N	2024-08
4710567	2024-08-28	29	3855.0	36.0	2.0	Menyusun kke pembinaan spip takalar dan pangkep	-2	\N	2024-08
4663713	2024-08-13	1	54	23.0	10.0	pembahasan notisi audit	145507	Reguler-NG	2024-08
4639265	2024-08-06	23	3095.0	52.0	2.0	Laporan	143856.0	Investigasi-NG	2024-08
4662679	2024-08-13	29	3921.0	24.0	10.0	Ujian	88556	PKAU-NG	2024-08
4626518	2024-08-01	25	3480.0	23.0	10.0	diskusi dengan obrik	143132.0	Investigasi-NG	2024-08
4720604	2024-08-30	22	2981.0	38.0	2.0	Rapat zi	89441.0	PKAU-NG	2024-08
4677650	2024-08-16	30	4025.0	36.0	2.0	Memperbaiki kke	143659	Investigasi-NG	2024-08
4635011	2024-08-05	21	2868.0	53.0	83.0	Penomoran surat keluar, st sima, pantau map sima bisma kaper, distribusi dokumen	-2.0	\N	2024-08
4661998	2024-08-13	29	3956.0	57.0	285.0	BKN Makassar	88289	PKAU-NG	2024-08
4648477	2024-08-08	44	5125.0	25.0	10.0	Evaluasi GRC BPR Bulungan	-1.0	\N	2024-08
4643235	2024-08-06	10	1323.0	34.0	2.0	Bekerja	-3	\N	2024-08
4634712	2024-08-05	25	3400.0	52.0	7.0	Reviu laporan ev PK apip	-1.0	\N	2024-08
4792971	2024-09-26	43	5012.0	33.0	16.0	Bimtek	149437.0	Reguler-NG	2024-09
4761664	2024-09-13	29	3822.0	53.0	254.0	Membuat sampul laporan menggandakan menjilid laporan bidang APD AN IPP keuangan dan P3A	-2	\N	2024-09
4795357	2024-09-26	12	1632.0	37.0	2.0	Rencana pembinaan APIP	-1.0	\N	2024-09
4779687	2024-09-20	11	1392.0	58.0	12.0	Kerja	147559	Reguler-NG	2024-09
4739358	2024-09-05	46	5204.0	50.0	7.0	Penyusunan laporan perkembangan STAR Agustus	89898.0	PKAU-NG	2024-09
4772131	2024-09-18	1	210	58.0	7.0	Rekap bukti setor royalti PT BKU	144657	Reguler-NG	2024-09
4750677	2024-09-10	25	3406.0	24.0	10.0	-----	147291.0	Reguler-NG	2024-09
4790392	2024-09-25	10	1300.0	54.0	38.0	Melakukan kegiatan Pengelolaan Surat Dinas dan Arsip Fasilitasi Pengangkatan dalam JFA dari Subid 3.1 Pusbin JFA	85500	PKAU-NG	2024-09
4770327	2024-09-18	30	4012.0	37.0	2.0	Tkdd prov	146713	Reguler-NG	2024-09
4737190	2024-09-05	35	4492	56	2.0	Pembuatan laporan	-1	\N	2024-09
4783377	2024-09-23	22	3048.0	54.0	2.0	Pul data dukung analisa penyelenggaraan apip di insp.kab gunung kidul	148968.0	Reguler-NG	2024-09
4765391	2024-09-17	43	5046.0	35.0	2.0	Isu sosial	-1.0	\N	2024-09
4775177	2024-09-19	24	3318.0	24.0	10.0	Rekap bukti	146860.0	Investigasi-NG	2024-09
4722922	2024-09-02	31	4093.0	24.0	10.0	Reviu PSN Pelabuhan Bitung TW 3	-2	\N	2024-09
4741933	2024-09-06	18	2334.0	36.0	2.0	Menyusun kke dan shp	146694.0	Investigasi-NG	2024-09
4778221	2024-09-20	10	1023.0	38.0	171.0	analisis evaluasi pemenuhan jumlah	85930	PKAU-NG	2024-09
4788817	2024-09-25	33	4233	48	12.0	Monitoring pengawasan	-1	\N	2024-09
4737520	2024-09-05	4	648.0	36.0	2.0	Pembahasan APP Tw3	-1.0	\N	2024-09
4730643	2024-09-03	15	2004.0	55.0	2.0	Melengkapi data di Dinas Pendidikan Provinsi	146603.0	Reguler-NG	2024-09
4786665	2024-09-24	39	4744.0	24.0	10.0	Mengisi KKE	149135	Reguler-NG	2024-09
4794466	2024-09-26	47	5282.0	30.0	115.0	Kerja	90311.0	PKAU-NG	2024-09
4764392	2024-09-14	30	3962.0	30.0	3.0	Update data BLUD di aplikasi	-1	\N	2024-09
4755924	2024-09-11	19	2466.0	31.0	52.0	Menyusun kebutuhan belanja modal 2024	90273.0	PKAU-NG	2024-09
4788517	2024-09-24	12	1586.0	25.0	10.0	mengerjakan kertas kerja	148126.0	Reguler-NG	2024-09
4794355	2024-09-26	12	1636.0	27.0	16.0	-----	150111.0	Reguler-NG	2024-09
4785519	2024-09-24	2	384	38.0	2.0	Pelaksanaan pengawasan	149399	Reguler-NG	2024-09
4768150	2024-09-17	9	1242.0	36.0	21.0	"1. menyiapkan SPM pembayaran kontraktual PNI termin 2	\N	\N	2024-09
4764862	2024-09-15	1	138	34.0	33.0	Revisi Anggaran Relaksasi AA	88292	PKAU-NG	2024-09
4792369	2024-09-25	12	1668.0	30.0	10.0	Keseharian ipp2	-1.0	\N	2024-09
4795461	2024-09-26	22	3004.0	59.0	7.0	Pencermatan kke	148355.0	Reguler-NG	2024-09
4756809	2024-09-11	19	2486.0	36.0	16.0	Pembahasan dimensi 1	148271.0	Reguler-NG	2024-09
4796962	2024-09-27	34	4309	23	10.0	mengerjakan laporan	-1	\N	2024-09
4744714	2024-09-08	43	5060.0	30.0	189.0	Pembenaban	-1.0	\N	2024-09
4762332	2024-09-13	31	4057.0	24.0	10.0	Buat ST	-1	\N	2024-09
4778210	2024-09-20	22	2956.0	39.0	2.0	Pendalaman  kertas kerja pengendalian kecurangan	-1.0	\N	2024-09
4777500	2024-09-20	28	3759.0	37.0	52.0	Update sirup dan rkbmn 2026	-1	\N	2024-09
4789641	2024-09-25	42	4930.0	24.0	10.0	Membuat spj	149059.0	Reguler-NG	2024-09
4786224	2024-09-24	27	3654.0	34.0	16.0	Evaluasi DTKS	150099	Reguler-NG	2024-09
4796499	2024-09-27	12	1609.0	25.0	10.0	Monitoring TKD	148590.0	Reguler-NG	2024-09
4788675	2024-09-24	1	49	26.0	10.0	Kertas kerja	148314	Reguler-NG	2024-09
4738809	2024-09-05	15	2028.0	28.0	10.0	Evaluasi pendidikan vokasi	146641.0	Reguler-NG	2024-09
4730100	2024-09-03	2	390	49.0	67.0	Evaluasi spip	-2	\N	2024-09
4722122	2024-09-02	20	2689.0	34.0	51.0	Maintenance jaringan	90077.0	PKAU-NG	2024-09
4791007	2024-09-25	22	3006.0	29.0	188.0	Mengikuti pelatihan Jarak Jauh Persiapan uji Kompetensi JF  PLB	91588.0	PKAU-NG	2024-09
4805478	2024-09-30	42	4926.0	23.0	10.0	Cetak laporan	149929.0	Reguler-NG	2024-09
4792054	2024-09-25	39	4759.0	28.0	3.0	Evaluasi pembiayaan kesehatan	149184	Reguler-NG	2024-09
4756051	2024-09-11	18	2374.0	35.0	189.0	Scan spj pembelian, input lpse, input permintaan barang atk	-2.0	\N	2024-09
4805050	2024-09-30	45	5158.0	30.0	177.0	pertanggungjawaban keuangan	90447.0	PKAU-NG	2024-09
4794699	2024-09-26	18	2367.0	29.0	188.0	Diklat bmn	91313.0	PKAU-NG	2024-09
4801011	2024-09-29	30	4007.0	25.0	163.0	keuangan	-1	\N	2024-09
4762376	2024-09-13	49	5463.0	35.0	16.0	Pendampingan Pengelolaan SAKTI di pusdiklatwas bpkp	90905.0	PKAU-NG	2024-09
4727262	2024-09-03	3	491.0	34.0	2.0	Pengawasan	147922.0	Reguler-NG	2024-09
4793609	2024-09-26	44	5108.0	30.0	16.0	------	88288.0	PKAU-NG	2024-09
4774246	2024-09-19	20	2562.0	50.0	7.0	Mereviu laporan asesmen esg bio farma	149611.0	Reguler-NG	2024-09
4783104	2024-09-23	44	5070.0	34.0	3.0	Laporan	-2.0	\N	2024-09
4765557	2024-09-17	35	4408	56	12.0	Tugas kantor lainnya	-2	\N	2024-09
4802047	2024-09-30	34	4347	25	10.0	Membuat laporan	149146	Reguler-NG	2024-09
4791229	2024-09-25	20	2601.0	48.0	219.0	Mengisi survei	90077.0	PKAU-NG	2024-09
4743687	2024-09-07	30	3964.0	56.0	48.0	Lembur penyelesaian laporan blu untad	148047	Reguler-NG	2024-09
4785600	2024-09-24	14	1884.0	26.0	20.0	verifikasi berkas pertanggungjawaban perjalanan dinas	-2.0	\N	2024-09
4727910	2024-09-03	29	3925.0	25.0	10.0	mengerjakan shp	145375	Investigasi-NG	2024-09
4796115	2024-09-26	47	5350.0	37.0	342.0	Kerja	-1.0	\N	2024-09
4774692	2024-09-19	9	1266.0	30.0	166.0	Memverifikasi Berkas SPJ Perjadin ST-478 dan ST-480	-1	\N	2024-09
4762397	2024-09-13	19	2492.0	38.0	2.0	Penugasan	-1.0	\N	2024-09
4788234	2024-09-24	16	2126.0	29.0	51.0	Kerja	85548.0	PKAU-NG	2024-09
4736174	2024-09-05	29	3877.0	27.0	16.0	Kerja kka	145843	Reguler-NG	2024-09
4785853	2024-09-24	21	2766.0	57.0	2.0	Mempelajari materi bimtek	150131.0	Reguler-NG	2024-09
4754400	2024-09-11	38	4714.0	34.0	71.0	Reviu PSN Triwulan III PT Aman Mineral	148389	Reguler-NG	2024-09
4726469	2024-09-02	47	5308.0	34.0	338.0	Ppt dan notulensi serta laporan	-1.0	\N	2024-09
4761629	2024-09-13	19	2445.0	23.0	10.0	Pembahasan dengan Counterpart Jaktour	-1.0	\N	2024-09
4777741	2024-09-20	22	3040.0	37.0	2.0	Kerja	142510.0	Reguler-NG	2024-09
4763457	2024-09-13	37	4637.0	34.0	134.0	Proses Pembuatan dashboard looker studio Integrated Service Excellent (ISE),Monitoring Surat Masuk dan Keluar	\N	\N	2024-09
4726773	2024-09-03	20	2592.0	55.0	2.0	Evkin Bum Desa	-2.0	\N	2024-09
4756966	2024-09-12	20	2542.0	54.0	12.0	PH DI RENTANG	148050.0	Investigasi-NG	2024-09
4796070	2024-09-26	32	4220.0	54.0	34.0	Zoom meeting kemajuan pelaporan tw3	-1	\N	2024-09
4804973	2024-09-30	15	1833.0	53.0	7.0	Persiapan dan penyusunan laporan kinerja perwakilan tw 3 tahun 2024	-1.0	\N	2024-09
4803669	2024-09-30	5	812.0	24.0	20.0	Verifikasi	-1	\N	2024-09
4726233	2024-09-02	21	2834.0	59.0	232.0	Narasumber pelatihan P3D Kemendagri	143696.0	Investigasi-NG	2024-09
4745809	2024-09-09	34	3590	25	20.0	Membuat rekap potongan perjalanan dinas	-2	\N	2024-09
4776463	2024-09-20	21	2873.0	60.0	7.0	Mengendalikan penyusunan konsep laporan konsolidasi psn	-3.0	\N	2024-09
4745602	2024-09-04	20	2641.0	40.0	12.0	Pelaksanaan	147412.0	Reguler-NG	2024-09
4744848	2024-09-08	2	373	33.0	19.0	Pengidentifikasian pertanggungjawaban keuangan yg telah jatuh tempo sebagai proyeksi percapaian target RPD bln september 2024	-1	\N	2024-09
4764526	2024-09-14	38	4687.0	47.0	67.0	Lembur	89030	PKAU-NG	2024-09
4762868	2024-09-13	47	5318.0	40.0	2.0	Merapikan arsip PAK	-1.0	\N	2024-09
4723660	2024-09-02	31	4058.0	57.0	12.0	.....	-2	\N	2024-09
4780139	2024-09-21	23	3195.0	29.0	134.0	Sesuai spkl	91479.0	PKAU-NG	2024-09
4778889	2024-09-20	1	71	24.0	10.0	melakukan Pemeriksaan atas Pemenuhan Kewajiban PNBP PT Ceria Nugraha Indotama Periode 1 Januari 2021 s.d. 31 Desember 2023	144711	Reguler-NG	2024-09
4781220	2024-09-23	19	2487.0	54.0	7.0	Lap pp39	-2.0	\N	2024-09
4786238	2024-09-24	44	5062.0	42.0	2.0	Pembiayaan	150209.0	Reguler-NG	2024-09
4734452	2024-09-04	40	4817.0	23.0	10.0	melakukan evaluasi	147483	Reguler-NG	2024-09
4771830	2024-09-18	15	1968.0	53.0	46.0	Menyelesaikan tugas harian	-2.0	\N	2024-09
4772493	2024-09-18	37	4590.0	24.0	10.0	mengisi siapp transda	148031	Reguler-NG	2024-09
4799303	2024-09-27	18	2270.0	56.0	7.0	Evaluasi	148418.0	Reguler-NG	2024-09
4767814	2024-09-17	1	218	40.0	44.0	Kerja	-2	\N	2024-09
4765036	2024-09-15	11	1394.0	24.0	10.0	Kerja	147559	Reguler-NG	2024-09
4790431	2024-09-25	12	1487.0	55.0	234.0	Mendistribusikan surat surat di bidang tata usaha	-1.0	\N	2024-09
4732580	2024-09-04	26	3518.0	28.0	52.0	sharing season dengan DJKN, update master aset siman	90354.0	PKAU-NG	2024-09
4792913	2024-09-26	20	2698.0	57.0	15.0	Mengikuti Diklat Manajemen ASN di Pusdiklat	90019.0	PKAU-NG	2024-09
4799550	2024-09-27	23	3234.0	52.0	2.0	Perbaikan laporan kompilasi Evkin BUMD Aneka Usaha reviu dalnis	-1.0	\N	2024-09
4799370	2024-09-27	45	5175.0	32.0	20.0	Verifikasi spj	90364.0	PKAU-NG	2024-09
4891262	2024-10-29	22	2998.0	52.0	12.0	Monitoring survey reputasi	-1.0	\N	2024-10
4877027	2024-10-24	22	3049.0	38.0	2.0	Melakukan entry meeting penugasan evaluasi IEPK	152483.0	PKPT-NG	2024-10
4837212	2024-10-10	28	3768.0	47.0	12.0	Pelaksanaan workshop	-1	\N	2024-10
4846943	2024-10-14	26	3549.0	24.0	10.0	Mengerjakan KK SPIP Balangan	-1.0	\N	2024-10
4875263	2024-10-23	34	4361	24	10.0	Mempelajari materi spip dan mr	152170	PKPT-NG	2024-10
4866595	2024-10-21	7	1090.0	36.0	3.0	Pembukaan pelatihan CGRA batch 1	93653	PKAU-NG	2024-10
4833501	2024-10-09	43	5008.0	24.0	10.0	Audit Penyesuaian Harga	-1.0	\N	2024-10
4858684	2024-10-17	3	600.0	36.0	2.0	"1. Penyusunan Laporan Hasil QA Penugasan Reviu PAPBJ, Evaluasi OPAD, dan Evaluasi Pembiayaan Daerah di Perwakilan BPKP Provinsi Lampung	\N	\N	2024-10
4828893	2024-10-08	27	3625.0	56.0	11.0	Membuat surat pengantar laporan yg dikirim	-2	\N	2024-10
4884940	2024-10-28	16	2131.0	57.0	7.0	Monitoring SPIP	152598.0	PKPT-NG	2024-10
4866357	2024-10-21	20	2559.0	38.0	3.0	Tl ba sakip	-1.0	\N	2024-10
4807413	2024-10-01	31	4079.0	59.0	78.0	Mengoordinasikan Tugas-Tugas APD	149877	Reguler-NG	2024-10
4806844	2024-10-01	44	5086.0	23.0	10.0	bekerja	-1.0	\N	2024-10
4885984	2024-10-28	29	3914.0	44.0	2.0	Melaksanakan..	-1	\N	2024-10
4815937	2024-10-03	10	1318.0	37.0	2.0	Perbaikan bugs pada aplikasi bangkom	-1	\N	2024-10
4887739	2024-10-28	38	3114.0	36.0	2.0	Sesuai arahan	-1	\N	2024-10
4820652	2024-10-04	22	3060.0	37.0	2.0	Monit TKD	-1.0	\N	2024-10
4883885	2024-10-26	30	3986.0	29.0	183.0	Mempersiapkan sarana dan prasarana diklat	152591	PKPT-NG	2024-10
4850935	2024-10-15	37	4608.0	24.0	10.0	perencanaan ST monitoring dan evaluasi MR	-1	\N	2024-10
4882633	2024-10-25	11	1409.0	24.0	10.0	perencanaan	152743	PKPT-NG	2024-10
4852707	2024-10-15	42	4946.0	23.0	10.0	menyelesaikan ppt ekspose spip	-1.0	\N	2024-10
4868864	2024-10-22	16	2089.0	59.0	161.0	Proses audit	152064.0	PKPT-NG	2024-10
4819870	2024-10-04	38	4681.0	58.0	7.0	Reviu kertas kerja	-2	\N	2024-10
4879505	2024-10-24	26	3531.0	34.0	3.0	Kertas kerja spip	-1.0	\N	2024-10
4826109	2024-10-07	6	964.0	57.0	7.0	Reviu	92341	PKAU-NG	2024-10
4899236	2024-10-31	6	975.0	50.0	161.0	Persiapan dan ujian sertifikasi pbj level 1	93695	PKAU-NG	2024-10
4893717	2024-10-30	20	2646.0	35.0	2.0	Evaluasi MR RSUD Bandung Kiwari	152402.0	PKPT-NG	2024-10
4869823	2024-10-22	1	223	28.0	10.0	dokumen kka	-1	\N	2024-10
4864452	2024-10-20	27	3656.0	44.0	2.0	Check in hotel swiss-beliin untuk mengikuti diklat	-1	\N	2024-10
4883809	2024-10-26	15	1443.0	38.0	57.0	Lembur persiapan SKD CPNS BPKP	-2.0	\N	2024-10
4813835	2024-10-02	27	3643.0	41.0	2.0	Evaluasi efektifitas TKD DAK DAU Dan DBH provinsi bali	148815	Reguler-NG	2024-10
4813962	2024-10-02	2	386	36.0	7.0	Penyusunan ihp konsolidasi di bogor	-1	\N	2024-10
4870608	2024-10-22	1	50	39.0	2.0	Exit meeting kapabilitas apip	147501	Reguler-NG	2024-10
4838506	2024-10-10	15	1950.0	28.0	19.0	Membuat ST diklat	-1.0	\N	2024-10
4818852	2024-10-04	9	1264.0	36.0	71.0	Aset bmn	92524	PKAU-NG	2024-10
4833512	2024-10-09	37	4572.0	34.0	3.0	koordinasi denga APIP terkait Penyampaian Nomor Keanggotaan, User ID, dan Password e-Voting Kongres AAIPI 2024	\N	\N	2024-10
4839535	2024-10-10	36	4559	25	10.0	Mengerjakan kke	-1	\N	2024-10
4821026	2024-10-04	21	2911.0	28.0	19.0	Membuat usulan pensiun	-1.0	\N	2024-10
4886523	2024-10-28	22	2942.0	37.0	3.0	Konsultasi Kejati terkait tanah BUMN milik Kasultanan	152483.0	PKPT-NG	2024-10
4826994	2024-10-07	16	1834.0	57.0	200.0	Reviu dok SPJ belanja	-1.0	\N	2024-10
4856337	2024-10-16	1	127	34.0	2.0	Reviu	151626	PKPT-NG	2024-10
4872660	2024-10-23	26	3604.0	36.0	71.0	Gabung pdf dokumen Akumulasi AK dan PAK PFA an Rizky Tisa sd periode 30 September 2024 dengan I Love PDF	-2.0	\N	2024-10
4837492	2024-10-10	25	3420.0	24.0	10.0	Membuat surat tugas	142261.0	Reguler-NG	2024-10
4863216	2024-10-18	6	976.0	38.0	2.0	Reviu rkbmn BPKP	92341	PKAU-NG	2024-10
4876148	2024-10-24	16	2165.0	58.0	242.0	Audit PH	152558.0	PKPT-NG	2024-10
4863183	2024-10-18	23	3255.0	30.0	41.0	input st sima surat masuk surat keluar	92705.0	PKAU-NG	2024-10
4866637	2024-10-21	23	3110.0	37.0	2.0	Menyiapkan WS	-1.0	\N	2024-10
4840813	2024-10-11	34	4326	24	10.0	Telaah	-1	\N	2024-10
4852401	2024-10-15	45	4899.0	39.0	67.0	Pipk.	90800.0	PKAU-NG	2024-10
4894918	2024-10-30	1	196	35.0	2.0	data KP	152312	PKPT-NG	2024-10
4814541	2024-10-03	48	5376.0	29.0	193.0	Mengikuti Forum Tematik Bakohumas	92216.0	PKAU-NG	2024-10
4816924	2024-10-03	12	1635.0	53.0	245.0	Memproses surat surat kepegawaian dan umum	-2.0	\N	2024-10
4817041	2024-10-03	15	1990.0	25.0	10.0	Menyusun KKE	149279.0	Reguler-NG	2024-10
4861856	2024-10-18	19	1321.0	54.0	34.0	Reviu revisi anggaran	-3.0	\N	2024-10
4892640	2024-10-29	45	5175.0	32.0	20.0	Tiba di Mamuju	93966.0	PKAU-NG	2024-10
4816351	2024-10-03	49	5505.0	29.0	10.0	kerja	91402.0	PKAU-NG	2024-10
4813158	2024-10-02	10	1336.0	33.0	2.0	Memberikan layanan konsultasi JFA	-1	\N	2024-10
4809471	2024-10-01	5	843.0	25.0	10.0	Penyelesaian proper Pak Dir	-1	\N	2024-10
4875005	2024-10-23	22	3067.0	58.0	84.0	Melaksanakan penugasan rutin sekretaris di bidang APD	-2.0	\N	2024-10
4823153	2024-10-06	13	1825.0	31.0	51.0	Update Modul distribusi laporan	-1.0	\N	2024-10
4806404	2024-10-01	33	4288	34	71.0	Monitoring Surat masuk Subbagian Kepegawaian	-2	\N	2024-10
4897226	2024-10-31	34	4341	23	10.0	Mempelajari penugasan selanjutnya	-3	\N	2024-10
4811752	2024-10-02	3	529.0	35.0	2.0	Identifikasi risiko lintas sektor DLh	150171.0	Reguler-NG	2024-10
4832145	2024-10-09	49	5530.0	56.0	183.0	Tehnisi Elektrical	-2.0	\N	2024-10
4866576	2024-10-21	39	4786.0	34.0	3.0	Koordinasi dan penyusunan laporan PIA	-1	\N	2024-10
4865205	2024-10-18	35	4491	37	3.0	Aktivitas Rutin Kantor	-1	\N	2024-10
4869862	2024-10-22	36	4522	24	10.0	QA rendal	151615	PKPT-NG	2024-10
4891718	2024-10-29	1	92	36.0	2.0	Kertas kerjA	152512	PKPT-NG	2024-10
4806714	2024-10-01	4	653.0	35.0	2.0	Menyelesaikan laporan	-1.0	\N	2024-10
4815339	2024-10-03	23	3194.0	52.0	136.0	Menyusun Laporan Penyelenggaraan PPM/PKS TW 3 Tahun 2024, memproses usulan Kenaikan Pangkat per 1 Desember 2024	92026.0	PKAU-NG	2024-10
4835118	2024-10-09	21	2915.0	49.0	34.0	Monitoring pemanfaatan aplikasi siswaskeudes	-3.0	\N	2024-10
4885929	2024-10-28	41	4890.0	26.0	10.0	Mengikuti arahan pimpinan	151786.0	PKPT-NG	2024-10
4883399	2024-10-26	27	3672.0	57.0	206.0	Lembur dalam rangka persiapan kegiatan dukungan pelaksanaan kegiatan Workshop Evaluasi Pengelolaan Keuangan dan PembangunanDesa tahun 2024 di Kabupaten Gianyar dan Buleleng	\N	\N	2024-10
4834095	2024-10-09	4	791.0	35.0	2.0	Penyelesaian tugas manajemen risiko bidang ipp	-1.0	\N	2024-10
4822252	2024-10-05	49	5497.0	33.0	361.0	Pendampingan Deputi 2 BPKP	88280.0	PKAU-NG	2024-10
4897860	2024-10-31	22	3019.0	31.0	134.0	meliput kegiatan PSN Bendungan Bener di Purworejo	94824.0	PKAU-NG	2024-10
4827839	2024-10-07	46	4607.0	37.0	295.0	Review Mission	-2.0	\N	2024-10
4855757	2024-10-16	4	758.0	35.0	2.0	Promosi pariwisata	151392.0	PKPT-NG	2024-10
4846370	2024-10-14	13	1758.0	38.0	2.0	exit meeting pisew	151654.0	PKPT-NG	2024-10
4867884	2024-10-21	46	5200.0	24.0	10.0	Rekap pemantauan keterjadian risiko	-1.0	\N	2024-10
4830603	2024-10-08	30	3999.0	23.0	10.0	mengerjakan kke spip	-1	\N	2024-10
4807070	2024-10-01	31	4055.0	25.0	10.0	Evaluasi	-1	\N	2024-10
4877800	2024-10-24	22	2976.0	38.0	3.0	Sesuai st	92894.0	PKAU-NG	2024-10
4878456	2024-10-24	1	16	54.0	7.0	Menyusun laporan	152387	PKPT-NG	2024-10
4879124	2024-10-24	22	3070.0	35.0	2.0	spipt	151871.0	PKPT-NG	2024-10
4838656	2024-10-10	5	880.0	28.0	10.0	Pebde	-1	\N	2024-10
4895320	2024-10-30	11	1478.0	48.0	19.0	Mengerjakan pekerjaan administrasi kepegawaian	-1	\N	2024-10
4885461	2024-10-28	5	814.0	29.0	115.0	Memproses update dan analisa proses kepegawaian tahun 2025	\N	\N	2024-10
4830347	2024-10-08	13	1742.0	25.0	10.0	Pembahasan	148406.0	Reguler-NG	2024-10
4812646	2024-10-02	48	5422.0	31.0	193.0	Desain cover WP 3	-1.0	\N	2024-10
4818350	2024-10-04	16	2060.0	46.0	12.0	Telaah Kasus Mayor Ruslan	-2.0	\N	2024-10
4827058	2024-10-07	3	576.0	26.0	10.0	Rekap data pinjaman dan kpbu perwakilan	150079.0	Reguler-NG	2024-10
4824300	2024-10-07	33	4251	58	2.0	Evaluasi	-1	\N	2024-10
4839992	2024-10-10	15	2023.0	26.0	10.0	Penugasan rutin	-1.0	\N	2024-10
4861815	2024-10-18	48	5414.0	58.0	193.0	Penataan folder	92356.0	PKAU-NG	2024-10
4863628	2024-10-18	28	3741.0	26.0	10.0	Exit meeting	151789	PKPT-NG	2024-10
4862490	2024-10-18	7	1094.0	36.0	184.0	Supervisi	-2	\N	2024-10
4852445	2024-10-15	18	2290.0	48.0	7.0	memperbaiki laporan	151494.0	PKPT-NG	2024-10
4827705	2024-10-07	13	1795.0	24.0	10.0	Dinamika PKN STAN	92511.0	PKAU-NG	2024-10
4832331	2024-10-09	18	2350.0	52.0	12.0	Monitoring DAU Lamtim	150144.0	Reguler-NG	2024-10
4977941	2024-11-28	4	725.0	35.0	2.0	Rikber star kakap	152809.0	PKPT-NG	2024-11
4922330	2024-11-08	47	5259.0	54.0	15.0	Melaksanakan Pemrosesan Kenaikan Pangkat 1 Desember 2024	-1.0	\N	2024-11
4953227	2024-11-19	11	1449.0	35.0	10.0	Menyusun kke	153949	PKPT-NG	2024-11
4941315	2024-11-14	3	576.0	26.0	10.0	Rekap permasalahan aset oemda	154244.0	PKPT-NG	2024-11
4900945	2024-11-01	16	2063.0	56.0	2.0	Melaksanakan penugasan bimtek spip kab.ogan ilir	153203.0	PKPT-NG	2024-11
4946365	2024-11-17	25	3486.0	57.0	245.0	Reviu Nota Dinas Pelaksanaan Pelepasan Pegawai Purnabakti.	-1.0	\N	2024-11
4951447	2024-11-19	43	5025.0	23.0	10.0	melengkapi pendataan aoi pk apip	-1.0	\N	2024-11
4971293	2024-11-25	32	4213.0	56.0	84.0	Input surat masuk di aplikasi Sadewa, input surat keluar,ST, Laporan dll, serta memonitor ST, Laporan ke dlm aplikasi SIMA, cost shet di BISMA dan memonitor srt keluar. LAP, dll di aplikasi MAP, call srt 2 keluar dan Laporan,scan surat2, mengarsipkan	-2	\N	2024-11
4957871	2024-11-21	16	2165.0	58.0	242.0	Ekspose HKP dengan Pj. Gubernur	-1.0	\N	2024-11
4924180	2024-11-08	12	1598.0	28.0	16.0	Evaluasi ILPTB	153941.0	PKPT-NG	2024-11
4978885	2024-11-28	25	1540.0	28.0	16.0	Papbj	154705.0	PKPT-NG	2024-11
4980795	2024-11-28	11	1446.0	23.0	10.0	Outline LED	154008	PKPT-NG	2024-11
4952747	2024-11-19	22	2964.0	37.0	3.0	SPIP Kota Yogyakarta	157438.0	PKPT-NG	2024-11
4975879	2024-11-26	21	2925.0	33.0	3.0	Koordinasi	155505.0	PKPT-NG	2024-11
4933628	2024-11-12	48	5404.0	49.0	356.0	Penyelesaian pekerjaan	95642.0	PKAU-NG	2024-11
4932134	2024-11-12	2	366.0	35.0	2.0	Spip ORI	153495.0	PKPT-NG	2024-11
4948836	2024-11-18	12	1530.0	32.0	238.0	"1. Membuat surat keterangan penghasilan	\N	\N	2024-11
4956388	2024-11-20	39	4766.0	44.0	2.0	Monitoring AOI PK-APIP	-2	\N	2024-11
4928916	2024-11-11	44	5119.0	54.0	7.0	QA Was ASN	153426.0	PKPT-NG	2024-11
4926134	2024-11-10	22	2942.0	37.0	3.0	Upacara	152483.0	PKPT-NG	2024-11
4954701	2024-11-20	36	4553	35	2.0	Mempersiapkan penugasan Reviu Hibah ALS Natuna	155636	PKPT-NG	2024-11
4954398	2024-11-20	12	1634.0	57.0	241.0	Membaca pedoman audit	-3.0	\N	2024-11
4965749	2024-11-23	47	5347.0	44.0	336.0	Melakukan persiapan skb cpns. Mengikuti raker	98016.0	PKAU-NG	2024-11
4964853	2024-11-22	47	5340.0	34.0	16.0	Perencanaan mutasi	96436.0	PKAU-NG	2024-11
4984358	2024-11-29	38	4691.0	25.0	10.0	Finalisasi st	157885	PKPT-NG	2024-11
4981536	2024-11-29	27	3697.0	34.0	2.0	PSN Bias Munjul	156032	PKPT-NG	2024-11
4973449	2024-11-25	5	829.0	34.0	3.0	Klarifikasi	153214	PKPT-NG	2024-11
4961376	2024-11-22	18	2351.0	34.0	3.0	Penyusunan KKE	151571.0	PKPT-NG	2024-11
4903039	2024-11-01	37	4177.0	55.0	124.0	FCP Kab Bangka	151229	PKPT-NG	2024-11
4930934	2024-11-11	38	4687.0	47.0	67.0	And rmi	96042	PKAU-NG	2024-11
4981627	2024-11-29	14	1843.0	58.0	7.0	Pengendalian monitoring akuntabilitas transfer ke daerah provinsi Riau	155798.0	PKPT-NG	2024-11
4971624	2024-11-25	47	5330.0	38.0	2.0	Izin LN	-2.0	\N	2024-11
4923470	2024-11-08	36	4552	29	188.0	Melakukan transaksi keluar atk pada sakti	-2	\N	2024-11
4949506	2024-11-18	49	5470.0	28.0	25.0	Bimtek VAI Govtech Procurement, Pelayanan Helpdesk LPSE BPKP	76508.0	PKAU-NG	2024-11
4955162	2024-11-20	44	5128.0	38.0	2.0	Evaluasi	153923.0	PKPT-NG	2024-11
4951235	2024-11-19	16	2156.0	45.0	12.0	Kemudahan berusaha	153600.0	PKPT-NG	2024-11
4952712	2024-11-19	7	1139.0	30.0	134.0	Desain cover laporan	-1	\N	2024-11
4959541	2024-11-21	48	5385.0	28.0	350.0	Follow up izin penelitian	-1.0	\N	2024-11
4927459	2024-11-11	18	2294.0	54.0	11.0	Scan laporan dan ST Bid. AN	-2.0	\N	2024-11
4966259	2024-11-23	45	5158.0	30.0	177.0	rekon data sakti bisma dan monitoring internal	97999.0	PKAU-NG	2024-11
4903725	2024-11-01	36	2143	54	124.0	Review laporan	153059	PKPT-NG	2024-11
4961223	2024-11-22	4	784.0	35.0	2.0	Raker bpkp	-1.0	\N	2024-11
4967732	2024-11-23	34	4310	23	10.0	Mengikuti zoom raker	-1	\N	2024-11
4953738	2024-11-19	5	882.0	28.0	16.0	Mrpnnn	97660	PKAU-NG	2024-11
4962610	2024-11-22	36	4561	24	20.0	Mengikuti Rapat Kerja BPKP	-1	\N	2024-11
4908138	2024-11-04	3	533.0	51.0	7.0	Persiapan panitia ujikom cgra	153229.0	PKPT-NG	2024-11
4980812	2024-11-28	1	145	57.0	34.0	FGD Sektor D	97227	PKAU-NG	2024-11
4934198	2024-11-12	17	2253.0	24.0	10.0	IEPK PDAM	156526.0	PKPT-NG	2024-11
4979230	2024-11-28	40	4819.0	51.0	78.0	Reviu laporan	157040	PKPT-NG	2024-11
4913854	2024-11-06	7	1108.0	57.0	11.0	Rekap GDN THL	-2	\N	2024-11
4956093	2024-11-20	5	818.0	35.0	20.0	"Rekonsiliasi spby pada bisma	\N	\N	2024-11
4977731	2024-11-28	22	2642.0	52.0	7.0	Penyusunan laporan hasil reviu hasil verifikasi konsultan atas program HALS pada Kab Kulon Progo	155062.0	PKPT-NG	2024-11
4930014	2024-11-11	20	2646.0	35.0	2.0	Evaluasi mr rsud bandung kiwari	152402.0	PKPT-NG	2024-11
4914546	2024-11-06	12	1624.0	34.0	2.0	Evaluasi spip kab Asahan	-1.0	\N	2024-11
4951954	2024-11-19	36	4512	30	13.0	"Melakukan penomoran dokumen surat tugas, surat keluar & dokumen lainnya	\N	\N	2024-11
4933641	2024-11-12	6	999.0	36.0	2.0	Mengajar diklat sakip	95860	PKAU-NG	2024-11
4939564	2024-11-14	38	3463.0	35.0	2.0	Zoom led	156536	PKPT-NG	2024-11
4922651	2024-11-08	43	5037.0	25.0	10.0	kerja	153611.0	PKPT-NG	2024-11
4950530	2024-11-18	27	3714.0	29.0	10.0	Mengisi kka	156267	PKPT-NG	2024-11
4946166	2024-11-17	47	5260.0	30.0	51.0	LHKPN	97759.0	PKAU-NG	2024-11
4919847	2024-11-07	23	3194.0	52.0	136.0	Mengikuti Pelatihan MOOC Pembangunan Budaya Risiko di Lingkungan BPKP, memproses PAK PFA mutasi keluar	95645.0	PKAU-NG	2024-11
4934694	2024-11-13	20	2592.0	55.0	2.0	Mempelajari pedoman	-1.0	\N	2024-11
4911370	2024-11-05	31	4084.0	36.0	134.0	"1. Pelayanan administrasi di bagian TU	\N	\N	2024-11
4948116	2024-11-18	44	5117.0	31.0	3.0	pengisian kka	153911.0	PKPT-NG	2024-11
4971897	2024-11-25	4	787.0	28.0	16.0	Checklist dokumen	157060.0	PKPT-NG	2024-11
4969997	2024-11-25	12	697.0	58.0	7.0	Melakukan assessmen tata kelola	155356.0	PKPT-NG	2024-11
4940192	2024-11-14	46	5198.0	38.0	2.0	"1. Diskusi perbaikan substansi penyelenggaraan mr	\N	\N	2024-11
4954349	2024-11-20	12	1490.0	56.0	83.0	Arsioaris	-2.0	\N	2024-11
4934298	2024-11-12	12	1631.0	37.0	2.0	Kapabilitas apip	151805.0	PKPT-NG	2024-11
4978624	2024-11-28	47	5287.0	28.0	25.0	pengembangan dashboard peserta ujikom	96380.0	PKAU-NG	2024-11
4983843	2024-11-29	24	3351.0	31.0	52.0	mengerjakan kegiatan bagian umum	-2.0	\N	2024-11
4981298	2024-11-29	40	4800.0	49.0	2.0	Monitoring Tindak Lanjut atas Area of Imporovement (AoI) Hasil Penilaian Kapabilitas APIP di wilayah Provinsi Sulawesi Barat	156413	PKPT-NG	2024-11
4904542	2024-11-02	28	108.0	40.0	26.0	Persiapan pemantauan pelaksanaan anggaran oleh biro keuangan	-2	\N	2024-11
4928136	2024-11-11	34	4312	23	10.0	Membuat BA pembahasan audit	152670	PKPT-NG	2024-11
4923134	2024-11-08	7	1142.0	34.0	2.0	Persiapan pelaksanaan kegiatan	95514	PKAU-NG	2024-11
4978493	2024-11-28	24	3302.0	34.0	3.0	Melengkapi kertas kerja dan draft outline LED	98344.0	PKAU-NG	2024-11
4964672	2024-11-22	10	1327.0	40.0	221.0	Webpost	97601	PKAU-NG	2024-11
4984148	2024-11-29	13	1769.0	25.0	10.0	Paparan outline	152119.0	PKPT-NG	2024-11
4942740	2024-11-15	4	738.0	36.0	3.0	Diskusi internal Tim	153548.0	PKPT-NG	2024-11
4929158	2024-11-11	6	988.0	36.0	2.0	Audit bandin	94800	PKAU-NG	2024-11
4916744	2024-11-06	12	1545.0	37.0	2.0	Menyusun laporan	-1.0	\N	2024-11
4900743	2024-11-01	47	5318.0	40.0	2.0	Pelaksanaan SKD CPNS	95077.0	PKAU-NG	2024-11
4983088	2024-11-29	48	5370.0	34.0	348.0	LD Perdep	\N	\N	2024-11
4957923	2024-11-21	25	3503.0	36.0	2.0	Penyusunan laporan & KKA	152673.0	PKPT-NG	2024-11
4907153	2024-11-04	38	4682.0	24.0	10.0	wawancara	151533	PKPT-NG	2024-11
4953146	2024-11-19	2	314.0	35.0	2.0	Notisi	154087.0	PKPT-NG	2024-11
4964543	2024-11-22	48	5266.0	42.0	28.0	Liputan Rapat Kerja BPKP 2024	-1.0	\N	2024-11
4948771	2024-11-18	19	2515.0	57.0	69.0	Evaluasi ILP dan TB	154077.0	PKPT-NG	2024-11
4948760	2024-11-18	24	2289.0	37.0	3.0	Evaluasi tingkat maturitas oenerapan MR pada perumdam tirta raya	152682.0	PKPT-NG	2024-11
4925936	2024-11-10	31	4127.0	49.0	189.0	Mengikuti upacara bendera memperingati Hari Pahlawan	-1	\N	2024-11
4975985	2024-11-26	27	3708.0	57.0	280.0	Administrasi kantor	-2	\N	2024-11
4940996	2024-11-14	45	1526.0	33.0	51.0	Keberangkatan	95844.0	PKAU-NG	2024-11
4927737	2024-11-11	27	3671.0	52.0	7.0	Mengikuti kegiatan diklat MRPN	97070	PKAU-NG	2024-11
4961008	2024-11-21	48	5392.0	37.0	354.0	Persiapan raker	95319.0	PKAU-NG	2024-11
4979562	2024-11-28	36	4514	52	2.0	TL akip itda prov kepri	154620	PKPT-NG	2024-11
4969723	2024-11-25	13	1699.0	49.0	224.0	Melakukan tugas bidang umum	95276.0	PKAU-NG	2024-11
4904722	2024-11-02	46	5227.0	40.0	319.0	Reviu Penyusunan Modul JFA	-1.0	\N	2024-11
4925805	2024-11-10	27	3620.0	55.0	12.0	mengikuti upacara bendera memperingati Hari Pahlawan 10 November 2024.	-1	\N	2024-11
4947755	2024-11-18	28	3786.0	38.0	2.0	Entry meeting dengan Bapenda	156293	PKPT-NG	2024-11
4931246	2024-11-12	7	1138.0	56.0	12.0	Menyusun Laporan	95210	PKAU-NG	2024-11
5043215	2024-12-24	49	4978.0	48.0	303.0	Mengendalikan penyelesaian pengadaan barang/jasa lingkup Biro Umum dan Pengadaan Barang/Jasa BPKP.	\N	\N	2024-12
5041991	2024-12-23	1	31	36.0	2.0	Reviu Laporan	155105	PKPT-NG	2024-12
5025860	2024-12-16	3	522.0	29.0	25.0	Persiapan Raker PPKD	159247.0	PKPT-NG	2024-12
4997077	2024-12-05	12	1616.0	34.0	2.0	Menyusun kertas kerja	157514.0	PKPT-NG	2024-12
5010318	2024-12-10	6	994.0	60.0	164.0	Manajemen Penugasan  Reviu Inspektorat	-1	\N	2024-12
5010751	2024-12-10	49	5501.0	56.0	370.0	Mengoordinasikan kegiatan pengelolaan PBJ, pengelolaan SPSE serta pembinaan dan advokasi PBJ	-2.0	\N	2024-12
5035561	2024-12-19	39	4773.0	53.0	7.0	Supervisi	155195	PKPT-NG	2024-12
5002714	2024-12-06	20	2532.0	35.0	3.0	Melakukan Verifikasi tersebut	157735.0	PKPT-NG	2024-12
5002646	2024-12-06	29	3895.0	51.0	284.0	Melakukan koordinasi dng stakeholder	154458	PKPT-NG	2024-12
5014038	2024-12-11	44	5113.0	34.0	2.0	Telaah	-1.0	\N	2024-12
4991820	2024-12-03	2	356.0	58.0	7.0	Supervisi evaluasi atas Program P3DN Tahun 2024 pada ANRI	155896.0	PKPT-NG	2024-12
5051538	2024-12-30	3	514.0	36.0	16.0	pengembangan cacm	-2.0	\N	2024-12
5019867	2024-12-13	16	2091.0	50.0	2.0	Simpulasn data	155815.0	PKPT-NG	2024-12
5024744	2024-12-16	17	2259.0	24.0	10.0	Entry meeting	159741.0	PKPT-NG	2024-12
5047837	2024-12-27	20	2641.0	40.0	12.0	Pelaksanaan	159870.0	PKPT-NG	2024-12
5023512	2024-12-16	24	3387.0	34.0	19.0	Konsep laporan GDN periode Desember 2024	97127.0	PKAU-NG	2024-12
5030198	2024-12-18	33	4122	43	48.0	Monitoring dan reviu kegiatan evaluasi kelembagaan	99656	PKAU-NG	2024-12
5017700	2024-12-12	12	1618.0	35.0	3.0	Pkkn kominfo taput	156613.0	PKPT-NG	2024-12
4991851	2024-12-03	20	2565.0	45.0	11.0	Mengonsep DATA PERORANGAN CALON PENERIMA PENSIUN (DPCP)  atas nama Juratmaji dan Sri Suharti	\N	\N	2024-12
4999457	2024-12-05	49	5490.0	54.0	11.0	Melaksanakan tugas bagian dari rumah tangga	-2.0	\N	2024-12
5036400	2024-12-20	21	2739.0	56.0	12.0	Konsolidasi Laporan Gubernur Semester II	160008.0	PKPT-NG	2024-12
4996138	2024-12-04	14	1930.0	31.0	35.0	Mendaftarkan supplier pegawai	-2.0	\N	2024-12
4992621	2024-12-03	18	1788.0	35.0	3.0	QA tkd	155747.0	PKPT-NG	2024-12
5050332	2024-12-30	16	2074.0	25.0	10.0	Eval spip	156082.0	PKPT-NG	2024-12
5030059	2024-12-18	19	2400.0	48.0	115.0	Pemberkasan rekap daftar hadir pegawai periode Desember 24	-2.0	\N	2024-12
5029106	2024-12-17	24	3345.0	25.0	10.0	mengikuti pelantikan, revisi paparan spip dan papbj	155008.0	PKPT-NG	2024-12
5026882	2024-12-17	1	50	39.0	2.0	Laporan	154942	PKPT-NG	2024-12
5021384	2024-12-14	36	4515	48	52.0	Lembur	-1	\N	2024-12
5027930	2024-12-17	21	2778.0	35.0	16.0	lapgub	93579.0	PKAU-NG	2024-12
5044976	2024-12-24	5	951.0	46.0	2.0	Pembahasan pedoman	-1	\N	2024-12
5029760	2024-12-18	23	3113.0	58.0	7.0	Penyembuhan pasca operasi mata	-1.0	\N	2024-12
5043287	2024-12-24	15	1723.0	52.0	2.0	Evaluasi Tata Kelola Pariwisata	148863.0	Reguler-NG	2024-12
5014545	2024-12-11	22	2642.0	52.0	7.0	Penyusunan laporan	92894.0	PKAU-NG	2024-12
5043350	2024-12-24	22	3030.0	57.0	12.0	Menyusun KK	92894.0	PKAU-NG	2024-12
4994864	2024-12-04	19	2427.0	35.0	2.0	Aktifitas	153767.0	PKPT-NG	2024-12
5051177	2024-12-30	20	2588.0	36.0	3.0	Reviu FS PTPTN 1	158186.0	PKPT-NG	2024-12
4987382	2024-12-02	29	3949.0	36.0	2.0	PSN PSEL Makassar	155088	PKPT-NG	2024-12
5030985	2024-12-18	12	1412.0	39.0	2.0	Menyusun laporan	155624.0	PKPT-NG	2024-12
4988924	2024-12-02	11	1450.0	33.0	2.0	Menyusun outline	154008	PKPT-NG	2024-12
5018461	2024-12-13	32	4145.0	32.0	51.0	Melakukan koordinasi pengawasan dan penyusunan lakip s.d TW IV 2024	156053	PKPT-NG	2024-12
5052337	2024-12-31	45	5154.0	34.0	177.0	Monitoring spm nihil	98017.0	PKAU-NG	2024-12
4988050	2024-12-02	31	4121.0	29.0	13.0	"1. Menomor surat keluar pada Agenda Surat	\N	\N	2024-12
5027401	2024-12-17	19	2504.0	49.0	2.0	Penugasan	153781.0	PKPT-NG	2024-12
5000708	2024-12-06	11	1414.0	23.0	10.0	monitoring pengawasan pengadaan pppk dan cpns	158125	PKPT-NG	2024-12
5046991	2024-12-27	25	3480.0	23.0	10.0	mengerjakan laporan	156357.0	PKPT-NG	2024-12
5047342	2024-12-27	10	1337.0	56.0	218.0	Evaluasi ujian	-2	\N	2024-12
5003317	2024-12-07	15	1946.0	52.0	7.0	Raker	97017.0	PKAU-NG	2024-12
4990377	2024-12-02	10	1304.0	24.0	10.0	liputan kongres	-1	\N	2024-12
5001049	2024-12-06	38	4665.0	33.0	3.0	Klarifikasi	157460	PKPT-NG	2024-12
5018562	2024-12-12	10	1296.0	24.0	10.0	Pengembangan SI JFA	96728	PKAU-NG	2024-12
4999337	2024-12-05	47	5315.0	24.0	10.0	Persiapan pppk tahap 2	96901.0	PKAU-NG	2024-12
5017941	2024-12-12	12	1668.0	30.0	10.0	Keseharian ipp2	-1.0	\N	2024-12
4986546	2024-12-01	32	4194.0	58.0	12.0	Reviu tata kelola PSN. atas pembangunan  kawasan Industri Kolaka resource industrial tahun 2024	155282	PKPT-NG	2024-12
5034373	2024-12-19	21	2727.0	27.0	3.0	——————	100068.0	PKAU-NG	2024-12
4988726	2024-12-02	21	2823.0	38.0	16.0	Rutin kantor	-2.0	\N	2024-12
5021543	2024-12-14	25	3425.0	23.0	10.0	outline LED	151454.0	PKPT-NG	2024-12
5010511	2024-12-10	46	5195.0	37.0	2.0	Lkj sesma tw 4	99214.0	PKAU-NG	2024-12
5034012	2024-12-19	23	3234.0	52.0	2.0	Kompilasi GCG dan SPI	153818.0	PKPT-NG	2024-12
5036121	2024-12-20	21	2877.0	56.0	7.0	Reviu laporan	157788.0	PKPT-NG	2024-12
5014118	2024-12-11	13	1750.0	30.0	16.0	Persiapan ekpos Spip	155116.0	PKPT-NG	2024-12
5054238	2024-12-31	16	2123.0	34.0	13.0	Distribusi surat masuk dan keluar	98995.0	PKAU-NG	2024-12
5013325	2024-12-11	18	2279.0	36.0	2.0	Mengolah data	154379.0	PKPT-NG	2024-12
4990565	2024-12-03	39	4798.0	57.0	2.0	.......	156118	PKPT-NG	2024-12
4987161	2024-12-02	23	3125.0	38.0	3.0	Melakukan Audit PKKN Dugaan TPK Pekerjaan Rehab Jalan Sumber Dana DID II TA 2020	153793.0	PKPT-NG	2024-12
5037055	2024-12-20	40	4810.0	24.0	10.0	mengunggah laporan	159892	PKPT-NG	2024-12
5021326	2024-12-14	19	2413.0	52.0	18.0	Mengentry laporan tahun 2024 triwulan II dan III bidang investigasi	98984.0	PKAU-NG	2024-12
5029168	2024-12-17	15	1967.0	29.0	41.0	pengelolaan arsip	-1.0	\N	2024-12
5052122	2024-12-31	19	2403.0	54.0	7.0	Reviu Perencanaan PBJ	153575.0	PKPT-NG	2024-12
5010215	2024-12-10	22	3040.0	37.0	2.0	Kerja	154796.0	PKPT-NG	2024-12
5011540	2024-12-10	21	2773.0	35.0	3.0	LED monitoring	158980.0	PKPT-NG	2024-12
5052791	2024-12-31	41	4903.0	56.0	245.0	Pengusulan diklat	98804.0	PKAU-NG	2024-12
5002626	2024-12-06	37	4643.0	33.0	2.0	Exit meeting	157724	PKPT-NG	2024-12
5012258	2024-12-11	14	1895.0	58.0	7.0	Entry meeting	155841.0	PKPT-NG	2024-12
5020429	2024-12-13	14	1937.0	41.0	51.0	"Melakukan pencatatan penugasan Pengawasan dan non pengawasan pada Bidang P3A	\N	\N	2024-12
5013763	2024-12-11	13	1826.0	33.0	2.0	masih bantu susun laporan	154878.0	PKPT-NG	2024-12
5051396	2024-12-30	23	3145.0	34.0	16.0	Susun laporan	159535.0	PKPT-NG	2024-12
5003815	2024-12-07	16	2088.0	29.0	16.0	Jam pimpinan Arahan Pak Kaper dan Pak Direktur (Raker)	96746.0	PKAU-NG	2024-12
5023155	2024-12-16	34	4332	34	3.0	baca pedoman	156987	PKPT-NG	2024-12
5006658	2024-12-09	35	4421	36	2.0	Laporan Desa, Laporan Bulanan, SHP Desa, dan Laporan SPIP	154399	PKPT-NG	2024-12
5020567	2024-12-13	15	2025.0	24.0	10.0	Finalisasi Laporan	-3.0	\N	2024-12
5034015	2024-12-19	27	3710.0	38.0	57.0	Kelengkapan SKP, 360	99844	PKAU-NG	2024-12
5002459	2024-12-06	22	3044.0	33.0	3.0	Menyusun kka ph	152786.0	PKPT-NG	2024-12
5026006	2024-12-16	4	675.0	24.0	10.0	Membuat bahan paparan pimpinan	-1.0	\N	2024-12
5016205	2024-12-12	31	4054.0	34.0	193.0	Dokumentasi panel spip. Menyiapkan sarana dan prasarana panel spip. Menyusun laporan sintesa hasil pengawasan bagian umum tw 4	-1	\N	2024-12
5030808	2024-12-18	28	3786.0	38.0	2.0	FGD SPIP	-1	\N	2024-12
4991991	2024-12-03	1	36	37.0	2.0	Evaluasi	153486	PKPT-NG	2024-12
5021499	2024-12-14	19	2446.0	56.0	2.0	Rancangan bab 3 lkj	-1.0	\N	2024-12
5031065	2024-12-18	3	459.0	52.0	11.0	Tugas ke TUP an PPKD	-2.0	\N	2024-12
4990187	2024-12-02	12	1618.0	35.0	3.0	Pkkn kominfo taput	156613.0	PKPT-NG	2024-12
4988979	2024-12-02	39	4748.0	34.0	2.0	Susun laporan	-1	\N	2024-12
5016959	2024-12-12	12	1608.0	55.0	243.0	Penjaminan kualitas	-1.0	\N	2024-12
4987064	2024-12-02	2	369.0	28.0	10.0	PAPBJ Menpan	153071.0	PKPT-NG	2024-12
5010593	2024-12-10	18	2309.0	33.0	2.0	Evaluasi spip	154375.0	PKPT-NG	2024-12
5021466	2024-12-14	29	3843.0	23.0	10.0	Mengisi kertas kerja	158858	PKPT-NG	2024-12
5033709	2024-12-19	28	3775.0	28.0	193.0	Validasi gdn	100107	PKAU-NG	2024-12
5037836	2024-12-20	11	1395.0	25.0	10.0	Mengisi kk	159767	PKPT-NG	2024-12
5052180	2024-12-31	21	2766.0	57.0	2.0	Tugas rutin kantor	-1.0	\N	2024-12
5013744	2024-12-11	1	121	29.0	3.0	Pembahasan	155355	PKPT-NG	2024-12
5012747	2024-12-11	34	4350	24	10.0	Pengumpulan data	155111	PKPT-NG	2024-12
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.attendance (id, employee, date, check_in, check_out, status, remarks, created_on, updated_on, leave_type) FROM stdin;
1	4	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2	6	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
3	7	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
4	9	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
5	8	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
6	142	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
7	154	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
8	160	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
9	178	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
10	166	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
11	148	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
12	172	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
13	130	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
14	136	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
15	127	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
16	157	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
17	171	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
18	159	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
19	129	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
20	177	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
21	165	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
22	124	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
23	135	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
24	147	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
25	163	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
26	183	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
27	132	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
28	153	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
29	141	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
30	168	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
31	128	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
32	174	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
33	180	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
34	158	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
35	150	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
36	144	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
37	138	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
38	140	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
39	131	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
40	156	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
41	182	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
42	152	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
43	164	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
44	162	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
45	126	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
46	134	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
47	170	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
48	176	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
49	146	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
50	161	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
51	181	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
52	175	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
53	167	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
54	139	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
55	173	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
56	137	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
57	179	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
58	149	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
59	125	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
60	143	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
61	151	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
62	133	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
63	145	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
64	155	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
65	169	2025-01-01	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
66	4	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
67	6	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
68	7	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
69	9	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
70	8	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
71	142	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
72	154	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
73	160	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
74	178	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
75	166	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
76	148	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
77	172	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
78	130	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
79	136	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
80	127	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
81	157	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
82	171	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
83	159	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
84	129	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
85	177	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
86	165	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
87	124	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
88	135	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
89	147	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
90	163	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
91	183	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
92	132	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
93	153	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
94	141	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
95	168	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
96	128	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
97	174	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
98	180	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
99	158	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
100	150	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
101	144	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
102	138	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
103	140	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
104	131	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
105	156	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
106	182	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
107	152	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
108	164	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
109	162	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
110	126	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
111	134	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
112	170	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
113	176	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
114	146	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
115	161	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
116	181	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
117	175	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
118	167	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
119	139	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
120	173	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
121	137	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
122	179	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
123	149	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
124	125	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
125	143	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
126	151	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
127	133	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
128	145	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
129	155	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
130	169	2025-01-02	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
131	4	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
132	6	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
133	7	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
134	9	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
135	8	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
136	142	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
137	154	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
138	160	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
139	178	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
140	166	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
141	148	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
142	172	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
143	130	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
144	136	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
145	127	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
146	157	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
147	171	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
148	159	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
149	129	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
150	177	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
151	165	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
152	124	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
153	135	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
154	147	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
155	163	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
156	183	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
157	132	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
158	153	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
159	141	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
160	168	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
161	128	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
162	174	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
163	180	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
164	158	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
165	150	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
166	144	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
167	138	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
168	140	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
169	131	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
170	156	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
171	182	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
172	152	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
173	164	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
174	162	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
175	126	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
176	134	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
177	170	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
178	176	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
179	146	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
180	161	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
181	181	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
182	175	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
183	167	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
184	139	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
185	173	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
186	137	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
187	179	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
188	149	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
189	125	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
190	143	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
191	151	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
192	133	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
193	145	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
194	155	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
195	169	2025-01-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
196	4	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
197	6	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
198	7	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
199	9	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
200	8	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
201	142	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
202	154	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
203	160	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
204	178	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
205	166	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
206	148	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
207	172	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
208	130	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
209	136	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
210	127	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
211	157	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
212	171	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
213	159	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
214	129	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
215	177	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
216	165	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
217	124	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
218	135	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
219	147	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
220	163	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
221	183	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
222	132	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
223	153	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
224	141	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
225	168	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
226	128	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
227	174	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
228	180	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
229	158	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
230	150	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
231	144	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
232	138	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
233	140	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
234	131	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
235	156	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
236	182	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
237	152	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
238	164	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
239	162	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
240	126	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
241	134	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
242	170	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
243	176	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
244	146	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
245	161	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
246	181	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
247	175	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
248	167	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
249	139	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
250	173	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
251	137	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
252	179	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
253	149	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
254	125	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
255	143	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
256	151	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
257	133	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
258	145	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
259	155	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
260	169	2025-01-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
261	4	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
262	6	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
263	7	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
264	9	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
265	8	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
266	142	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
267	154	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
268	160	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
269	178	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
270	166	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
271	148	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
272	172	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
273	130	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
274	136	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
275	127	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
276	157	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
277	171	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
278	159	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
279	129	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
280	177	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
281	165	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
282	124	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
283	135	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
284	147	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
285	163	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
286	183	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
287	132	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
288	153	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
289	141	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
290	168	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
291	128	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
292	174	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
293	180	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
294	158	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
295	150	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
296	144	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
297	138	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
298	140	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
299	131	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
300	156	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
301	182	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
302	152	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
303	164	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
304	162	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
305	126	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
306	134	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
307	170	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
308	176	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
309	146	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
310	161	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
311	181	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
312	175	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
313	167	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
314	139	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
315	173	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
316	137	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
317	179	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
318	149	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
319	125	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
320	143	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
321	151	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
322	133	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
323	145	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
324	155	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
325	169	2025-01-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
326	4	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
327	6	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
328	7	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
329	9	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
330	8	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
331	142	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
332	154	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
333	160	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
334	178	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
335	166	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
336	148	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
337	172	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
338	130	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
339	136	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
340	127	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
341	157	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
342	171	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
343	159	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
344	129	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
345	177	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
346	165	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
347	124	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
348	135	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
349	147	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
350	163	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
351	183	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
352	132	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
353	153	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
354	141	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
355	168	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
356	128	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
357	174	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
358	180	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
359	158	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
360	150	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
361	144	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
362	138	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
363	140	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
364	131	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
365	156	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
366	182	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
367	152	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
368	164	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
369	162	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
370	126	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
371	134	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
372	170	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
373	176	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
374	146	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
375	161	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
376	181	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
377	175	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
378	167	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
379	139	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
380	173	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
381	137	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
382	179	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
383	149	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
384	125	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
385	143	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
386	151	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
387	133	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
388	145	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
389	155	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
390	169	2025-01-08	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
391	4	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
392	6	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
393	7	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
394	9	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
395	8	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
396	142	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
397	154	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
398	160	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
399	178	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
400	166	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
401	148	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
402	172	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
403	130	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
404	136	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
405	127	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
406	157	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
407	171	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
408	159	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
409	129	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
410	177	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
411	165	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
412	124	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
413	135	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
414	147	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
415	163	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
416	183	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
417	132	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
418	153	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
419	141	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
420	168	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
421	128	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
422	174	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
423	180	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
424	158	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
425	150	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
426	144	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
427	138	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
428	140	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
429	131	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
430	156	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
431	182	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
432	152	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
433	164	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
434	162	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
435	126	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
436	134	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
437	170	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
438	176	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
439	146	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
440	161	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
441	181	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
442	175	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
443	167	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
444	139	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
445	173	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
446	137	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
447	179	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
448	149	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
449	125	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
450	143	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
451	151	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
452	133	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
453	145	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
454	155	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
455	169	2025-01-09	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
456	4	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
457	6	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
458	7	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
459	9	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
460	8	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
461	142	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
462	154	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
463	160	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
464	178	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
465	166	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
466	148	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
467	172	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
468	130	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
469	136	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
470	127	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
471	157	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
472	171	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
473	159	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
474	129	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
475	177	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
476	165	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
477	124	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
478	135	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
479	147	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
480	163	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
481	183	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
482	132	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
483	153	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
484	141	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
485	168	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
486	128	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
487	174	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
488	180	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
489	158	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
490	150	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
491	144	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
492	138	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
493	140	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
494	131	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
495	156	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
496	182	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
497	152	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
498	164	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
499	162	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
500	126	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
501	134	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
502	170	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
503	176	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
504	146	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
505	161	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
506	181	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
507	175	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
508	167	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
509	139	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
510	173	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
511	137	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
512	179	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
513	149	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
514	125	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
515	143	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
516	151	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
517	133	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
518	145	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
519	155	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
520	169	2025-01-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
521	4	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
522	6	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
523	7	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
524	9	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
525	8	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
526	142	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
527	154	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
528	160	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
529	178	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
530	166	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
531	148	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
532	172	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
533	130	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
534	136	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
535	127	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
536	157	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
537	171	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
538	159	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
539	129	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
540	177	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
541	165	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
542	124	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
543	135	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
544	147	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
545	163	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
546	183	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
547	132	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
548	153	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
549	141	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
550	168	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
551	128	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
552	174	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
553	180	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
554	158	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
555	150	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
556	144	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
557	138	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
558	140	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
559	131	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
560	156	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
561	182	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
562	152	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
563	164	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
564	162	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
565	126	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
566	134	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
567	170	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
568	176	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
569	146	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
570	161	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
571	181	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
572	175	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
573	167	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
574	139	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
575	173	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
576	137	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
577	179	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
578	149	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
579	125	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
580	143	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
581	151	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
582	133	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
583	145	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
584	155	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
585	169	2025-01-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
586	4	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
587	6	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
588	7	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
589	9	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
590	8	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
591	142	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
592	154	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
593	160	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
594	178	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
595	166	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
596	148	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
597	172	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
598	130	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
599	136	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
600	127	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
601	157	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
602	171	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
603	159	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
604	129	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
605	177	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
606	165	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
607	124	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
608	135	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
609	147	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
610	163	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
611	183	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
612	132	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
613	153	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
614	141	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
615	168	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
616	128	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
617	174	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
618	180	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
619	158	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
620	150	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
621	144	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
622	138	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
623	140	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
624	131	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
625	156	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
626	182	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
627	152	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
628	164	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
629	162	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
630	126	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
631	134	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
632	170	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
633	176	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
634	146	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
635	161	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
636	181	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
637	175	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
638	167	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
639	139	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
640	173	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
641	137	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
642	179	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
643	149	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
644	125	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
645	143	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
646	151	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
647	133	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
648	145	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
649	155	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
650	169	2025-01-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
651	4	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
652	6	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
653	7	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
654	9	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
655	8	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
656	142	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
657	154	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
658	160	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
659	178	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
660	166	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
661	148	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
662	172	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
663	130	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
664	136	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
665	127	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
666	157	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
667	171	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
668	159	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
669	129	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
670	177	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
671	165	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
672	124	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
673	135	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
674	147	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
675	163	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
676	183	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
677	132	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
678	153	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
679	141	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
680	168	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
681	128	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
682	174	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
683	180	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
684	158	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
685	150	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
686	144	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
687	138	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
688	140	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
689	131	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
690	156	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
691	182	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
692	152	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
693	164	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
694	162	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
695	126	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
696	134	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
697	170	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
698	176	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
699	146	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
700	161	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
701	181	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
702	175	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
703	167	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
704	139	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
705	173	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
706	137	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
707	179	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
708	149	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
709	125	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
710	143	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
711	151	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
712	133	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
713	145	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
714	155	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
715	169	2025-01-15	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
716	4	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
717	6	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
718	7	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
719	9	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
720	8	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
721	142	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
722	154	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
723	160	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
724	178	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
725	166	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
726	148	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
727	172	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
728	130	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
729	136	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
730	127	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
731	157	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
732	171	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
733	159	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
734	129	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
735	177	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
736	165	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
737	124	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
738	135	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
739	147	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
740	163	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
741	183	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
742	132	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
743	153	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
744	141	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
745	168	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
746	128	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
747	174	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
748	180	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
749	158	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
750	150	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
751	144	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
752	138	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
753	140	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
754	131	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
755	156	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
756	182	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
757	152	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
758	164	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
759	162	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
760	126	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
761	134	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
762	170	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
763	176	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
764	146	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
765	161	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
766	181	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
767	175	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
768	167	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
769	139	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
770	173	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
771	137	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
772	179	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
773	149	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
774	125	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
775	143	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
776	151	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
777	133	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
778	145	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
779	155	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
780	169	2025-01-16	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
781	4	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
782	6	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
783	7	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
784	9	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
785	8	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
786	142	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
787	154	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
788	160	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
789	178	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
790	166	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
791	148	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
792	172	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
793	130	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
794	136	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
795	127	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
796	157	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
797	171	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
798	159	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
799	129	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
800	177	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
801	165	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
802	124	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
803	135	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
804	147	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
805	163	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
806	183	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
807	132	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
808	153	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
809	141	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
810	168	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
811	128	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
812	174	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
813	180	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
814	158	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
815	150	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
816	144	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
817	138	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
818	140	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
819	131	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
820	156	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
821	182	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
822	152	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
823	164	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
824	162	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
825	126	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
826	134	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
827	170	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
828	176	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
829	146	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
830	161	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
831	181	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
832	175	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
833	167	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
834	139	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
835	173	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
836	137	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
837	179	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
838	149	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
839	125	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
840	143	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
841	151	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
842	133	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
843	145	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
844	155	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
845	169	2025-01-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
846	4	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
847	6	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
848	7	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
849	9	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
850	8	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
851	142	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
852	154	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
853	160	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
854	178	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
855	166	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
856	148	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
857	172	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
858	130	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
859	136	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
860	127	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
861	157	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
862	171	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
863	159	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
864	129	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
865	177	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
866	165	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
867	124	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
868	135	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
869	147	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
870	163	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
871	183	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
872	132	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
873	153	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
874	141	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
875	168	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
876	128	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
877	174	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
878	180	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
879	158	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
880	150	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
881	144	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
882	138	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
883	140	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
884	131	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
885	156	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
886	182	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
887	152	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
888	164	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
889	162	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
890	126	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
891	134	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
892	170	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
893	176	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
894	146	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
895	161	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
896	181	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
897	175	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
898	167	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
899	139	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
900	173	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
901	137	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
902	179	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
903	149	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
904	125	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
905	143	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
906	151	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
907	133	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
908	145	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
909	155	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
910	169	2025-01-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
911	4	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
912	6	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
913	7	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
914	9	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
915	8	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
916	142	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
917	154	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
918	160	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
919	178	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
920	166	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
921	148	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
922	172	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
923	130	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
924	136	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
925	127	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
926	157	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
927	171	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
928	159	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
929	129	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
930	177	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
931	165	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
932	124	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
933	135	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
934	147	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
935	163	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
936	183	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
937	132	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
938	153	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
939	141	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
940	168	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
941	128	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
942	174	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
943	180	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
944	158	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
945	150	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
946	144	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
947	138	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
948	140	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
949	131	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
950	156	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
951	182	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
952	152	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
953	164	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
954	162	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
955	126	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
956	134	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
957	170	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
958	176	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
959	146	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
960	161	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
961	181	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
962	175	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
963	167	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
964	139	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
965	173	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
966	137	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
967	179	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
968	149	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
969	125	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
970	143	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
971	151	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
972	133	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
973	145	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
974	155	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
975	169	2025-01-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
976	4	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
977	6	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
978	7	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
979	9	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
980	8	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
981	142	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
982	154	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
983	160	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
984	178	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
985	166	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
986	148	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
987	172	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
988	130	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
989	136	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
990	127	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
991	157	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
992	171	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
993	159	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
994	129	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
995	177	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
996	165	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
997	124	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
998	135	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
999	147	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1000	163	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1001	183	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1002	132	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1003	153	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1004	141	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1005	168	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1006	128	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1007	174	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1008	180	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1009	158	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1010	150	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1011	144	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1012	138	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1013	140	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1014	131	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1015	156	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1016	182	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1017	152	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1018	164	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1019	162	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1020	126	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1021	134	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1022	170	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1023	176	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1024	146	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1025	161	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1026	181	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1027	175	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1028	167	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1029	139	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1030	173	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1031	137	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1032	179	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1033	149	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1034	125	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1035	143	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1036	151	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1037	133	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1038	145	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1039	155	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1040	169	2025-01-22	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1041	4	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1042	6	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1043	7	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1044	9	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1045	8	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1046	142	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1047	154	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1048	160	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1049	178	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1050	166	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1051	148	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1052	172	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1053	130	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1054	136	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1055	127	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1056	157	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1057	171	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1058	159	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1059	129	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1060	177	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1061	165	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1062	124	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1063	135	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1064	147	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1065	163	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1066	183	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1067	132	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1068	153	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1069	141	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1070	168	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1071	128	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1072	174	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1073	180	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1074	158	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1075	150	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1076	144	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1077	138	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1078	140	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1079	131	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1080	156	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1081	182	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1082	152	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1083	164	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1084	162	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1085	126	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1086	134	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1087	170	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1088	176	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1089	146	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1090	161	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1091	181	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1092	175	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1093	167	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1094	139	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1095	173	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1096	137	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1097	179	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1098	149	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1099	125	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1100	143	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1101	151	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1102	133	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1103	145	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1104	155	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1105	169	2025-01-23	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1106	4	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1107	6	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1108	7	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1109	9	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1110	8	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1111	142	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1112	154	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1113	160	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1114	178	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1115	166	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1116	148	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1117	172	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1118	130	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1119	136	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1120	127	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1121	157	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1122	171	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1123	159	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1124	129	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1125	177	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1126	165	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1127	124	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1128	135	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1129	147	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1130	163	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1131	183	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1132	132	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1133	153	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1134	141	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1135	168	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1136	128	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1137	174	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1138	180	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1139	158	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1140	150	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1141	144	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1142	138	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1143	140	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1144	131	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1145	156	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1146	182	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1147	152	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1148	164	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1149	162	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1150	126	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1151	134	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1152	170	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1153	176	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1154	146	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1155	161	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1156	181	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1157	175	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1158	167	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1159	139	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1160	173	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1161	137	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1162	179	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1163	149	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1164	125	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1165	143	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1166	151	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1167	133	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1168	145	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1169	155	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1170	169	2025-01-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1171	4	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1172	6	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1173	7	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1174	9	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1175	8	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1176	142	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1177	154	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1178	160	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1179	178	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1180	166	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1181	148	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1182	172	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1183	130	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1184	136	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1185	127	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1186	157	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1187	171	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1188	159	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1189	129	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1190	177	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1191	165	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1192	124	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1193	135	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1194	147	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1195	163	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1196	183	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1197	132	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1198	153	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1199	141	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1200	168	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1201	128	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1202	174	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1203	180	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1204	158	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1205	150	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1206	144	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1207	138	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1208	140	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1209	131	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1210	156	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1211	182	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1212	152	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1213	164	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1214	162	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1215	126	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1216	134	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1217	170	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1218	176	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1219	146	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1220	161	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1221	181	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1222	175	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1223	167	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1224	139	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1225	173	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1226	137	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1227	179	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1228	149	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1229	125	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1230	143	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1231	151	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1232	133	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1233	145	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1234	155	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1235	169	2025-01-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1236	4	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1237	6	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1238	7	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1239	9	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1240	8	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1241	142	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1242	154	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1243	160	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1244	178	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1245	166	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1246	148	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1247	172	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1248	130	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1249	136	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1250	127	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1251	157	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1252	171	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1253	159	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1254	129	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1255	177	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1256	165	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1257	124	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1258	135	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1259	147	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1260	163	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1261	183	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1262	132	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1263	153	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1264	141	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1265	168	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1266	128	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1267	174	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1268	180	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1269	158	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1270	150	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1271	144	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1272	138	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1273	140	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1274	131	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1275	156	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1276	182	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1277	152	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1278	164	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1279	162	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1280	126	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1281	134	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1282	170	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1283	176	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1284	146	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1285	161	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1286	181	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1287	175	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1288	167	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1289	139	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1290	173	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1291	137	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1292	179	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1293	149	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1294	125	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1295	143	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1296	151	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1297	133	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1298	145	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1299	155	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1300	169	2025-01-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1301	4	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1302	6	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1303	7	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1304	9	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1305	8	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1306	142	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1307	154	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1308	160	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1309	178	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1310	166	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1311	148	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1312	172	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1313	130	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1314	136	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1315	127	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1316	157	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1317	171	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1318	159	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1319	129	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1320	177	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1321	165	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1322	124	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1323	135	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1324	147	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1325	163	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1326	183	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1327	132	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1328	153	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1329	141	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1330	168	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1331	128	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1332	174	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1333	180	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1334	158	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1335	150	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1336	144	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1337	138	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1338	140	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1339	131	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1340	156	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1341	182	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1342	152	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1343	164	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1344	162	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1345	126	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1346	134	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1347	170	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1348	176	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1349	146	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1350	161	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1351	181	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1352	175	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1353	167	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1354	139	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1355	173	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1356	137	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1357	179	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1358	149	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1359	125	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1360	143	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1361	151	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1362	133	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1363	145	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1364	155	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1365	169	2025-01-29	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1366	4	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1367	6	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1368	7	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1369	9	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1370	8	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1371	142	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1372	154	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1373	160	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1374	178	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1375	166	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1376	148	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1377	172	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1378	130	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1379	136	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1380	127	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1381	157	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1382	171	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1383	159	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1384	129	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1385	177	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1386	165	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1387	124	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1388	135	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1389	147	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1390	163	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1391	183	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1392	132	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1393	153	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1394	141	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1395	168	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1396	128	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1397	174	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1398	180	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1399	158	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1400	150	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1401	144	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1402	138	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1403	140	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1404	131	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1405	156	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1406	182	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1407	152	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1408	164	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1409	162	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1410	126	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1411	134	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1412	170	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1413	176	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1414	146	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1415	161	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1416	181	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1417	175	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1418	167	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1419	139	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1420	173	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1421	137	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1422	179	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1423	149	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1424	125	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1425	143	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1426	151	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1427	133	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1428	145	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1429	155	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1430	169	2025-01-30	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1431	4	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1432	6	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1433	7	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1434	9	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1435	8	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1436	142	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1437	154	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1438	160	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1439	178	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1440	166	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1441	148	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1442	172	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1443	130	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1444	136	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1445	127	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1446	157	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1447	171	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1448	159	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1449	129	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1450	177	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1451	165	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1452	124	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1453	135	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1454	147	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1455	163	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1456	183	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1457	132	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1458	153	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1459	141	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1460	168	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1461	128	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1462	174	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1463	180	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1464	158	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1465	150	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1466	144	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1467	138	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1468	140	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1469	131	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1470	156	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1471	182	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1472	152	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1473	164	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1474	162	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1475	126	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1476	134	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1477	170	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1478	176	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1479	146	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1480	161	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1481	181	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1482	175	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1483	167	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1484	139	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1485	173	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1486	137	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1487	179	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1488	149	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1489	125	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1490	143	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1491	151	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1492	133	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1493	145	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1494	155	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1495	169	2025-01-31	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1496	4	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1497	6	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1498	7	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1499	9	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1500	8	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1501	142	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1502	154	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1503	160	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1504	178	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1505	166	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1506	148	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1507	172	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1508	130	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1509	136	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1510	127	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1511	157	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1512	171	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1513	159	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1514	129	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1515	177	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1516	165	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1517	124	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1518	135	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1519	147	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1520	163	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1521	183	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1522	132	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1523	153	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1524	141	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1525	168	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1526	128	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1527	174	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1528	180	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1529	158	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1530	150	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1531	144	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1532	138	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1533	140	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1534	131	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1535	156	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1536	182	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1537	152	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1538	164	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1539	162	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1540	126	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1541	134	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1542	170	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1543	176	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1544	146	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1545	161	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1546	181	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1547	175	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1548	167	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1549	139	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1550	173	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1551	137	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1552	179	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1553	149	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1554	125	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1555	143	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1556	151	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1557	133	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1558	145	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1559	155	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1560	169	2025-02-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1561	4	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1562	6	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1563	7	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1564	9	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1565	8	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1566	142	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1567	154	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1568	160	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1569	178	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1570	166	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1571	148	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1572	172	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1573	130	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1574	136	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1575	127	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1576	157	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1577	171	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1578	159	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1579	129	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1580	177	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1581	165	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1582	124	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1583	135	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1584	147	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1585	163	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1586	183	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1587	132	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1588	153	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1589	141	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1590	168	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1591	128	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1592	174	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1593	180	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1594	158	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1595	150	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1596	144	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1597	138	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1598	140	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1599	131	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1600	156	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1601	182	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1602	152	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1603	164	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1604	162	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1605	126	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1606	134	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1607	170	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1608	176	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1609	146	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1610	161	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1611	181	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1612	175	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1613	167	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1614	139	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1615	173	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1616	137	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1617	179	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1618	149	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1619	125	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1620	143	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1621	151	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1622	133	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1623	145	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1624	155	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1625	169	2025-02-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1626	4	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1627	6	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1628	7	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1629	9	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1630	8	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1631	142	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1632	154	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1633	160	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1634	178	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1635	166	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1636	148	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1637	172	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1638	130	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1639	136	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1640	127	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1641	157	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1642	171	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1643	159	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1644	129	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1645	177	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1646	165	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1647	124	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1648	135	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1649	147	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1650	163	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1651	183	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1652	132	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1653	153	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1654	141	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1655	168	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1656	128	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1657	174	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1658	180	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1659	158	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1660	150	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1661	144	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1662	138	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1663	140	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1664	131	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1665	156	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1666	182	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1667	152	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1668	164	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1669	162	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1670	126	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1671	134	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1672	170	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1673	176	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1674	146	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1675	161	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1676	181	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1677	175	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1678	167	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1679	139	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1680	173	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1681	137	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1682	179	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1683	149	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1684	125	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1685	143	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1686	151	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1687	133	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1688	145	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1689	155	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1690	169	2025-02-05	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1691	4	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1692	6	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1693	7	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1694	9	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1695	8	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1696	142	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1697	154	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1698	160	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1699	178	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1700	166	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1701	148	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1702	172	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1703	130	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1704	136	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1705	127	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1706	157	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1707	171	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1708	159	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1709	129	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1710	177	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1711	165	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1712	124	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1713	135	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1714	147	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1715	163	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1716	183	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1717	132	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1718	153	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1719	141	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1720	168	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1721	128	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1722	174	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1723	180	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1724	158	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1725	150	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1726	144	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1727	138	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1728	140	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1729	131	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1730	156	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1731	182	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1732	152	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1733	164	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1734	162	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1735	126	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1736	134	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1737	170	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1738	176	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1739	146	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1740	161	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1741	181	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1742	175	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1743	167	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1744	139	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1745	173	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1746	137	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1747	179	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1748	149	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1749	125	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1750	143	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1751	151	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1752	133	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1753	145	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1754	155	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1755	169	2025-02-06	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1756	4	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1757	6	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1758	7	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1759	9	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1760	8	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1761	142	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1762	154	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1763	160	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1764	178	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1765	166	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1766	148	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1767	172	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1768	130	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1769	136	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1770	127	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1771	157	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1772	171	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1773	159	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1774	129	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1775	177	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1776	165	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1777	124	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1778	135	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1779	147	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1780	163	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1781	183	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1782	132	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1783	153	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1784	141	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1785	168	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1786	128	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1787	174	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1788	180	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1789	158	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1790	150	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1791	144	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1792	138	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1793	140	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1794	131	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1795	156	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1796	182	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1797	152	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1798	164	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1799	162	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1800	126	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1801	134	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1802	170	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1803	176	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1804	146	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1805	161	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1806	181	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1807	175	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1808	167	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1809	139	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1810	173	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1811	137	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1812	179	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1813	149	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1814	125	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1815	143	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1816	151	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1817	133	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1818	145	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1819	155	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1820	169	2025-02-07	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1821	4	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1822	6	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1823	7	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1824	9	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1825	8	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1826	142	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1827	154	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1828	160	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1829	178	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1830	166	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1831	148	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1832	172	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1833	130	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1834	136	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1835	127	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1836	157	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1837	171	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1838	159	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1839	129	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1840	177	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1841	165	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1842	124	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1843	135	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1844	147	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1845	163	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1846	183	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1847	132	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1848	153	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1849	141	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1850	168	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1851	128	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1852	174	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1853	180	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1854	158	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1855	150	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1856	144	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1857	138	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1858	140	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1859	131	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1860	156	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1861	182	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1862	152	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1863	164	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1864	162	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1865	126	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1866	134	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1867	170	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1868	176	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1869	146	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1870	161	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1871	181	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1872	175	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1873	167	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1874	139	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1875	173	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1876	137	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1877	179	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1878	149	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1879	125	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1880	143	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1881	151	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1882	133	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1883	145	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1884	155	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1885	169	2025-02-10	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1886	4	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1887	6	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1888	7	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1889	9	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1890	8	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1891	142	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1892	154	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1893	160	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1894	178	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1895	166	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1896	148	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1897	172	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1898	130	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1899	136	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1900	127	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1901	157	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1902	171	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1903	159	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1904	129	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1905	177	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1906	165	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1907	124	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1908	135	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1909	147	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1910	163	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1911	183	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1912	132	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1913	153	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1914	141	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1915	168	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1916	128	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1917	174	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1918	180	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1919	158	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1920	150	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1921	144	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1922	138	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1923	140	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1924	131	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1925	156	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1926	182	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1927	152	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1928	164	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1929	162	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1930	126	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1931	134	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1932	170	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1933	176	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1934	146	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1935	161	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1936	181	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1937	175	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1938	167	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1939	139	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1940	173	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1941	137	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1942	179	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1943	149	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1944	125	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1945	143	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1946	151	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1947	133	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1948	145	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1949	155	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1950	169	2025-02-11	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1951	4	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1952	6	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1953	7	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1954	9	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1955	8	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1956	142	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1957	154	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1958	160	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1959	178	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1960	166	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1961	148	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1962	172	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1963	130	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1964	136	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1965	127	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1966	157	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1967	171	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1968	159	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1969	129	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1970	177	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1971	165	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1972	124	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1973	135	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1974	147	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1975	163	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1976	183	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1977	132	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1978	153	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1979	141	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1980	168	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1981	128	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1982	174	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1983	180	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1984	158	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1985	150	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1986	144	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1987	138	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1988	140	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1989	131	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1990	156	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1991	182	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1992	152	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1993	164	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1994	162	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1995	126	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1996	134	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1997	170	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1998	176	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
1999	146	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2000	161	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2001	181	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2002	175	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2003	167	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2004	139	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2005	173	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2006	137	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2007	179	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2008	149	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2009	125	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2010	143	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2011	151	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2012	133	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2013	145	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2014	155	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2015	169	2025-02-12	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2016	4	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2017	6	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2018	7	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2019	9	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2020	8	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2021	142	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2022	154	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2023	160	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2024	178	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2025	166	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2026	148	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2027	172	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2028	130	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2029	136	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2030	127	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2031	157	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2032	171	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2033	159	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2034	129	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2035	177	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2036	165	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2037	124	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2038	135	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2039	147	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2040	163	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2041	183	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2042	132	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2043	153	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2044	141	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2045	168	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2046	128	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2047	174	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2048	180	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2049	158	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2050	150	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2051	144	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2052	138	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2053	140	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2054	131	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2055	156	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2056	182	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2057	152	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2058	164	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2059	162	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2060	126	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2061	134	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2062	170	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2063	176	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2064	146	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2065	161	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2066	181	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2067	175	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2068	167	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2069	139	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2070	173	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2071	137	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2072	179	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2073	149	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2074	125	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2075	143	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2076	151	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2077	133	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2078	145	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2079	155	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2080	169	2025-02-13	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2081	4	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2082	6	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2083	7	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2084	9	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2085	8	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2086	142	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2087	154	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2088	160	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2089	178	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2090	166	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2091	148	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2092	172	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2093	130	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2094	136	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2095	127	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2096	157	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2097	171	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2098	159	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2099	129	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2100	177	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2101	165	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2102	124	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2103	135	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2104	147	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2105	163	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2106	183	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2107	132	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2108	153	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2109	141	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2110	168	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2111	128	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2112	174	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2113	180	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2114	158	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2115	150	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2116	144	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2117	138	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2118	140	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2119	131	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2120	156	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2121	182	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2122	152	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2123	164	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2124	162	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2125	126	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2126	134	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2127	170	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2128	176	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2129	146	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2130	161	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2131	181	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2132	175	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2133	167	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2134	139	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2135	173	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2136	137	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2137	179	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2138	149	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2139	125	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2140	143	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2141	151	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2142	133	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2143	145	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2144	155	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2145	169	2025-02-14	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2146	4	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2147	6	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2148	7	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2149	9	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2150	8	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2151	142	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2152	154	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2153	160	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2154	178	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2155	166	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2156	148	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2157	172	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2158	130	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2159	136	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2160	127	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2161	157	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2162	171	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2163	159	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2164	129	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2165	177	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2166	165	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2167	124	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2168	135	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2169	147	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2170	163	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2171	183	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2172	132	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2173	153	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2174	141	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2175	168	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2176	128	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2177	174	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2178	180	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2179	158	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2180	150	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2181	144	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2182	138	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2183	140	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2184	131	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2185	156	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2186	182	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2187	152	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2188	164	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2189	162	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2190	126	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2191	134	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2192	170	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2193	176	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2194	146	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2195	161	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2196	181	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2197	175	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2198	167	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2199	139	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2200	173	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2201	137	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2202	179	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2203	149	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2204	125	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2205	143	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2206	151	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2207	133	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2208	145	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2209	155	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2210	169	2025-02-17	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2211	4	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2212	6	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2213	7	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2214	9	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2215	8	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2216	142	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2217	154	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2218	160	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2219	178	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2220	166	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2221	148	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2222	172	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2223	130	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2224	136	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2225	127	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2226	157	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2227	171	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2228	159	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2229	129	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2230	177	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2231	165	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2232	124	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2233	135	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2234	147	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2235	163	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2236	183	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2237	132	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2238	153	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2239	141	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2240	168	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2241	128	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2242	174	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2243	180	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2244	158	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2245	150	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2246	144	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2247	138	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2248	140	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2249	131	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2250	156	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2251	182	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2252	152	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2253	164	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2254	162	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2255	126	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2256	134	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2257	170	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2258	176	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2259	146	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2260	161	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2261	181	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2262	175	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2263	167	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2264	139	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2265	173	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2266	137	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2267	179	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2268	149	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2269	125	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2270	143	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2271	151	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2272	133	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2273	145	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2274	155	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2275	169	2025-02-18	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2276	4	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2277	6	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2278	7	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2279	9	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2280	8	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2281	142	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2282	154	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2283	160	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2284	178	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2285	166	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2286	148	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2287	172	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2288	130	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2289	136	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2290	127	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2291	157	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2292	171	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2293	159	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2294	129	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2295	177	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2296	165	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2297	124	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2298	135	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2299	147	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2300	163	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2301	183	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2302	132	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2303	153	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2304	141	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2305	168	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2306	128	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2307	174	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2308	180	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2309	158	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2310	150	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2311	144	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2312	138	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2313	140	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2314	131	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2315	156	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2316	182	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2317	152	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2318	164	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2319	162	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2320	126	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2321	134	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2322	170	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2323	176	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2324	146	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2325	161	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2326	181	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2327	175	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2328	167	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2329	139	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2330	173	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2331	137	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2332	179	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2333	149	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2334	125	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2335	143	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2336	151	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2337	133	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2338	145	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2339	155	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2340	169	2025-02-19	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2341	4	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2342	6	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2343	7	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2344	9	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2345	8	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2346	142	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2347	154	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2348	160	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2349	178	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2350	166	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2351	148	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2352	172	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2353	130	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2354	136	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2355	127	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2356	157	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2357	171	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2358	159	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2359	129	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2360	177	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2361	165	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2362	124	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2363	135	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2364	147	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2365	163	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2366	183	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2367	132	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2368	153	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2369	141	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2370	168	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2371	128	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2372	174	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2373	180	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2374	158	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2375	150	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2376	144	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2377	138	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2378	140	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2379	131	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2380	156	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2381	182	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2382	152	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2383	164	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2384	162	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2385	126	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2386	134	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2387	170	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2388	176	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2389	146	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2390	161	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2391	181	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2392	175	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2393	167	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2394	139	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2395	173	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2396	137	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2397	179	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2398	149	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2399	125	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2400	143	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2401	151	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2402	133	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2403	145	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2404	155	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2405	169	2025-02-20	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2406	4	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2407	6	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2408	7	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2409	9	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2410	8	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2411	142	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2412	154	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2413	160	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2414	178	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2415	166	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2416	148	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2417	172	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2418	130	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2419	136	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2420	127	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2421	157	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2422	171	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2423	159	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2424	129	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2425	177	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2426	165	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2427	124	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2428	135	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2429	147	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2430	163	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2431	183	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2432	132	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2433	153	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2434	141	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2435	168	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2436	128	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2437	174	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2438	180	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2439	158	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2440	150	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2441	144	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2442	138	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2443	140	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2444	131	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2445	156	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2446	182	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2447	152	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2448	164	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2449	162	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2450	126	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2451	134	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2452	170	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2453	176	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2454	146	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2455	161	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2456	181	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2457	175	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2458	167	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2459	139	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2460	173	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2461	137	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2462	179	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2463	149	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2464	125	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2465	143	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2466	151	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2467	133	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2468	145	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2469	155	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2470	169	2025-02-21	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2471	4	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2472	6	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2473	7	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2474	9	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2475	8	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2476	142	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2477	154	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2478	160	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2479	178	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2480	166	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2481	148	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2482	172	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2483	130	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2484	136	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2485	127	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2486	157	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2487	171	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2488	159	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2489	129	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2490	177	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2491	165	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2492	124	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2493	135	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2494	147	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2495	163	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2496	183	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2497	132	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2498	153	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2499	141	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2500	168	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2501	128	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2502	174	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2503	180	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2504	158	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2505	150	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2506	144	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2507	138	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2508	140	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2509	131	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2510	156	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2511	182	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2512	152	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2513	164	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2514	162	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2515	126	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2516	134	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2517	170	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2518	176	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2519	146	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2520	161	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2521	181	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2522	175	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2523	167	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2524	139	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2525	173	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2526	137	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2527	179	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2528	149	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2529	125	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2530	143	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2531	151	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2532	133	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2533	145	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2534	155	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2535	169	2025-02-24	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2536	4	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2537	6	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2538	7	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2539	9	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2540	8	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2541	142	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2542	154	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2543	160	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2544	178	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2545	166	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2546	148	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2547	172	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2548	130	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2549	136	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2550	127	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2551	157	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2552	171	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2553	159	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2554	129	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2555	177	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2556	165	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2557	124	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2558	135	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2559	147	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2560	163	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2561	183	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2562	132	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2563	153	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2564	141	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2565	168	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2566	128	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2567	174	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2568	180	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2569	158	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2570	150	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2571	144	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2572	138	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2573	140	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2574	131	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2575	156	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2576	182	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2577	152	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2578	164	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2579	162	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2580	126	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2581	134	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2582	170	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2583	176	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2584	146	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2585	161	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2586	181	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2587	175	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2588	167	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2589	139	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2590	173	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2591	137	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2592	179	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2593	149	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2594	125	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2595	143	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2596	151	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2597	133	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2598	145	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2599	155	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2600	169	2025-02-25	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2601	4	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2602	6	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2603	7	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2604	9	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2605	8	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2606	142	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2607	154	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2608	160	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2609	178	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2610	166	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2611	148	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2612	172	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2613	130	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2614	136	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2615	127	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2616	157	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2617	171	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2618	159	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2619	129	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2620	177	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2621	165	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2622	124	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2623	135	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2624	147	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2625	163	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2626	183	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2627	132	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2628	153	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2629	141	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2630	168	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2631	128	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2632	174	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2633	180	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2634	158	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2635	150	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2636	144	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2637	138	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2638	140	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2639	131	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2640	156	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2641	182	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2642	152	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2643	164	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2644	162	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2645	126	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2646	134	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2647	170	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2648	176	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2649	146	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2650	161	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2651	181	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2652	175	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2653	167	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2654	139	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2655	173	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2656	137	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2657	179	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2658	149	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2659	125	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2660	143	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2661	151	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2662	133	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2663	145	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2664	155	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2665	169	2025-02-26	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2666	4	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2667	6	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2668	7	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2669	9	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2670	8	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2671	142	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2672	154	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2673	160	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2674	178	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2675	166	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2676	148	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2677	172	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2678	130	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2679	136	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2680	127	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2681	157	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2682	171	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2683	159	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2684	129	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2685	177	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2686	165	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2687	124	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2688	135	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2689	147	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2690	163	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2691	183	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2692	132	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2693	153	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2694	141	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2695	168	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2696	128	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2697	174	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2698	180	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2699	158	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2700	150	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2701	144	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2702	138	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2703	140	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2704	131	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2705	156	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2706	182	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2707	152	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2708	164	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2709	162	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2710	126	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2711	134	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2712	170	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2713	176	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2714	146	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2715	161	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2716	181	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2717	175	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2718	167	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2719	139	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2720	173	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2721	137	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2722	179	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2723	149	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2724	125	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2725	143	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2726	151	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2727	133	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2728	145	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2729	155	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2730	169	2025-02-27	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2731	4	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2732	6	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2733	7	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2734	9	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2735	8	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2736	142	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2737	154	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2738	160	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2739	178	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2740	166	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2741	148	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2742	172	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2743	130	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2744	136	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2745	127	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2746	157	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2747	171	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2748	159	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2749	129	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2750	177	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2751	165	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2752	124	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2753	135	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2754	147	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2755	163	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2756	183	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2757	132	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2758	153	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2759	141	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2760	168	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2761	128	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2762	174	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2763	180	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2764	158	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2765	150	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2766	144	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2767	138	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2768	140	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2769	131	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2770	156	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2771	182	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2772	152	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2773	164	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2774	162	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2775	126	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2776	134	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2777	170	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2778	176	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2779	146	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2780	161	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2781	181	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2782	175	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2783	167	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2784	139	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2785	173	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2786	137	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2787	179	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2788	149	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2789	125	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2790	143	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2791	151	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2792	133	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2793	145	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2794	155	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2795	169	2025-02-28	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2796	4	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2797	6	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2798	7	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2799	9	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2800	8	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2801	142	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2802	154	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2803	160	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2804	178	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2805	166	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2806	148	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2807	172	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2808	130	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2809	136	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2810	127	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2811	157	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2812	171	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2813	159	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2814	129	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2815	177	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2816	165	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2817	124	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2818	135	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2819	147	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2820	163	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2821	183	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2822	132	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2823	153	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2824	141	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2825	168	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2826	128	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2827	174	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2828	180	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2829	158	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2830	150	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2831	144	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2832	138	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2833	140	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2834	131	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2835	156	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2836	182	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2837	152	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2838	164	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2839	162	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2840	126	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2841	134	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2842	170	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2843	176	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2844	146	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2845	161	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2846	181	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2847	175	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2848	167	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2849	139	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2850	173	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2851	137	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2852	179	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2853	149	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2854	125	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2855	143	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2856	151	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2857	133	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2858	145	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2859	155	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2860	169	2025-03-03	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2861	4	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2862	6	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2863	7	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2864	9	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2865	8	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2866	142	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2867	154	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2868	160	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2869	178	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2870	166	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2871	148	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2872	172	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2873	130	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2874	136	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2875	127	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2876	157	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2877	171	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2878	159	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2879	129	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2880	177	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2881	165	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2882	124	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2883	135	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2884	147	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2885	163	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2886	183	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2887	132	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2888	153	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2889	141	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2890	168	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2891	128	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2892	174	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2893	180	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2894	158	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2895	150	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2896	144	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2897	138	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2898	140	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2899	131	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2900	156	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2901	182	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2902	152	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2903	164	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2904	162	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2905	126	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2906	134	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2907	170	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2908	176	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2909	146	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2910	161	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2911	181	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2912	175	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2913	167	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2914	139	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2915	173	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2916	137	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2917	179	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2918	149	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2919	125	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2920	143	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2921	151	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2922	133	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2923	145	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2924	155	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
2925	169	2025-03-04	08:00:00	16:30:00	1	\N	2025-03-04 17:43:30.38926	\N	\N
\.


--
-- Data for Name: dependents; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.dependents (id, first_name, last_name, relationship, employee, created_on, updated_on) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.employees (id, id_number, first_name, last_name, citizen_number, birth_place, birth_date, address, email, phone_number, tax_number, hire_date, resignation_date, rank, job, unit, manager, salary, created_on, updated_on, sex) FROM stdin;
147	199307251999122024	Sari	Handayani	3210242309930024	Tegal	1993-07-25	Jl. Cempaka No.8, Tegal	sari.handayani@example.com	083456789012	3210242309930024	1999-12-01	\N	9	11	5	8	0	2025-03-04 13:21:58.719069	\N	2
131	199206251998082008	Lisa	Nugraha	3210082908920008	Palembang	1992-06-25	Jl. Cempaka No.6, Palembang	lisa.nugraha@example.com	081890123456	3210082908920008	1998-08-01	\N	6	7	5	8	0	2025-03-04 13:21:58.57785	\N	2
141	199406151998062018	Dewi	Sartika	3210181809940018	Batam	1994-06-15	Jl. Kamboja No.2, Batam	dewi.sartika@example.com	082890123456	3210181809940018	1998-06-01	\N	8	11	5	8	0	2025-03-04 13:21:58.642071	\N	2
153	199509101999062030	Lina	Haryanti	3210301809950030	Purwokerto	1995-09-10	Jl. Seruni No.5, Purwokerto	lina.haryanti@example.com	084012345678	3210301809950030	1999-06-01	\N	8	11	5	8	0	2025-03-04 13:21:58.719069	\N	2
139	199309101999042016	Rina	Putri	3210162509930016	Samarinda	1993-09-10	Jl. Melur No.6, Samarinda	rina.putri@example.com	082678901234	3210162509930016	1999-04-01	\N	5	9	5	8	0	2025-03-04 13:21:58.642071	\N	2
127	198712301997042004	Rina	Kusuma	3210041507920004	Medan	1987-12-30	Jl. Kenanga No.8, Medan	rina.kusuma@example.com	081456789012	3210041507920004	1997-04-01	\N	10	9	5	8	0	2025-03-04 13:21:58.57785	\N	2
137	198905151998022014	Yuli	Handayani	3210140908890014	Pekanbaru	1989-05-15	Jl. Seruni No.7, Pekanbaru	yuli.handayani@example.com	082456789012	3210140908890014	1998-02-01	\N	5	7	5	8	0	2025-03-04 13:21:58.642071	\N	2
155	199311151999082032	Sinta	Wulandari	3210321809930032	Jambi	1993-11-15	Jl. Melati No.5, Jambi	sinta.wulandari@example.com	084234567890	3210321809930032	1999-08-01	\N	5	7	5	8	0	2025-03-04 13:21:58.808574	\N	2
145	199208201998102022	Wulan	Pertiwi	3210221808920022	Depok	1992-08-20	Jl. Anggrek No.4, Depok	wulan.pertiwi@example.com	083234567890	3210221808920022	1998-10-01	\N	5	9	5	8	0	2025-03-04 13:21:58.719069	\N	2
133	199512201999102010	Nina	Ardiani	3210102509950010	Pontianak	1995-12-20	Jl. Tulip No.5, Pontianak	nina.ardiani@example.com	082012345678	3210102509950010	1999-10-01	\N	5	9	5	8	0	2025-03-04 13:21:58.57785	\N	2
135	199107301997122012	Desi	Amalia	3210122008910012	Padang	1991-07-30	Jl. Bougenville No.10, Padang	desi.amalia@example.com	082234567890	3210122008910012	1997-12-01	\N	9	11	5	8	0	2025-03-04 13:21:58.642071	\N	2
151	199404251999042028	Nia	Kusumawati	3210282109940028	Serang	1994-04-25	Jl. Flamboyan No.12, Serang	nia.kusumawati@example.com	083890123456	3210282109940028	1999-04-01	\N	5	9	5	8	0	2025-03-04 13:21:58.719069	\N	2
143	199512011999082020	Novi	Cahyani	3210202809950020	Cirebon	1995-12-01	Jl. Dahlia No.5, Cirebon	novi.cahyani@example.com	083012345678	3210202809950020	1999-08-01	\N	5	7	5	8	0	2025-03-04 13:21:58.642071	\N	2
125	198502141999022002	Siti	Rahmawati	3210022507890002	Bandung	1985-02-14	Jl. Mawar No.5, Bandung	siti.rahmawati@example.com	081298765432	3210022507890002	1999-02-01	\N	5	7	5	8	0	2025-03-04 13:21:58.57785	\N	2
149	199110151998022026	Dina	Safitri	3210261509910026	Magelang	1991-10-15	Jl. Tulip No.9, Magelang	dina.safitri@example.com	083678901234	3210261509910026	1998-02-01	\N	5	7	5	8	0	2025-03-04 13:21:58.719069	\N	2
4	197005012022061092	Wahyu	Purnomo	3201100105700001	Sorong	1970-05-01	Jl. Manggis no. 20, Tugu, Cimanggis, Depok	wahyu.purnomo@example.com	089012345678	3201100105700001	2022-06-01	\N	17	1	1	\N	0	2025-03-03 09:07:14.447123	\N	1
6	197012032000011120	Agus	Wijaya	3276010312700010	Solo	1970-12-03	Jl. Apel no. 3, Tanah Baru, Beji, Depok	agus.wijaya@example.com	089012345679	3276010312700010	2000-01-01	\N	16	2	2	4	0	\N	\N	1
7	197603092006041901	Agung	Juanda	3101110903760090	Makassar	1976-03-09	Jl. Tenggiri no. 10, Sukmajaya, Sukmajaya, Depok	agung.juanda@example.com	089012345680	3101110903760090	2006-04-01	\N	14	3	3	6	0	\N	\N	1
8	198001282008072999	Dewi	Anastasia	3276096801800041	Medan	1980-01-28	Jl. Makassar no. 7, Sukahati, Cibinong, Kab. Bogor	dewi.anastasia@example.com	089012345681	3276096801800041	2008-07-01	\N	11	4	4	7	0	2025-03-03 09:19:06.09577	\N	2
9	198110052010101711	Ihsan	Hakim	3101110510810010	Jayapura	1981-10-05	Jl. Jawa no. 9, Tanggulan, Sawangan, Depok	ihsan.hakim@example.com	089012345682	3101110510810010	2010-10-01	\N	12	5	5	7	0	2025-03-03 09:21:56.416152	\N	1
124	197803051999011001	Budi	Santoso	3210011506780001	Jakarta	1978-03-05	Jl. Merdeka No.10, Jakarta	budi.santoso@example.com	081234567890	3210011506780001	1999-01-01	\N	9	6	4	7	0	2025-03-04 13:21:58.57785	\N	1
126	199001201998031003	Andi	Wijaya	3210030108900003	Surabaya	1990-01-20	Jl. Melati No.3, Surabaya	andi.wijaya@example.com	081345678901	3210030108900003	1998-03-01	\N	6	8	4	7	0	2025-03-04 13:21:58.57785	\N	1
152	198109201997051029	Toni	Kurniawan	3210291507810029	Solo	1981-09-20	Jl. Anggrek No.11, Solo	toni.kurniawan@example.com	083901234567	3210291507810029	1997-05-01	\N	6	10	4	7	0	2025-03-04 13:21:58.719069	\N	1
154	198609051996071031	Fahmi	Ramadhan	3210311507860031	Palu	1986-09-05	Jl. Kenanga No.10, Palu	fahmi.ramadhan@example.com	084123456789	3210311507860031	1996-07-01	\N	12	6	4	7	0	2025-03-04 13:21:58.808574	\N	1
156	198704201997091033	Dimas	Hernando	3210331207870033	Ambon	1987-04-20	Jl. Mawar No.8, Ambon	dimas.hernando@example.com	084345678901	3210331207870033	1997-09-01	\N	6	8	4	7	0	2025-03-04 13:21:58.808574	\N	1
158	197803101995011035	Eko	Susanto	3210351703780035	Jayapura	1978-03-10	Jl. Tulip No.4, Jayapura	eko.susanto@example.com	084567890123	3210351703780035	1995-01-01	\N	7	10	4	7	0	2025-03-04 13:21:58.808574	\N	1
160	198102051996031037	Zulfikar	Ahmad	3210371507810037	Tarakan	1981-02-05	Jl. Dahlia No.9, Tarakan	zulfikar.ahmad@example.com	084789012345	3210371507810037	1996-03-01	\N	12	6	4	7	0	2025-03-04 13:21:58.808574	\N	1
179	199308201999022056	Mira	Anggraini	3210562209930056	Banyuwangi	1993-08-20	Jl. Flamboyan No.10, Banyuwangi	mira.anggraini@example.com	086678901234	3210562209930056	1999-02-01	\N	5	7	5	8	0	2025-03-04 13:21:59.034123	\N	2
165	199312201999082042	Putri	Anggraini	3210421809930042	Banda Aceh	1993-12-20	Jl. Mawar No.10, Banda Aceh	putri.anggraini@example.com	085234567890	3210421809930042	1999-08-01	\N	9	11	5	8	0	2025-03-04 13:21:58.94992	\N	2
171	199406251998042048	Dewi	Susanti	3210481809940048	Maumere	1994-06-25	Jl. Seruni No.8, Maumere	dewi.susanti@example.com	085890123456	3210481809940048	1998-04-01	\N	9	11	5	8	0	2025-03-04 13:21:58.94992	\N	2
163	199509051999062040	Novi	Lestari	3210402809950040	Pangkalpinang	1995-09-05	Jl. Bougenville No.7, Pangkalpinang	novi.lestari@example.com	085012345678	3210402809950040	1999-06-01	\N	8	9	5	8	0	2025-03-04 13:21:58.808574	\N	2
173	199509051999062050	Nadia	Cahyani	3210502809950050	Ruteng	1995-09-05	Jl. Bougenville No.6, Ruteng	nadia.cahyani@example.com	086012345678	3210502809950050	1999-06-01	\N	5	7	5	8	0	2025-03-04 13:21:58.94992	\N	2
167	199202151998102044	Siska	Pratiwi	3210442509920044	Langsa	1992-02-15	Jl. Cempaka No.7, Langsa	siska.pratiwi@example.com	085456789012	3210442509920044	1998-10-01	\N	5	7	5	8	0	2025-03-04 13:21:58.94992	\N	2
177	199204151998102054	Sari	Hidayati	3210542509920054	Tuban	1992-04-15	Jl. Cempaka No.8, Tuban	sari.hidayati@example.com	086456789012	3210542509920054	1998-10-01	\N	9	11	5	8	0	2025-03-04 13:21:59.034123	\N	2
175	199211151998082052	Rani	Putri	3210521809920052	Tanjung Pinang	1992-11-15	Jl. Mawar No.5, Tanjung Pinang	rani.putri@example.com	086234567890	3210521809920052	1998-08-01	\N	5	9	5	8	0	2025-03-04 13:21:59.034123	\N	2
183	199512051999062060	Lina	Wijayanti	3210602809950060	Sidoarjo	1995-12-05	Jl. Bougenville No.7, Sidoarjo	lina.wijayanti@example.com	087012345678	3210602809950060	1999-06-01	\N	8	11	5	8	0	2025-03-04 13:21:59.034123	\N	2
161	199407151998042038	Dewi	Kartika	3210381809940038	Gorontalo	1994-07-15	Jl. Seruni No.6, Gorontalo	dewi.kartika@example.com	084890123456	3210381809940038	1998-04-01	\N	5	7	5	8	0	2025-03-04 13:21:58.808574	\N	2
169	199310101999022046	Wenny	Rahmawati	3210462209930046	Singaraja	1993-10-10	Jl. Flamboyan No.12, Singaraja	wenny.rahmawati@example.com	085678901234	3210462209930046	1999-02-01	\N	5	9	5	8	0	2025-03-04 13:21:58.94992	\N	2
157	199208301998102034	Lestari	Wijayanti	3210342509920034	Kendari	1992-08-30	Jl. Cempaka No.7, Kendari	lestari.wijayanti@example.com	084456789012	3210342509920034	1998-10-01	\N	10	9	5	8	0	2025-03-04 13:21:58.808574	\N	2
129	199304181999062006	Maya	Sari	3210062108940006	Yogyakarta	1993-04-18	Jl. Dahlia No.9, Yogyakarta	maya.sari@example.com	081678901234	3210062108940006	1999-06-01	\N	9	11	5	8	0	2025-03-04 13:21:58.57785	\N	2
159	199310251999022036	Rika	Permatasari	3210362209930036	Bengkulu	1993-10-25	Jl. Anggrek No.12, Bengkulu	rika.permatasari@example.com	084678901234	3210362209930036	1999-02-01	\N	9	11	5	8	0	2025-03-04 13:21:58.808574	\N	2
128	197911051996051005	Dedi	Saputra	3210051206790005	Semarang	1979-11-05	Jl. Anggrek No.7, Semarang	dedi.saputra@example.com	081567890123	3210051206790005	1996-05-01	\N	7	10	4	7	0	2025-03-04 13:21:58.57785	\N	1
130	198110121997071007	Fajar	Pratama	3210071807810007	Makassar	1981-10-12	Jl. Teratai No.4, Makassar	fajar.pratama@example.com	081789012345	3210071807810007	1997-07-01	\N	12	6	4	7	0	2025-03-04 13:21:58.57785	\N	1
132	198403091995091009	Hendra	Gunawan	3210091507830009	Banjarmasin	1984-03-09	Jl. Flamboyan No.2, Banjarmasin	hendra.gunawan@example.com	081901234567	3210091507830009	1995-09-01	\N	8	8	4	7	0	2025-03-04 13:21:58.57785	\N	1
134	198611151996111011	Rizky	Permana	3210111507860011	Manado	1986-11-15	Jl. Mawar No.11, Manado	rizky.permana@example.com	082123456789	3210111507860011	1996-11-01	\N	6	10	4	7	0	2025-03-04 13:21:58.642071	\N	1
136	197502251995011013	Taufik	Hidayat	3210131206750013	Denpasar	1975-02-25	Jl. Anggrek No.3, Denpasar	taufik.hidayat@example.com	082345678901	3210131206750013	1995-01-01	\N	12	6	4	7	0	2025-03-04 13:21:58.642071	\N	1
138	198208051996031015	Arif	Setiawan	3210151807820015	Balikpapan	1982-08-05	Jl. Kemuning No.12, Balikpapan	arif.setiawan@example.com	082567890123	3210151807820015	1996-03-01	\N	7	8	4	7	0	2025-03-04 13:21:58.642071	\N	1
140	197912301995051017	Hadi	Wijaya	3210171507790017	Tangerang	1979-12-30	Jl. Mawar No.9, Tangerang	hadi.wijaya@example.com	082789012345	3210171507790017	1995-05-01	\N	6	10	4	7	0	2025-03-04 13:21:58.642071	\N	1
142	198305251996071019	Joko	Susanto	3210191107830019	Malang	1983-05-25	Jl. Anggrek No.8, Malang	joko.susanto@example.com	082901234567	3210191107830019	1996-07-01	\N	12	6	4	7	0	2025-03-04 13:21:58.642071	\N	1
144	198711051997091021	Surya	Pradana	3210211507870021	Bogor	1987-11-05	Jl. Melati No.10, Bogor	surya.pradana@example.com	083123456789	3210211507870021	1997-09-01	\N	7	8	4	7	0	2025-03-04 13:21:58.719069	\N	1
146	198005121996111023	Agus	Saputro	3210231107800023	Cilegon	1980-05-12	Jl. Kenanga No.7, Cilegon	agus.saputro@example.com	083345678901	3210231107800023	1996-11-01	\N	6	10	4	7	0	2025-03-04 13:21:58.719069	\N	1
148	197606301995011025	Bayu	Firmansyah	3210251706760025	Bekasi	1976-06-30	Jl. Mawar No.6, Bekasi	bayu.firmansyah@example.com	083567890123	3210251706760025	1995-01-01	\N	12	6	4	7	0	2025-03-04 13:21:58.719069	\N	1
150	198212101996031027	Rahmat	Hidayat	3210271107820027	Cianjur	1982-12-10	Jl. Dahlia No.3, Cianjur	rahmat.hidayat@example.com	083789012345	3210271107820027	1996-03-01	\N	7	8	4	7	0	2025-03-04 13:21:58.719069	\N	1
162	198506201997051039	Rahman	Firdaus	3210391707850039	Mataram	1985-06-20	Jl. Flamboyan No.3, Mataram	rahman.firdaus@example.com	084901234567	3210391707850039	1997-05-01	\N	6	8	4	7	0	2025-03-04 13:21:58.808574	\N	1
164	198910101998071041	Aditya	Santoso	3210411507890041	Ternate	1989-10-10	Jl. Melati No.2, Ternate	aditya.santoso@example.com	085123456789	3210411507890041	1998-07-01	\N	6	10	4	7	0	2025-03-04 13:21:58.94992	\N	1
166	198704051997091043	Hendri	Saputra	3210431207870043	Lhokseumawe	1987-04-05	Jl. Kenanga No.8, Lhokseumawe	hendri.saputra@example.com	085345678901	3210431207870043	1997-09-01	\N	12	6	4	7	0	2025-03-04 13:21:58.94992	\N	1
168	197812251995011045	Haris	Gunawan	3210451703780045	Sabang	1978-12-25	Jl. Dahlia No.3, Sabang	haris.gunawan@example.com	085567890123	3210451703780045	1995-01-01	\N	7	8	4	7	0	2025-03-04 13:21:58.94992	\N	1
170	198202051996031047	Bambang	Setiawan	3210471507820047	Kupang	1982-02-05	Jl. Tulip No.5, Kupang	bambang.setiawan@example.com	085789012345	3210471507820047	1996-03-01	\N	6	10	4	7	0	2025-03-04 13:21:58.94992	\N	1
172	198306151997051049	Rizal	Fauzi	3210491707830049	Waingapu	1983-06-15	Jl. Anggrek No.11, Waingapu	rizal.fauzi@example.com	085901234567	3210491707830049	1997-05-01	\N	12	6	4	7	0	2025-03-04 13:21:58.94992	\N	1
174	198510101997071051	Faisal	Anwar	3210511507850051	Bontang	1985-10-10	Jl. Melati No.3, Bontang	faisal.anwar@example.com	086123456789	3210511507850051	1997-07-01	\N	7	8	4	7	0	2025-03-04 13:21:59.034123	\N	1
176	198709201997091053	Ahmad	Kurniawan	3210531207870053	Pamekasan	1987-09-20	Jl. Kenanga No.7, Pamekasan	ahmad.kurniawan@example.com	086345678901	3210531207870053	1997-09-01	\N	6	10	4	7	0	2025-03-04 13:21:59.034123	\N	1
178	197704251995011055	Edy	Saputra	3210551704770055	Kediri	1977-04-25	Jl. Dahlia No.2, Kediri	edy.saputra@example.com	086567890123	3210551704770055	1995-01-01	\N	12	6	4	7	0	2025-03-04 13:21:59.034123	\N	1
180	198111301996031057	Yusuf	Ramadhan	3210571507810057	Gresik	1981-11-30	Jl. Tulip No.6, Gresik	yusuf.ramadhan@example.com	086789012345	3210571507810057	1996-03-01	\N	7	8	4	7	0	2025-03-04 13:21:59.034123	\N	1
182	198307101997051059	Hadi	Firman	3210591707830059	Pasuruan	1983-07-10	Jl. Anggrek No.9, Pasuruan	hadi.firman@example.com	086901234567	3210591707830059	1997-05-01	\N	6	10	4	7	0	2025-03-04 13:21:59.034123	\N	1
181	199402151998042058	Intan	Permata	3210581809940058	Lamongan	1994-02-15	Jl. Seruni No.4, Lamongan	intan.permata@example.com	086890123456	3210581809940058	1998-04-01	\N	5	9	5	8	0	2025-03-04 13:21:59.034123	\N	2
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.jobs (id, title, echelon, min_salary, max_salary, created_on, updated_on, rank) FROM stdin;
1	Sekretaris Utama	1	\N	\N	2025-03-03 04:01:26.781314	\N	\N
2	Kepala Biro Sumber Daya Manusia	3	\N	\N	2025-03-03 04:03:25.42441	\N	\N
3	Koordinator Manajemen Data dan Penilaian Kinerja Sumber Daya Manusia	5	\N	\N	2025-03-03 04:42:36.180591	\N	\N
4	Subkoordinator Manajemen dan Analisis Data Sumber Daya Manusia	7	\N	\N	2025-03-03 04:42:36.180591	\N	\N
5	Subkoordinator Penilaian Kinerja Sumber Daya Manusia	7	\N	\N	2025-03-03 04:42:36.180591	\N	\N
7	Auditor Terampil	\N	\N	\N	2025-03-03 04:43:46.165333	\N	\N
8	Auditor Ahli Pertama	\N	\N	\N	2025-03-03 04:43:46.165333	\N	\N
6	Pranata Komputer Terampil	\N	\N	\N	2025-03-03 04:43:46.165333	\N	\N
9	Pranata Komputer Ahli Pertama	\N	\N	\N	2025-03-03 04:44:43.883186	\N	\N
10	Arsiparis Terampil	\N	\N	\N	2025-03-03 04:44:43.883186	\N	\N
11	Arsiparis Ahli Pertama	\N	\N	\N	2025-03-03 04:44:43.883186	\N	\N
\.


--
-- Data for Name: kpi; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.kpi (id, employee, category, target_value, achieved_value, unit, period_fr, period_to, status, remarks, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leave_entitlements; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.leave_entitlements (id, year, employee, leave_type, entitlement, used, valid_fr, valid_thru, status, created_on, updated_on, description) FROM stdin;
1	2025	4	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 14:52:44.183416	\N	Regular annual leave
2	2025	4	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 14:52:44.2529	\N	Tahun Baru 2025 Masehi
3	2025	4	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 14:52:44.320373	\N	Isra Miraj Nabi Muhammad SAW
4	2025	4	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 14:52:44.403023	\N	Tahun Baru Imlek 2576 Kongzili
5	2025	4	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 14:52:44.475918	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
6	2025	4	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 14:52:44.526647	\N	Idul Fitri 1 Syawal 1446 Hijriah
7	2025	4	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 14:52:44.572904	\N	Idul Fitri 2 Syawal 1446 Hijriah
8	2025	4	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 14:52:44.620076	\N	Wafat Isa Almasih
9	2025	4	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 14:52:44.673805	\N	Hari Buruh Internasional
10	2025	4	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 14:52:44.719582	\N	Kenaikan Isa Almasih
11	2025	4	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 14:52:44.76842	\N	Hari Raya Waisak 2569 BE
12	2025	4	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 14:52:44.821403	\N	Idul Adha 10 Zulhijah 1446 Hijriah
13	2025	4	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 14:52:44.875397	\N	Tahun Baru Islam 1447 Hijriah
14	2025	4	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 14:52:44.935116	\N	Maulid Nabi Muhammad SAW
15	2025	4	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 14:52:44.989632	\N	Hari Kemerdekaan Republik Indonesia
16	2025	4	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 14:52:45.05801	\N	Hari Raya Natal
17	2025	4	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 14:52:45.124865	\N	Cuti Bersama Idul Fitri
18	2025	4	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 14:52:45.190469	\N	Cuti Bersama Idul Fitri
19	2025	4	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 14:52:45.249711	\N	Cuti Bersama Idul Fitri
20	2025	4	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 14:52:45.317601	\N	Cuti Bersama Idul Fitri
21	2025	4	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 14:52:45.366402	\N	Cuti Bersama Kenaikan Isa Almasih
22	2025	4	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 14:52:45.438225	\N	Cuti Bersama Idul Adha
23	2025	4	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 14:52:45.532689	\N	Cuti Bersama Natal
24	2025	4	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 14:52:45.595195	\N	Cuti Bersama Natal
25	2025	6	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:03:51.534237	\N	Regular annual leave
26	2025	6	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:03:51.574775	\N	Tahun Baru 2025 Masehi
27	2025	6	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:03:51.612395	\N	Isra Miraj Nabi Muhammad SAW
28	2025	6	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:03:51.656329	\N	Tahun Baru Imlek 2576 Kongzili
29	2025	6	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:03:51.835567	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
30	2025	6	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:03:51.874926	\N	Idul Fitri 1 Syawal 1446 Hijriah
31	2025	6	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:03:51.924974	\N	Idul Fitri 2 Syawal 1446 Hijriah
32	2025	6	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:03:51.968451	\N	Wafat Isa Almasih
33	2025	6	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:03:52.017088	\N	Hari Buruh Internasional
34	2025	6	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:03:52.075462	\N	Kenaikan Isa Almasih
35	2025	6	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:03:52.119431	\N	Hari Raya Waisak 2569 BE
36	2025	6	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:03:52.186551	\N	Idul Adha 10 Zulhijah 1446 Hijriah
37	2025	6	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:03:52.242857	\N	Tahun Baru Islam 1447 Hijriah
38	2025	6	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:03:52.280143	\N	Maulid Nabi Muhammad SAW
39	2025	6	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:03:52.325815	\N	Hari Kemerdekaan Republik Indonesia
40	2025	6	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:03:52.376271	\N	Hari Raya Natal
41	2025	6	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:03:52.412608	\N	Cuti Bersama Idul Fitri
42	2025	6	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:03:52.473097	\N	Cuti Bersama Idul Fitri
43	2025	6	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:03:52.518802	\N	Cuti Bersama Idul Fitri
44	2025	6	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:03:52.566541	\N	Cuti Bersama Idul Fitri
45	2025	6	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:03:52.628076	\N	Cuti Bersama Kenaikan Isa Almasih
46	2025	6	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:03:52.66744	\N	Cuti Bersama Idul Adha
47	2025	6	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:03:52.705769	\N	Cuti Bersama Natal
48	2025	6	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:03:52.769057	\N	Cuti Bersama Natal
49	2025	7	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:03:52.819656	\N	Regular annual leave
50	2025	7	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:03:52.875453	\N	Tahun Baru 2025 Masehi
51	2025	7	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:03:52.915902	\N	Isra Miraj Nabi Muhammad SAW
52	2025	7	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:03:52.982508	\N	Tahun Baru Imlek 2576 Kongzili
53	2025	7	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:03:53.066953	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
54	2025	7	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:03:53.109043	\N	Idul Fitri 1 Syawal 1446 Hijriah
55	2025	7	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:03:53.148848	\N	Idul Fitri 2 Syawal 1446 Hijriah
56	2025	7	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:03:53.197943	\N	Wafat Isa Almasih
57	2025	7	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:03:53.251817	\N	Hari Buruh Internasional
58	2025	7	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:03:53.33154	\N	Kenaikan Isa Almasih
59	2025	7	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:03:53.379006	\N	Hari Raya Waisak 2569 BE
60	2025	7	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:03:53.420032	\N	Idul Adha 10 Zulhijah 1446 Hijriah
61	2025	7	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:03:53.465842	\N	Tahun Baru Islam 1447 Hijriah
62	2025	7	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:03:53.535327	\N	Maulid Nabi Muhammad SAW
63	2025	7	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:03:53.578056	\N	Hari Kemerdekaan Republik Indonesia
64	2025	7	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:03:53.703237	\N	Hari Raya Natal
65	2025	7	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:03:53.762048	\N	Cuti Bersama Idul Fitri
66	2025	7	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:03:53.813279	\N	Cuti Bersama Idul Fitri
67	2025	7	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:03:53.942387	\N	Cuti Bersama Idul Fitri
68	2025	7	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:03:54.021387	\N	Cuti Bersama Idul Fitri
69	2025	7	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:03:54.124276	\N	Cuti Bersama Kenaikan Isa Almasih
70	2025	7	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:03:54.18192	\N	Cuti Bersama Idul Adha
71	2025	7	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:03:54.246288	\N	Cuti Bersama Natal
72	2025	7	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:03:54.306323	\N	Cuti Bersama Natal
73	2025	9	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:03:54.359888	\N	Regular annual leave
74	2025	9	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:03:54.416742	\N	Tahun Baru 2025 Masehi
75	2025	9	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:03:54.461974	\N	Isra Miraj Nabi Muhammad SAW
76	2025	9	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:03:54.518358	\N	Tahun Baru Imlek 2576 Kongzili
77	2025	9	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:03:54.61607	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
78	2025	9	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:03:54.700215	\N	Idul Fitri 1 Syawal 1446 Hijriah
79	2025	9	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:03:54.822041	\N	Idul Fitri 2 Syawal 1446 Hijriah
80	2025	9	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:03:54.915056	\N	Wafat Isa Almasih
81	2025	9	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:03:54.968869	\N	Hari Buruh Internasional
82	2025	9	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:03:55.014519	\N	Kenaikan Isa Almasih
83	2025	9	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:03:55.088794	\N	Hari Raya Waisak 2569 BE
84	2025	9	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:03:55.13068	\N	Idul Adha 10 Zulhijah 1446 Hijriah
85	2025	9	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:03:55.186195	\N	Tahun Baru Islam 1447 Hijriah
86	2025	9	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:03:55.258098	\N	Maulid Nabi Muhammad SAW
87	2025	9	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:03:55.329107	\N	Hari Kemerdekaan Republik Indonesia
88	2025	9	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:03:55.437323	\N	Hari Raya Natal
89	2025	9	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:03:55.522214	\N	Cuti Bersama Idul Fitri
90	2025	9	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:03:55.627995	\N	Cuti Bersama Idul Fitri
91	2025	9	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:03:55.732404	\N	Cuti Bersama Idul Fitri
92	2025	9	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:03:55.816408	\N	Cuti Bersama Idul Fitri
93	2025	9	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:03:55.857597	\N	Cuti Bersama Kenaikan Isa Almasih
94	2025	9	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:03:55.915451	\N	Cuti Bersama Idul Adha
95	2025	9	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:03:56.017817	\N	Cuti Bersama Natal
96	2025	9	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:03:56.084033	\N	Cuti Bersama Natal
97	2025	8	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:03:56.263	\N	Regular annual leave
98	2025	8	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:03:56.519577	\N	Tahun Baru 2025 Masehi
99	2025	8	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:03:56.572869	\N	Isra Miraj Nabi Muhammad SAW
100	2025	8	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:03:56.609689	\N	Tahun Baru Imlek 2576 Kongzili
101	2025	8	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:03:56.761807	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
102	2025	8	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:03:56.82147	\N	Idul Fitri 1 Syawal 1446 Hijriah
103	2025	8	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:03:56.913497	\N	Idul Fitri 2 Syawal 1446 Hijriah
104	2025	8	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:03:56.976588	\N	Wafat Isa Almasih
105	2025	8	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:03:57.059248	\N	Hari Buruh Internasional
106	2025	8	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:03:57.103345	\N	Kenaikan Isa Almasih
107	2025	8	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:03:57.215222	\N	Hari Raya Waisak 2569 BE
108	2025	8	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:03:57.354991	\N	Idul Adha 10 Zulhijah 1446 Hijriah
109	2025	8	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:03:57.446034	\N	Tahun Baru Islam 1447 Hijriah
110	2025	8	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:03:57.508424	\N	Maulid Nabi Muhammad SAW
111	2025	8	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:03:57.582596	\N	Hari Kemerdekaan Republik Indonesia
112	2025	8	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:03:57.629065	\N	Hari Raya Natal
113	2025	8	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:03:57.673269	\N	Cuti Bersama Idul Fitri
114	2025	8	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:03:57.755141	\N	Cuti Bersama Idul Fitri
115	2025	8	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:03:57.902878	\N	Cuti Bersama Idul Fitri
116	2025	8	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:03:57.952844	\N	Cuti Bersama Idul Fitri
117	2025	8	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:03:58.00494	\N	Cuti Bersama Kenaikan Isa Almasih
118	2025	8	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:03:58.076391	\N	Cuti Bersama Idul Adha
119	2025	8	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:03:58.122705	\N	Cuti Bersama Natal
120	2025	8	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:03:58.195149	\N	Cuti Bersama Natal
121	2025	142	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:03:58.257063	\N	Regular annual leave
122	2025	142	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:03:58.328451	\N	Tahun Baru 2025 Masehi
123	2025	142	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:03:58.37428	\N	Isra Miraj Nabi Muhammad SAW
124	2025	142	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:03:58.457624	\N	Tahun Baru Imlek 2576 Kongzili
125	2025	142	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:03:58.528009	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
126	2025	142	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:03:58.669608	\N	Idul Fitri 1 Syawal 1446 Hijriah
127	2025	142	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:03:58.736337	\N	Idul Fitri 2 Syawal 1446 Hijriah
128	2025	142	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:03:58.895777	\N	Wafat Isa Almasih
129	2025	142	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:03:58.979273	\N	Hari Buruh Internasional
130	2025	142	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:03:59.047329	\N	Kenaikan Isa Almasih
131	2025	142	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:03:59.11546	\N	Hari Raya Waisak 2569 BE
132	2025	142	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:03:59.167083	\N	Idul Adha 10 Zulhijah 1446 Hijriah
133	2025	142	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:03:59.228717	\N	Tahun Baru Islam 1447 Hijriah
134	2025	142	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:03:59.311063	\N	Maulid Nabi Muhammad SAW
135	2025	142	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:03:59.352753	\N	Hari Kemerdekaan Republik Indonesia
136	2025	142	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:03:59.50866	\N	Hari Raya Natal
137	2025	142	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:03:59.55426	\N	Cuti Bersama Idul Fitri
138	2025	142	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:03:59.621109	\N	Cuti Bersama Idul Fitri
139	2025	142	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:03:59.678894	\N	Cuti Bersama Idul Fitri
140	2025	142	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:03:59.770792	\N	Cuti Bersama Idul Fitri
141	2025	142	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:03:59.860161	\N	Cuti Bersama Kenaikan Isa Almasih
142	2025	142	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:03:59.972246	\N	Cuti Bersama Idul Adha
143	2025	142	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:00.172547	\N	Cuti Bersama Natal
144	2025	142	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:00.426793	\N	Cuti Bersama Natal
145	2025	154	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:00.464681	\N	Regular annual leave
146	2025	154	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:00.502472	\N	Tahun Baru 2025 Masehi
147	2025	154	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:00.659907	\N	Isra Miraj Nabi Muhammad SAW
148	2025	154	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:00.742632	\N	Tahun Baru Imlek 2576 Kongzili
149	2025	154	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:00.788687	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
150	2025	154	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:00.882527	\N	Idul Fitri 1 Syawal 1446 Hijriah
151	2025	154	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:00.972893	\N	Idul Fitri 2 Syawal 1446 Hijriah
152	2025	154	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:01.073851	\N	Wafat Isa Almasih
153	2025	154	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:01.169126	\N	Hari Buruh Internasional
154	2025	154	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:01.326768	\N	Kenaikan Isa Almasih
155	2025	154	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:01.469952	\N	Hari Raya Waisak 2569 BE
156	2025	154	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:01.619969	\N	Idul Adha 10 Zulhijah 1446 Hijriah
157	2025	154	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:01.706656	\N	Tahun Baru Islam 1447 Hijriah
158	2025	154	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:01.815737	\N	Maulid Nabi Muhammad SAW
159	2025	154	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:01.9157	\N	Hari Kemerdekaan Republik Indonesia
160	2025	154	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:01.988611	\N	Hari Raya Natal
161	2025	154	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:02.045299	\N	Cuti Bersama Idul Fitri
162	2025	154	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:02.137903	\N	Cuti Bersama Idul Fitri
163	2025	154	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:02.187182	\N	Cuti Bersama Idul Fitri
164	2025	154	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:02.282533	\N	Cuti Bersama Idul Fitri
165	2025	154	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:02.36578	\N	Cuti Bersama Kenaikan Isa Almasih
166	2025	154	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:02.41826	\N	Cuti Bersama Idul Adha
167	2025	154	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:02.48605	\N	Cuti Bersama Natal
168	2025	154	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:02.605408	\N	Cuti Bersama Natal
169	2025	160	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:02.657128	\N	Regular annual leave
170	2025	160	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:02.744201	\N	Tahun Baru 2025 Masehi
171	2025	160	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:02.857817	\N	Isra Miraj Nabi Muhammad SAW
172	2025	160	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:02.947032	\N	Tahun Baru Imlek 2576 Kongzili
173	2025	160	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:03.008109	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
174	2025	160	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:03.106111	\N	Idul Fitri 1 Syawal 1446 Hijriah
175	2025	160	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:03.214667	\N	Idul Fitri 2 Syawal 1446 Hijriah
176	2025	160	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:03.324082	\N	Wafat Isa Almasih
177	2025	160	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:03.413683	\N	Hari Buruh Internasional
178	2025	160	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:03.481828	\N	Kenaikan Isa Almasih
179	2025	160	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:03.527863	\N	Hari Raya Waisak 2569 BE
180	2025	160	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:03.619704	\N	Idul Adha 10 Zulhijah 1446 Hijriah
181	2025	160	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:03.701999	\N	Tahun Baru Islam 1447 Hijriah
182	2025	160	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:03.793338	\N	Maulid Nabi Muhammad SAW
183	2025	160	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:03.926979	\N	Hari Kemerdekaan Republik Indonesia
184	2025	160	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:03.998793	\N	Hari Raya Natal
185	2025	160	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:04.06091	\N	Cuti Bersama Idul Fitri
186	2025	160	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:04.124833	\N	Cuti Bersama Idul Fitri
187	2025	160	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:04.218701	\N	Cuti Bersama Idul Fitri
188	2025	160	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:04.409363	\N	Cuti Bersama Idul Fitri
189	2025	160	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:04.505586	\N	Cuti Bersama Kenaikan Isa Almasih
190	2025	160	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:04.593689	\N	Cuti Bersama Idul Adha
191	2025	160	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:04.640904	\N	Cuti Bersama Natal
192	2025	160	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:04.795836	\N	Cuti Bersama Natal
193	2025	178	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:04.874588	\N	Regular annual leave
194	2025	178	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:04.972995	\N	Tahun Baru 2025 Masehi
195	2025	178	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:05.021009	\N	Isra Miraj Nabi Muhammad SAW
196	2025	178	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:05.071716	\N	Tahun Baru Imlek 2576 Kongzili
197	2025	178	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:05.168197	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
198	2025	178	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:05.232864	\N	Idul Fitri 1 Syawal 1446 Hijriah
199	2025	178	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:05.387907	\N	Idul Fitri 2 Syawal 1446 Hijriah
200	2025	178	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:05.454915	\N	Wafat Isa Almasih
201	2025	178	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:05.511581	\N	Hari Buruh Internasional
202	2025	178	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:05.576574	\N	Kenaikan Isa Almasih
203	2025	178	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:05.779992	\N	Hari Raya Waisak 2569 BE
204	2025	178	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:05.836261	\N	Idul Adha 10 Zulhijah 1446 Hijriah
205	2025	178	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:05.88649	\N	Tahun Baru Islam 1447 Hijriah
206	2025	178	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:05.925529	\N	Maulid Nabi Muhammad SAW
207	2025	178	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:05.987885	\N	Hari Kemerdekaan Republik Indonesia
208	2025	178	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:06.038976	\N	Hari Raya Natal
209	2025	178	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:06.119509	\N	Cuti Bersama Idul Fitri
210	2025	178	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:06.166611	\N	Cuti Bersama Idul Fitri
211	2025	178	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:06.424366	\N	Cuti Bersama Idul Fitri
212	2025	178	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:06.472329	\N	Cuti Bersama Idul Fitri
213	2025	178	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:06.516072	\N	Cuti Bersama Kenaikan Isa Almasih
214	2025	178	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:06.556252	\N	Cuti Bersama Idul Adha
215	2025	178	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:06.60839	\N	Cuti Bersama Natal
216	2025	178	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:06.709852	\N	Cuti Bersama Natal
217	2025	166	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:06.748833	\N	Regular annual leave
218	2025	166	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:06.843357	\N	Tahun Baru 2025 Masehi
219	2025	166	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:06.89777	\N	Isra Miraj Nabi Muhammad SAW
220	2025	166	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:06.947073	\N	Tahun Baru Imlek 2576 Kongzili
221	2025	166	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:07.002972	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
222	2025	166	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:07.04971	\N	Idul Fitri 1 Syawal 1446 Hijriah
223	2025	166	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:07.167323	\N	Idul Fitri 2 Syawal 1446 Hijriah
224	2025	166	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:07.21199	\N	Wafat Isa Almasih
225	2025	166	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:07.250448	\N	Hari Buruh Internasional
226	2025	166	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:07.308837	\N	Kenaikan Isa Almasih
227	2025	166	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:07.351679	\N	Hari Raya Waisak 2569 BE
228	2025	166	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:07.410246	\N	Idul Adha 10 Zulhijah 1446 Hijriah
229	2025	166	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:07.49635	\N	Tahun Baru Islam 1447 Hijriah
230	2025	166	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:07.573081	\N	Maulid Nabi Muhammad SAW
231	2025	166	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:07.633	\N	Hari Kemerdekaan Republik Indonesia
232	2025	166	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:07.68048	\N	Hari Raya Natal
233	2025	166	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:07.724906	\N	Cuti Bersama Idul Fitri
234	2025	166	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:07.839944	\N	Cuti Bersama Idul Fitri
235	2025	166	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:07.892148	\N	Cuti Bersama Idul Fitri
236	2025	166	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:07.980698	\N	Cuti Bersama Idul Fitri
237	2025	166	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:08.068966	\N	Cuti Bersama Kenaikan Isa Almasih
238	2025	166	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:08.111509	\N	Cuti Bersama Idul Adha
239	2025	166	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:08.171328	\N	Cuti Bersama Natal
240	2025	166	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:08.269157	\N	Cuti Bersama Natal
241	2025	148	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:08.360306	\N	Regular annual leave
242	2025	148	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:08.428116	\N	Tahun Baru 2025 Masehi
243	2025	148	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:08.550768	\N	Isra Miraj Nabi Muhammad SAW
244	2025	148	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:08.635686	\N	Tahun Baru Imlek 2576 Kongzili
245	2025	148	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:08.691124	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
246	2025	148	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:08.737593	\N	Idul Fitri 1 Syawal 1446 Hijriah
247	2025	148	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:08.891629	\N	Idul Fitri 2 Syawal 1446 Hijriah
248	2025	148	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:08.944091	\N	Wafat Isa Almasih
249	2025	148	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:09.000878	\N	Hari Buruh Internasional
250	2025	148	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:09.062263	\N	Kenaikan Isa Almasih
251	2025	148	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:09.1087	\N	Hari Raya Waisak 2569 BE
252	2025	148	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:09.158403	\N	Idul Adha 10 Zulhijah 1446 Hijriah
253	2025	148	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:09.329936	\N	Tahun Baru Islam 1447 Hijriah
254	2025	148	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:09.404621	\N	Maulid Nabi Muhammad SAW
255	2025	148	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:09.459585	\N	Hari Kemerdekaan Republik Indonesia
256	2025	148	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:09.501151	\N	Hari Raya Natal
257	2025	148	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:09.554622	\N	Cuti Bersama Idul Fitri
258	2025	148	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:09.611859	\N	Cuti Bersama Idul Fitri
259	2025	148	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:09.662826	\N	Cuti Bersama Idul Fitri
260	2025	148	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:09.708338	\N	Cuti Bersama Idul Fitri
261	2025	148	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:09.757603	\N	Cuti Bersama Kenaikan Isa Almasih
262	2025	148	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:09.812743	\N	Cuti Bersama Idul Adha
263	2025	148	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:09.853973	\N	Cuti Bersama Natal
264	2025	148	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:09.91068	\N	Cuti Bersama Natal
265	2025	172	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:10.048311	\N	Regular annual leave
266	2025	172	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:10.134941	\N	Tahun Baru 2025 Masehi
267	2025	172	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:10.182336	\N	Isra Miraj Nabi Muhammad SAW
268	2025	172	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:10.234926	\N	Tahun Baru Imlek 2576 Kongzili
269	2025	172	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:10.279476	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
270	2025	172	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:10.403943	\N	Idul Fitri 1 Syawal 1446 Hijriah
271	2025	172	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:10.471985	\N	Idul Fitri 2 Syawal 1446 Hijriah
272	2025	172	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:10.583195	\N	Wafat Isa Almasih
273	2025	172	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:10.694583	\N	Hari Buruh Internasional
274	2025	172	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:10.883304	\N	Kenaikan Isa Almasih
275	2025	172	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:10.919323	\N	Hari Raya Waisak 2569 BE
276	2025	172	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:11.106142	\N	Idul Adha 10 Zulhijah 1446 Hijriah
277	2025	172	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:11.156518	\N	Tahun Baru Islam 1447 Hijriah
278	2025	172	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:11.195892	\N	Maulid Nabi Muhammad SAW
279	2025	172	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:11.23913	\N	Hari Kemerdekaan Republik Indonesia
280	2025	172	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:11.27516	\N	Hari Raya Natal
281	2025	172	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:11.314502	\N	Cuti Bersama Idul Fitri
282	2025	172	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:11.411086	\N	Cuti Bersama Idul Fitri
283	2025	172	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:11.457165	\N	Cuti Bersama Idul Fitri
284	2025	172	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:11.498502	\N	Cuti Bersama Idul Fitri
285	2025	172	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:11.543783	\N	Cuti Bersama Kenaikan Isa Almasih
286	2025	172	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:11.603422	\N	Cuti Bersama Idul Adha
287	2025	172	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:11.672149	\N	Cuti Bersama Natal
288	2025	172	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:11.715884	\N	Cuti Bersama Natal
289	2025	130	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:11.762268	\N	Regular annual leave
290	2025	130	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:11.810408	\N	Tahun Baru 2025 Masehi
291	2025	130	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:11.859204	\N	Isra Miraj Nabi Muhammad SAW
292	2025	130	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:11.917041	\N	Tahun Baru Imlek 2576 Kongzili
293	2025	130	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:11.970743	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
294	2025	130	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:12.024241	\N	Idul Fitri 1 Syawal 1446 Hijriah
295	2025	130	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:12.273367	\N	Idul Fitri 2 Syawal 1446 Hijriah
296	2025	130	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:12.336043	\N	Wafat Isa Almasih
297	2025	130	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:12.383623	\N	Hari Buruh Internasional
298	2025	130	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:12.424618	\N	Kenaikan Isa Almasih
299	2025	130	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:12.466319	\N	Hari Raya Waisak 2569 BE
300	2025	130	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:12.515975	\N	Idul Adha 10 Zulhijah 1446 Hijriah
301	2025	130	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:12.554814	\N	Tahun Baru Islam 1447 Hijriah
302	2025	130	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:12.598422	\N	Maulid Nabi Muhammad SAW
303	2025	130	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:12.650316	\N	Hari Kemerdekaan Republik Indonesia
304	2025	130	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:12.697619	\N	Hari Raya Natal
305	2025	130	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:12.738784	\N	Cuti Bersama Idul Fitri
306	2025	130	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:12.790254	\N	Cuti Bersama Idul Fitri
307	2025	130	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:12.845625	\N	Cuti Bersama Idul Fitri
308	2025	130	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:12.908215	\N	Cuti Bersama Idul Fitri
309	2025	130	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:12.952936	\N	Cuti Bersama Kenaikan Isa Almasih
310	2025	130	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:13.044654	\N	Cuti Bersama Idul Adha
311	2025	130	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:13.087543	\N	Cuti Bersama Natal
312	2025	130	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:13.133049	\N	Cuti Bersama Natal
313	2025	136	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:13.254539	\N	Regular annual leave
314	2025	136	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:13.298433	\N	Tahun Baru 2025 Masehi
315	2025	136	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:13.375009	\N	Isra Miraj Nabi Muhammad SAW
316	2025	136	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:13.436751	\N	Tahun Baru Imlek 2576 Kongzili
317	2025	136	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:13.48405	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
318	2025	136	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:13.53352	\N	Idul Fitri 1 Syawal 1446 Hijriah
319	2025	136	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:13.619968	\N	Idul Fitri 2 Syawal 1446 Hijriah
320	2025	136	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:13.668541	\N	Wafat Isa Almasih
321	2025	136	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:13.742889	\N	Hari Buruh Internasional
322	2025	136	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:13.785357	\N	Kenaikan Isa Almasih
323	2025	136	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:13.8502	\N	Hari Raya Waisak 2569 BE
324	2025	136	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:13.901407	\N	Idul Adha 10 Zulhijah 1446 Hijriah
325	2025	136	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:13.979302	\N	Tahun Baru Islam 1447 Hijriah
326	2025	136	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:14.029905	\N	Maulid Nabi Muhammad SAW
327	2025	136	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:14.104192	\N	Hari Kemerdekaan Republik Indonesia
328	2025	136	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:14.199963	\N	Hari Raya Natal
329	2025	136	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:14.266589	\N	Cuti Bersama Idul Fitri
330	2025	136	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:14.316919	\N	Cuti Bersama Idul Fitri
331	2025	136	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:14.3759	\N	Cuti Bersama Idul Fitri
332	2025	136	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:14.454884	\N	Cuti Bersama Idul Fitri
333	2025	136	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:14.557562	\N	Cuti Bersama Kenaikan Isa Almasih
334	2025	136	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:14.619567	\N	Cuti Bersama Idul Adha
335	2025	136	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:14.702308	\N	Cuti Bersama Natal
336	2025	136	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:14.775177	\N	Cuti Bersama Natal
337	2025	127	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:14.81579	\N	Regular annual leave
338	2025	127	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:14.86321	\N	Tahun Baru 2025 Masehi
339	2025	127	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:14.991529	\N	Isra Miraj Nabi Muhammad SAW
340	2025	127	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:15.260265	\N	Tahun Baru Imlek 2576 Kongzili
341	2025	127	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:15.435447	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
342	2025	127	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:15.473352	\N	Idul Fitri 1 Syawal 1446 Hijriah
343	2025	127	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:15.513923	\N	Idul Fitri 2 Syawal 1446 Hijriah
344	2025	127	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:15.560252	\N	Wafat Isa Almasih
345	2025	127	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:15.604857	\N	Hari Buruh Internasional
346	2025	127	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:15.666448	\N	Kenaikan Isa Almasih
347	2025	127	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:15.718084	\N	Hari Raya Waisak 2569 BE
348	2025	127	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:15.756653	\N	Idul Adha 10 Zulhijah 1446 Hijriah
349	2025	127	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:15.797866	\N	Tahun Baru Islam 1447 Hijriah
350	2025	127	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:15.845398	\N	Maulid Nabi Muhammad SAW
351	2025	127	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:15.893107	\N	Hari Kemerdekaan Republik Indonesia
352	2025	127	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:15.944072	\N	Hari Raya Natal
353	2025	127	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:16.001113	\N	Cuti Bersama Idul Fitri
354	2025	127	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:16.044143	\N	Cuti Bersama Idul Fitri
355	2025	127	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:16.083982	\N	Cuti Bersama Idul Fitri
356	2025	127	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:16.148481	\N	Cuti Bersama Idul Fitri
357	2025	127	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:16.23617	\N	Cuti Bersama Kenaikan Isa Almasih
358	2025	127	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:16.277106	\N	Cuti Bersama Idul Adha
359	2025	127	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:16.400148	\N	Cuti Bersama Natal
360	2025	127	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:16.469529	\N	Cuti Bersama Natal
361	2025	157	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:16.513584	\N	Regular annual leave
362	2025	157	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:16.573434	\N	Tahun Baru 2025 Masehi
363	2025	157	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:16.617953	\N	Isra Miraj Nabi Muhammad SAW
364	2025	157	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:16.685551	\N	Tahun Baru Imlek 2576 Kongzili
365	2025	157	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:16.741871	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
366	2025	157	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:16.785133	\N	Idul Fitri 1 Syawal 1446 Hijriah
367	2025	157	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:16.826736	\N	Idul Fitri 2 Syawal 1446 Hijriah
368	2025	157	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:16.88224	\N	Wafat Isa Almasih
369	2025	157	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:16.939967	\N	Hari Buruh Internasional
370	2025	157	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:17.000614	\N	Kenaikan Isa Almasih
371	2025	157	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:17.039902	\N	Hari Raya Waisak 2569 BE
372	2025	157	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:17.084538	\N	Idul Adha 10 Zulhijah 1446 Hijriah
373	2025	157	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:17.136349	\N	Tahun Baru Islam 1447 Hijriah
374	2025	157	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:17.181189	\N	Maulid Nabi Muhammad SAW
375	2025	157	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:17.239986	\N	Hari Kemerdekaan Republik Indonesia
376	2025	157	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:17.346338	\N	Hari Raya Natal
377	2025	157	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:17.385326	\N	Cuti Bersama Idul Fitri
378	2025	157	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:17.458043	\N	Cuti Bersama Idul Fitri
379	2025	157	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:17.563685	\N	Cuti Bersama Idul Fitri
380	2025	157	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:17.612132	\N	Cuti Bersama Idul Fitri
381	2025	157	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:17.664528	\N	Cuti Bersama Kenaikan Isa Almasih
382	2025	157	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:17.706751	\N	Cuti Bersama Idul Adha
383	2025	157	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:17.749109	\N	Cuti Bersama Natal
384	2025	157	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:17.79173	\N	Cuti Bersama Natal
385	2025	171	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:17.837068	\N	Regular annual leave
386	2025	171	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:17.917397	\N	Tahun Baru 2025 Masehi
387	2025	171	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:17.967206	\N	Isra Miraj Nabi Muhammad SAW
388	2025	171	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:18.016337	\N	Tahun Baru Imlek 2576 Kongzili
389	2025	171	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:18.102769	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
390	2025	171	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:18.145604	\N	Idul Fitri 1 Syawal 1446 Hijriah
391	2025	171	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:18.250348	\N	Idul Fitri 2 Syawal 1446 Hijriah
392	2025	171	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:18.376004	\N	Wafat Isa Almasih
393	2025	171	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:18.428333	\N	Hari Buruh Internasional
394	2025	171	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:18.476125	\N	Kenaikan Isa Almasih
395	2025	171	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:18.55294	\N	Hari Raya Waisak 2569 BE
396	2025	171	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:18.640175	\N	Idul Adha 10 Zulhijah 1446 Hijriah
397	2025	171	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:18.691721	\N	Tahun Baru Islam 1447 Hijriah
398	2025	171	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:18.834338	\N	Maulid Nabi Muhammad SAW
399	2025	171	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:18.892827	\N	Hari Kemerdekaan Republik Indonesia
400	2025	171	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:18.970228	\N	Hari Raya Natal
401	2025	171	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:19.045263	\N	Cuti Bersama Idul Fitri
402	2025	171	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:19.090913	\N	Cuti Bersama Idul Fitri
403	2025	171	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:19.146882	\N	Cuti Bersama Idul Fitri
404	2025	171	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:19.397495	\N	Cuti Bersama Idul Fitri
405	2025	171	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:19.445356	\N	Cuti Bersama Kenaikan Isa Almasih
406	2025	171	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:19.479379	\N	Cuti Bersama Idul Adha
407	2025	171	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:19.704428	\N	Cuti Bersama Natal
408	2025	171	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:19.768261	\N	Cuti Bersama Natal
409	2025	159	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:19.802661	\N	Regular annual leave
410	2025	159	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:19.904746	\N	Tahun Baru 2025 Masehi
411	2025	159	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:19.949193	\N	Isra Miraj Nabi Muhammad SAW
412	2025	159	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:20.001108	\N	Tahun Baru Imlek 2576 Kongzili
413	2025	159	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:20.053391	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
414	2025	159	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:20.106606	\N	Idul Fitri 1 Syawal 1446 Hijriah
415	2025	159	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:20.155332	\N	Idul Fitri 2 Syawal 1446 Hijriah
416	2025	159	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:20.206484	\N	Wafat Isa Almasih
417	2025	159	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:20.248145	\N	Hari Buruh Internasional
418	2025	159	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:20.285007	\N	Kenaikan Isa Almasih
419	2025	159	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:20.330222	\N	Hari Raya Waisak 2569 BE
420	2025	159	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:20.37846	\N	Idul Adha 10 Zulhijah 1446 Hijriah
421	2025	159	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:20.424274	\N	Tahun Baru Islam 1447 Hijriah
422	2025	159	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:20.48571	\N	Maulid Nabi Muhammad SAW
423	2025	159	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:20.522133	\N	Hari Kemerdekaan Republik Indonesia
424	2025	159	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:20.563785	\N	Hari Raya Natal
425	2025	159	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:20.631591	\N	Cuti Bersama Idul Fitri
426	2025	159	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:20.699956	\N	Cuti Bersama Idul Fitri
427	2025	159	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:20.743297	\N	Cuti Bersama Idul Fitri
428	2025	159	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:20.791952	\N	Cuti Bersama Idul Fitri
429	2025	159	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:20.83704	\N	Cuti Bersama Kenaikan Isa Almasih
430	2025	159	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:20.896949	\N	Cuti Bersama Idul Adha
431	2025	159	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:20.959136	\N	Cuti Bersama Natal
432	2025	159	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:20.995449	\N	Cuti Bersama Natal
433	2025	129	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:21.058208	\N	Regular annual leave
434	2025	129	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:21.098866	\N	Tahun Baru 2025 Masehi
435	2025	129	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:21.141411	\N	Isra Miraj Nabi Muhammad SAW
436	2025	129	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:21.186442	\N	Tahun Baru Imlek 2576 Kongzili
437	2025	129	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:21.236408	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
438	2025	129	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:21.273127	\N	Idul Fitri 1 Syawal 1446 Hijriah
439	2025	129	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:21.308334	\N	Idul Fitri 2 Syawal 1446 Hijriah
440	2025	129	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:21.412214	\N	Wafat Isa Almasih
441	2025	129	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:21.454477	\N	Hari Buruh Internasional
442	2025	129	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:21.496406	\N	Kenaikan Isa Almasih
443	2025	129	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:21.543475	\N	Hari Raya Waisak 2569 BE
444	2025	129	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:21.583149	\N	Idul Adha 10 Zulhijah 1446 Hijriah
445	2025	129	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:21.635045	\N	Tahun Baru Islam 1447 Hijriah
446	2025	129	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:21.667413	\N	Maulid Nabi Muhammad SAW
447	2025	129	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:21.727123	\N	Hari Kemerdekaan Republik Indonesia
448	2025	129	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:21.768104	\N	Hari Raya Natal
449	2025	129	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:21.803892	\N	Cuti Bersama Idul Fitri
450	2025	129	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:21.843142	\N	Cuti Bersama Idul Fitri
451	2025	129	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:21.895158	\N	Cuti Bersama Idul Fitri
452	2025	129	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:21.953029	\N	Cuti Bersama Idul Fitri
453	2025	129	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:22.018265	\N	Cuti Bersama Kenaikan Isa Almasih
454	2025	129	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:22.065665	\N	Cuti Bersama Idul Adha
455	2025	129	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:22.113676	\N	Cuti Bersama Natal
456	2025	129	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:22.16081	\N	Cuti Bersama Natal
457	2025	177	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:22.204244	\N	Regular annual leave
458	2025	177	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:22.313877	\N	Tahun Baru 2025 Masehi
459	2025	177	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:22.364039	\N	Isra Miraj Nabi Muhammad SAW
460	2025	177	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:22.403392	\N	Tahun Baru Imlek 2576 Kongzili
461	2025	177	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:22.514614	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
462	2025	177	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:22.560614	\N	Idul Fitri 1 Syawal 1446 Hijriah
463	2025	177	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:22.596372	\N	Idul Fitri 2 Syawal 1446 Hijriah
464	2025	177	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:22.650217	\N	Wafat Isa Almasih
465	2025	177	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:22.7019	\N	Hari Buruh Internasional
466	2025	177	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:22.754632	\N	Kenaikan Isa Almasih
467	2025	177	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:22.798096	\N	Hari Raya Waisak 2569 BE
468	2025	177	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:22.8311	\N	Idul Adha 10 Zulhijah 1446 Hijriah
469	2025	177	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:22.870765	\N	Tahun Baru Islam 1447 Hijriah
470	2025	177	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:22.913341	\N	Maulid Nabi Muhammad SAW
471	2025	177	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:22.955666	\N	Hari Kemerdekaan Republik Indonesia
472	2025	177	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:22.999381	\N	Hari Raya Natal
473	2025	177	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:23.039689	\N	Cuti Bersama Idul Fitri
474	2025	177	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:23.078662	\N	Cuti Bersama Idul Fitri
475	2025	177	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:23.1191	\N	Cuti Bersama Idul Fitri
476	2025	177	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:23.159863	\N	Cuti Bersama Idul Fitri
477	2025	177	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:23.199792	\N	Cuti Bersama Kenaikan Isa Almasih
478	2025	177	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:23.237836	\N	Cuti Bersama Idul Adha
479	2025	177	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:23.286469	\N	Cuti Bersama Natal
480	2025	177	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:23.332333	\N	Cuti Bersama Natal
481	2025	165	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:23.380018	\N	Regular annual leave
482	2025	165	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:23.444379	\N	Tahun Baru 2025 Masehi
483	2025	165	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:23.486365	\N	Isra Miraj Nabi Muhammad SAW
484	2025	165	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:23.532209	\N	Tahun Baru Imlek 2576 Kongzili
485	2025	165	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:23.576119	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
486	2025	165	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:23.630397	\N	Idul Fitri 1 Syawal 1446 Hijriah
487	2025	165	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:23.665012	\N	Idul Fitri 2 Syawal 1446 Hijriah
488	2025	165	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:23.706594	\N	Wafat Isa Almasih
489	2025	165	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:23.745636	\N	Hari Buruh Internasional
490	2025	165	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:23.78606	\N	Kenaikan Isa Almasih
491	2025	165	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:23.820732	\N	Hari Raya Waisak 2569 BE
492	2025	165	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:23.857304	\N	Idul Adha 10 Zulhijah 1446 Hijriah
493	2025	165	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:24.043266	\N	Tahun Baru Islam 1447 Hijriah
494	2025	165	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:24.083513	\N	Maulid Nabi Muhammad SAW
495	2025	165	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:24.129661	\N	Hari Kemerdekaan Republik Indonesia
496	2025	165	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:24.166146	\N	Hari Raya Natal
497	2025	165	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:24.20812	\N	Cuti Bersama Idul Fitri
498	2025	165	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:24.245855	\N	Cuti Bersama Idul Fitri
499	2025	165	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:24.288417	\N	Cuti Bersama Idul Fitri
500	2025	165	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:24.328292	\N	Cuti Bersama Idul Fitri
501	2025	165	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:24.367945	\N	Cuti Bersama Kenaikan Isa Almasih
502	2025	165	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:24.410766	\N	Cuti Bersama Idul Adha
503	2025	165	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:24.46496	\N	Cuti Bersama Natal
504	2025	165	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:24.508719	\N	Cuti Bersama Natal
505	2025	124	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:24.543432	\N	Regular annual leave
506	2025	124	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:24.594724	\N	Tahun Baru 2025 Masehi
507	2025	124	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:24.642449	\N	Isra Miraj Nabi Muhammad SAW
508	2025	124	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:24.677834	\N	Tahun Baru Imlek 2576 Kongzili
509	2025	124	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:24.739743	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
510	2025	124	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:24.778244	\N	Idul Fitri 1 Syawal 1446 Hijriah
511	2025	124	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:24.838343	\N	Idul Fitri 2 Syawal 1446 Hijriah
512	2025	124	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:25.017901	\N	Wafat Isa Almasih
513	2025	124	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:25.141236	\N	Hari Buruh Internasional
514	2025	124	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:25.199047	\N	Kenaikan Isa Almasih
515	2025	124	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:25.264189	\N	Hari Raya Waisak 2569 BE
516	2025	124	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:25.322732	\N	Idul Adha 10 Zulhijah 1446 Hijriah
517	2025	124	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:25.39372	\N	Tahun Baru Islam 1447 Hijriah
518	2025	124	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:25.444353	\N	Maulid Nabi Muhammad SAW
519	2025	124	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:25.485959	\N	Hari Kemerdekaan Republik Indonesia
520	2025	124	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:25.548558	\N	Hari Raya Natal
521	2025	124	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:25.587379	\N	Cuti Bersama Idul Fitri
522	2025	124	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:25.639618	\N	Cuti Bersama Idul Fitri
523	2025	124	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:25.678001	\N	Cuti Bersama Idul Fitri
524	2025	124	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:25.734571	\N	Cuti Bersama Idul Fitri
525	2025	124	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:25.917673	\N	Cuti Bersama Kenaikan Isa Almasih
526	2025	124	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:26.132397	\N	Cuti Bersama Idul Adha
527	2025	124	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:26.187953	\N	Cuti Bersama Natal
528	2025	124	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:26.234464	\N	Cuti Bersama Natal
529	2025	135	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:26.273935	\N	Regular annual leave
530	2025	135	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:26.312414	\N	Tahun Baru 2025 Masehi
531	2025	135	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:26.35401	\N	Isra Miraj Nabi Muhammad SAW
532	2025	135	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:26.395762	\N	Tahun Baru Imlek 2576 Kongzili
533	2025	135	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:26.437295	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
534	2025	135	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:26.488509	\N	Idul Fitri 1 Syawal 1446 Hijriah
535	2025	135	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:26.527392	\N	Idul Fitri 2 Syawal 1446 Hijriah
536	2025	135	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:26.573696	\N	Wafat Isa Almasih
537	2025	135	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:26.652183	\N	Hari Buruh Internasional
538	2025	135	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:26.743389	\N	Kenaikan Isa Almasih
539	2025	135	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:26.786417	\N	Hari Raya Waisak 2569 BE
540	2025	135	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:26.839245	\N	Idul Adha 10 Zulhijah 1446 Hijriah
541	2025	135	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:26.889192	\N	Tahun Baru Islam 1447 Hijriah
542	2025	135	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:26.980636	\N	Maulid Nabi Muhammad SAW
543	2025	135	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:27.024411	\N	Hari Kemerdekaan Republik Indonesia
544	2025	135	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:27.063518	\N	Hari Raya Natal
545	2025	135	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:27.100543	\N	Cuti Bersama Idul Fitri
546	2025	135	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:27.141503	\N	Cuti Bersama Idul Fitri
547	2025	135	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:27.179287	\N	Cuti Bersama Idul Fitri
548	2025	135	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:27.227161	\N	Cuti Bersama Idul Fitri
549	2025	135	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:27.269893	\N	Cuti Bersama Kenaikan Isa Almasih
550	2025	135	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:27.308685	\N	Cuti Bersama Idul Adha
551	2025	135	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:27.347704	\N	Cuti Bersama Natal
552	2025	135	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:27.398591	\N	Cuti Bersama Natal
553	2025	147	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:27.44851	\N	Regular annual leave
554	2025	147	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:27.488681	\N	Tahun Baru 2025 Masehi
555	2025	147	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:27.529893	\N	Isra Miraj Nabi Muhammad SAW
556	2025	147	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:27.567377	\N	Tahun Baru Imlek 2576 Kongzili
557	2025	147	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:27.607763	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
558	2025	147	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:27.676223	\N	Idul Fitri 1 Syawal 1446 Hijriah
559	2025	147	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:27.766269	\N	Idul Fitri 2 Syawal 1446 Hijriah
560	2025	147	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:27.815302	\N	Wafat Isa Almasih
561	2025	147	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:27.855929	\N	Hari Buruh Internasional
562	2025	147	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:27.898347	\N	Kenaikan Isa Almasih
563	2025	147	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:27.939832	\N	Hari Raya Waisak 2569 BE
564	2025	147	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:28.026667	\N	Idul Adha 10 Zulhijah 1446 Hijriah
565	2025	147	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:28.114678	\N	Tahun Baru Islam 1447 Hijriah
566	2025	147	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:28.1632	\N	Maulid Nabi Muhammad SAW
567	2025	147	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:28.327814	\N	Hari Kemerdekaan Republik Indonesia
568	2025	147	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:28.367948	\N	Hari Raya Natal
569	2025	147	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:28.433751	\N	Cuti Bersama Idul Fitri
570	2025	147	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:28.480216	\N	Cuti Bersama Idul Fitri
571	2025	147	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:28.778245	\N	Cuti Bersama Idul Fitri
572	2025	147	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:28.825158	\N	Cuti Bersama Idul Fitri
573	2025	147	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:28.91893	\N	Cuti Bersama Kenaikan Isa Almasih
574	2025	147	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:28.95791	\N	Cuti Bersama Idul Adha
575	2025	147	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:29.032792	\N	Cuti Bersama Natal
576	2025	147	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:29.180975	\N	Cuti Bersama Natal
577	2025	163	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:29.228118	\N	Regular annual leave
578	2025	163	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:29.268434	\N	Tahun Baru 2025 Masehi
579	2025	163	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:29.310521	\N	Isra Miraj Nabi Muhammad SAW
580	2025	163	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:29.346361	\N	Tahun Baru Imlek 2576 Kongzili
581	2025	163	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:29.398716	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
582	2025	163	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:29.439864	\N	Idul Fitri 1 Syawal 1446 Hijriah
583	2025	163	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:29.484804	\N	Idul Fitri 2 Syawal 1446 Hijriah
584	2025	163	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:29.528129	\N	Wafat Isa Almasih
585	2025	163	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:29.572446	\N	Hari Buruh Internasional
586	2025	163	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:29.635068	\N	Kenaikan Isa Almasih
587	2025	163	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:29.67199	\N	Hari Raya Waisak 2569 BE
588	2025	163	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:29.718661	\N	Idul Adha 10 Zulhijah 1446 Hijriah
589	2025	163	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:29.753054	\N	Tahun Baru Islam 1447 Hijriah
590	2025	163	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:29.851191	\N	Maulid Nabi Muhammad SAW
591	2025	163	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:29.964513	\N	Hari Kemerdekaan Republik Indonesia
592	2025	163	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:30.016411	\N	Hari Raya Natal
593	2025	163	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:30.067439	\N	Cuti Bersama Idul Fitri
594	2025	163	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:30.102951	\N	Cuti Bersama Idul Fitri
595	2025	163	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:30.188472	\N	Cuti Bersama Idul Fitri
596	2025	163	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:30.243947	\N	Cuti Bersama Idul Fitri
597	2025	163	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:30.290829	\N	Cuti Bersama Kenaikan Isa Almasih
598	2025	163	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:30.354185	\N	Cuti Bersama Idul Adha
599	2025	163	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:30.423878	\N	Cuti Bersama Natal
600	2025	163	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:30.468222	\N	Cuti Bersama Natal
601	2025	183	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:30.515658	\N	Regular annual leave
602	2025	183	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:30.563171	\N	Tahun Baru 2025 Masehi
603	2025	183	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:30.603982	\N	Isra Miraj Nabi Muhammad SAW
604	2025	183	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:30.644856	\N	Tahun Baru Imlek 2576 Kongzili
605	2025	183	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:30.680702	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
606	2025	183	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:30.730384	\N	Idul Fitri 1 Syawal 1446 Hijriah
607	2025	183	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:30.768555	\N	Idul Fitri 2 Syawal 1446 Hijriah
608	2025	183	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:30.807872	\N	Wafat Isa Almasih
609	2025	183	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:30.851575	\N	Hari Buruh Internasional
610	2025	183	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:30.943599	\N	Kenaikan Isa Almasih
611	2025	183	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:30.99363	\N	Hari Raya Waisak 2569 BE
612	2025	183	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:31.032815	\N	Idul Adha 10 Zulhijah 1446 Hijriah
613	2025	183	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:31.078704	\N	Tahun Baru Islam 1447 Hijriah
614	2025	183	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:31.126361	\N	Maulid Nabi Muhammad SAW
615	2025	183	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:31.172764	\N	Hari Kemerdekaan Republik Indonesia
616	2025	183	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:31.291959	\N	Hari Raya Natal
617	2025	183	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:31.357107	\N	Cuti Bersama Idul Fitri
618	2025	183	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:31.48079	\N	Cuti Bersama Idul Fitri
619	2025	183	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:31.52624	\N	Cuti Bersama Idul Fitri
620	2025	183	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:31.589696	\N	Cuti Bersama Idul Fitri
621	2025	183	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:31.625898	\N	Cuti Bersama Kenaikan Isa Almasih
622	2025	183	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:31.65945	\N	Cuti Bersama Idul Adha
623	2025	183	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:31.702751	\N	Cuti Bersama Natal
624	2025	183	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:31.744291	\N	Cuti Bersama Natal
625	2025	132	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:31.791599	\N	Regular annual leave
626	2025	132	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:31.845269	\N	Tahun Baru 2025 Masehi
627	2025	132	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:31.892812	\N	Isra Miraj Nabi Muhammad SAW
628	2025	132	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:31.926409	\N	Tahun Baru Imlek 2576 Kongzili
629	2025	132	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:31.973432	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
630	2025	132	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:32.018755	\N	Idul Fitri 1 Syawal 1446 Hijriah
631	2025	132	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:32.060821	\N	Idul Fitri 2 Syawal 1446 Hijriah
632	2025	132	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:32.112121	\N	Wafat Isa Almasih
633	2025	132	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:32.152119	\N	Hari Buruh Internasional
634	2025	132	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:32.186625	\N	Kenaikan Isa Almasih
635	2025	132	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:32.222942	\N	Hari Raya Waisak 2569 BE
636	2025	132	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:32.266499	\N	Idul Adha 10 Zulhijah 1446 Hijriah
637	2025	132	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:32.307307	\N	Tahun Baru Islam 1447 Hijriah
638	2025	132	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:32.345684	\N	Maulid Nabi Muhammad SAW
639	2025	132	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:32.390928	\N	Hari Kemerdekaan Republik Indonesia
640	2025	132	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:32.836887	\N	Hari Raya Natal
641	2025	132	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:32.879557	\N	Cuti Bersama Idul Fitri
642	2025	132	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:32.928802	\N	Cuti Bersama Idul Fitri
643	2025	132	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:32.973543	\N	Cuti Bersama Idul Fitri
644	2025	132	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:33.040721	\N	Cuti Bersama Idul Fitri
645	2025	132	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:33.144189	\N	Cuti Bersama Kenaikan Isa Almasih
646	2025	132	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:33.250236	\N	Cuti Bersama Idul Adha
647	2025	132	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:33.29299	\N	Cuti Bersama Natal
648	2025	132	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:33.341928	\N	Cuti Bersama Natal
649	2025	153	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:33.382794	\N	Regular annual leave
650	2025	153	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:33.45629	\N	Tahun Baru 2025 Masehi
651	2025	153	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:33.513005	\N	Isra Miraj Nabi Muhammad SAW
652	2025	153	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:33.553422	\N	Tahun Baru Imlek 2576 Kongzili
653	2025	153	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:33.635416	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
654	2025	153	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:33.683204	\N	Idul Fitri 1 Syawal 1446 Hijriah
655	2025	153	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:33.738194	\N	Idul Fitri 2 Syawal 1446 Hijriah
656	2025	153	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:33.809397	\N	Wafat Isa Almasih
657	2025	153	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:33.863532	\N	Hari Buruh Internasional
658	2025	153	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:33.953039	\N	Kenaikan Isa Almasih
659	2025	153	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:34.118085	\N	Hari Raya Waisak 2569 BE
660	2025	153	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:34.257828	\N	Idul Adha 10 Zulhijah 1446 Hijriah
661	2025	153	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:34.304575	\N	Tahun Baru Islam 1447 Hijriah
662	2025	153	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:34.374751	\N	Maulid Nabi Muhammad SAW
663	2025	153	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:34.418767	\N	Hari Kemerdekaan Republik Indonesia
664	2025	153	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:34.489152	\N	Hari Raya Natal
665	2025	153	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:34.536527	\N	Cuti Bersama Idul Fitri
666	2025	153	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:34.606172	\N	Cuti Bersama Idul Fitri
667	2025	153	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:34.689514	\N	Cuti Bersama Idul Fitri
668	2025	153	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:34.790574	\N	Cuti Bersama Idul Fitri
669	2025	153	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:34.834446	\N	Cuti Bersama Kenaikan Isa Almasih
670	2025	153	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:35.075257	\N	Cuti Bersama Idul Adha
671	2025	153	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:35.175961	\N	Cuti Bersama Natal
672	2025	153	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:35.317255	\N	Cuti Bersama Natal
673	2025	141	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:35.369669	\N	Regular annual leave
674	2025	141	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:35.413032	\N	Tahun Baru 2025 Masehi
675	2025	141	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:35.457842	\N	Isra Miraj Nabi Muhammad SAW
676	2025	141	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:35.497025	\N	Tahun Baru Imlek 2576 Kongzili
677	2025	141	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:35.566014	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
678	2025	141	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:35.658017	\N	Idul Fitri 1 Syawal 1446 Hijriah
679	2025	141	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:35.697597	\N	Idul Fitri 2 Syawal 1446 Hijriah
680	2025	141	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:35.754426	\N	Wafat Isa Almasih
681	2025	141	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:35.819903	\N	Hari Buruh Internasional
682	2025	141	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:35.855937	\N	Kenaikan Isa Almasih
683	2025	141	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:35.926429	\N	Hari Raya Waisak 2569 BE
684	2025	141	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:36.019225	\N	Idul Adha 10 Zulhijah 1446 Hijriah
685	2025	141	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:36.07893	\N	Tahun Baru Islam 1447 Hijriah
686	2025	141	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:36.131703	\N	Maulid Nabi Muhammad SAW
687	2025	141	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:36.173031	\N	Hari Kemerdekaan Republik Indonesia
688	2025	141	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:36.229989	\N	Hari Raya Natal
689	2025	141	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:36.313547	\N	Cuti Bersama Idul Fitri
690	2025	141	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:36.362526	\N	Cuti Bersama Idul Fitri
691	2025	141	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:36.416173	\N	Cuti Bersama Idul Fitri
692	2025	141	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:36.481025	\N	Cuti Bersama Idul Fitri
693	2025	141	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:36.542786	\N	Cuti Bersama Kenaikan Isa Almasih
694	2025	141	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:36.594062	\N	Cuti Bersama Idul Adha
695	2025	141	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:36.690588	\N	Cuti Bersama Natal
696	2025	141	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:36.776212	\N	Cuti Bersama Natal
697	2025	168	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:36.81504	\N	Regular annual leave
698	2025	168	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:36.860337	\N	Tahun Baru 2025 Masehi
699	2025	168	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:36.905618	\N	Isra Miraj Nabi Muhammad SAW
700	2025	168	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:36.95957	\N	Tahun Baru Imlek 2576 Kongzili
701	2025	168	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:37.01592	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
702	2025	168	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:37.073264	\N	Idul Fitri 1 Syawal 1446 Hijriah
703	2025	168	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:37.125189	\N	Idul Fitri 2 Syawal 1446 Hijriah
704	2025	168	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:37.202097	\N	Wafat Isa Almasih
705	2025	168	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:37.292295	\N	Hari Buruh Internasional
706	2025	168	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:37.331735	\N	Kenaikan Isa Almasih
707	2025	168	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:37.371165	\N	Hari Raya Waisak 2569 BE
708	2025	168	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:37.419799	\N	Idul Adha 10 Zulhijah 1446 Hijriah
709	2025	168	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:37.459026	\N	Tahun Baru Islam 1447 Hijriah
710	2025	168	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:37.501756	\N	Maulid Nabi Muhammad SAW
711	2025	168	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:37.636183	\N	Hari Kemerdekaan Republik Indonesia
712	2025	168	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:37.688202	\N	Hari Raya Natal
713	2025	168	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:37.730264	\N	Cuti Bersama Idul Fitri
714	2025	168	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:37.776365	\N	Cuti Bersama Idul Fitri
715	2025	168	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:37.816872	\N	Cuti Bersama Idul Fitri
716	2025	168	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:37.856975	\N	Cuti Bersama Idul Fitri
717	2025	168	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:37.909354	\N	Cuti Bersama Kenaikan Isa Almasih
718	2025	168	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:37.953235	\N	Cuti Bersama Idul Adha
719	2025	168	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:37.997364	\N	Cuti Bersama Natal
720	2025	168	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:38.048501	\N	Cuti Bersama Natal
721	2025	128	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:38.140048	\N	Regular annual leave
722	2025	128	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:38.189604	\N	Tahun Baru 2025 Masehi
723	2025	128	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:38.225197	\N	Isra Miraj Nabi Muhammad SAW
724	2025	128	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:38.276237	\N	Tahun Baru Imlek 2576 Kongzili
725	2025	128	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:38.314694	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
726	2025	128	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:38.360621	\N	Idul Fitri 1 Syawal 1446 Hijriah
727	2025	128	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:38.403221	\N	Idul Fitri 2 Syawal 1446 Hijriah
728	2025	128	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:38.467273	\N	Wafat Isa Almasih
729	2025	128	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:38.520005	\N	Hari Buruh Internasional
730	2025	128	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:38.558494	\N	Kenaikan Isa Almasih
731	2025	128	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:38.604071	\N	Hari Raya Waisak 2569 BE
732	2025	128	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:38.699412	\N	Idul Adha 10 Zulhijah 1446 Hijriah
733	2025	128	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:38.781516	\N	Tahun Baru Islam 1447 Hijriah
734	2025	128	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:38.840278	\N	Maulid Nabi Muhammad SAW
735	2025	128	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:38.890569	\N	Hari Kemerdekaan Republik Indonesia
736	2025	128	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:38.939484	\N	Hari Raya Natal
737	2025	128	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:38.988122	\N	Cuti Bersama Idul Fitri
738	2025	128	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:39.045711	\N	Cuti Bersama Idul Fitri
739	2025	128	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:39.243722	\N	Cuti Bersama Idul Fitri
740	2025	128	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:39.302215	\N	Cuti Bersama Idul Fitri
741	2025	128	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:39.464564	\N	Cuti Bersama Kenaikan Isa Almasih
742	2025	128	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:39.504892	\N	Cuti Bersama Idul Adha
743	2025	128	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:39.614871	\N	Cuti Bersama Natal
744	2025	128	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:39.662912	\N	Cuti Bersama Natal
745	2025	174	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:39.700478	\N	Regular annual leave
746	2025	174	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:39.739653	\N	Tahun Baru 2025 Masehi
747	2025	174	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:39.781679	\N	Isra Miraj Nabi Muhammad SAW
748	2025	174	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:39.821966	\N	Tahun Baru Imlek 2576 Kongzili
749	2025	174	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:39.866481	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
750	2025	174	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:39.925776	\N	Idul Fitri 1 Syawal 1446 Hijriah
751	2025	174	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:39.976513	\N	Idul Fitri 2 Syawal 1446 Hijriah
752	2025	174	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:40.02772	\N	Wafat Isa Almasih
753	2025	174	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:40.083201	\N	Hari Buruh Internasional
754	2025	174	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:40.12777	\N	Kenaikan Isa Almasih
755	2025	174	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:40.160414	\N	Hari Raya Waisak 2569 BE
756	2025	174	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:40.196466	\N	Idul Adha 10 Zulhijah 1446 Hijriah
757	2025	174	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:40.24721	\N	Tahun Baru Islam 1447 Hijriah
758	2025	174	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:40.291312	\N	Maulid Nabi Muhammad SAW
759	2025	174	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:40.336198	\N	Hari Kemerdekaan Republik Indonesia
760	2025	174	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:40.375871	\N	Hari Raya Natal
761	2025	174	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:40.412392	\N	Cuti Bersama Idul Fitri
762	2025	174	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:40.464543	\N	Cuti Bersama Idul Fitri
763	2025	174	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:40.51395	\N	Cuti Bersama Idul Fitri
764	2025	174	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:40.576161	\N	Cuti Bersama Idul Fitri
765	2025	174	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:40.608632	\N	Cuti Bersama Kenaikan Isa Almasih
766	2025	174	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:40.641448	\N	Cuti Bersama Idul Adha
767	2025	174	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:40.674272	\N	Cuti Bersama Natal
768	2025	174	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:40.724152	\N	Cuti Bersama Natal
769	2025	180	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:40.758022	\N	Regular annual leave
770	2025	180	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:40.811257	\N	Tahun Baru 2025 Masehi
771	2025	180	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:40.856241	\N	Isra Miraj Nabi Muhammad SAW
772	2025	180	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:40.898167	\N	Tahun Baru Imlek 2576 Kongzili
773	2025	180	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:40.962682	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
774	2025	180	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:41.016635	\N	Idul Fitri 1 Syawal 1446 Hijriah
775	2025	180	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:41.066677	\N	Idul Fitri 2 Syawal 1446 Hijriah
776	2025	180	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:41.115336	\N	Wafat Isa Almasih
777	2025	180	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:41.167867	\N	Hari Buruh Internasional
778	2025	180	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:41.210898	\N	Kenaikan Isa Almasih
779	2025	180	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:41.26473	\N	Hari Raya Waisak 2569 BE
780	2025	180	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:41.332216	\N	Idul Adha 10 Zulhijah 1446 Hijriah
781	2025	180	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:41.36797	\N	Tahun Baru Islam 1447 Hijriah
782	2025	180	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:41.40319	\N	Maulid Nabi Muhammad SAW
783	2025	180	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:41.449411	\N	Hari Kemerdekaan Republik Indonesia
784	2025	180	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:41.486964	\N	Hari Raya Natal
785	2025	180	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:41.560695	\N	Cuti Bersama Idul Fitri
786	2025	180	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:41.619928	\N	Cuti Bersama Idul Fitri
787	2025	180	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:41.724016	\N	Cuti Bersama Idul Fitri
788	2025	180	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:41.770709	\N	Cuti Bersama Idul Fitri
789	2025	180	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:41.811151	\N	Cuti Bersama Kenaikan Isa Almasih
790	2025	180	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:41.845773	\N	Cuti Bersama Idul Adha
791	2025	180	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:41.93479	\N	Cuti Bersama Natal
792	2025	180	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:42.018566	\N	Cuti Bersama Natal
793	2025	158	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:42.080811	\N	Regular annual leave
794	2025	158	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:42.129011	\N	Tahun Baru 2025 Masehi
795	2025	158	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:42.171383	\N	Isra Miraj Nabi Muhammad SAW
796	2025	158	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:42.218479	\N	Tahun Baru Imlek 2576 Kongzili
797	2025	158	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:42.253607	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
798	2025	158	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:42.306264	\N	Idul Fitri 1 Syawal 1446 Hijriah
799	2025	158	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:42.358362	\N	Idul Fitri 2 Syawal 1446 Hijriah
800	2025	158	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:42.409029	\N	Wafat Isa Almasih
801	2025	158	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:42.446269	\N	Hari Buruh Internasional
802	2025	158	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:42.503285	\N	Kenaikan Isa Almasih
803	2025	158	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:42.592063	\N	Hari Raya Waisak 2569 BE
804	2025	158	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:42.634887	\N	Idul Adha 10 Zulhijah 1446 Hijriah
805	2025	158	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:42.697571	\N	Tahun Baru Islam 1447 Hijriah
806	2025	158	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:42.755089	\N	Maulid Nabi Muhammad SAW
807	2025	158	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:42.803986	\N	Hari Kemerdekaan Republik Indonesia
808	2025	158	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:42.84394	\N	Hari Raya Natal
809	2025	158	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:42.916472	\N	Cuti Bersama Idul Fitri
810	2025	158	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:42.975756	\N	Cuti Bersama Idul Fitri
811	2025	158	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:43.175211	\N	Cuti Bersama Idul Fitri
812	2025	158	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:43.212506	\N	Cuti Bersama Idul Fitri
813	2025	158	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:43.250618	\N	Cuti Bersama Kenaikan Isa Almasih
814	2025	158	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:43.477739	\N	Cuti Bersama Idul Adha
815	2025	158	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:43.526464	\N	Cuti Bersama Natal
816	2025	158	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:43.602731	\N	Cuti Bersama Natal
817	2025	150	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:43.725825	\N	Regular annual leave
818	2025	150	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:43.783507	\N	Tahun Baru 2025 Masehi
819	2025	150	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:43.88502	\N	Isra Miraj Nabi Muhammad SAW
820	2025	150	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:44.154515	\N	Tahun Baru Imlek 2576 Kongzili
821	2025	150	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:44.249282	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
822	2025	150	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:44.292944	\N	Idul Fitri 1 Syawal 1446 Hijriah
823	2025	150	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:44.342052	\N	Idul Fitri 2 Syawal 1446 Hijriah
824	2025	150	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:44.385965	\N	Wafat Isa Almasih
825	2025	150	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:44.433135	\N	Hari Buruh Internasional
826	2025	150	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:44.479218	\N	Kenaikan Isa Almasih
827	2025	150	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:44.544502	\N	Hari Raya Waisak 2569 BE
828	2025	150	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:44.607775	\N	Idul Adha 10 Zulhijah 1446 Hijriah
829	2025	150	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:44.641084	\N	Tahun Baru Islam 1447 Hijriah
830	2025	150	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:44.683824	\N	Maulid Nabi Muhammad SAW
831	2025	150	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:44.724719	\N	Hari Kemerdekaan Republik Indonesia
832	2025	150	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:44.774715	\N	Hari Raya Natal
833	2025	150	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:44.913536	\N	Cuti Bersama Idul Fitri
834	2025	150	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:44.958765	\N	Cuti Bersama Idul Fitri
835	2025	150	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:45.005105	\N	Cuti Bersama Idul Fitri
836	2025	150	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:45.120094	\N	Cuti Bersama Idul Fitri
837	2025	150	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:45.172008	\N	Cuti Bersama Kenaikan Isa Almasih
838	2025	150	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:45.259589	\N	Cuti Bersama Idul Adha
839	2025	150	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:45.315905	\N	Cuti Bersama Natal
840	2025	150	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:45.363875	\N	Cuti Bersama Natal
841	2025	144	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:45.412474	\N	Regular annual leave
842	2025	144	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:45.449987	\N	Tahun Baru 2025 Masehi
843	2025	144	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:45.490875	\N	Isra Miraj Nabi Muhammad SAW
844	2025	144	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:45.531673	\N	Tahun Baru Imlek 2576 Kongzili
845	2025	144	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:45.577018	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
846	2025	144	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:45.620738	\N	Idul Fitri 1 Syawal 1446 Hijriah
847	2025	144	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:45.699764	\N	Idul Fitri 2 Syawal 1446 Hijriah
848	2025	144	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:45.779981	\N	Wafat Isa Almasih
849	2025	144	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:45.832181	\N	Hari Buruh Internasional
850	2025	144	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:45.877434	\N	Kenaikan Isa Almasih
851	2025	144	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:45.958739	\N	Hari Raya Waisak 2569 BE
852	2025	144	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:46.040051	\N	Idul Adha 10 Zulhijah 1446 Hijriah
853	2025	144	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:46.088932	\N	Tahun Baru Islam 1447 Hijriah
854	2025	144	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:46.243566	\N	Maulid Nabi Muhammad SAW
855	2025	144	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:46.29028	\N	Hari Kemerdekaan Republik Indonesia
856	2025	144	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:46.340475	\N	Hari Raya Natal
857	2025	144	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:46.380439	\N	Cuti Bersama Idul Fitri
858	2025	144	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:46.427329	\N	Cuti Bersama Idul Fitri
859	2025	144	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:46.547332	\N	Cuti Bersama Idul Fitri
860	2025	144	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:46.605306	\N	Cuti Bersama Idul Fitri
861	2025	144	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:46.645867	\N	Cuti Bersama Kenaikan Isa Almasih
862	2025	144	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:46.685425	\N	Cuti Bersama Idul Adha
863	2025	144	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:46.741112	\N	Cuti Bersama Natal
864	2025	144	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:46.797843	\N	Cuti Bersama Natal
865	2025	138	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:46.857491	\N	Regular annual leave
866	2025	138	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:46.911954	\N	Tahun Baru 2025 Masehi
867	2025	138	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:46.953231	\N	Isra Miraj Nabi Muhammad SAW
868	2025	138	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:46.996196	\N	Tahun Baru Imlek 2576 Kongzili
869	2025	138	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:47.072425	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
870	2025	138	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:47.148415	\N	Idul Fitri 1 Syawal 1446 Hijriah
871	2025	138	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:47.191912	\N	Idul Fitri 2 Syawal 1446 Hijriah
872	2025	138	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:47.234634	\N	Wafat Isa Almasih
873	2025	138	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:47.30311	\N	Hari Buruh Internasional
874	2025	138	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:47.378326	\N	Kenaikan Isa Almasih
875	2025	138	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:47.419511	\N	Hari Raya Waisak 2569 BE
876	2025	138	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:47.484885	\N	Idul Adha 10 Zulhijah 1446 Hijriah
877	2025	138	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:47.535024	\N	Tahun Baru Islam 1447 Hijriah
878	2025	138	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:47.623372	\N	Maulid Nabi Muhammad SAW
879	2025	138	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:47.718935	\N	Hari Kemerdekaan Republik Indonesia
880	2025	138	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:47.759942	\N	Hari Raya Natal
881	2025	138	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:47.844935	\N	Cuti Bersama Idul Fitri
882	2025	138	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:47.886681	\N	Cuti Bersama Idul Fitri
883	2025	138	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:47.957868	\N	Cuti Bersama Idul Fitri
884	2025	138	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:47.995659	\N	Cuti Bersama Idul Fitri
885	2025	138	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:48.033398	\N	Cuti Bersama Kenaikan Isa Almasih
886	2025	138	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:48.151037	\N	Cuti Bersama Idul Adha
887	2025	138	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:48.328123	\N	Cuti Bersama Natal
888	2025	138	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:48.368161	\N	Cuti Bersama Natal
889	2025	140	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:48.409758	\N	Regular annual leave
890	2025	140	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:48.491691	\N	Tahun Baru 2025 Masehi
891	2025	140	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:49.613677	\N	Isra Miraj Nabi Muhammad SAW
892	2025	140	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:49.719899	\N	Tahun Baru Imlek 2576 Kongzili
893	2025	140	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:49.763803	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
894	2025	140	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:49.845682	\N	Idul Fitri 1 Syawal 1446 Hijriah
895	2025	140	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:49.908546	\N	Idul Fitri 2 Syawal 1446 Hijriah
896	2025	140	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:50.08389	\N	Wafat Isa Almasih
897	2025	140	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:50.12622	\N	Hari Buruh Internasional
898	2025	140	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:50.175095	\N	Kenaikan Isa Almasih
899	2025	140	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:50.224693	\N	Hari Raya Waisak 2569 BE
900	2025	140	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:50.264197	\N	Idul Adha 10 Zulhijah 1446 Hijriah
901	2025	140	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:50.358043	\N	Tahun Baru Islam 1447 Hijriah
902	2025	140	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:50.41225	\N	Maulid Nabi Muhammad SAW
903	2025	140	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:50.452996	\N	Hari Kemerdekaan Republik Indonesia
904	2025	140	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:50.500369	\N	Hari Raya Natal
905	2025	140	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:50.534161	\N	Cuti Bersama Idul Fitri
906	2025	140	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:50.657808	\N	Cuti Bersama Idul Fitri
907	2025	140	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:50.713966	\N	Cuti Bersama Idul Fitri
908	2025	140	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:51.366096	\N	Cuti Bersama Idul Fitri
909	2025	140	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:51.411614	\N	Cuti Bersama Kenaikan Isa Almasih
910	2025	140	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:51.445237	\N	Cuti Bersama Idul Adha
911	2025	140	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:51.478314	\N	Cuti Bersama Natal
912	2025	140	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:51.527324	\N	Cuti Bersama Natal
913	2025	131	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:51.606225	\N	Regular annual leave
914	2025	131	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:51.66941	\N	Tahun Baru 2025 Masehi
915	2025	131	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:51.703169	\N	Isra Miraj Nabi Muhammad SAW
916	2025	131	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:51.749684	\N	Tahun Baru Imlek 2576 Kongzili
917	2025	131	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:51.80922	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
918	2025	131	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:51.867207	\N	Idul Fitri 1 Syawal 1446 Hijriah
919	2025	131	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:51.907975	\N	Idul Fitri 2 Syawal 1446 Hijriah
920	2025	131	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:51.941636	\N	Wafat Isa Almasih
921	2025	131	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:51.989815	\N	Hari Buruh Internasional
922	2025	131	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:52.025422	\N	Kenaikan Isa Almasih
923	2025	131	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:52.064443	\N	Hari Raya Waisak 2569 BE
924	2025	131	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:52.105466	\N	Idul Adha 10 Zulhijah 1446 Hijriah
925	2025	131	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:52.143802	\N	Tahun Baru Islam 1447 Hijriah
926	2025	131	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:52.195471	\N	Maulid Nabi Muhammad SAW
927	2025	131	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:52.240264	\N	Hari Kemerdekaan Republik Indonesia
928	2025	131	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:52.27994	\N	Hari Raya Natal
929	2025	131	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:52.325173	\N	Cuti Bersama Idul Fitri
930	2025	131	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:52.369619	\N	Cuti Bersama Idul Fitri
931	2025	131	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:52.408645	\N	Cuti Bersama Idul Fitri
932	2025	131	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:52.441993	\N	Cuti Bersama Idul Fitri
933	2025	131	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:52.480484	\N	Cuti Bersama Kenaikan Isa Almasih
934	2025	131	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:52.567448	\N	Cuti Bersama Idul Adha
935	2025	131	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:52.618166	\N	Cuti Bersama Natal
936	2025	131	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:52.684159	\N	Cuti Bersama Natal
937	2025	156	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:52.779502	\N	Regular annual leave
938	2025	156	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:52.818544	\N	Tahun Baru 2025 Masehi
939	2025	156	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:52.856283	\N	Isra Miraj Nabi Muhammad SAW
940	2025	156	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:52.89776	\N	Tahun Baru Imlek 2576 Kongzili
941	2025	156	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:52.95264	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
942	2025	156	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:53.005323	\N	Idul Fitri 1 Syawal 1446 Hijriah
943	2025	156	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:53.042681	\N	Idul Fitri 2 Syawal 1446 Hijriah
944	2025	156	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:53.159227	\N	Wafat Isa Almasih
945	2025	156	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:53.204135	\N	Hari Buruh Internasional
946	2025	156	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:53.238418	\N	Kenaikan Isa Almasih
947	2025	156	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:53.282997	\N	Hari Raya Waisak 2569 BE
948	2025	156	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:53.468747	\N	Idul Adha 10 Zulhijah 1446 Hijriah
949	2025	156	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:53.523625	\N	Tahun Baru Islam 1447 Hijriah
950	2025	156	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:53.586444	\N	Maulid Nabi Muhammad SAW
951	2025	156	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:53.65145	\N	Hari Kemerdekaan Republik Indonesia
952	2025	156	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:53.701568	\N	Hari Raya Natal
953	2025	156	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:53.748355	\N	Cuti Bersama Idul Fitri
954	2025	156	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:53.801685	\N	Cuti Bersama Idul Fitri
955	2025	156	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:53.854976	\N	Cuti Bersama Idul Fitri
956	2025	156	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:53.905898	\N	Cuti Bersama Idul Fitri
957	2025	156	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:53.975053	\N	Cuti Bersama Kenaikan Isa Almasih
958	2025	156	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:54.046119	\N	Cuti Bersama Idul Adha
959	2025	156	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:54.103967	\N	Cuti Bersama Natal
960	2025	156	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:54.153523	\N	Cuti Bersama Natal
961	2025	182	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:54.1987	\N	Regular annual leave
962	2025	182	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:54.243903	\N	Tahun Baru 2025 Masehi
963	2025	182	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:54.290543	\N	Isra Miraj Nabi Muhammad SAW
964	2025	182	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:54.332793	\N	Tahun Baru Imlek 2576 Kongzili
965	2025	182	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:54.533503	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
966	2025	182	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:54.609024	\N	Idul Fitri 1 Syawal 1446 Hijriah
967	2025	182	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:54.645862	\N	Idul Fitri 2 Syawal 1446 Hijriah
968	2025	182	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:54.694741	\N	Wafat Isa Almasih
969	2025	182	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:54.739392	\N	Hari Buruh Internasional
970	2025	182	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:54.78147	\N	Kenaikan Isa Almasih
971	2025	182	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:54.828871	\N	Hari Raya Waisak 2569 BE
972	2025	182	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:54.875527	\N	Idul Adha 10 Zulhijah 1446 Hijriah
973	2025	182	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:54.926054	\N	Tahun Baru Islam 1447 Hijriah
974	2025	182	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:54.983583	\N	Maulid Nabi Muhammad SAW
975	2025	182	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:55.040654	\N	Hari Kemerdekaan Republik Indonesia
976	2025	182	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:55.081969	\N	Hari Raya Natal
977	2025	182	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:55.154243	\N	Cuti Bersama Idul Fitri
978	2025	182	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:55.222234	\N	Cuti Bersama Idul Fitri
979	2025	182	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:55.278971	\N	Cuti Bersama Idul Fitri
980	2025	182	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:55.325934	\N	Cuti Bersama Idul Fitri
981	2025	182	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:55.38075	\N	Cuti Bersama Kenaikan Isa Almasih
982	2025	182	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:55.420579	\N	Cuti Bersama Idul Adha
983	2025	182	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:55.486765	\N	Cuti Bersama Natal
984	2025	182	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:55.567465	\N	Cuti Bersama Natal
985	2025	152	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:55.617458	\N	Regular annual leave
986	2025	152	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:55.656796	\N	Tahun Baru 2025 Masehi
987	2025	152	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:55.693938	\N	Isra Miraj Nabi Muhammad SAW
988	2025	152	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:55.736201	\N	Tahun Baru Imlek 2576 Kongzili
989	2025	152	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:55.782681	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
990	2025	152	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:55.838319	\N	Idul Fitri 1 Syawal 1446 Hijriah
991	2025	152	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:55.89577	\N	Idul Fitri 2 Syawal 1446 Hijriah
992	2025	152	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:55.941909	\N	Wafat Isa Almasih
993	2025	152	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:55.981198	\N	Hari Buruh Internasional
994	2025	152	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:56.018447	\N	Kenaikan Isa Almasih
995	2025	152	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:56.059744	\N	Hari Raya Waisak 2569 BE
996	2025	152	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:56.171187	\N	Idul Adha 10 Zulhijah 1446 Hijriah
997	2025	152	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:56.215507	\N	Tahun Baru Islam 1447 Hijriah
998	2025	152	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:56.263614	\N	Maulid Nabi Muhammad SAW
999	2025	152	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:56.300289	\N	Hari Kemerdekaan Republik Indonesia
1000	2025	152	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:56.37046	\N	Hari Raya Natal
1001	2025	152	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:04:56.407853	\N	Cuti Bersama Idul Fitri
1002	2025	152	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:04:56.444648	\N	Cuti Bersama Idul Fitri
1003	2025	152	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:04:56.484694	\N	Cuti Bersama Idul Fitri
1004	2025	152	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:04:56.543861	\N	Cuti Bersama Idul Fitri
1005	2025	152	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:04:56.622635	\N	Cuti Bersama Kenaikan Isa Almasih
1006	2025	152	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:04:56.706005	\N	Cuti Bersama Idul Adha
1007	2025	152	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:04:56.759502	\N	Cuti Bersama Natal
1008	2025	152	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:04:56.807336	\N	Cuti Bersama Natal
1009	2025	164	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:04:56.875008	\N	Regular annual leave
1010	2025	164	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:04:56.928797	\N	Tahun Baru 2025 Masehi
1011	2025	164	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:04:56.990456	\N	Isra Miraj Nabi Muhammad SAW
1012	2025	164	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:04:57.159858	\N	Tahun Baru Imlek 2576 Kongzili
1013	2025	164	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:04:57.531665	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1014	2025	164	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:04:57.703695	\N	Idul Fitri 1 Syawal 1446 Hijriah
1015	2025	164	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:04:57.843262	\N	Idul Fitri 2 Syawal 1446 Hijriah
1016	2025	164	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:04:58.009746	\N	Wafat Isa Almasih
1017	2025	164	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:04:58.166475	\N	Hari Buruh Internasional
1018	2025	164	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:04:58.334793	\N	Kenaikan Isa Almasih
1019	2025	164	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:04:58.522738	\N	Hari Raya Waisak 2569 BE
1020	2025	164	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:04:59.014714	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1021	2025	164	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:04:59.362836	\N	Tahun Baru Islam 1447 Hijriah
1022	2025	164	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:04:59.521233	\N	Maulid Nabi Muhammad SAW
1023	2025	164	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:04:59.710869	\N	Hari Kemerdekaan Republik Indonesia
1024	2025	164	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:04:59.879467	\N	Hari Raya Natal
1025	2025	164	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:00.192611	\N	Cuti Bersama Idul Fitri
1026	2025	164	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:00.669038	\N	Cuti Bersama Idul Fitri
1027	2025	164	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:00.809974	\N	Cuti Bersama Idul Fitri
1028	2025	164	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:01.254743	\N	Cuti Bersama Idul Fitri
1029	2025	164	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:01.363166	\N	Cuti Bersama Kenaikan Isa Almasih
1030	2025	164	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:01.474619	\N	Cuti Bersama Idul Adha
1031	2025	164	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:01.675568	\N	Cuti Bersama Natal
1032	2025	164	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:01.827402	\N	Cuti Bersama Natal
1033	2025	162	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:01.976016	\N	Regular annual leave
1034	2025	162	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:02.070221	\N	Tahun Baru 2025 Masehi
1035	2025	162	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:02.217067	\N	Isra Miraj Nabi Muhammad SAW
1036	2025	162	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:02.380439	\N	Tahun Baru Imlek 2576 Kongzili
1037	2025	162	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:02.521814	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1038	2025	162	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:02.680549	\N	Idul Fitri 1 Syawal 1446 Hijriah
1039	2025	162	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:02.771861	\N	Idul Fitri 2 Syawal 1446 Hijriah
1040	2025	162	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:02.957911	\N	Wafat Isa Almasih
1041	2025	162	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:03.175736	\N	Hari Buruh Internasional
1042	2025	162	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:03.319942	\N	Kenaikan Isa Almasih
1043	2025	162	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:03.523092	\N	Hari Raya Waisak 2569 BE
1044	2025	162	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:03.681493	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1045	2025	162	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:03.792806	\N	Tahun Baru Islam 1447 Hijriah
1046	2025	162	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:03.92426	\N	Maulid Nabi Muhammad SAW
1047	2025	162	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:04.076029	\N	Hari Kemerdekaan Republik Indonesia
1048	2025	162	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:04.176474	\N	Hari Raya Natal
1049	2025	162	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:04.300959	\N	Cuti Bersama Idul Fitri
1050	2025	162	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:04.404285	\N	Cuti Bersama Idul Fitri
1051	2025	162	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:04.577086	\N	Cuti Bersama Idul Fitri
1052	2025	162	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:04.704492	\N	Cuti Bersama Idul Fitri
1053	2025	162	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:04.832563	\N	Cuti Bersama Kenaikan Isa Almasih
1054	2025	162	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:04.879078	\N	Cuti Bersama Idul Adha
1055	2025	162	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:05.024094	\N	Cuti Bersama Natal
1056	2025	162	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:05.143916	\N	Cuti Bersama Natal
1057	2025	126	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:05.349965	\N	Regular annual leave
1058	2025	126	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:05.50211	\N	Tahun Baru 2025 Masehi
1059	2025	126	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:05.733517	\N	Isra Miraj Nabi Muhammad SAW
1060	2025	126	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:05.871705	\N	Tahun Baru Imlek 2576 Kongzili
1061	2025	126	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:05.979225	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1062	2025	126	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:06.138007	\N	Idul Fitri 1 Syawal 1446 Hijriah
1063	2025	126	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:06.323693	\N	Idul Fitri 2 Syawal 1446 Hijriah
1064	2025	126	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:06.482924	\N	Wafat Isa Almasih
1065	2025	126	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:06.680848	\N	Hari Buruh Internasional
1066	2025	126	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:06.804475	\N	Kenaikan Isa Almasih
1067	2025	126	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:06.938905	\N	Hari Raya Waisak 2569 BE
1068	2025	126	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:07.174978	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1069	2025	126	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:07.219426	\N	Tahun Baru Islam 1447 Hijriah
1070	2025	126	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:07.445304	\N	Maulid Nabi Muhammad SAW
1071	2025	126	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:07.798717	\N	Hari Kemerdekaan Republik Indonesia
1072	2025	126	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:08.004745	\N	Hari Raya Natal
1073	2025	126	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:08.256026	\N	Cuti Bersama Idul Fitri
1074	2025	126	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:08.38642	\N	Cuti Bersama Idul Fitri
1075	2025	126	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:08.585028	\N	Cuti Bersama Idul Fitri
1076	2025	126	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:08.757231	\N	Cuti Bersama Idul Fitri
1077	2025	126	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:08.844979	\N	Cuti Bersama Kenaikan Isa Almasih
1078	2025	126	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:08.975767	\N	Cuti Bersama Idul Adha
1079	2025	126	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:09.076076	\N	Cuti Bersama Natal
1080	2025	126	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:09.244138	\N	Cuti Bersama Natal
1081	2025	134	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:09.335422	\N	Regular annual leave
1082	2025	134	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:09.484841	\N	Tahun Baru 2025 Masehi
1083	2025	134	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:09.633045	\N	Isra Miraj Nabi Muhammad SAW
1084	2025	134	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:09.793802	\N	Tahun Baru Imlek 2576 Kongzili
1085	2025	134	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:10.020217	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1086	2025	134	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:10.151963	\N	Idul Fitri 1 Syawal 1446 Hijriah
1087	2025	134	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:10.262466	\N	Idul Fitri 2 Syawal 1446 Hijriah
1088	2025	134	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:10.492001	\N	Wafat Isa Almasih
1089	2025	134	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:10.777088	\N	Hari Buruh Internasional
1090	2025	134	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:10.960913	\N	Kenaikan Isa Almasih
1091	2025	134	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:11.121018	\N	Hari Raya Waisak 2569 BE
1092	2025	134	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:11.196052	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1093	2025	134	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:11.291609	\N	Tahun Baru Islam 1447 Hijriah
1094	2025	134	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:11.369163	\N	Maulid Nabi Muhammad SAW
1095	2025	134	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:11.510912	\N	Hari Kemerdekaan Republik Indonesia
1096	2025	134	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:11.601985	\N	Hari Raya Natal
1097	2025	134	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:11.792709	\N	Cuti Bersama Idul Fitri
1098	2025	134	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:11.94259	\N	Cuti Bersama Idul Fitri
1099	2025	134	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:12.094628	\N	Cuti Bersama Idul Fitri
1100	2025	134	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:12.240026	\N	Cuti Bersama Idul Fitri
1101	2025	134	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:12.40749	\N	Cuti Bersama Kenaikan Isa Almasih
1102	2025	134	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:12.567555	\N	Cuti Bersama Idul Adha
1103	2025	134	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:12.659848	\N	Cuti Bersama Natal
1104	2025	134	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:12.867244	\N	Cuti Bersama Natal
1105	2025	170	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:13.030025	\N	Regular annual leave
1106	2025	170	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:13.254957	\N	Tahun Baru 2025 Masehi
1107	2025	170	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:13.410491	\N	Isra Miraj Nabi Muhammad SAW
1108	2025	170	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:13.523542	\N	Tahun Baru Imlek 2576 Kongzili
1109	2025	170	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:13.669694	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1110	2025	170	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:13.878298	\N	Idul Fitri 1 Syawal 1446 Hijriah
1111	2025	170	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:14.0653	\N	Idul Fitri 2 Syawal 1446 Hijriah
1112	2025	170	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:14.149286	\N	Wafat Isa Almasih
1113	2025	170	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:14.296753	\N	Hari Buruh Internasional
1114	2025	170	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:14.389828	\N	Kenaikan Isa Almasih
1115	2025	170	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:21.107697	\N	Hari Raya Waisak 2569 BE
1116	2025	170	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:21.197318	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1117	2025	170	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:21.361072	\N	Tahun Baru Islam 1447 Hijriah
1118	2025	170	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:21.558104	\N	Maulid Nabi Muhammad SAW
1119	2025	170	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:21.810737	\N	Hari Kemerdekaan Republik Indonesia
1120	2025	170	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:21.950334	\N	Hari Raya Natal
1121	2025	170	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:22.17605	\N	Cuti Bersama Idul Fitri
1122	2025	170	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:22.447373	\N	Cuti Bersama Idul Fitri
1123	2025	170	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:22.556269	\N	Cuti Bersama Idul Fitri
1124	2025	170	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:23.002539	\N	Cuti Bersama Idul Fitri
1125	2025	170	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:23.253148	\N	Cuti Bersama Kenaikan Isa Almasih
1126	2025	170	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:23.389543	\N	Cuti Bersama Idul Adha
1127	2025	170	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:23.60427	\N	Cuti Bersama Natal
1128	2025	170	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:23.748253	\N	Cuti Bersama Natal
1129	2025	176	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:23.848039	\N	Regular annual leave
1130	2025	176	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:24.004965	\N	Tahun Baru 2025 Masehi
1131	2025	176	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:24.153589	\N	Isra Miraj Nabi Muhammad SAW
1132	2025	176	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:24.272767	\N	Tahun Baru Imlek 2576 Kongzili
1133	2025	176	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:24.419264	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1134	2025	176	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:24.597286	\N	Idul Fitri 1 Syawal 1446 Hijriah
1135	2025	176	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:24.698327	\N	Idul Fitri 2 Syawal 1446 Hijriah
1136	2025	176	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:24.86005	\N	Wafat Isa Almasih
1137	2025	176	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:25.067155	\N	Hari Buruh Internasional
1138	2025	176	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:25.163335	\N	Kenaikan Isa Almasih
1139	2025	176	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:25.367172	\N	Hari Raya Waisak 2569 BE
1140	2025	176	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:25.532705	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1141	2025	176	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:25.724582	\N	Tahun Baru Islam 1447 Hijriah
1142	2025	176	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:25.891285	\N	Maulid Nabi Muhammad SAW
1143	2025	176	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:26.039073	\N	Hari Kemerdekaan Republik Indonesia
1144	2025	176	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:26.200497	\N	Hari Raya Natal
1145	2025	176	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:26.28154	\N	Cuti Bersama Idul Fitri
1146	2025	176	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:26.432708	\N	Cuti Bersama Idul Fitri
1147	2025	176	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:26.526098	\N	Cuti Bersama Idul Fitri
1148	2025	176	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:26.691952	\N	Cuti Bersama Idul Fitri
1149	2025	176	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:26.78733	\N	Cuti Bersama Kenaikan Isa Almasih
1150	2025	176	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:26.95577	\N	Cuti Bersama Idul Adha
1151	2025	176	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:27.106567	\N	Cuti Bersama Natal
1152	2025	176	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:27.193612	\N	Cuti Bersama Natal
1153	2025	146	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:27.358969	\N	Regular annual leave
1154	2025	146	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:27.462238	\N	Tahun Baru 2025 Masehi
1155	2025	146	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:27.613155	\N	Isra Miraj Nabi Muhammad SAW
1156	2025	146	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:27.708682	\N	Tahun Baru Imlek 2576 Kongzili
1157	2025	146	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:27.877018	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1158	2025	146	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:28.066762	\N	Idul Fitri 1 Syawal 1446 Hijriah
1159	2025	146	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:28.229515	\N	Idul Fitri 2 Syawal 1446 Hijriah
1160	2025	146	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:28.40918	\N	Wafat Isa Almasih
1161	2025	146	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:28.56856	\N	Hari Buruh Internasional
1162	2025	146	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:28.805157	\N	Kenaikan Isa Almasih
1163	2025	146	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:28.952775	\N	Hari Raya Waisak 2569 BE
1164	2025	146	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:29.071312	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1165	2025	146	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:29.252515	\N	Tahun Baru Islam 1447 Hijriah
1166	2025	146	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:29.349206	\N	Maulid Nabi Muhammad SAW
1167	2025	146	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:29.504686	\N	Hari Kemerdekaan Republik Indonesia
1168	2025	146	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:29.670543	\N	Hari Raya Natal
1169	2025	146	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:29.890557	\N	Cuti Bersama Idul Fitri
1170	2025	146	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:30.025987	\N	Cuti Bersama Idul Fitri
1171	2025	146	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:30.181816	\N	Cuti Bersama Idul Fitri
1172	2025	146	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:30.546245	\N	Cuti Bersama Idul Fitri
1173	2025	146	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:30.759293	\N	Cuti Bersama Kenaikan Isa Almasih
1174	2025	146	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:30.987535	\N	Cuti Bersama Idul Adha
1175	2025	146	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:31.404333	\N	Cuti Bersama Natal
1176	2025	146	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:31.589935	\N	Cuti Bersama Natal
1177	2025	161	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:31.729224	\N	Regular annual leave
1178	2025	161	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:31.894394	\N	Tahun Baru 2025 Masehi
1179	2025	161	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:32.119573	\N	Isra Miraj Nabi Muhammad SAW
1180	2025	161	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:32.227599	\N	Tahun Baru Imlek 2576 Kongzili
1181	2025	161	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:32.2651	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1182	2025	161	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:32.434178	\N	Idul Fitri 1 Syawal 1446 Hijriah
1183	2025	161	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:32.596464	\N	Idul Fitri 2 Syawal 1446 Hijriah
1184	2025	161	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:32.753927	\N	Wafat Isa Almasih
1185	2025	161	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:32.934737	\N	Hari Buruh Internasional
1186	2025	161	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:33.083609	\N	Kenaikan Isa Almasih
1187	2025	161	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:33.234127	\N	Hari Raya Waisak 2569 BE
1188	2025	161	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:33.406368	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1189	2025	161	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:33.502596	\N	Tahun Baru Islam 1447 Hijriah
1190	2025	161	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:33.681279	\N	Maulid Nabi Muhammad SAW
1191	2025	161	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:33.865343	\N	Hari Kemerdekaan Republik Indonesia
1192	2025	161	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:34.016044	\N	Hari Raya Natal
1193	2025	161	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:34.301722	\N	Cuti Bersama Idul Fitri
1194	2025	161	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:34.441578	\N	Cuti Bersama Idul Fitri
1195	2025	161	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:34.540966	\N	Cuti Bersama Idul Fitri
1196	2025	161	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:34.72515	\N	Cuti Bersama Idul Fitri
1197	2025	161	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:34.881843	\N	Cuti Bersama Kenaikan Isa Almasih
1198	2025	161	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:35.052215	\N	Cuti Bersama Idul Adha
1199	2025	161	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:35.226162	\N	Cuti Bersama Natal
1200	2025	161	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:35.378242	\N	Cuti Bersama Natal
1201	2025	181	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:35.54355	\N	Regular annual leave
1202	2025	181	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:35.647571	\N	Tahun Baru 2025 Masehi
1203	2025	181	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:35.80353	\N	Isra Miraj Nabi Muhammad SAW
1204	2025	181	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:35.894527	\N	Tahun Baru Imlek 2576 Kongzili
1205	2025	181	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:36.061463	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1206	2025	181	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:36.24309	\N	Idul Fitri 1 Syawal 1446 Hijriah
1207	2025	181	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:36.410413	\N	Idul Fitri 2 Syawal 1446 Hijriah
1208	2025	181	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:36.505804	\N	Wafat Isa Almasih
1209	2025	181	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:36.671121	\N	Hari Buruh Internasional
1210	2025	181	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:36.772324	\N	Kenaikan Isa Almasih
1211	2025	181	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:36.864666	\N	Hari Raya Waisak 2569 BE
1212	2025	181	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:37.030622	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1213	2025	181	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:37.19294	\N	Tahun Baru Islam 1447 Hijriah
1214	2025	181	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:37.371904	\N	Maulid Nabi Muhammad SAW
1215	2025	181	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:37.519576	\N	Hari Kemerdekaan Republik Indonesia
1216	2025	181	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:37.627737	\N	Hari Raya Natal
1217	2025	181	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:37.781005	\N	Cuti Bersama Idul Fitri
1218	2025	181	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:37.949839	\N	Cuti Bersama Idul Fitri
1219	2025	181	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:38.245143	\N	Cuti Bersama Idul Fitri
1220	2025	181	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:38.493084	\N	Cuti Bersama Idul Fitri
1221	2025	181	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:38.749403	\N	Cuti Bersama Kenaikan Isa Almasih
1222	2025	181	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:38.896546	\N	Cuti Bersama Idul Adha
1223	2025	181	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:39.188327	\N	Cuti Bersama Natal
1224	2025	181	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:39.387579	\N	Cuti Bersama Natal
1225	2025	175	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:39.527744	\N	Regular annual leave
1226	2025	175	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:39.739554	\N	Tahun Baru 2025 Masehi
1227	2025	175	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:39.959679	\N	Isra Miraj Nabi Muhammad SAW
1228	2025	175	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:40.148323	\N	Tahun Baru Imlek 2576 Kongzili
1229	2025	175	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:40.232462	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1230	2025	175	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:40.389315	\N	Idul Fitri 1 Syawal 1446 Hijriah
1231	2025	175	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:40.556405	\N	Idul Fitri 2 Syawal 1446 Hijriah
1232	2025	175	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:40.731243	\N	Wafat Isa Almasih
1233	2025	175	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:40.981479	\N	Hari Buruh Internasional
1234	2025	175	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:41.083695	\N	Kenaikan Isa Almasih
1235	2025	175	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:41.280927	\N	Hari Raya Waisak 2569 BE
1236	2025	175	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:41.451969	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1237	2025	175	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:41.611191	\N	Tahun Baru Islam 1447 Hijriah
1238	2025	175	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:41.707025	\N	Maulid Nabi Muhammad SAW
1239	2025	175	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:41.910898	\N	Hari Kemerdekaan Republik Indonesia
1240	2025	175	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:42.049087	\N	Hari Raya Natal
1241	2025	175	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:42.278616	\N	Cuti Bersama Idul Fitri
1242	2025	175	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:42.426318	\N	Cuti Bersama Idul Fitri
1243	2025	175	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:42.59334	\N	Cuti Bersama Idul Fitri
1244	2025	175	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:42.811367	\N	Cuti Bersama Idul Fitri
1245	2025	175	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:42.980281	\N	Cuti Bersama Kenaikan Isa Almasih
1246	2025	175	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:43.162601	\N	Cuti Bersama Idul Adha
1247	2025	175	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:43.326626	\N	Cuti Bersama Natal
1248	2025	175	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:43.522072	\N	Cuti Bersama Natal
1249	2025	167	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:43.701573	\N	Regular annual leave
1250	2025	167	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:43.911825	\N	Tahun Baru 2025 Masehi
1251	2025	167	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:43.997161	\N	Isra Miraj Nabi Muhammad SAW
1252	2025	167	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:44.098457	\N	Tahun Baru Imlek 2576 Kongzili
1253	2025	167	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:44.250655	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1254	2025	167	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:44.350532	\N	Idul Fitri 1 Syawal 1446 Hijriah
1255	2025	167	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:44.529779	\N	Idul Fitri 2 Syawal 1446 Hijriah
1256	2025	167	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:44.705931	\N	Wafat Isa Almasih
1257	2025	167	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:44.881457	\N	Hari Buruh Internasional
1258	2025	167	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:45.055339	\N	Kenaikan Isa Almasih
1259	2025	167	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:45.282642	\N	Hari Raya Waisak 2569 BE
1260	2025	167	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:45.544578	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1261	2025	167	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:45.699869	\N	Tahun Baru Islam 1447 Hijriah
1262	2025	167	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:45.933766	\N	Maulid Nabi Muhammad SAW
1263	2025	167	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:46.183133	\N	Hari Kemerdekaan Republik Indonesia
1264	2025	167	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:46.323291	\N	Hari Raya Natal
1265	2025	167	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:46.59559	\N	Cuti Bersama Idul Fitri
1266	2025	167	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:46.867313	\N	Cuti Bersama Idul Fitri
1267	2025	167	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:47.010556	\N	Cuti Bersama Idul Fitri
1268	2025	167	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:47.348556	\N	Cuti Bersama Idul Fitri
1269	2025	167	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:47.672935	\N	Cuti Bersama Kenaikan Isa Almasih
1270	2025	167	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:47.712775	\N	Cuti Bersama Idul Adha
1271	2025	167	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:47.940319	\N	Cuti Bersama Natal
1272	2025	167	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:47.975272	\N	Cuti Bersama Natal
1273	2025	139	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:48.139449	\N	Regular annual leave
1274	2025	139	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:48.179232	\N	Tahun Baru 2025 Masehi
1275	2025	139	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:48.271272	\N	Isra Miraj Nabi Muhammad SAW
1276	2025	139	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:48.587859	\N	Tahun Baru Imlek 2576 Kongzili
1277	2025	139	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:48.62059	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1278	2025	139	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:48.668075	\N	Idul Fitri 1 Syawal 1446 Hijriah
1279	2025	139	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:48.821746	\N	Idul Fitri 2 Syawal 1446 Hijriah
1280	2025	139	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:48.858224	\N	Wafat Isa Almasih
1281	2025	139	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:49.009886	\N	Hari Buruh Internasional
1282	2025	139	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:49.059239	\N	Kenaikan Isa Almasih
1283	2025	139	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:49.094414	\N	Hari Raya Waisak 2569 BE
1284	2025	139	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:49.129151	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1285	2025	139	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:49.413795	\N	Tahun Baru Islam 1447 Hijriah
1286	2025	139	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:49.459128	\N	Maulid Nabi Muhammad SAW
1287	2025	139	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:49.491049	\N	Hari Kemerdekaan Republik Indonesia
1288	2025	139	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:49.526997	\N	Hari Raya Natal
1289	2025	139	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:49.56065	\N	Cuti Bersama Idul Fitri
1290	2025	139	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:49.727983	\N	Cuti Bersama Idul Fitri
1291	2025	139	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:49.778996	\N	Cuti Bersama Idul Fitri
1292	2025	139	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:49.912221	\N	Cuti Bersama Idul Fitri
1293	2025	139	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:49.94756	\N	Cuti Bersama Kenaikan Isa Almasih
1294	2025	139	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:49.983334	\N	Cuti Bersama Idul Adha
1295	2025	139	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:50.11709	\N	Cuti Bersama Natal
1296	2025	139	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:50.283158	\N	Cuti Bersama Natal
1297	2025	173	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:50.44261	\N	Regular annual leave
1298	2025	173	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:50.602244	\N	Tahun Baru 2025 Masehi
1299	2025	173	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:50.765499	\N	Isra Miraj Nabi Muhammad SAW
1300	2025	173	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:50.932656	\N	Tahun Baru Imlek 2576 Kongzili
1301	2025	173	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:51.183818	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1302	2025	173	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:51.277336	\N	Idul Fitri 1 Syawal 1446 Hijriah
1303	2025	173	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:51.509612	\N	Idul Fitri 2 Syawal 1446 Hijriah
1304	2025	173	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:51.664089	\N	Wafat Isa Almasih
1305	2025	173	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:51.834224	\N	Hari Buruh Internasional
1306	2025	173	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:52.012222	\N	Kenaikan Isa Almasih
1307	2025	173	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:52.16287	\N	Hari Raya Waisak 2569 BE
1308	2025	173	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:52.279391	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1309	2025	173	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:52.508579	\N	Tahun Baru Islam 1447 Hijriah
1310	2025	173	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:52.822128	\N	Maulid Nabi Muhammad SAW
1311	2025	173	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:53.010367	\N	Hari Kemerdekaan Republik Indonesia
1312	2025	173	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:53.809821	\N	Hari Raya Natal
1313	2025	173	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:54.097908	\N	Cuti Bersama Idul Fitri
1314	2025	173	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:54.271793	\N	Cuti Bersama Idul Fitri
1315	2025	173	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:54.448557	\N	Cuti Bersama Idul Fitri
1316	2025	173	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:54.538241	\N	Cuti Bersama Idul Fitri
1317	2025	173	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:54.713264	\N	Cuti Bersama Kenaikan Isa Almasih
1318	2025	173	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:54.803946	\N	Cuti Bersama Idul Adha
1319	2025	173	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:54.971615	\N	Cuti Bersama Natal
1320	2025	173	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:55.172385	\N	Cuti Bersama Natal
1321	2025	137	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:55.293875	\N	Regular annual leave
1322	2025	137	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:55.466008	\N	Tahun Baru 2025 Masehi
1323	2025	137	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:55.630337	\N	Isra Miraj Nabi Muhammad SAW
1324	2025	137	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:05:55.742537	\N	Tahun Baru Imlek 2576 Kongzili
1325	2025	137	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:05:56.056571	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1326	2025	137	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:05:56.088699	\N	Idul Fitri 1 Syawal 1446 Hijriah
1327	2025	137	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:05:56.350019	\N	Idul Fitri 2 Syawal 1446 Hijriah
1328	2025	137	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:05:56.607492	\N	Wafat Isa Almasih
1329	2025	137	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:05:56.884868	\N	Hari Buruh Internasional
1330	2025	137	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:05:57.087766	\N	Kenaikan Isa Almasih
1331	2025	137	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:05:57.410554	\N	Hari Raya Waisak 2569 BE
1332	2025	137	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:05:57.552244	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1333	2025	137	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:05:57.726052	\N	Tahun Baru Islam 1447 Hijriah
1334	2025	137	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:05:57.934019	\N	Maulid Nabi Muhammad SAW
1335	2025	137	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:05:58.144105	\N	Hari Kemerdekaan Republik Indonesia
1336	2025	137	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:05:58.247566	\N	Hari Raya Natal
1337	2025	137	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:05:58.415366	\N	Cuti Bersama Idul Fitri
1338	2025	137	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:05:58.513497	\N	Cuti Bersama Idul Fitri
1339	2025	137	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:05:58.615296	\N	Cuti Bersama Idul Fitri
1340	2025	137	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:05:58.77518	\N	Cuti Bersama Idul Fitri
1341	2025	137	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:05:58.972112	\N	Cuti Bersama Kenaikan Isa Almasih
1342	2025	137	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:05:59.153421	\N	Cuti Bersama Idul Adha
1343	2025	137	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:05:59.340603	\N	Cuti Bersama Natal
1344	2025	137	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:05:59.463559	\N	Cuti Bersama Natal
1345	2025	179	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:05:59.563682	\N	Regular annual leave
1346	2025	179	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:05:59.735492	\N	Tahun Baru 2025 Masehi
1347	2025	179	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:05:59.899243	\N	Isra Miraj Nabi Muhammad SAW
1348	2025	179	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:00.102275	\N	Tahun Baru Imlek 2576 Kongzili
1349	2025	179	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:00.200106	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1350	2025	179	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:00.419139	\N	Idul Fitri 1 Syawal 1446 Hijriah
1351	2025	179	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:00.61942	\N	Idul Fitri 2 Syawal 1446 Hijriah
1352	2025	179	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:00.770355	\N	Wafat Isa Almasih
1353	2025	179	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:00.868854	\N	Hari Buruh Internasional
1354	2025	179	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:01.058867	\N	Kenaikan Isa Almasih
1355	2025	179	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:01.227102	\N	Hari Raya Waisak 2569 BE
1356	2025	179	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:01.463585	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1357	2025	179	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:01.527024	\N	Tahun Baru Islam 1447 Hijriah
1358	2025	179	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:01.735822	\N	Maulid Nabi Muhammad SAW
1359	2025	179	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:01.903577	\N	Hari Kemerdekaan Republik Indonesia
1360	2025	179	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:02.00214	\N	Hari Raya Natal
1361	2025	179	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:02.107385	\N	Cuti Bersama Idul Fitri
1362	2025	179	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:02.376068	\N	Cuti Bersama Idul Fitri
1363	2025	179	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:02.581697	\N	Cuti Bersama Idul Fitri
1364	2025	179	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:02.771477	\N	Cuti Bersama Idul Fitri
1365	2025	179	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:03.060233	\N	Cuti Bersama Kenaikan Isa Almasih
1366	2025	179	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:03.330784	\N	Cuti Bersama Idul Adha
1367	2025	179	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:03.548091	\N	Cuti Bersama Natal
1368	2025	179	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:03.810142	\N	Cuti Bersama Natal
1369	2025	149	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:03.918733	\N	Regular annual leave
1370	2025	149	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:04.095402	\N	Tahun Baru 2025 Masehi
1371	2025	149	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:04.295243	\N	Isra Miraj Nabi Muhammad SAW
1372	2025	149	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:04.461566	\N	Tahun Baru Imlek 2576 Kongzili
1373	2025	149	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:04.653112	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1374	2025	149	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:04.917625	\N	Idul Fitri 1 Syawal 1446 Hijriah
1375	2025	149	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:05.221599	\N	Idul Fitri 2 Syawal 1446 Hijriah
1376	2025	149	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:05.654309	\N	Wafat Isa Almasih
1377	2025	149	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:05.804991	\N	Hari Buruh Internasional
1378	2025	149	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:06.149176	\N	Kenaikan Isa Almasih
1379	2025	149	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:06.428138	\N	Hari Raya Waisak 2569 BE
1380	2025	149	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:06.688399	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1381	2025	149	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:06.922168	\N	Tahun Baru Islam 1447 Hijriah
1382	2025	149	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:07.020822	\N	Maulid Nabi Muhammad SAW
1383	2025	149	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:07.195473	\N	Hari Kemerdekaan Republik Indonesia
1384	2025	149	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:07.364293	\N	Hari Raya Natal
1385	2025	149	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:07.479949	\N	Cuti Bersama Idul Fitri
1386	2025	149	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:07.667672	\N	Cuti Bersama Idul Fitri
1387	2025	149	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:07.851251	\N	Cuti Bersama Idul Fitri
1388	2025	149	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:07.960006	\N	Cuti Bersama Idul Fitri
1389	2025	149	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:08.189	\N	Cuti Bersama Kenaikan Isa Almasih
1390	2025	149	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:08.298588	\N	Cuti Bersama Idul Adha
1391	2025	149	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:08.399005	\N	Cuti Bersama Natal
1392	2025	149	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:08.610117	\N	Cuti Bersama Natal
1393	2025	125	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:08.905482	\N	Regular annual leave
1394	2025	125	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:09.012023	\N	Tahun Baru 2025 Masehi
1395	2025	125	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:09.255129	\N	Isra Miraj Nabi Muhammad SAW
1396	2025	125	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:09.43066	\N	Tahun Baru Imlek 2576 Kongzili
1397	2025	125	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:09.684438	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1398	2025	125	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:09.793324	\N	Idul Fitri 1 Syawal 1446 Hijriah
1399	2025	125	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:09.979894	\N	Idul Fitri 2 Syawal 1446 Hijriah
1400	2025	125	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:10.094235	\N	Wafat Isa Almasih
1401	2025	125	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:10.288421	\N	Hari Buruh Internasional
1402	2025	125	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:10.4508	\N	Kenaikan Isa Almasih
1403	2025	125	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:10.650913	\N	Hari Raya Waisak 2569 BE
1404	2025	125	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:10.836163	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1405	2025	125	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:11.039151	\N	Tahun Baru Islam 1447 Hijriah
1406	2025	125	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:11.135626	\N	Maulid Nabi Muhammad SAW
1407	2025	125	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:11.315492	\N	Hari Kemerdekaan Republik Indonesia
1408	2025	125	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:11.481632	\N	Hari Raya Natal
1409	2025	125	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:11.692971	\N	Cuti Bersama Idul Fitri
1410	2025	125	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:11.80379	\N	Cuti Bersama Idul Fitri
1411	2025	125	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:12.184746	\N	Cuti Bersama Idul Fitri
1412	2025	125	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:12.730106	\N	Cuti Bersama Idul Fitri
1413	2025	125	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:13.440627	\N	Cuti Bersama Kenaikan Isa Almasih
1414	2025	125	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:14.891949	\N	Cuti Bersama Idul Adha
1415	2025	125	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:15.648276	\N	Cuti Bersama Natal
1416	2025	125	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:15.770757	\N	Cuti Bersama Natal
1417	2025	143	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:15.962671	\N	Regular annual leave
1418	2025	143	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:16.075644	\N	Tahun Baru 2025 Masehi
1419	2025	143	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:16.260455	\N	Isra Miraj Nabi Muhammad SAW
1420	2025	143	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:16.557888	\N	Tahun Baru Imlek 2576 Kongzili
1421	2025	143	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:16.727095	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1422	2025	143	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:17.022863	\N	Idul Fitri 1 Syawal 1446 Hijriah
1423	2025	143	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:17.324408	\N	Idul Fitri 2 Syawal 1446 Hijriah
1424	2025	143	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:17.579843	\N	Wafat Isa Almasih
1425	2025	143	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:17.77287	\N	Hari Buruh Internasional
1426	2025	143	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:17.96808	\N	Kenaikan Isa Almasih
1427	2025	143	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:18.253621	\N	Hari Raya Waisak 2569 BE
1428	2025	143	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:18.624506	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1429	2025	143	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:18.852216	\N	Tahun Baru Islam 1447 Hijriah
1430	2025	143	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:19.037156	\N	Maulid Nabi Muhammad SAW
1431	2025	143	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:19.142745	\N	Hari Kemerdekaan Republik Indonesia
1432	2025	143	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:19.371376	\N	Hari Raya Natal
1433	2025	143	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:19.5583	\N	Cuti Bersama Idul Fitri
1434	2025	143	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:19.750221	\N	Cuti Bersama Idul Fitri
1435	2025	143	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:19.860997	\N	Cuti Bersama Idul Fitri
1436	2025	143	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:20.095155	\N	Cuti Bersama Idul Fitri
1437	2025	143	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:20.269043	\N	Cuti Bersama Kenaikan Isa Almasih
1438	2025	143	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:20.397518	\N	Cuti Bersama Idul Adha
1439	2025	143	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:20.571045	\N	Cuti Bersama Natal
1440	2025	143	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:20.794188	\N	Cuti Bersama Natal
1441	2025	151	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:20.98579	\N	Regular annual leave
1442	2025	151	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:21.505133	\N	Tahun Baru 2025 Masehi
1443	2025	151	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:21.709386	\N	Isra Miraj Nabi Muhammad SAW
1444	2025	151	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:21.888381	\N	Tahun Baru Imlek 2576 Kongzili
1445	2025	151	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:22.08475	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1446	2025	151	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:22.188132	\N	Idul Fitri 1 Syawal 1446 Hijriah
1447	2025	151	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:22.378096	\N	Idul Fitri 2 Syawal 1446 Hijriah
1448	2025	151	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:22.558699	\N	Wafat Isa Almasih
1449	2025	151	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:22.76583	\N	Hari Buruh Internasional
1450	2025	151	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:22.910573	\N	Kenaikan Isa Almasih
1451	2025	151	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:23.210407	\N	Hari Raya Waisak 2569 BE
1452	2025	151	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:23.247779	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1453	2025	151	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:24.024276	\N	Tahun Baru Islam 1447 Hijriah
1454	2025	151	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:24.409791	\N	Maulid Nabi Muhammad SAW
1455	2025	151	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:24.751285	\N	Hari Kemerdekaan Republik Indonesia
1456	2025	151	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:24.987111	\N	Hari Raya Natal
1457	2025	151	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:25.282045	\N	Cuti Bersama Idul Fitri
1458	2025	151	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:25.414586	\N	Cuti Bersama Idul Fitri
1459	2025	151	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:25.550134	\N	Cuti Bersama Idul Fitri
1460	2025	151	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:25.739662	\N	Cuti Bersama Idul Fitri
1461	2025	151	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:25.952177	\N	Cuti Bersama Kenaikan Isa Almasih
1462	2025	151	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:26.240052	\N	Cuti Bersama Idul Adha
1463	2025	151	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:26.345259	\N	Cuti Bersama Natal
1464	2025	151	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:26.550825	\N	Cuti Bersama Natal
1465	2025	133	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:26.753856	\N	Regular annual leave
1466	2025	133	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:27.215906	\N	Tahun Baru 2025 Masehi
1467	2025	133	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:27.631334	\N	Isra Miraj Nabi Muhammad SAW
1468	2025	133	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:27.916126	\N	Tahun Baru Imlek 2576 Kongzili
1469	2025	133	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:28.117252	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1470	2025	133	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:28.219377	\N	Idul Fitri 1 Syawal 1446 Hijriah
1471	2025	133	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:28.345082	\N	Idul Fitri 2 Syawal 1446 Hijriah
1472	2025	133	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:28.587956	\N	Wafat Isa Almasih
1473	2025	133	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:28.762185	\N	Hari Buruh Internasional
1474	2025	133	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:28.996469	\N	Kenaikan Isa Almasih
1475	2025	133	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:29.243388	\N	Hari Raya Waisak 2569 BE
1476	2025	133	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:29.440554	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1477	2025	133	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:29.611134	\N	Tahun Baru Islam 1447 Hijriah
1478	2025	133	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:29.726587	\N	Maulid Nabi Muhammad SAW
1479	2025	133	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:29.926385	\N	Hari Kemerdekaan Republik Indonesia
1480	2025	133	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:30.123907	\N	Hari Raya Natal
1481	2025	133	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:30.320887	\N	Cuti Bersama Idul Fitri
1482	2025	133	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:30.531052	\N	Cuti Bersama Idul Fitri
1483	2025	133	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:30.636108	\N	Cuti Bersama Idul Fitri
1484	2025	133	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:30.745127	\N	Cuti Bersama Idul Fitri
1485	2025	133	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:30.927934	\N	Cuti Bersama Kenaikan Isa Almasih
1486	2025	133	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:31.043661	\N	Cuti Bersama Idul Adha
1487	2025	133	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:31.15852	\N	Cuti Bersama Natal
1488	2025	133	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:31.354481	\N	Cuti Bersama Natal
1489	2025	145	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:31.558927	\N	Regular annual leave
1490	2025	145	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:31.887491	\N	Tahun Baru 2025 Masehi
1491	2025	145	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:32.087716	\N	Isra Miraj Nabi Muhammad SAW
1492	2025	145	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:32.337431	\N	Tahun Baru Imlek 2576 Kongzili
1493	2025	145	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:32.538385	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1494	2025	145	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:32.830844	\N	Idul Fitri 1 Syawal 1446 Hijriah
1495	2025	145	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:33.020362	\N	Idul Fitri 2 Syawal 1446 Hijriah
1496	2025	145	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:33.327649	\N	Wafat Isa Almasih
1497	2025	145	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:33.465302	\N	Hari Buruh Internasional
1498	2025	145	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:33.630163	\N	Kenaikan Isa Almasih
1499	2025	145	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:33.916693	\N	Hari Raya Waisak 2569 BE
1500	2025	145	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:34.158251	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1501	2025	145	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:34.489653	\N	Tahun Baru Islam 1447 Hijriah
1502	2025	145	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:34.637256	\N	Maulid Nabi Muhammad SAW
1503	2025	145	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:35.005629	\N	Hari Kemerdekaan Republik Indonesia
1504	2025	145	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:35.168153	\N	Hari Raya Natal
1505	2025	145	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:35.385923	\N	Cuti Bersama Idul Fitri
1506	2025	145	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:35.497251	\N	Cuti Bersama Idul Fitri
1507	2025	145	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:35.713516	\N	Cuti Bersama Idul Fitri
1508	2025	145	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:35.894592	\N	Cuti Bersama Idul Fitri
1509	2025	145	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:36.100397	\N	Cuti Bersama Kenaikan Isa Almasih
1510	2025	145	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:36.291198	\N	Cuti Bersama Idul Adha
1511	2025	145	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:36.488024	\N	Cuti Bersama Natal
1512	2025	145	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:36.600502	\N	Cuti Bersama Natal
1513	2025	155	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:36.794926	\N	Regular annual leave
1514	2025	155	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:37.110049	\N	Tahun Baru 2025 Masehi
1515	2025	155	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:37.378528	\N	Isra Miraj Nabi Muhammad SAW
1516	2025	155	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:37.504657	\N	Tahun Baru Imlek 2576 Kongzili
1517	2025	155	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:37.644506	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1518	2025	155	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:37.869187	\N	Idul Fitri 1 Syawal 1446 Hijriah
1519	2025	155	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:38.070941	\N	Idul Fitri 2 Syawal 1446 Hijriah
1520	2025	155	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:38.289456	\N	Wafat Isa Almasih
1521	2025	155	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:38.39377	\N	Hari Buruh Internasional
1522	2025	155	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:38.511982	\N	Kenaikan Isa Almasih
1523	2025	155	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:38.712178	\N	Hari Raya Waisak 2569 BE
1524	2025	155	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:38.930467	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1525	2025	155	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:39.060451	\N	Tahun Baru Islam 1447 Hijriah
1526	2025	155	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:39.444785	\N	Maulid Nabi Muhammad SAW
1527	2025	155	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:39.701396	\N	Hari Kemerdekaan Republik Indonesia
1528	2025	155	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:39.914409	\N	Hari Raya Natal
1529	2025	155	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:40.031765	\N	Cuti Bersama Idul Fitri
1530	2025	155	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:40.26603	\N	Cuti Bersama Idul Fitri
1531	2025	155	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:40.386479	\N	Cuti Bersama Idul Fitri
1532	2025	155	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:40.608733	\N	Cuti Bersama Idul Fitri
1533	2025	155	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:40.737668	\N	Cuti Bersama Kenaikan Isa Almasih
1534	2025	155	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:40.936102	\N	Cuti Bersama Idul Adha
1535	2025	155	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:41.145226	\N	Cuti Bersama Natal
1536	2025	155	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:41.337937	\N	Cuti Bersama Natal
1537	2025	169	1	12	0	2025-01-01	2025-12-31	1	2025-03-04 15:06:41.443167	\N	Regular annual leave
1538	2025	169	2	1	1	2025-01-01	2025-01-01	4	2025-03-04 15:06:41.590295	\N	Tahun Baru 2025 Masehi
1539	2025	169	2	1	1	2025-01-27	2025-01-27	4	2025-03-04 15:06:42.077995	\N	Isra Miraj Nabi Muhammad SAW
1540	2025	169	2	1	1	2025-01-29	2025-01-29	4	2025-03-04 15:06:42.227185	\N	Tahun Baru Imlek 2576 Kongzili
1541	2025	169	2	1	0	2025-03-29	2025-03-29	2	2025-03-04 15:06:42.530235	\N	Hari Suci Nyepi (Tahun Baru Saka 1947)
1542	2025	169	2	1	0	2025-03-31	2025-03-31	2	2025-03-04 15:06:42.812643	\N	Idul Fitri 1 Syawal 1446 Hijriah
1543	2025	169	2	1	0	2025-04-01	2025-04-01	2	2025-03-04 15:06:43.040508	\N	Idul Fitri 2 Syawal 1446 Hijriah
1544	2025	169	2	1	0	2025-04-18	2025-04-18	2	2025-03-04 15:06:43.168728	\N	Wafat Isa Almasih
1545	2025	169	2	1	0	2025-05-01	2025-05-01	2	2025-03-04 15:06:43.438972	\N	Hari Buruh Internasional
1546	2025	169	2	1	0	2025-05-15	2025-05-15	2	2025-03-04 15:06:43.604797	\N	Kenaikan Isa Almasih
1547	2025	169	2	1	0	2025-05-18	2025-05-18	2	2025-03-04 15:06:43.828596	\N	Hari Raya Waisak 2569 BE
1548	2025	169	2	1	0	2025-05-26	2025-05-26	2	2025-03-04 15:06:44.024828	\N	Idul Adha 10 Zulhijah 1446 Hijriah
1549	2025	169	2	1	0	2025-06-17	2025-06-17	2	2025-03-04 15:06:44.225232	\N	Tahun Baru Islam 1447 Hijriah
1550	2025	169	2	1	0	2025-07-17	2025-07-17	2	2025-03-04 15:06:44.410473	\N	Maulid Nabi Muhammad SAW
1551	2025	169	2	1	0	2025-08-17	2025-08-17	2	2025-03-04 15:06:44.694378	\N	Hari Kemerdekaan Republik Indonesia
1552	2025	169	2	1	0	2025-09-26	2025-09-26	2	2025-03-04 15:06:44.818402	\N	Hari Raya Natal
1553	2025	169	3	1	0	2025-03-28	2025-03-28	2	2025-03-04 15:06:45.019685	\N	Cuti Bersama Idul Fitri
1554	2025	169	3	1	0	2025-04-02	2025-04-02	2	2025-03-04 15:06:45.25982	\N	Cuti Bersama Idul Fitri
1555	2025	169	3	1	0	2025-04-03	2025-04-03	2	2025-03-04 15:06:45.530287	\N	Cuti Bersama Idul Fitri
1556	2025	169	3	1	0	2025-04-04	2025-04-04	2	2025-03-04 15:06:45.803636	\N	Cuti Bersama Idul Fitri
1557	2025	169	3	1	0	2025-05-16	2025-05-16	2	2025-03-04 15:06:46.050222	\N	Cuti Bersama Kenaikan Isa Almasih
1558	2025	169	3	1	0	2025-05-27	2025-05-27	2	2025-03-04 15:06:46.276001	\N	Cuti Bersama Idul Adha
1559	2025	169	3	1	0	2025-12-24	2025-12-24	2	2025-03-04 15:06:46.52269	\N	Cuti Bersama Natal
1560	2025	169	3	1	0	2025-12-26	2025-12-26	2	2025-03-04 15:06:46.704252	\N	Cuti Bersama Natal
1561	2025	132	4	1	1	2025-02-01	2025-02-01	4	2025-03-04 16:26:04.51546	\N	Heartache
1562	2025	146	4	1	1	2025-01-03	2025-01-03	4	2025-03-04 16:26:04.594224	\N	Heartache
1563	2025	130	4	1	1	2025-02-02	2025-02-02	4	2025-03-04 16:26:04.6608	\N	Food Poisoning
1564	2025	148	4	1	1	2025-01-21	2025-01-21	4	2025-03-04 16:26:04.725232	\N	Toothache
1565	2025	182	4	1	1	2025-01-04	2025-01-04	4	2025-03-04 16:26:04.822575	\N	Migraine
1566	2025	158	4	1	1	2025-01-08	2025-01-08	4	2025-03-04 16:26:04.880509	\N	Flu
1567	2025	144	4	1	1	2025-01-26	2025-01-26	4	2025-03-04 16:26:04.960258	\N	Migraine
1568	2025	180	4	1	1	2025-02-05	2025-02-05	4	2025-03-04 16:26:05.013055	\N	Heartache
1569	2025	152	4	1	1	2025-02-06	2025-02-06	4	2025-03-04 16:26:05.05665	\N	Toothache
1570	2025	160	4	1	1	2025-02-18	2025-02-18	4	2025-03-04 16:26:05.142487	\N	Stomachache
1571	2025	140	7	1	0	2025-06-18	2025-06-18	2	2025-03-04 16:26:05.196998	\N	Newborn care
1572	2025	144	7	1	0	2025-03-22	2025-03-22	2	2025-03-04 16:26:05.408104	\N	Newborn care
1573	2025	154	11	1	0	2025-05-23	2025-05-23	2	2025-03-04 16:26:05.464814	\N	Travel
1574	2025	124	11	1	0	2025-03-20	2025-03-20	2	2025-03-04 16:26:05.518774	\N	Self-care day
1575	2025	158	11	1	0	2025-05-22	2025-05-22	2	2025-03-04 16:26:05.589483	\N	Home renovation
1576	2025	130	11	1	0	2025-06-09	2025-06-09	2	2025-03-04 16:26:05.648721	\N	Urgent personal matter
1577	2025	162	11	1	0	2025-07-02	2025-07-02	2	2025-03-04 16:26:05.695818	\N	Self-care day
1578	2025	183	4	1	1	2025-02-10	2025-02-10	4	2025-03-04 16:26:05.737701	\N	Stomachache
1579	2025	155	4	1	1	2025-01-26	2025-01-26	4	2025-03-04 16:26:05.785794	\N	Headache
1580	2025	153	4	1	1	2025-01-20	2025-01-20	4	2025-03-04 16:26:05.827026	\N	Heartache
1581	2025	9	4	1	1	2025-03-03	2025-03-03	4	2025-03-04 16:26:05.884884	\N	Toothache
1582	2025	173	4	1	1	2025-02-02	2025-02-02	4	2025-03-04 16:26:05.943164	\N	Migraine
1583	2025	139	4	1	1	2025-01-27	2025-01-27	4	2025-03-04 16:26:05.998541	\N	Toothache
1584	2025	157	4	1	1	2025-02-18	2025-02-18	4	2025-03-04 16:26:06.056843	\N	Food Poisoning
1585	2025	147	4	1	1	2025-01-19	2025-01-19	4	2025-03-04 16:26:06.10932	\N	Headache
1586	2025	179	4	1	1	2025-02-20	2025-02-20	4	2025-03-04 16:26:06.163873	\N	Flu
1587	2025	145	4	1	1	2025-02-15	2025-02-15	4	2025-03-04 16:26:06.224442	\N	Toothache
1588	2025	137	4	1	1	2025-02-28	2025-02-28	4	2025-03-04 16:26:06.270797	\N	Flu
1589	2025	175	4	1	1	2025-01-10	2025-01-10	4	2025-03-04 16:26:06.321403	\N	Heartache
1590	2025	135	4	1	1	2025-02-20	2025-02-20	4	2025-03-04 16:26:06.424599	\N	Migraine
1591	2025	143	4	1	1	2025-01-30	2025-01-30	4	2025-03-04 16:26:06.508091	\N	Stomachache
1592	2025	163	4	1	1	2025-01-28	2025-01-28	4	2025-03-04 16:26:06.553009	\N	Migraine
1593	2025	183	6	1	0	2025-03-22	2025-03-22	2	2025-03-04 16:26:06.605046	\N	Postpartum care
1594	2025	137	13	1	0	2025-05-20	2025-05-20	2	2025-03-04 16:26:06.658653	\N	Honeymoon
1595	2025	145	11	1	0	2025-05-01	2025-05-01	2	2025-03-04 16:26:06.73599	\N	Travel
1596	2025	143	11	1	0	2025-03-18	2025-03-18	2	2025-03-04 16:26:06.788064	\N	Home renovation
1597	2025	155	11	1	0	2025-05-19	2025-05-19	2	2025-03-04 16:26:06.840575	\N	Family event
\.


--
-- Data for Name: leaves; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.leaves (id, employee, leave_type, start_date, end_date, total_days, paid, status, approved_by, created_on, updated_on) FROM stdin;
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.units (id, name, echelon, office, managing_unit, head, created_on, updated_on) FROM stdin;
1	Sekretariat Utama	1	22	\N	\N	2025-03-02 00:40:45.036345	\N
3	Koordinator Manajemen Data dan Penilaian Kinerja Sumber Daya Manusia	5	22	2	\N	2025-03-03 04:30:34.054	\N
4	Subkoordinator Manajemen dan Analisis Data Sumber Daya Manusia	7	22	3	\N	2025-03-03 04:39:47.892217	\N
5	Subkoordinator Penilaian Kinerja Sumber Daya Manusia	7	22	3	\N	2025-03-03 04:39:47.892217	\N
2	Biro Sumber Daya Manusia	3	22	1	\N	2025-03-02 00:41:17.356458	\N
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
rFUsg3kcJfx7hrdRcPlM8gjRLWObKOMekME22boN	\N	111.7.96.150	curl/7.64.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYktENlNYcXVBT2FiWUs2WHpwM084WlAyZkRlR3JEamUwQ0NIaG5ZYSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740980801
9P2IrzTdVZUPUF0k91193zMaltx1rzUPcZicBq5W	\N	123.160.223.74	Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUkxrTnVCa2Z2Q3diZnRtV2dGWHNVS05RVzh0ZnFWaDdKMUpJdm5BSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740996211
uQNz5XpzZNDHYAeiuItKPg7U5mqLqlYy5wsySTyX	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNnFMTGZyU282M3JVMFdIMk5xYWtlODVQWU5ZY2FZaVF0bnp3M1Q4TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741011849
y6EVsJvk97KEwFjcdILIC1DbWxmTTQGQ2xodpwm1	\N	91.84.87.137	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoieEZaT2ZwNlpWRWNXM2w0cGt6MlhPSWZoRVZUdVBQb2R2RjFZaFNvMSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vaGlsbWkuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741030937
WtXumjgy3ljzObILgZIo4UNONnL4nolTSz9aRZTT	\N	167.94.145.102	Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiOEpqYjN0b3hEMHZ2MzR6SE1COGZnVHJCQjJHaHoxY1BQVVl5eTBpayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741038005
JSdryQ2Wzyn6YvfRjn3esprlXkszid0PP2NnU8th	\N	51.254.49.107	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVlGb053TldMWHRtcnJQVjBMazU3dkJxdVBLbGNtbXhmRkxPcTZzTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741062349
mfXEw6wfiRL7RDllPvdVZP6t40cqTEsi4LuG6SKD	\N	205.169.39.8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSnN0N1JyUjJNZExycXZDU1FIN2hzQ0ZFbk1xcE9YTTVPck5hZFY0TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741092173
WSe1bIFQKZrfXqINnw9C4I12YrLExgdpKmRXuo2P	\N	45.148.10.35	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNjNuTzd4TlRLQTdJaHdpTEtVWExJRkVVVFNRUVByeThNSWJKZmJydCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740982275
0c3f8WCGFGgU3DqLnBOUrwJe8HiPePOFvbAENwfJ	\N	150.109.230.210	Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoid3lIVThyMVptSTVhT085R3ZhOEM2SDVaNmFqcXp3TzBuVU9zV2FLaiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741001144
qRYP1WR3N4C78hSdGaJZAVCE55BJSNxCMLcaOvO1	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGxMcVpCY0dWUndaOEpKdFk1ejIwb242bmZGUWFabTR1cEM3SWpDWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741011849
Ytas0HxqoH2C3CmaSxR2XVkAFPbl8eMtcOvqVowV	\N	82.197.68.199	Wget/1.9.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNTVYV3kyVWhOdXd6dGF1cUtXRmZjRjRpckd0OFlxR3NxZFdWR2gxeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741031445
H2OEWMvdyyvuWJSszhpM1XwVVSRx30GT2OwRxk64	\N	23.27.145.104	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiR285WXVBaHpSTUVtcGRhMXM1cmFZY1FxZmpCWTZZc0VTMEx5R0RJQiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741039155
ZzKcRIEYULPu5Wx3w5ws4F2LtfiNJsomPwYVsaY1	\N	87.236.176.233	Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoieGwxUnZCQ1dCOE1UMjlISnJjMWhkZ2dhZGRpNjMzY1NLQlRiYk5PaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741067807
hPGAauuzvBKbkpNtgzysPniB2FFSOk3D30jhYXBA	\N	43.129.58.235	Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiM1lsT3I4T0twTFdhS2VocjhhbGt6Q0dWQ0JWMlRGNHdFUkd5d0V3VCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741095105
fKuxl5xOxndZxMgABxVGYNQwTrpAPuWtlXhwFwgN	\N	104.155.43.195	python-requests/2.32.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoibU8yZnJKcWIzSThoRTcwMkRQSm1ZbDUwUUlIY2x5WHUycVl6d0lRNyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740982991
w8FsDtHoeWJd2FPQ5SSPP5dByYBM6oQUQUpc5UcI	\N	71.6.232.28	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkJMWTVUTXJUYVZNeGlJaE4zVDA5WEZRYjdWMmlWMHRTZ2NJSHpneCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741004814
78n0dE9rpFzONuELjnTSd66VBus1X681BQbFrZ5X	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoic0JYNTBVM0NEWEdVUkRSanIwV3UzaUl2ODdOeVFaRkxleVFVUDRocyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741011850
f9zyIsTNFE4tVSEhqqv2ViYU3vfAFYq3f6pZ3RLW	\N	45.148.10.90	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiMlBNcEVsSlpqQlBWRlFRT3B5dUI1S0VJQzd3N0RlTVJtdTdDMGhFUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741031527
Wg5moLTbGvuuwZFcYVudCeaG0s8eAvCRys0Cl4Ce	\N	34.105.48.180	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiODJkWVJTT01RUmRnbVVWdG10cUVGZ2tqS2JPc3o0NDh0aW5QT09STCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741043550
MAKOr6eNsaBCJgl6vr8ZUhtwG3I7sVCmKQBKUL4P	\N	161.35.150.38	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUE9PVzAxZVVvRlMxYUFndWVCUnNKQXJWam5sZjdSUDdiRnNDakFFYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741072672
sDFvcegRQ2Ulsm8ulfmtr45WXULqWVkZK0gYxkGJ	\N	35.195.72.149	python-requests/2.32.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYnpON0FEUURnQXlFUHdWcVVVanI4NEZtV0VackI0bVNEVzVuWHNxVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741097155
7AI594s1wwzvghTuLELktLWGYCGKobsJvlhN4Pae	\N	101.36.108.175	curl/7.29.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVDZDVktJTHpJYXBvUGtlc0hVblJoMW9KaEw3Y0g4MklON1B3eGFQYSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740983151
lxUrW2r11RKu9sO4bPOuT6ap4tsPDveJoF2OM0Td	\N	45.148.10.35	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoibmFZNFA5OURvMlBUaEVMU3lzdW5oMUZ5TVRLQzlrSklQNkJuREVDTSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741006654
utK6MvkADrQHTHx7Tq8kpTCz6dl3qDZGFFHxsdZF	\N	162.142.125.206	Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHhoTFlQSzlSVUJyU0dKUG1XMTJ0NXJDR1dOVWVhZnR0YkN3elMybiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741016578
WeLeOfsXdZEq3Lvvyf6boQg9bCtGhRH5hq0QLUFX	\N	45.148.10.90	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZFhLQVIyUjhNZnZqVm1GMHJxVGs5MjAzVEhMdmtFQ3FMSHZpaEtLTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741032906
8uP1k6WkTsSnnP8ACFDcWOzr8r38Feqwh9LCF18B	\N	34.105.48.180	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3I5NjRVNXN4SEkwZW85ZDU4ZjZ3Zk9IZGF3bDZFM2xmWnpYQTkxNSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741043550
2HnjPPNXiMyu1FvM0vwGIRIqiBSwdnTYdUreXVGW	\N	44.193.78.48	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ0s1czU1dHU4ZkZ3T0Q0UzNySDZLMHprcEExd3dIdG5iejFEN2NFSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741073160
UwYHvcVVWbMcTLhu4yEd7heGgGlrBOmpkqVnayK1	\N	74.82.47.4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTXNRZVpXdDlrNVdGV3g4b1NxZGFzS2JDNkRrRGRvUHhYbnpDVjUzOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741099816
nmXJoVtjz4Xy5fbE8yZjrL2WkVRuthKXgUv5zEQz	\N	165.154.120.223	Mozilla/5.0 (Macintosh; Intel Mac OS X 8_2_1) AppleWebKit/568.48 (KHTML, like Gecko) Chrome/97.0.2759 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNnZZbmM2RVk1SUNrUnhnb0NLYnJPd3FVQ0dJb3JkZzZXNHR2VkFoRSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740983200
eiMX2RcptNWxxNtWcl1MLlpQkTc0UFFlFit5aSep	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRXZKMGxXZEhrRkJDcDNRdHdSeHVkamRXVUZXSmplWndXNzhHdGlFcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741006864
xUF7gXtmzSNxnu8REtTcGLBiAfOQqmCa2ZeO7K5S	\N	45.148.10.90	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYlh1UTlDc2JmSnlFRWhYTXJReEtFcWlBQUhGTko4TkRiblVITlpSeCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741021226
F57c0VtdTod8PhIltYUmpKRi4eqAj5YN8uAcMq26	\N	82.197.68.199	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.19 Safari/537.36 OPR/64.0.3409.0 (Edition developer)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYklkR2dPWjc3SXdJSUFrU1BEelluRVBEZXJ2bVVLTXNxMlZjT2lnSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741033463
lMGkNWxdrjpxia1hn9y79ea8Op0WnBeW2VdvSxw2	\N	34.105.48.180	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoia1lFZ3ZYZEoyZVRjdlVlSVFZM2hacURjOWxZdDdJVEZ4bFBkZ1lhYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741043550
LT6CUIyejbPgmg12WKK7CrDKrr78Wiajn8vUqKtv	\N	134.122.114.81	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3llNkZNRVNZTllRVTFNTDZiQ0RYVnRlRnVXM2VBTm1WWFJlUGNNUyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741073279
Jyzk9FnyigWoRTMbUqUfimCMKB0KOljkaRpHO64l	\N	74.82.47.4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoidlY4WVF0eGhhTVZPRUExeXlXbnk4dXdMaGNoVWIyUFNLdXZQb0g4ZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741100385
r7HbmsfSR9UfF1flmb8d0OymT2361iErSaVucfNi	\N	64.62.197.164	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoibzIyTVBLaEZ6N3BBbXBGTEVRQWVsVmdRMGRsS0xiUFRweTlvd1JjNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740960945
qOURc7DekUkDurBdLWf81rC3ZI2TX3qfYDwmuAYs	\N	45.8.17.12	Mozilla/5.0 (X11; Linux x86_64; rv:106.0) Gecko/20100101 Firefox/106.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNjAzM3Z5b0tZQjNpdTRwTHRPSm1NcENnSEZsWXpDOHA5S0xxdU1FMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740986031
xo2LSpYwgKoxVUboYSyThygdO0xZxiF74P8TbGRs	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ3MzSzBoaGZGWWtCOFZpUWlzRGlXTkI1a2FUZTZQV01BUnZwaVBucSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741006865
fhl8zCFh4ovtDaPlKK4x9L5c9DGb4DCKPohxg6Lz	\N	162.142.125.114		YTozOntzOjY6Il90b2tlbiI7czo0MDoiVWdaMFZtU0ljUUNXS0I3eklPVDg1d3AzWDV1UVgyYlZuMnROMnhhNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741021378
wH9dkHxPX65KCsmDC4LJeiEKgw2bJfpbYoRbUjbg	\N	82.197.68.199	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.145 Safari/537.36 Vivaldi/2.6.1566.49	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUXZYalNxSExkQ291R0p4dkZCeGw4ZjlnSjVVZGY1RXJqVHZ0WWZMQiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vaGlsbWkuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741033465
YdshYxs9uHzl4ZPoJjo93HmYUPicP0AwfSJAMWa5	\N	34.105.48.180	Go-http-client/1.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRFV1QzViTFY4ZlNjU2FON244NElEQlNieFVRbUh5ZnZ0bUZ5N21oRCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741043551
oVmgbzxCgrFchQzNJwDnoRCmNlkFrW3F20QuX4cg	\N	185.242.226.155	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN2RlUWphbHI4RDVHU041WlhESzJEUm8yTUpLaUJPNUNRRHpKMmlaMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741076914
XwVZFr24B8r3nyUggCdvidfa28i2aPaGykM9Xkz6	\N	146.190.155.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNG9lZGlPcXRBS0FNeElScGxvanNPMlNoZldQZFprUGhqQzdzWHUwWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741102356
0vWvVeDE3nq86lNLwHarE7k0hNeOJ0EGtw8N1XKX	\N	64.62.197.164	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSVV3TUtsMzZzeFVGSVdOa29ORW5lcThwR0FYV2o1YmFZM2xTcG1RSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740961512
NpoRwZElbnj7QmomNHjCPEu5JPJy2PJD7miMl8jo	\N	45.128.199.142	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ1k0bEdmZzlGenJMdjZ4UjRvZzZnaWZ6Q0FkdkYwUGxPanlid2NFTyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740986043
HMdQYU0zCfIS6kkTSpxtxHh6sMzEFbTOy2z2WWxw	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVNUUThqV2c0ckRSckQ1ZGFVc3VFeWNSRXVGMndWNlVxOTJXU1h4bSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741006865
PiqyU1TxvgXXq5MNQbwL2gYNoaoZz5Zt0b7Z7Jyt	\N	162.142.125.114	Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnFDbjVHZEpvS09SbTVSek5pdjZ2eGVUdEUxbnBOUU9rcTQ3ZmhSVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741021394
4OJCBJa82qzKA4J3KEfCNZT5pgb2V9EoRBEceoca	\N	82.197.68.199	Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36 OPR/62.0.3331.116	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZDJ6M01OS1l2dkNpUUdaVUwwRVlmc1BGRjlObUhUM25Td25ZaVZMVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vYWx3aS5haXZhLmNhdGhhbmFzdGFyaS5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741033721
p7RRKRAOEneNLbsifk6n3cxHPFoPfd3dogy4vl8X	\N	45.156.129.57	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmdDZUpGZk54UHJHcHJiejlFaUNPMVd1Sm16WW9XNzh3RnBRd0RuMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741045127
aXk9Ebq4yoccjvFq9GMUAY27jsWU61JxcCHJC8fW	\N	104.197.69.115	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/125.0.6422.60 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN1Y2cHJjRm9EVDhOdHJQY1NmUWh6bG9IalJUaTVKaVZ1SmwybExFUyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741078151
n8qL9XKi74q5R2AtQ2OYMfLflRnHRbLqFRSulL0R	\N	146.190.155.58	Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3BrVDVxUVhRejJ5bVFEUjZORmRrYzdYYnNaNU4zbGpsVjFlVFl0UCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741102360
6DVHdA4raR1ChLVX7qMBfwBmnih0ysiw79fLYDg0	\N	92.255.57.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSlBZd1lZS3pyTjZjUWk3QVcwOUJZR1dTSlVVaGFJcWtNa3RKMUFZcCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTI6Imh0dHBzOi8vMTAzLjI3LjIwNi40MC8/WERFQlVHX1NFU1NJT05fU1RBUlQ9cGhwc3Rvcm0iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1740964617
Kub77oOjYSn6gkjXLgio1UXseIqTISITPvGuvfml	\N	45.128.199.216	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2VFQmpIZ2VNdnBQMklncW9DbWhuVTUzb1JNaDNETHI4c3Q2YTIxUCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740986345
1vNrFnqcQeszuBIyXMOvR2NNFki3Dd5Vd4bW7I0E	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZEhjZDJEa3p5eFdmM1o2U1FBY3c1RmVaR0QzRWE2bUoweERNS3Y2bCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741006866
HLu9lJLBbNMGEbvlMIvab49fb1DrycZx7tum8mx5	\N	207.180.196.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRFcxV2FOUmdiVGFwYlduWk1WR2ZpbEFnSkdrdncyWDFuY1JmVFlnRSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741022437
MlAcGFKXk5fT96jeaUL546brPgn5uyXkTkuC2J24	\N	82.197.68.199	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3876.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFQxaldUWG9YaEhZSUlibk55dUpRS0VTaEd1ZFU4WXVNZzg2eDhDMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741033839
RnvpwdDuNlJi0vPnaJR5IM8dQ08lYLnMvgX3ocJm	\N	119.28.177.175	Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVWhGUlp1dEl2SW1QTU1EREg0SHhPZjZ3ZzZzV2J3OFg1Unl3MnljUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741045432
mJIWFXNtrzUAatp2HxVA6d1jAEgLiwwFIJQkLERW	\N	147.185.132.243	Expanse, a Palo Alto Networks company, searches across the global IPv4 space multiple times per day to identify customers&#39; presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloaltonetworks.com	YTozOntzOjY6Il90b2tlbiI7czo0MDoib3Y1UzBxd2xaNVlJQmdERlZiNUVzdTBsZ0wyc2JNWnp3eXYyOEpmSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741080653
t60QuWJBRcClRMXpdyDL4RgtKVbGqu8EhzG4sgWN	\N	207.180.196.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoicXNtMDBUV0pxUUFUYlhkZTBHaktBY1pHTzFTQURFOUl4UFU0NjQ4dyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741105319
UwRFUUEjz2NZLJ5r0dhny2hMoEl98MAWE8fKLR0E	\N	20.171.29.92	Mozilla/5.0 zgrab/0.x	YTozOntzOjY6Il90b2tlbiI7czo0MDoiY3FKbWU1MDk4MkgwaXFaUTlxVkVLeVc0ckJMZ0xXWnY2SkppVEV4cCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740967133
fzkoPXH9E90Z3YjB3ClYphhZjQFMiGtULsHZsv70	\N	45.128.199.212	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRHdiMGExRUtXWVduVFh0M1JIU3V6QmxkMmxsMnFLQ3E1Y0tVZkpyOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740986454
Wq0mcoLQSnXxYTmgDRybSugMVdcrwG6dPGPOzYAT	\N	209.38.67.123	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUJIRU9FSUJxMm1rdkoyVFVScG5KSkV6UmhBUndBSDV1VTlBOU5zViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741007443
LKjaH6loac74a7yIelZkC4VBIbrsNOfTt8IiObaI	\N	35.195.72.149	python-requests/2.32.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUtYbDBhM1Mwa0VrMHpoNkVSWlVxb1lXSjFCajdJQkVJWWM2M1ljMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741025273
XFVYoa3rNAsS7UATyGIJTwFxSPfzRDkjnrDoIZ8a	\N	185.242.226.155	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoidlREMHVBeXFnclBmSjZRV2V3elVyM3k1eTM0STdTMEk3YVFZeFdmMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741036227
CJakk9DicSBDowqbLhQ2e62ZqWDU7UWTNm3f6q7V	\N	45.79.181.104	Mozilla/5.0 (Macintosh; Intel Mac OS X 13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQkRCMDBSUUloRG11VktSbEhLSkh1UGUxRkhWVnU4TVVPQlZkS2tjbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741050230
j9iHRQyIwo1TxRH7LX7rdtjpDnyoFcC0LeHBgK9J	\N	162.142.125.114		YTozOntzOjY6Il90b2tlbiI7czo0MDoia0gzV2JodUtLUEJVZVVwUzJmMEprTldLZjl3NWZDWDAxbHp3NUJWQSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741085141
0PCxYJ0BWQZLF8FFu2V5MJ6jqpJufS4V4ETkuHIS	\N	3.20.225.199	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZWpuaUNRY2s2TlJkNUpqVjE3VExPSkY2VE91aUIyVktjd3FJYnRtbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741108714
FdyIj05ZRFzHuoof5okUXI6hjvf6ARzmZkpxhMXG	\N	106.75.50.4		YTozOntzOjY6Il90b2tlbiI7czo0MDoiNUFrbENsTVhreXFyZWtqNFJKMlhKbjE5Sjc3OHR1ZzFpMTBWU095UCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740968721
EvBC9QAMR8Tzi0YrH5v2UhUfhBShkpR2ZE19ZsBP	\N	207.180.196.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUF1N25VS1BYWVlSYkYwQlRhUzEyWmlNUWtBQmxEaUNHdkw5Y0ZhbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740989477
pvjkppi7Z2dxntPkhsOltOoT724YToKe8HrO5aSy	\N	45.148.10.90	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSE4xcGc2clgwTHU3a0RTTWxsVVlkdElTc2RjaE9sV2Zhc3NpeEFUUSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741007874
gQzvNgppBitHztZ4ro0aWSlhl34Wnqh4SpmKn5KH	\N	156.214.247.102	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSzBMQnVLMnNndmVaenNkdTkzYVdSdEZZdHdhZVBWQmVmQmlLVG9DaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741025283
kRgL3T66LfnrBscqKFPibrX0RHIJwTL9E75aL75K	\N	23.27.145.250	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoibHoyQm5HbURoR05tWE1LdWE0STRMWkYwTktWOG90U1J2R01OZjlOVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741037355
ugEkZgTfWnfABJNI0Fgx5KgJSe7R4qezKtbcCi7O	\N	91.196.152.62	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3Fac0RCUzdyM2xoaWNWb2ZIOEJCWG9MaHM2WTZ2R093RFpHSXNkaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741053937
9n4WeEk0m4N98AD9I64NO743WHNJ4xtDLbI5KvhC	\N	162.142.125.114	Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnl1d25WRkw4aGxnc1dWVzNONEM3ak90UkpGcGRGT3BqUTg5UFdpciI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzI6Imh0dHBzOi8vYmFrcGFzaXIuY2F0aGFuYXN0YXJpLmlkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1741085152
Ff98Jec6Fiev5v2EbVWDFj08XP3RJ1WPUfQiAIov	\N	103.140.34.114	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoicXA2NzdzMzVSUmNCa3ZucDNBaGdqUVlBZjhISzc5OFRuR3FkRUJyZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vaGlsbWkuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741114966
y0t2yNAi7mxQQrhVABmIrsByRZoUz4dA5Hlk5rFa	\N	35.81.83.224	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEY1aG9yVE5WUEJOa09Pc1pPU1VGOElLZUtPeHFWb0puZ1h3S2tLYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740969450
3Qy8M4oKkw15ThLxNUh159bgN0OeScMFlI78WbQk	\N	185.242.226.155	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiV20zRHM0emNwQThFaWtMZGpnRTRCZHBLR1ZJU21pOW5SaHR2amlWbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740993330
7fKr51u3INk0HbRtUjmnFvMnvkzbNkEvmE094iHR	\N	207.180.196.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaER3YkpRdjdJSzA2bUw4dkRhcU9yTWtYZWFmQ2JOQmREM1g4blFUcyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741010194
CIhrYwSOd1rDzru8je8AMqJJWSaNoMnDIlEgeW8p	\N	18.188.88.215	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiV2tYR0x6djdXRG05U2ppcXY5SVFLVTNIUVNCcGVxcWFlZ3B6b3dVbSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741025813
Z3WtEC0CMFzrpprqRMOV7AtzKT9WeB8zTR3bHm9v	\N	23.27.145.155	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTmFxRmZuSEFrcUlla1J5dHBjbEVxR0pYYXNUMnBEb2NvVUprY0dYcyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vYWx3aS5haXZhLmNhdGhhbmFzdGFyaS5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741037396
Qrxd7jK2fKfZXQidlw5qkzAAbnSgv7NklwNpJtxg	\N	92.255.57.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiY0xwZEVpZUUzTlNLT2wxNUFENWVITWxYTVF4Mlh0WkxNSkRpMVpyZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTI6Imh0dHBzOi8vMTAzLjI3LjIwNi40MC8/WERFQlVHX1NFU1NJT05fU1RBUlQ9cGhwc3Rvcm0iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741054608
AqDEkGNqwBwQXnqyeTzkvAKD2y9KPgTGNwAQqfj2	\N	139.59.58.216	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiT1hEcUhiYURJdkFPZlNVSFJpbFRlMkxqVEUxOGlGWW5zNTlzemZKbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741085842
QODzcOTwSKPnyPg5lIg5uNUSExXxmQKEwqsB9SxF	\N	103.140.34.114	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoic3J4VjRFSm5LRUlwbmN6ejNtb1h3RjRKSEpoSHFNeWdDMmN2cDNJMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741114954
xdbgnTMOF24tMuICgDsjp35UdvJpQ7NdZrwCbwmr	\N	195.178.110.163	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkpqSzNRWDhxZXdwT1Q3WTd1TEhzWFdTNVBCb2R0ckdEQ2xyU3lsSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740977162
vvr8vIXGijhzvkpbRUZ0PmVdQzVAJ6MDlf1W2Zxn	\N	159.223.203.145	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoibUdBZDVzdTNIY3l0SG5RTWdPQzRDZzY3eWt6S245N3pxZHZjSzFPaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740993942
mrPBRUG4bQsb8mqmfRZsd3upKA560gbnXw0737iz	\N	161.35.7.111	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUFMaXJRa0pSMWNGRjhsU0tkTFhsUEViNVpYR3dFZ3A3ZUtibTZyaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vYWx3aS5haXZhLmNhdGhhbmFzdGFyaS5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741010539
iUSSbKA76oJLHzYt5uci1xzq4GTSE5czkDk1okGc	\N	91.84.87.137	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUxQVHpPeWxDd0lxc1YybjROcmFYYjBUck01VHgxQld6YXZQVHB5WSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vYWx3aS5haXZhLmNhdGhhbmFzdGFyaS5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741030122
V1ewo74CIGBxm4Pb8guul2isEvqsmcpnJHA6Tsvq	\N	23.27.145.13	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ0puZW9zQzV6MHVnRzhNWWZBcGFvRGNSb0ltcnJCTGJOOU9ZTDVYWiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vaGlsbWkuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741037437
hYV7SP5kOaFeZIvnq3iZTstKOlvFLJ6KqqYSlAGG	\N	135.148.63.211	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaUsyZGZ6cUIzRmNhZUxsRWl3UzZVRVFQWmJ1aWhPTjVpTkpodXVucCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741055796
HMhsfvNXib7Cg8sfh7QlmzANcqTZxQ6m1GR2a9Qy	\N	20.65.195.44	Mozilla/5.0 zgrab/0.x	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEZXR1N1VGQ3VTJLb2tJMGxja3JobHJISHJ4TXNuRm1NT2JVdXZYSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741087408
Qppo2XHSWea4GgneonNIuxpYvPr3IuuUB1BkTmDp	\N	103.140.34.114	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoid0MwVlNITmxVUVhtYjM1MllRRDdKckNMT0REd2tVV2FLaUloN2R3biI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741114961
tqX1wsnSz5SBuOBWVrFnyC3Opoc2gcUwqD5hR8Zl	\N	54.241.232.202	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoianVJeTZiV3Axb2F2VHVMZkR5ckRZa3BGT2dPbTBuaVlxWjhxTnVFZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740978177
G6qGPmbReDzHi23j2CPz7wXsjdd9UkREnpt2IM2d	\N	159.223.203.145	Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 10.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZWI0TjF6OGZuWDIzdzV6aHRrYTNzYnRmYlJ0YnF3bmplVnlRbmxOayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740993946
sfuDKtvHjtZc6Z0LtI7MSY7vCJhX3wxMGJ7QTItz	\N	156.214.247.102	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSFMwVXVqSzhpVTZvM1h2Mlk4emNLMGx2eEV6THNvcHhvVjYxMzBadyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741010556
T05ANGM8EeQfZrPQ8tgnT2vVkK2nyQnAchR8Lk7Y	\N	91.84.87.137	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWE03TGJsUXY5RGhEWjdBM0Vob1VEUGNjWlZ0VzludVRyODc5WUtoNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vdG9mYW4uYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741030266
iW1jKV8jM9ifTn2q6V41hQmWafUbge4KVUZrd39b	\N	23.27.145.141	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoibTM1NVRVZ3hVN3c3YWlXS3JtMk1QRnRpNkx5cm41Q1psWWJ6dERoZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741037586
Evn3aK2z6C4Zi9SdbWPWSorayYQZvsjBC8aoj30x	\N	80.64.30.85	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.203	YTozOntzOjY6Il90b2tlbiI7czo0MDoicGNwT0xEWFJiV1RLMFR5akxSNVpINm5MdTFDWWFLY0pwMGY3WE00TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjc6Imh0dHBzOi8vMTAzLjI3LjIwNi40MC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741055839
4BfVOsxVmkR8ano0d9zoqYej7W8qViOMz9n1duNc	\N	66.240.236.109	Mozilla/5.0 zgrab/0.x	YTozOntzOjY6Il90b2tlbiI7czo0MDoieFYxY2pKTXN2MXRPajQwVlZsdXBETFA4ckd1N3k4ajJEUTVOVjg1QSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741089849
Qzk5KZOU4l3vdF2lvN2iW3QRRSenppbebTYbwNN4	\N	45.148.10.90	l9tcpid/v1.1.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoibFFGS2ZFQmZMb0o3TXJZNzZNOFRna3pLWTVEQkgxV2NhMXBpM0xvaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740978472
xU2iLQcNwk6Z8ZOg6CiVF4Mp7DeLAsd9S6GCoTiJ	\N	123.160.223.75	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN1BoTHAzV2FHRFZTYzdBcGYxcWUxMjNZQzI5SXNFUm94MVNHZ0U0aCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1740996208
Yzdyb7TzM3rVLpGTJaRNm8c33GGYIaz0AWsLdQ0G	\N	13.228.73.249	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTkE3NGdncjJJaWk3N24wZU9xZmY3WDUwOGQ4MksxZ0VMMVNRczRndSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741011848
S0XvAZxj4TxPthzkTatUEe3be5wkKveuczLOUGVQ	\N	91.84.87.137	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoia25xbFVST3pMMlZFZFA3QU1hUmZveWpaMEdFeDBaeEwzaXlGcHlCeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vcmlja3kuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741030272
uPRNoCJMeMQ7MZvzvb12lNAiasuzBpASsTSVYYMm	\N	167.94.145.102		YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmlmNFZKN1dFMnVqRFNyWnVibGFjM2FhanRiVjFHMkpURXZheHo3ZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741037999
aGGbsW0SGRHpwT9ESSo14o3pKk3l7lAV0DtnYIVJ	\N	51.254.49.106	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiY3l5a1VERFN2OWx6dEFtdXFiNmNpb0gxa0JENzJpQVUwRk1UVVkyUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHBzOi8vMTAzLjI3LjIwNi40MCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1741061823
9IZb93PR1HhL7Cx5JMwuUjNAqa3laeEJQcPv0fEg	\N	159.89.125.235	Mozilla/5.0 (compatible)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQXV4SHhvOHV2WlNtaWJnTTB2TjBDTFNFMUthTEF6SUlncUpkc0dPOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vaGlsbWkuYWl2YS5jYXRoYW5hc3RhcmkuaWQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1741091237
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, employee_id) FROM stdin;
1	user	bpkp-aiva@cathanastari.id	\N	$2y$12$UFAk5Vbx1FtHzf7Xh7/4b.hwOLQ3qJ3cc3XZOVaAMYPFdLgQqU9fa	\N	2025-02-27 04:35:00	2025-02-27 04:35:00	\N
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.cities (id, province, code, type, name) FROM stdin;
1	1	1101	1	Aceh Selatan
2	1	1102	1	Aceh Tenggara
3	1	1103	1	Aceh Timur
4	1	1104	1	Aceh Tengah
5	1	1105	1	Aceh Barat
6	1	1106	1	Aceh Besar
7	1	1107	1	Pidie
8	1	1108	1	Aceh Utara
9	1	1109	1	Simeulue
10	1	1110	1	Aceh Singkil
11	1	1111	1	Bireuen
12	1	1112	1	Aceh Barat Daya
13	1	1113	1	Gayo Lues
14	1	1114	1	Aceh Jaya
15	1	1115	1	Nagan Raya
16	1	1116	1	Aceh Tamiang
17	1	1117	1	Bener Meriah
18	1	1118	1	Pidie Jaya
19	1	1171	2	Kota Banda Aceh
20	1	1172	2	Kota Sabang
21	1	1173	2	Kota Lhokseumawe
22	1	1174	2	Kota Langsa
23	1	1175	2	Kota Subulussalam
24	2	1201	1	Tapanuli Tengah
25	2	1202	1	Tapanuli Utara
26	2	1203	1	Tapanuli Selatan
27	2	1204	1	Nias
28	2	1205	1	Langkat
29	2	1206	1	Karo
30	2	1207	1	Deli Serdang
31	2	1208	1	Simalungun
32	2	1209	1	Asahan
33	2	1210	1	Labuhanbatu
34	2	1211	1	Dairi
35	2	1212	1	Toba
36	2	1213	1	Mandailing Natal
37	2	1214	1	Nias Selatan
38	2	1215	1	Pakpak Bharat
39	2	1216	1	Humbang Hasundutan
40	2	1217	1	Samosir
41	2	1218	1	Serdang Bedagai
42	2	1219	1	Batu Bara
43	2	1220	1	Padang Lawas Utara
44	2	1221	1	Padang Lawas
45	2	1222	1	Labuhanbatu Selatan
46	2	1223	1	Labuhanbatu Utara
47	2	1224	1	Nias Utara
48	2	1225	1	Nias Barat
49	2	1271	2	Kota Medan
50	2	1272	2	Kota Pematangsiantar
51	2	1273	2	Kota Sibolga
52	2	1274	2	Kota Tanjung Balai
53	2	1275	2	Kota Binjai
54	2	1276	2	Kota Tebing Tinggi
55	2	1277	2	Kota Padangsidimpuan
56	2	1278	2	Kota Gunungsitoli
57	3	1301	1	Pesisir Selatan
58	3	1302	1	Solok
59	3	1303	1	Sijunjung
60	3	1304	1	Tanah Datar
61	3	1305	1	Padang Pariaman
62	3	1306	1	Agam
63	3	1307	1	Lima Puluh Kota
64	3	1308	1	Pasaman
65	3	1309	1	Kepulauan Mentawai
66	3	1310	1	Dharmasraya
67	3	1311	1	Solok Selatan
68	3	1312	1	Pasaman Barat
69	3	1371	2	Kota Padang
70	3	1372	2	Kota Solok
71	3	1373	2	Kota Sawahlunto
72	3	1374	2	Kota Padang Panjang
73	3	1375	2	Kota Bukittinggi
74	3	1376	2	Kota Payakumbuh
75	3	1377	2	Kota Pariaman
76	4	1401	1	Kampar
77	4	1402	1	Indragiri Hulu
78	4	1403	1	Bengkalis
79	4	1404	1	Indragiri Hilir
80	4	1405	1	Pelalawan
81	4	1406	1	Rokan Hulu
82	4	1407	1	Rokan Hilir
83	4	1408	1	Siak
84	4	1409	1	Kuantan Singingi
85	4	1410	1	Kepulauan Meranti
86	4	1471	2	Kota Pekanbaru
87	4	1472	2	Kota Dumai
88	5	1501	1	Kerinci
89	5	1502	1	Merangin
90	5	1503	1	Sarolangun
91	5	1504	1	Batanghari
92	5	1505	1	Muaro Jambi
93	5	1506	1	Tanjung Jabung Barat
94	5	1507	1	Tanjung Jabung Timur
95	5	1508	1	Bungo
96	5	1509	1	Tebo
97	5	1571	2	Kota Jambi
98	5	1572	2	Kota Sungai Penuh
99	6	1601	1	Ogan Komering Ulu
100	6	1602	1	Ogan Komering Ilir
101	6	1603	1	Muara Enim
102	6	1604	1	Lahat
103	6	1605	1	Musi Rawas
104	6	1606	1	Musi Banyuasin
105	6	1607	1	Banyuasin
106	6	1608	1	Ogan Komering Ulu Timur
107	6	1609	1	Ogan Komering Ulu Selatan
108	6	1610	1	Ogan Ilir
109	6	1611	1	Empat Lawang
110	6	1612	1	Penukal Abab Lematang Ilir
111	6	1613	1	Musi Rawas Utara
112	6	1671	2	Kota Palembang
113	6	1672	2	Kota Pagar Alam
114	6	1673	2	Kota Lubuk Linggau
115	6	1674	2	Kota Prabumulih
116	7	1701	1	Bengkulu Selatan
117	7	1702	1	Rejang Lebong
118	7	1703	1	Bengkulu Utara
119	7	1704	1	Kaur
120	7	1705	1	Seluma
121	7	1706	1	Muko Muko
122	7	1707	1	Lebong
123	7	1708	1	Kepahiang
124	7	1709	1	Bengkulu Tengah
125	7	1771	2	Kota Bengkulu
126	8	1801	1	Lampung Selatan
127	8	1802	1	Lampung Tengah
128	8	1803	1	Lampung Utara
129	8	1804	1	Lampung Barat
130	8	1805	1	Tulang Bawang
131	8	1806	1	Tanggamus
132	8	1807	1	Lampung Timur
133	8	1808	1	Way Kanan
134	8	1809	1	Pesawaran
135	8	1810	1	Pringsewu
136	8	1811	1	Mesuji
137	8	1812	1	Tulang Bawang Barat
138	8	1813	1	Pesisir Barat
139	8	1871	2	Kota Bandar Lampung
140	8	1872	2	Kota Metro
141	9	1901	1	Bangka
142	9	1902	1	Belitung
143	9	1903	1	Bangka Selatan
144	9	1904	1	Bangka Tengah
145	9	1905	1	Bangka Barat
146	9	1906	1	Belitung Timur
147	9	1971	2	Kota Pangkal Pinang
148	10	2101	1	Bintan
149	10	2102	1	Karimun
150	10	2103	1	Natuna
151	10	2104	1	Lingga
152	10	2105	1	Kepulauan Anambas
153	10	2171	2	Kota Batam
154	10	2172	2	Kota Tanjung Pinang
155	11	3101	1	Kepulauan Seribu
156	11	3171	2	Kota Jakarta Pusat
157	11	3172	2	Jakarta Utara
158	11	3173	2	Kota Jakarta Barat
159	11	3174	2	Kota Jakarta Selatan
160	11	3175	2	Kota Jakarta Timur
161	12	3201	1	Bogor
162	12	3202	1	Sukabumi
163	12	3203	1	Cianjur
164	12	3204	1	Bandung
165	12	3205	1	Garut
166	12	3206	1	Tasikmalaya
167	12	3207	1	Ciamis
168	12	3208	1	Kuningan
169	12	3209	1	Cirebon
170	12	3210	1	Majalengka
171	12	3211	1	Sumedang
172	12	3212	1	Indramayu
173	12	3213	1	Subang
174	12	3214	1	Purwakarta
175	12	3215	1	Karawang
176	12	3216	1	Bekasi
177	12	3217	1	Bandung Barat
178	12	3218	1	Pangandaran
179	12	3271	2	Kota Bogor
180	12	3272	2	Kota Sukabumi
181	12	3273	2	Kota Bandung
182	12	3274	2	Kota Cirebon
183	12	3275	2	Kota Bekasi
184	12	3276	2	Kota Depok
185	12	3277	2	Kota Cimahi
186	12	3278	2	Kota Tasikmalaya
187	12	3279	2	Kota Banjar
188	13	3301	1	Cilacap
189	13	3302	1	Banyumas
190	13	3303	1	Purbalingga
191	13	3304	1	Banjarnegara
192	13	3305	1	Kebumen
193	13	3306	1	Purworejo
194	13	3307	1	Wonosobo
195	13	3308	1	Magelang
196	13	3309	1	Boyolali
197	13	3310	1	Klaten
198	13	3311	1	Sukoharjo
199	13	3312	1	Wonogiri
200	13	3313	1	Karanganyar
201	13	3314	1	Sragen
202	13	3315	1	Grobogan
203	13	3316	1	Blora
204	13	3317	1	Rembang
205	13	3318	1	Pati
206	13	3319	1	Kudus
207	13	3320	1	Jepara
208	13	3321	1	Demak
209	13	3322	1	Semarang
210	13	3323	1	Temanggung
211	13	3324	1	Kendal
212	13	3325	1	Batang
213	13	3326	1	Pekalongan
214	13	3327	1	Pemalang
215	13	3328	1	Tegal
216	13	3329	1	Brebes
217	13	3371	2	Kota Magelang
218	13	3372	2	Kota Surakarta
219	13	3373	2	Kota Salatiga
220	13	3374	2	Kota Semarang
221	13	3375	2	Kota Pekalongan
222	13	3376	2	Kota Tegal
223	14	3401	1	Kulon Progo
224	14	3402	1	Bantul
225	14	3403	1	Gunungkidul
226	14	3404	1	Sleman
227	14	3471	2	Kota Yogyakarta
228	15	3501	1	Pacitan
229	15	3502	1	Ponorogo
230	15	3503	1	Trenggalek
231	15	3504	1	Tulungagung
232	15	3505	1	Blitar
233	15	3506	1	Kediri
234	15	3507	1	Malang
235	15	3508	1	Lumajang
236	15	3509	1	Jember
237	15	3510	1	Banyuwangi
238	15	3511	1	Bondowoso
239	15	3512	1	Situbondo
240	15	3513	1	Probolinggo
241	15	3514	1	Pasuruan
242	15	3515	1	Sidoarjo
243	15	3516	1	Mojokerto
244	15	3517	1	Jombang
245	15	3518	1	Nganjuk
246	15	3519	1	Madiun
247	15	3520	1	Magetan
248	15	3521	1	Ngawi
249	15	3522	1	Bojonegoro
250	15	3523	1	Tuban
251	15	3524	1	Lamongan
252	15	3525	1	Gresik
253	15	3526	1	Bangkalan
254	15	3527	1	Sampang
255	15	3528	1	Pamekasan
256	15	3529	1	Sumenep
257	15	3571	2	Kota Kediri
258	15	3572	2	Kota Blitar
259	15	3573	2	Kota Malang
260	15	3574	2	Kota Probolinggo
261	15	3575	2	Kota Pasuruan
262	15	3576	2	Kota Mojokerto
263	15	3577	2	Kota Madiun
264	15	3578	2	Kota Surabaya
265	15	3579	2	Kota Batu
266	16	3601	1	Pandeglang
267	16	3602	1	Lebak
268	16	3603	1	Tangerang
269	16	3604	1	Serang
270	16	3671	2	Kota Tangerang
271	16	3672	2	Kota Cilegon
272	16	3673	2	Kota Serang
273	16	3674	2	Kota Tangerang Selatan
274	17	5101	1	Jembrana
275	17	5102	1	Tabanan
276	17	5103	1	Badung
277	17	5104	1	Gianyar
278	17	5105	1	Klungkung
279	17	5106	1	Bangli
280	17	5107	1	Karangasem
281	17	5108	1	Buleleng
282	17	5171	2	Kota Denpasar
283	18	5201	1	Lombok Barat
284	18	5202	1	Lombok Tengah
285	18	5203	1	Lombok Timur
286	18	5204	1	Sumbawa
287	18	5205	1	Dompu
288	18	5206	1	Bima
289	18	5207	1	Sumbawa Barat
290	18	5208	1	Lombok Utara
291	18	5271	2	Kota Mataram
292	18	5272	2	Kota Bima
293	19	5301	1	Kupang
294	19	5302	1	Timor Tengah Selatan
295	19	5303	1	Timor Tengah Utara
296	19	5304	1	Belu
297	19	5305	1	Alor
298	19	5306	1	Flores Timur
299	19	5307	1	Sikka
300	19	5308	1	Ende
301	19	5309	1	Ngada
302	19	5310	1	Manggarai
303	19	5311	1	Sumba Timur
304	19	5312	1	Sumba Barat
305	19	5313	1	Lembata
306	19	5314	1	Rote Ndao
307	19	5315	1	Manggarai Barat
308	19	5316	1	Nagekeo
309	19	5317	1	Sumba Tengah
310	19	5318	1	Sumba Barat Daya
311	19	5319	1	Manggarai Timur
312	19	5320	1	Sabu Raijua
313	19	5321	1	Malaka
314	19	5371	2	Kota Kupang
315	20	6101	1	Sambas
316	20	6102	1	Mempawah
317	20	6103	1	Sanggau
318	20	6104	1	Ketapang
319	20	6105	1	Sintang
320	20	6106	1	Kapuas Hulu
321	20	6107	1	Bengkayang
322	20	6108	1	Landak
323	20	6109	1	Sekadau
324	20	6110	1	Melawi
325	20	6111	1	Kayong Utara
326	20	6112	1	Kubu Raya
327	20	6171	2	Kota Pontianak
328	20	6172	2	Kota Singkawang
329	21	6201	1	Kotawaringin Barat
330	21	6202	1	Kotawaringin Timur
331	21	6203	1	Kapuas
332	21	6204	1	Barito Selatan
333	21	6205	1	Barito Utara
334	21	6206	1	Katingan
335	21	6207	1	Seruyan
336	21	6208	1	Sukamara
337	21	6209	1	Lamandau
338	21	6210	1	Gunung Mas
339	21	6211	1	Pulang Pisau
340	21	6212	1	Murung Raya
341	21	6213	1	Barito Timur
342	21	6271	2	Kota Palangkaraya
343	22	6301	1	Tanah Laut
344	22	6302	1	Kotabaru
345	22	6303	1	Banjar
346	22	6304	1	Barito Kuala
347	22	6305	1	Tapin
348	22	6306	1	Hulu Sungai Selatan
349	22	6307	1	Hulu Sungai Tengah
350	22	6308	1	Hulu Sungai Utara
351	22	6309	1	Tabalong
352	22	6310	1	Tanah Bumbu
353	22	6311	1	Balangan
354	22	6371	2	Kota Banjarmasin
355	22	6372	2	Kota Banjarbaru
356	23	6401	1	Paser
357	23	6402	1	Kutai Kartanegara
358	23	6403	1	Berau
359	23	6407	1	Kutai Barat
360	23	6408	1	Kutai Timur
361	23	6409	1	Penajam Paser Utara
362	23	6411	1	Mahakam Ulu
363	23	6471	2	Kota Balikpapan
364	23	6472	2	Kota Samarinda
365	23	6474	2	Kota Bontang
366	24	6501	1	Bulungan
367	24	6502	1	Malinau
368	24	6503	1	Nunukan
369	24	6504	1	Tana Tidung
370	24	6571	2	Kota Tarakan
371	25	7101	1	Bolaang Mongondow
372	25	7102	1	Minahasa
373	25	7103	1	Kepulauan Sangihe
374	25	7104	1	Kepulauan Talaud
375	25	7105	1	Minahasa Selatan
376	25	7106	1	Minahasa Utara
377	25	7107	1	Minahasa Tenggara
378	25	7108	1	Bolaang Mongondow Utara
379	25	7109	1	Kepulauan Siau Tagulandang Biaro (Sitaro)
380	25	7110	1	Bolaang Mongondow Timur
381	25	7111	1	Bolaang Mongondow Selatan
382	25	7171	2	Kota Manado
383	25	7172	2	Kota Bitung
384	25	7173	2	Kota Tomohon
385	25	7174	2	Kota Kotamobagu
386	26	7201	1	Banggai
387	26	7202	1	Poso
388	26	7203	1	Donggala
389	26	7204	1	Toli Toli
390	26	7205	1	Buol
391	26	7206	1	Morowali
392	26	7207	1	Banggai Kepulauan
393	26	7208	1	Parigi Moutong
394	26	7209	1	Tojo Una Una
395	26	7210	1	Sigi
396	26	7211	1	Banggai Laut
397	26	7212	1	Morowali Utara
398	26	7271	2	Kota Palu
399	27	7301	1	Kepulauan Selayar
400	27	7302	1	Bulukumba
401	27	7303	1	Bantaeng
402	27	7304	1	Jeneponto
403	27	7305	1	Takalar
404	27	7306	1	Gowa
405	27	7307	1	Sinjai
406	27	7308	1	Bone
407	27	7309	1	Maros
408	27	7310	1	Pangkajene Kepulauan
409	27	7311	1	Barru
410	27	7312	1	Soppeng
411	27	7313	1	Wajo
412	27	7314	1	Sidenreng Rappang
413	27	7315	1	Pinrang
414	27	7316	1	Enrekang
415	27	7317	1	Luwu
416	27	7318	1	Tana Toraja
417	27	7322	1	Luwu Utara
418	27	7324	1	Luwu Timur
419	27	7326	1	Toraja Utara
420	27	7371	2	Kota Makassar
421	27	7372	2	Kota Pare Pare
422	27	7373	2	Kota Palopo
423	28	7401	1	Kolaka
424	28	7402	1	Konawe
425	28	7403	1	Muna
426	28	7404	1	Buton
427	28	7405	1	Konawe Selatan
428	28	7406	1	Bombana
429	28	7407	1	Wakatobi
430	28	7408	1	Kolaka Utara
431	28	7409	1	Konawe Utara
432	28	7410	1	Buton Utara
433	28	7411	1	Kolaka Timur
434	28	7412	1	Konawe Kepulauan
435	28	7413	1	Muna Barat
436	28	7414	1	Buton Tengah
437	28	7415	1	Buton Selatan
438	28	7471	2	Kota Kendari
439	28	7472	2	Kota Bau Bau
440	29	7501	1	Gorontalo
441	29	7502	1	Boalemo
442	29	7503	1	Bone Bolango
443	29	7504	1	Pahuwato
444	29	7505	1	Gorontalo Utara
445	29	7571	2	Kota Gorontalo
446	30	7601	1	Pasangkayu (Mamuju Utara)
447	30	7602	1	Mamuju
448	30	7603	1	Mamasa
449	30	7604	1	Polewali Mandar
450	30	7605	1	Majene
451	30	7606	1	Mamuju Tengah
452	31	8101	1	Maluku Tengah
453	31	8102	1	Maluku Tenggara
454	31	8103	1	Kepulauan Tanimbar (Maluku Tenggara Barat)
455	31	8104	1	Buru
456	31	8105	1	Seram Bagian Timur
457	31	8106	1	Seram Bagian Barat
458	31	8107	1	Kepulauan Aru
459	31	8108	1	Maluku Barat Daya
460	31	8109	1	Buru Selatan
461	31	8171	2	Kota Ambon
462	31	8172	2	Kota Tual
463	32	8201	1	Halmahera Barat
464	32	8202	1	Halmahera Tengah
465	32	8203	1	Halmahera Utara
466	32	8204	1	Halmahera Selatan
467	32	8205	1	Kepulauan Sula
468	32	8206	1	Halmahera Timur
469	32	8207	1	Pulau Morotai
470	32	8208	1	Pulau Taliabu
471	32	8271	2	Kota Ternate
472	32	8272	2	Kota Tidore Kepulauan
473	33	9103	1	Jayapura
474	33	9105	1	Kepulauan Yapen
475	33	9106	1	Biak Numfor
476	33	9110	1	Sarmi
477	33	9111	1	Keerom
478	33	9115	1	Waropen
479	33	9119	1	Supiori
480	33	9120	1	Mamberamo Raya
481	33	9171	2	Kota Jayapura
482	34	9202	1	Manokwari
483	34	9203	1	Fak Fak
484	34	9206	1	Teluk Bintuni
485	34	9207	1	Teluk Wondama
486	34	9208	1	Kaimana
487	34	9211	1	Manokwari Selatan
488	34	9212	1	Pegunungan Arfak
489	35	9301	1	Merauke
490	35	9302	1	Boven Digoel
491	35	9303	1	Mappi
492	35	9304	1	Asmat
493	36	9401	1	Nabire
494	36	9402	1	Puncak Jaya
495	36	9403	1	Paniai
496	36	9404	1	Mimika
497	36	9405	1	Puncak
498	36	9406	1	Dogiyai
499	36	9407	1	Intan Jaya
500	36	9408	1	Deiyai
501	37	9501	1	Jayawijaya
502	37	9502	1	Pegunungan Bintang
503	37	9503	1	Yahukimo
504	37	9504	1	Tolikara
505	37	9505	1	Mamberamo Tengah
506	37	9506	1	Yalimo
507	37	9507	1	Lanny Jaya
508	37	9508	1	Nduga
509	38	9601	1	Sorong
510	38	9604	1	Sorong Selatan
511	38	9605	1	Raja Ampat
512	38	9609	1	Tambrauw
513	38	9610	1	Maybrat
514	38	9671	2	Kota Sorong
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: ref; Owner: bpkp_aiva
--

COPY ref.countries (id, name, region, created_on, updated_on, code) FROM stdin;
11	France	1	2025-03-01 03:05:04.037705	\N	FR
2	Australia	3	2025-03-01 03:05:04.037705	\N	AU
16	Japan	3	2025-03-01 03:05:04.037705	\N	JP
18	Mexico	2	2025-03-01 03:05:04.037705	\N	MX
17	Kuwait	4	2025-03-01 03:05:04.037705	\N	KW
5	Canada	2	2025-03-01 03:05:04.037705	\N	CA
22	United Kingdom	1	2025-03-01 03:05:04.037705	\N	UK
19	Nigeria	4	2025-03-01 03:05:04.037705	\N	NG
12	HongKong	3	2025-03-01 03:05:04.037705	\N	HK
7	China	3	2025-03-01 03:05:04.037705	\N	CN
4	Brazil	2	2025-03-01 03:05:04.037705	\N	BR
21	Singapore	3	2025-03-01 03:05:04.037705	\N	SG
9	Denmark	1	2025-03-01 03:05:04.037705	\N	DK
13	Israel	4	2025-03-01 03:05:04.037705	\N	IL
20	Netherlands	1	2025-03-01 03:05:04.037705	\N	NL
24	Zambia	4	2025-03-01 03:05:04.037705	\N	ZM
3	Belgium	1	2025-03-01 03:05:04.037705	\N	BE
6	Switzerland	1	2025-03-01 03:05:04.037705	\N	CH
23	United States of America	2	2025-03-01 03:05:04.037705	\N	US
10	Egypt	4	2025-03-01 03:05:04.037705	\N	EG
14	India	3	2025-03-01 03:05:04.037705	\N	IN
25	Zimbabwe	4	2025-03-01 03:05:04.037705	\N	ZW
1	Argentina	2	2025-03-01 03:05:04.037705	\N	AR
8	Germany	1	2025-03-01 03:05:04.037705	\N	DE
15	Italy	1	2025-03-01 03:05:04.037705	\N	IT
26	Indonesia	3	2025-03-01 16:58:13.31027	\N	ID
\.


--
-- Data for Name: echelons; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.echelons (id, name, min_rank, max_rank, min_salary, max_salary, created_on, updated_on, code) FROM stdin;
9	V	9	10	\N	\N	2025-03-02 00:39:56.054634	\N	5
7	IVa	11	12	\N	\N	2025-03-02 00:39:56.054634	\N	4a
5	IIIa	13	14	\N	\N	2025-03-02 00:39:56.054634	\N	3a
4	IIb	14	15	\N	\N	2025-03-02 00:39:56.054634	\N	2b
2	Ib	16	17	\N	\N	2025-03-02 00:39:56.054634	\N	1b
3	IIa	15	16	\N	\N	2025-03-02 00:39:56.054634	\N	2a
8	IVb	10	11	\N	\N	2025-03-02 00:39:56.054634	\N	4b
6	IIIb	12	13	\N	\N	2025-03-02 00:39:56.054634	\N	3b
1	Ia	17	17	\N	\N	2025-03-02 00:39:56.054634	\N	1a
\.


--
-- Data for Name: kpi_categories; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.kpi_categories (id, name, description, unit, created_on, updated_on) FROM stdin;
1	Audit Plan Completion Rate	\N	unit	2025-03-02 00:30:57.115607	\N
2	Training Hours	Hours spent on skill enhancement	hour	2025-03-02 00:32:01.775699	\N
\.


--
-- Data for Name: leave_types; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.leave_types (id, name, max_days, cycle) FROM stdin;
1	Annual Leave	12	annually
2	Public Holiday Leave	0	conditionally
3	Mass Leave	0	conditionally
4	Sick Leave	10	annually
5	Medical Leave	15	annually
6	Maternity Leave	90	conditionally
7	Paternity Leave	10	annually
8	Menstrual Leave	2	monthly
9	Emergency Leave	5	annually
10	Compassionate Leave	3	annually
11	Personal Leave	5	annually
12	Family Care Leave	7	annually
13	Marriage Leave	3	annually
14	Unpaid Leave	0	conditionally
15	Study Leave	30	annually
16	Sabbatical Leave	180	conditionally
17	Career Break Leave	0	conditionally
18	Military Leave	0	conditionally
19	Election Leave	1	annually
20	Jury Duty Leave	0	conditionally
21	Religious Leave	10	annually
\.


--
-- Data for Name: offices; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.offices (id, name, address, postal_code, city, province, country) FROM stdin;
22	BPKP Pusat (Central Office)	Jl. Pramuka No. 33, Jakarta Timur	13120	160	11	26
23	BPKP Provinsi Aceh	Jl. Teungku Panglima Nyak Makam, Banda Aceh	23118	19	1	26
24	BPKP Provinsi Sumatera Utara	Jl. Jenderal Gatot Subroto Km. 5.5, Medan	20118	49	2	26
25	BPKP Provinsi Sumatera Barat	Jl. Bypass KM. 14, Aie Pacah, Kota Padang	25586	69	3	26
26	BPKP Provinsi Riau	Jl. Jenderal Sudirman No. 10, Pekanbaru	28125	86	4	26
27	BPKP Provinsi Jambi	Jl. HOS Cokroaminoto No. 107, Jambi	36134	97	5	26
28	BPKP Provinsi Sumatera Selatan	Jl. Bank Raya No. 2, Demang Lebar Daun, Palembang	30129	112	6	26
29	BPKP Provinsi Bengkulu	Jl. Pembangunan No. 14, Kotak Pos 98, Bengkulu	38244	125	7	26
30	BPKP Provinsi Lampung	Jl. Basuki Rahmat No. 33, Bandar Lampung	35112	139	8	26
32	BPKP Provinsi Kepulauan Riau	Jl. R.E. Martadinata, Sekupang, Kepulauan Riau	29425	153	10	26
33	BPKP Provinsi DKI Jakarta	Jl. Raya Pramuka No. 33, Jakarta Timur	13120	160	11	26
34	BPKP Provinsi Jawa Barat	Jl. Jenderal H. Amir Machmud No. 50, Bandung	40184	181	12	26
35	BPKP Provinsi Jawa Tengah	Jl. Raya Semarang-Kendal Km. 12, Semarang	50186	220	13	26
36	BPKP Provinsi DI Yogyakarta	Jl. Parangtritis Km. 5.5, Sewon, Yogyakarta	55187	227	14	26
37	BPKP Provinsi Jawa Timur	Jl. Raya Bandara Juanda, Surabaya	61253	264	15	26
38	BPKP Provinsi Banten	Jl. Hayam Wuruk No. 7, Jakarta Pusat	10120	156	11	26
39	BPKP Provinsi Bali	Jl. Kapten Tantular, Renon, Denpasar	80234	282	17	26
40	BPKP Provinsi Nusa Tenggara Barat	Jl. Majapahit No. 23A, Mataram	83122	291	18	26
41	BPKP Provinsi Nusa Tenggara Timur	Jl. Palapa No. 21A, Kotak Pos 54, Kupang	85111	314	19	26
42	BPKP Provinsi Kalimantan Barat	Jl. Jenderal Ahmad Yani, Pontianak	78124	327	20	26
44	BPKP Provinsi Kalimantan Selatan	Jl. Gatot Subroto No. 22, Banjarmasin	70236	354	22	26
45	BPKP Provinsi Kalimantan Timur	Jl. MT. Haryono, PO. Box 1142, Samarinda	75124	364	23	26
31	BPKP Provinsi Kepulauan Bangka Belitung	Jl. Pulau Bangka, Pangkalpinang	33149	147	9	26
43	BPKP Provinsi Kalimantan Tengah	Jl. Adonis Samad, Palangkaraya	73111	342	21	26
\.


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.provinces (id, country, code, name) FROM stdin;
1	26	11	Aceh (NAD)
2	26	12	Sumatera Utara
3	26	13	Sumatera Barat
4	26	14	Riau
5	26	15	Jambi
6	26	16	Sumatera Selatan
7	26	17	Bengkulu
8	26	18	Lampung
9	26	19	Kepulauan Bangka Belitung
10	26	21	Kepulauan Riau
11	26	31	DKI Jakarta
12	26	32	Jawa Barat
13	26	33	Jawa Tengah
14	26	34	DI Yogyakarta
15	26	35	Jawa Timur
16	26	36	Banten
17	26	51	Bali
18	26	52	Nusa Tenggara Barat (NTB)
19	26	53	Nusa Tenggara Timur (NTT)
20	26	61	Kalimantan Barat
21	26	62	Kalimantan Tengah
22	26	63	Kalimantan Selatan
23	26	64	Kalimantan Timur
24	26	65	Kalimantan Utara
25	26	71	Sulawesi Utara
26	26	72	Sulawesi Tengah
27	26	73	Sulawesi Selatan
28	26	74	Sulawesi Tenggara
29	26	75	Gorontalo
30	26	76	Sulawesi Barat
31	26	81	Maluku
32	26	82	Maluku Utara
33	26	91	Papua
34	26	92	Papua Barat
35	26	93	Papua Selatan
36	26	94	Papua Tengah
37	26	95	Papua Pegunungan
38	26	96	Papua Barat Daya
\.


--
-- Data for Name: ranks; Type: TABLE DATA; Schema: ref; Owner: bpkp_aiva
--

COPY ref.ranks (id, code, name, min_salary, max_salary) FROM stdin;
3	1c	Ic - Juru	\N	\N
1	1a	Ia - Juru Muda	\N	\N
7	2c	IIc - Pengatur	\N	\N
16	4d	IVd - Pembina Utama Madya	\N	\N
14	4b	IVb - Pembina Tingkat I	\N	\N
10	3b	IIIb - Penata Muda Tingkat I	\N	\N
2	1b	Ib - Juru Muda Tingkat I	\N	\N
17	4e	IVe - Pembina Utama	\N	\N
15	4c	IVc - Pembina Utama Muda	\N	\N
5	2a	IIa - Pengatur Muda	\N	\N
4	1d	Id - Juru Tingkat I	\N	\N
6	2b	IIb - Pengatur Muda Tingkat I	\N	\N
9	3a	IIIa - Penata Muda	\N	\N
8	2d	IId - Pengatur Tingkat I	\N	\N
13	4a	IVa - Pembina	\N	\N
12	3d	IIId - Penata Tingkat I	\N	\N
11	3c	IIIc - Penata	\N	\N
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: ref; Owner: bpkp_aiva
--

COPY ref.regions (region_id, region_name) FROM stdin;
1	Europe
2	Americas
3	Asia
4	Middle East and Africa
\.


--
-- Data for Name: regulation_categories; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.regulation_categories (id, name, created_on, updated_on, is_active) FROM stdin;
1	General	2025-03-02 14:00:29.268692	\N	1
2	HR	2025-03-02 14:00:29.268692	\N	1
\.


--
-- Data for Name: regulations; Type: TABLE DATA; Schema: ref; Owner: postgres
--

COPY ref.regulations (id, category, name, description, created_on, updated_on, status, file_path) FROM stdin;
\.


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.attendance_id_seq', 2925, true);


--
-- Name: dependents_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.dependents_id_seq', 1, false);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.employees_id_seq', 183, true);


--
-- Name: jobs_job_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.jobs_job_seq', 11, true);


--
-- Name: kpi_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.kpi_id_seq', 1, false);


--
-- Name: leave_entitlements_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.leave_entitlements_id_seq', 1597, true);


--
-- Name: leaves_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.leaves_id_seq', 1, false);


--
-- Name: leaves_total_days_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.leaves_total_days_seq', 1, false);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.units_id_seq', 5, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: echelons_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.echelons_id_seq', 9, true);


--
-- Name: kpi_categories_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.kpi_categories_id_seq', 2, true);


--
-- Name: leave_types_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.leave_types_id_seq', 21, true);


--
-- Name: offices_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.offices_id_seq', 46, true);


--
-- Name: provinces_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.provinces_id_seq', 1, false);


--
-- Name: rank_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: bpkp_aiva
--

SELECT pg_catalog.setval('ref.rank_id_seq', 17, true);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: bpkp_aiva
--

SELECT pg_catalog.setval('ref.regions_region_id_seq', 1, false);


--
-- Name: regulation_categories_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.regulation_categories_id_seq', 2, true);


--
-- Name: regulations_id_seq; Type: SEQUENCE SET; Schema: ref; Owner: postgres
--

SELECT pg_catalog.setval('ref.regulations_id_seq', 1, false);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: dependents dependents_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.dependents
    ADD CONSTRAINT dependents_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: kpi kpi_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.kpi
    ADD CONSTRAINT kpi_pkey PRIMARY KEY (id);


--
-- Name: leave_entitlements leave_entitlements_pk; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leave_entitlements
    ADD CONSTRAINT leave_entitlements_pk PRIMARY KEY (id);


--
-- Name: leaves leaves_pk; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves
    ADD CONSTRAINT leaves_pk PRIMARY KEY (id);


--
-- Name: units units_pk; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.units
    ADD CONSTRAINT units_pk PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cities cities_code_key; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.cities
    ADD CONSTRAINT cities_code_key UNIQUE (code);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.countries
    ADD CONSTRAINT countries_pk UNIQUE (code);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: echelons echelons_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.echelons
    ADD CONSTRAINT echelons_pkey PRIMARY KEY (id);


--
-- Name: kpi_categories kpi_categories_name_key; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.kpi_categories
    ADD CONSTRAINT kpi_categories_name_key UNIQUE (name);


--
-- Name: kpi_categories kpi_categories_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.kpi_categories
    ADD CONSTRAINT kpi_categories_pkey PRIMARY KEY (id);


--
-- Name: leave_types leave_types_pk; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.leave_types
    ADD CONSTRAINT leave_types_pk PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_code_key; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.provinces
    ADD CONSTRAINT provinces_code_key UNIQUE (code);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: ranks ranks_pk; Type: CONSTRAINT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.ranks
    ADD CONSTRAINT ranks_pk PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: regulation_categories regulation_categories_pk; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.regulation_categories
    ADD CONSTRAINT regulation_categories_pk PRIMARY KEY (id);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: attendance attendance_employee_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.attendance
    ADD CONSTRAINT attendance_employee_fkey FOREIGN KEY (employee) REFERENCES hr.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance attendance_leave_types_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.attendance
    ADD CONSTRAINT attendance_leave_types_id_fk FOREIGN KEY (leave_type) REFERENCES ref.leave_types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dependents dependents_employees_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.dependents
    ADD CONSTRAINT dependents_employees_id_fk FOREIGN KEY (employee) REFERENCES hr.employees(id);


--
-- Name: employees employees_job_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_job_fkey FOREIGN KEY (job) REFERENCES hr.jobs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_manager_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_manager_fkey FOREIGN KEY (manager) REFERENCES hr.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_rank_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_rank_fkey FOREIGN KEY (rank) REFERENCES ref.ranks(id);


--
-- Name: employees employees_unit_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_unit_fkey FOREIGN KEY (unit) REFERENCES hr.units(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: jobs jobs_echelon_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.jobs
    ADD CONSTRAINT jobs_echelon_fkey FOREIGN KEY (echelon) REFERENCES ref.echelons(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: jobs jobs_ranks_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.jobs
    ADD CONSTRAINT jobs_ranks_id_fk FOREIGN KEY (rank) REFERENCES ref.ranks(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: kpi kpi_employee_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.kpi
    ADD CONSTRAINT kpi_employee_fkey FOREIGN KEY (employee) REFERENCES hr.employees(id);


--
-- Name: leave_entitlements leave_entitlements_employees_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leave_entitlements
    ADD CONSTRAINT leave_entitlements_employees_id_fk FOREIGN KEY (employee) REFERENCES hr.employees(id);


--
-- Name: leave_entitlements leave_entitlements_leave_types_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leave_entitlements
    ADD CONSTRAINT leave_entitlements_leave_types_id_fk FOREIGN KEY (leave_type) REFERENCES ref.leave_types(id);


--
-- Name: leaves leaves_employees_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves
    ADD CONSTRAINT leaves_employees_id_fk FOREIGN KEY (employee) REFERENCES hr.employees(id);


--
-- Name: leaves leaves_employees_id_fk_2; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves
    ADD CONSTRAINT leaves_employees_id_fk_2 FOREIGN KEY (approved_by) REFERENCES hr.employees(id);


--
-- Name: leaves leaves_leave_types_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.leaves
    ADD CONSTRAINT leaves_leave_types_id_fk FOREIGN KEY (leave_type) REFERENCES ref.leave_types(id);


--
-- Name: units units_offices_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.units
    ADD CONSTRAINT units_offices_id_fk FOREIGN KEY (office) REFERENCES ref.offices(id);


--
-- Name: units units_units_id_fk; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.units
    ADD CONSTRAINT units_units_id_fk FOREIGN KEY (managing_unit) REFERENCES hr.units(id);


--
-- Name: users users_employees_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employees_id_fk FOREIGN KEY (employee_id) REFERENCES hr.employees(id);


--
-- Name: cities cities_province_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.cities
    ADD CONSTRAINT cities_province_fkey FOREIGN KEY (province) REFERENCES ref.provinces(id);


--
-- Name: countries countries_region_id_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: bpkp_aiva
--

ALTER TABLE ONLY ref.countries
    ADD CONSTRAINT countries_region_id_fkey FOREIGN KEY (region) REFERENCES ref.regions(region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: echelons echelons_max_rank_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.echelons
    ADD CONSTRAINT echelons_max_rank_fkey FOREIGN KEY (max_rank) REFERENCES ref.ranks(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: echelons echelons_min_rank_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.echelons
    ADD CONSTRAINT echelons_min_rank_fkey FOREIGN KEY (min_rank) REFERENCES ref.ranks(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: offices offices_city_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.offices
    ADD CONSTRAINT offices_city_fkey FOREIGN KEY (city) REFERENCES ref.cities(id);


--
-- Name: offices offices_country_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.offices
    ADD CONSTRAINT offices_country_fkey FOREIGN KEY (country) REFERENCES ref.countries(id);


--
-- Name: offices offices_province_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.offices
    ADD CONSTRAINT offices_province_fkey FOREIGN KEY (province) REFERENCES ref.provinces(id);


--
-- Name: provinces provinces_country_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.provinces
    ADD CONSTRAINT provinces_country_fkey FOREIGN KEY (country) REFERENCES ref.countries(id);


--
-- Name: regulations regulations_regulation_categories_id_fk; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.regulations
    ADD CONSTRAINT regulations_regulation_categories_id_fk FOREIGN KEY (category) REFERENCES ref.regulation_categories(id);


--
-- PostgreSQL database dump complete
--

