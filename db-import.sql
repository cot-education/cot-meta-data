--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: set_created_date_trigger_fn(); Type: FUNCTION; Schema: public; Owner: api
--

CREATE FUNCTION set_created_date_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF NEW.created_date IS NULL THEN
  NEW.created_date := CURRENT_TIMESTAMP;
 END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_created_date_trigger_fn() OWNER TO api;

--
-- Name: set_dates_trigger_fn(); Type: FUNCTION; Schema: public; Owner: api
--

CREATE FUNCTION set_dates_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF TG_OP = 'INSERT' THEN
  NEW.created_date := CURRENT_TIMESTAMP;
  ELSE IF TG_OP = 'UPDATE' AND NEW.updated_date IS NULL THEN
   NEW.updated_date := CURRENT_TIMESTAMP;
  END IF;
 END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_dates_trigger_fn() OWNER TO api;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: author; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    repositoryid integer,
    name character varying(255) NOT NULL,
    search_name character varying(255) NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.author OWNER TO api;

--
-- Name: author_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.author_id_seq OWNER TO api;

--
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE author_id_seq OWNED BY author.id;


--
-- Name: chapter_review; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE chapter_review (
    id integer NOT NULL,
    review_id integer NOT NULL,
    chapter integer NOT NULL,
    comments character varying(255),
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.chapter_review OWNER TO api;

--
-- Name: chapter_review_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE chapter_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chapter_review_id_seq OWNER TO api;

--
-- Name: chapter_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE chapter_review_id_seq OWNED BY chapter_review.id;


--
-- Name: chapter_review_score; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE chapter_review_score (
    id integer NOT NULL,
    chapter_review_id integer NOT NULL,
    review_category_id integer NOT NULL,
    score numeric NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.chapter_review_score OWNER TO api;

--
-- Name: chapter_review_score_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE chapter_review_score_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chapter_review_score_id_seq OWNER TO api;

--
-- Name: chapter_review_score_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE chapter_review_score_id_seq OWNED BY chapter_review_score.id;


--
-- Name: editor; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE editor (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    search_name character varying(255) NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.editor OWNER TO api;

--
-- Name: editor_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE editor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editor_id_seq OWNER TO api;

--
-- Name: editor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE editor_id_seq OWNED BY editor.id;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE organization (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    logo_url character varying(255),
    search_name character varying(255),
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.organization OWNER TO api;

--
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_id_seq OWNER TO api;

--
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE organization_id_seq OWNED BY organization.id;


--
-- Name: repository; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE repository (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255),
    search_name character varying(255) NOT NULL,
    last_imported_date timestamp without time zone DEFAULT '2000-01-01 00:00:00'::timestamp without time zone NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.repository OWNER TO api;

--
-- Name: repository_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE repository_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repository_id_seq OWNER TO api;

--
-- Name: repository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE repository_id_seq OWNED BY repository.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    repository_id integer NOT NULL,
    title character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    ancillaries_url character varying(255),
    cot_review_url character varying(255),
    license_name character varying(255),
    license_url character varying(255),
    search_license character varying(255),
    search_title character varying(255) NOT NULL,
    external_id character varying(255),
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.resource OWNER TO api;

--
-- Name: resource_author; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE resource_author (
    resource_id integer NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.resource_author OWNER TO api;

--
-- Name: resource_editor; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE resource_editor (
    resource_id integer NOT NULL,
    editor_id integer NOT NULL
);


ALTER TABLE public.resource_editor OWNER TO api;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resource_id_seq OWNER TO api;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


--
-- Name: resource_tag; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE resource_tag (
    resource_id integer NOT NULL,
    tag_id integer NOT NULL,
    created_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.resource_tag OWNER TO api;

--
-- Name: review; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE review (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    reviewer_id integer NOT NULL,
    review_type character varying(255),
    score numeric NOT NULL,
    chart_url character varying(255),
    comments text,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.review OWNER TO api;

--
-- Name: review_category; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE review_category (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    review_type character varying(255) NOT NULL,
    sort_order integer NOT NULL,
    min_score numeric DEFAULT 1 NOT NULL,
    max_score numeric DEFAULT 5 NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.review_category OWNER TO api;

--
-- Name: review_category_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE review_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_category_id_seq OWNER TO api;

--
-- Name: review_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE review_category_id_seq OWNED BY review_category.id;


--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_id_seq OWNER TO api;

--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE review_id_seq OWNED BY review.id;


--
-- Name: reviewer; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE reviewer (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    biography text,
    search_name character varying(255),
    created_date timestamp without time zone DEFAULT now(),
    updated_date timestamp without time zone
);


ALTER TABLE public.reviewer OWNER TO api;

--
-- Name: reviewer_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE reviewer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviewer_id_seq OWNER TO api;

--
-- Name: reviewer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE reviewer_id_seq OWNED BY reviewer.id;


--
-- Name: sub_tag; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE sub_tag (
    tag_id integer NOT NULL,
    parent_tag_id integer NOT NULL,
    created_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sub_tag OWNER TO api;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE tag (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    tag_type character varying(255) DEFAULT 'GENERAL'::character varying NOT NULL,
    parent_tag_id integer,
    search_name character varying(255) NOT NULL,
    created_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tag OWNER TO api;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: api
--

CREATE SEQUENCE tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_id_seq OWNER TO api;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: api
--

ALTER SEQUENCE tag_id_seq OWNED BY tag.id;


--
-- Name: tag_keyword; Type: TABLE; Schema: public; Owner: api; Tablespace: 
--

CREATE TABLE tag_keyword (
    tag_id integer NOT NULL,
    keyword character varying(255) NOT NULL,
    created_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tag_keyword OWNER TO api;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('author_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY chapter_review ALTER COLUMN id SET DEFAULT nextval('chapter_review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY chapter_review_score ALTER COLUMN id SET DEFAULT nextval('chapter_review_score_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY editor ALTER COLUMN id SET DEFAULT nextval('editor_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY organization ALTER COLUMN id SET DEFAULT nextval('organization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY repository ALTER COLUMN id SET DEFAULT nextval('repository_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY review ALTER COLUMN id SET DEFAULT nextval('review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY review_category ALTER COLUMN id SET DEFAULT nextval('review_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY reviewer ALTER COLUMN id SET DEFAULT nextval('reviewer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: api
--

ALTER TABLE ONLY tag ALTER COLUMN id SET DEFAULT nextval('tag_id_seq'::regclass);


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: api
--

COPY author (id, repositoryid, name, search_name, created_date, updated_date) FROM stdin;
71	2	Aasland	aasland	2018-05-26 20:55:40.524393	2018-05-26 20:55:40.530357
17	2	Prevention 	prevention 	2018-05-26 20:55:39.451269	2018-05-26 20:55:39.460237
7	2	Kruse	kruse	2018-05-26 20:55:39.25965	2018-05-26 20:55:39.290221
3	2	Womble	womble	2018-05-26 20:55:39.246695	2018-05-26 20:55:39.27802
57	2	Vable	vable	2018-05-26 20:55:40.282146	2018-05-26 20:55:40.289887
102	2	Lau	lau	2018-05-26 20:55:41.065781	2018-05-26 20:55:41.073315
9	2	Betts	betts	2018-05-26 20:55:39.264014	2018-05-26 20:55:39.29581
67	2	Watson	watson	2018-05-26 20:55:40.500603	2018-05-26 20:55:40.511848
16	2	Centers for Disease Control	centers for disease control	2018-05-26 20:55:39.449171	2018-05-26 20:55:39.458097
8	2	Poe	poe	2018-05-26 20:55:39.2618	2018-05-26 20:55:39.293482
26	2	Edwards	edwards	2018-05-26 20:55:39.759123	2018-05-26 20:55:39.769653
34	2	Lewis	lewis	2018-05-26 20:55:39.90538	2018-05-26 20:55:39.91609
12	2	Baker	baker	2018-05-26 20:55:39.330061	2018-05-26 20:55:39.338583
37	2	Annand	annand	2018-05-26 20:55:39.927269	2018-05-26 20:55:39.937523
13	2	Emergency Management Instituite	emergency management instituite	2018-05-26 20:55:39.373728	2018-05-26 20:55:39.382706
58	2	Vable   	vable   	2018-05-26 20:55:40.309232	2018-05-26 20:55:40.315191
14	2	National Institute on Drug Abuse 	national institute on drug abuse 	2018-05-26 20:55:39.408401	2018-05-26 20:55:39.422631
33	2	Suranovic	suranovic	2018-05-26 20:55:39.878197	2018-05-26 20:55:39.884162
32	2	Kyle	kyle	2018-05-26 20:55:39.844048	2018-05-26 20:55:39.852682
31	2	Arnold	arnold	2018-05-26 20:55:39.842172	2018-05-26 20:55:39.850826
19	2	Wikibooks	wikibooks	2018-05-26 20:55:39.486493	2018-05-26 20:55:39.493079
88	2	Barron	barron	2018-05-26 20:55:40.868134	2018-05-26 20:55:40.875926
15	2	Emergency Management Institute 	emergency management institute 	2018-05-26 20:55:39.433936	2018-05-26 20:55:39.440623
42	2	Yacht	yacht	2018-05-26 20:55:40.006774	2018-05-26 20:55:40.014783
20	2	Mednick 	mednick 	2018-05-26 20:55:39.529994	2018-05-26 20:55:39.536595
36	2	Dauderis	dauderis	2018-05-26 20:55:39.925422	2018-05-26 20:55:39.935627
49	2	Freeman	freeman	2018-05-26 20:55:40.130986	2018-05-26 20:55:40.138969
72	2	Stokes	stokes	2018-05-26 20:55:40.537441	2018-05-26 20:55:40.54329
11	2	Emergency Management Institute	emergency management institute	2018-05-26 20:55:39.310929	2018-05-26 20:55:39.320801
41	2	Siegel	siegel	2018-05-26 20:55:40.004994	2018-05-26 20:55:40.012988
21	2	Ganfyd 	ganfyd 	2018-05-26 20:55:39.605026	2018-05-26 20:55:39.611596
22	2	  by OpenLearn 	  by openlearn 	2018-05-26 20:55:39.621645	2018-05-26 20:55:39.62867
38	2	Caplan	caplan	2018-05-26 20:55:39.96201	2018-05-26 20:55:39.968513
39	2	Wright	wright	2018-05-26 20:55:39.975663	2018-05-26 20:55:39.98194
23	2	HealthKnowledge	healthknowledge	2018-05-26 20:55:39.675732	2018-05-26 20:55:39.682006
40	2	Szulczyk	szulczyk	2018-05-26 20:55:39.990053	2018-05-26 20:55:39.996947
5	2	Korol	korol	2018-05-26 20:55:39.254889	2018-05-26 20:55:39.285035
27	2	Ivancevich	ivancevich	2018-05-26 20:55:39.76104	2018-05-26 20:55:39.771564
35	2	McAfee 	mcafee 	2018-05-26 20:55:39.907456	2018-05-26 20:55:39.917974
25	2	Hermanson	hermanson	2018-05-26 20:55:39.757106	2018-05-26 20:55:39.767718
28	2	Welch	welch	2018-05-26 20:55:39.778801	2018-05-26 20:55:39.784897
61	2	Frey	frey	2018-05-26 20:55:40.420686	2018-05-26 20:55:40.428214
89	2	Barron 	barron 	2018-05-26 20:55:40.869882	2018-05-26 20:55:40.877789
29	2	Petroff 	petroff 	2018-05-26 20:55:39.80867	2018-05-26 20:55:39.816146
73	2	OpenLearn	openlearn	2018-05-26 20:55:40.550813	2018-05-26 20:55:40.558266
48	2	Mahajan	mahajan	2018-05-26 20:55:40.12923	2018-05-26 20:55:40.13706
43	2	Walther	walther	2018-05-26 20:55:40.021985	2018-05-26 20:55:40.027897
24	2	Boundless	boundless	2018-05-26 20:55:39.738208	2018-05-26 20:55:39.744787
44	2	Fiore	fiore	2018-05-26 20:55:40.050148	2018-05-26 20:55:40.056518
46	2	Fiore 	fiore 	2018-05-26 20:55:40.076378	2018-05-26 20:55:40.082018
74	2	Collins	collins	2018-05-26 20:55:40.567133	2018-05-26 20:55:40.573222
97	2	Brockett	brockett	2018-05-26 20:55:40.991193	2018-05-26 20:55:41.001118
84	2	U.S. Department of State International Information Programs	u.s. department of state international information programs	2018-05-26 20:55:40.793636	2018-05-26 20:55:40.79987
47	2	Kann 	kann 	2018-05-26 20:55:40.116282	2018-05-26 20:55:40.122401
70	2	Zinkhan	zinkhan	2018-05-26 20:55:40.505927	2018-05-26 20:55:40.517298
60	2	Cruz-Cruz	cruz-cruz	2018-05-26 20:55:40.418882	2018-05-26 20:55:40.426518
50	2	Obwoya	obwoya	2018-05-26 20:55:40.146202	2018-05-26 20:55:40.152032
80	2	Cornell	cornell	2018-05-26 20:55:40.657953	2018-05-26 20:55:40.667382
51	2	Scharf	scharf	2018-05-26 20:55:40.171385	2018-05-26 20:55:40.177229
52	2	Bar-Meir 	bar-meir 	2018-05-26 20:55:40.183994	2018-05-26 20:55:40.190702
53	2	Bar-Meir	bar-meir	2018-05-26 20:55:40.197981	2018-05-26 20:55:40.204711
59	2	McLean 	mclean 	2018-05-26 20:55:40.392752	2018-05-26 20:55:40.39876
30	2	Johnson 	johnson 	2018-05-26 20:55:39.823475	2018-05-26 20:55:39.831558
54	2	Kann	kann	2018-05-26 20:55:40.224809	2018-05-26 20:55:40.230601
55	2	Wilson	wilson	2018-05-26 20:55:40.23833	2018-05-26 20:55:40.244302
56	2	Kuphaldt 	kuphaldt 	2018-05-26 20:55:40.269039	2018-05-26 20:55:40.275179
77	2	Gabriel	gabriel	2018-05-26 20:55:40.623712	2018-05-26 20:55:40.636191
69	2	Pitt	pitt	2018-05-26 20:55:40.504192	2018-05-26 20:55:40.515374
62	2	Brusseau	brusseau	2018-05-26 20:55:40.435337	2018-05-26 20:55:40.441843
63	2	Global Text Project	global text project	2018-05-26 20:55:40.448778	2018-05-26 20:55:40.454764
64	2	Rivers	rivers	2018-05-26 20:55:40.461443	2018-05-26 20:55:40.468369
65	2	Burnett	burnett	2018-05-26 20:55:40.47531	2018-05-26 20:55:40.481205
66	2	Von Hippel	von hippel	2018-05-26 20:55:40.487975	2018-05-26 20:55:40.493743
100	2	Thanasoulis-Cerrachio	thanasoulis-cerrachio	2018-05-26 20:55:41.012054	2018-05-26 20:55:41.021061
76	2	Goldman	goldman	2018-05-26 20:55:40.621649	2018-05-26 20:55:40.634139
99	2	Ceniza-Levine	ceniza-levine	2018-05-26 20:55:41.010295	2018-05-26 20:55:41.019009
75	2	Boccard	boccard	2018-05-26 20:55:40.608462	2018-05-26 20:55:40.614322
86	2	Erdogen	erdogen	2018-05-26 20:55:40.820117	2018-05-26 20:55:40.830684
83	2	Erdogan	erdogan	2018-05-26 20:55:40.740982	2018-05-26 20:55:40.75022
78	2	Virtual Training Suite	virtual training suite	2018-05-26 20:55:40.643108	2018-05-26 20:55:40.64893
81	2	Nizan	nizan	2018-05-26 20:55:40.659945	2018-05-26 20:55:40.669314
82	2	Bauer	bauer	2018-05-26 20:55:40.739256	2018-05-26 20:55:40.748419
79	2	Solomon	solomon	2018-05-26 20:55:40.656094	2018-05-26 20:55:40.665669
87	2	Short	short	2018-05-26 20:55:40.844411	2018-05-26 20:55:40.857152
92	2	TAP-a-PM	tap-a-pm	2018-05-26 20:55:40.901973	2018-05-26 20:55:40.909806
85	2	Carpenter	carpenter	2018-05-26 20:55:40.816273	2018-05-26 20:55:40.827067
10	2	Wise	wise	2018-05-26 20:55:39.266145	2018-05-26 20:55:39.29843
91	2	PM World	pm world	2018-05-26 20:55:40.898213	2018-05-26 20:55:40.908035
90	2	Watt	watt	2018-05-26 20:55:40.885847	2018-05-26 20:55:40.891271
2	2	Young	young	2018-05-26 20:55:39.244131	2018-05-26 20:55:39.275716
6	2	DeSaix	desaix	2018-05-26 20:55:39.257317	2018-05-26 20:55:39.287204
93	2	Darnall	darnall	2018-05-26 20:55:40.934057	2018-05-26 20:55:40.941486
95	2	Lessig	lessig	2018-05-26 20:55:40.967776	2018-05-26 20:55:40.974636
98	2	Kahane	kahane	2018-05-26 20:55:40.993002	2018-05-26 20:55:41.003083
68	2	Berthon	berthon	2018-05-26 20:55:40.502446	2018-05-26 20:55:40.513644
96	2	Baranoff	baranoff	2018-05-26 20:55:40.989433	2018-05-26 20:55:40.99941
94	2	Preston	preston	2018-05-26 20:55:40.935883	2018-05-26 20:55:40.943294
101	2	Larson	larson	2018-05-26 20:55:41.051748	2018-05-26 20:55:41.058808
170	2	Cifarelli	cifarelli	2018-05-26 20:55:42.064498	2018-05-26 20:55:42.075491
1	2	OpenLearn 	openlearn 	2018-05-26 20:55:39.176085	2018-05-26 20:55:39.212838
4	2	Johnson	johnson	2018-05-26 20:55:39.249256	2018-05-26 20:55:39.252577
103	2	Mill	mill	2018-05-26 20:55:41.082303	2018-05-26 20:55:41.087933
104	2	Kiwanga	kiwanga	2018-05-26 20:55:41.107628	2018-05-26 20:55:41.113631
105	2	Schnick 	schnick 	2018-05-26 20:55:41.120285	2018-05-26 20:55:41.125727
106	2	Cvitanovi'c	cvitanovi'c	2018-05-26 20:55:41.132713	2018-05-26 20:55:41.138796
114	2	Pujji	pujji	2018-05-26 20:55:41.174223	2018-05-26 20:55:41.189404
107	2	Urone	urone	2018-05-26 20:55:41.146018	2018-05-26 20:55:41.156902
116	2	Lyublinskaya	lyublinskaya	2018-05-26 20:55:41.177887	2018-05-26 20:55:41.192945
109	2	Dirks	dirks	2018-05-26 20:55:41.149638	2018-05-26 20:55:41.160295
120	2	Ngamo	ngamo	2018-05-26 20:55:41.280551	2018-05-26 20:55:41.288864
111	2	Wolfe	wolfe	2018-05-26 20:55:41.168826	2018-05-26 20:55:41.184053
148	2	Heinold	heinold	2018-05-26 20:55:41.792031	2018-05-26 20:55:41.804441
113	2	Oberoi	oberoi	2018-05-26 20:55:41.172412	2018-05-26 20:55:41.187639
150	2	Chalishajar	chalishajar	2018-05-26 20:55:41.795579	2018-05-26 20:55:41.807876
115	2	Ingram	ingram	2018-05-26 20:55:41.176054	2018-05-26 20:55:41.191107
201	2	Ellis 	ellis 	2018-05-26 20:55:42.458161	2018-05-26 20:55:42.465664
118	2	Rasolondramanitra	rasolondramanitra	2018-05-26 20:55:41.225207	2018-05-26 20:55:41.230967
45	2	Wikibooks 	wikibooks 	2018-05-26 20:55:40.063861	2018-05-26 20:55:40.06966
178	2	Lippmann	lippmann	2018-05-26 20:55:42.138328	2018-05-26 20:55:42.155771
190	2	Ellis   	ellis   	2018-05-26 20:55:42.279239	2018-05-26 20:55:42.28636
119	2	Ramilison	ramilison	2018-05-26 20:55:41.265482	2018-05-26 20:55:41.272725
142	2	Magnier	magnier	2018-05-26 20:55:41.715154	2018-05-26 20:55:41.732878
182	2	Shoup	shoup	2018-05-26 20:55:42.194662	2018-05-26 20:55:42.200244
124	2	Youm	youm	2018-05-26 20:55:41.336066	2018-05-26 20:55:41.342046
125	2	Chihaka	chihaka	2018-05-26 20:55:41.353379	2018-05-26 20:55:41.359774
126	2	Ratiarison	ratiarison	2018-05-26 20:55:41.380393	2018-05-26 20:55:41.385996
144	2	Buck	buck	2018-05-26 20:55:41.741539	2018-05-26 20:55:41.74756
128	2	Schiller 	schiller 	2018-05-26 20:55:41.409786	2018-05-26 20:55:41.416279
145	2	GeoGebra 	geogebra 	2018-05-26 20:55:41.75429	2018-05-26 20:55:41.759574
129	2	Singh 	singh 	2018-05-26 20:55:41.437697	2018-05-26 20:55:41.443326
183	2	Sloughter 	sloughter 	2018-05-26 20:55:42.218981	2018-05-26 20:55:42.224439
164	2	Strang	strang	2018-05-26 20:55:41.972203	2018-05-26 20:55:41.979709
146	2	Khalagai	khalagai	2018-05-26 20:55:41.766114	2018-05-26 20:55:41.771562
123	2	Rasoanaivo	rasoanaivo	2018-05-26 20:55:41.316671	2018-05-26 20:55:41.328289
131	2	Raymond 	raymond 	2018-05-26 20:55:41.503909	2018-05-26 20:55:41.509502
147	2	Hartman	hartman	2018-05-26 20:55:41.790321	2018-05-26 20:55:41.802755
152	2	Doerr	doerr	2018-05-26 20:55:41.816209	2018-05-26 20:55:41.823305
117	2	Crowell 	crowell 	2018-05-26 20:55:41.199821	2018-05-26 20:55:41.20561
149	2	Siemers	siemers	2018-05-26 20:55:41.793803	2018-05-26 20:55:41.806175
130	2	Shewamare	shewamare	2018-05-26 20:55:41.474847	2018-05-26 20:55:41.48036
166	2	Lyryx Learning	lyryx learning	2018-05-26 20:55:42.024032	2018-05-26 20:55:42.029786
165	2	Herman	herman	2018-05-26 20:55:41.973847	2018-05-26 20:55:41.981847
151	2	Bowen ed.	bowen ed.	2018-05-26 20:55:41.797215	2018-05-26 20:55:41.809639
127	2	Tesfaye	tesfaye	2018-05-26 20:55:41.394419	2018-05-26 20:55:41.400902
132	2	Judson 	judson 	2018-05-26 20:55:41.643723	2018-05-26 20:55:41.649459
133	2	Felder 	felder 	2018-05-26 20:55:41.656256	2018-05-26 20:55:41.661938
134	2	Siklos	siklos	2018-05-26 20:55:41.680327	2018-05-26 20:55:41.685906
135	2	Boundless 	boundless 	2018-05-26 20:55:41.692277	2018-05-26 20:55:41.697805
184	2	Ekol	ekol	2018-05-26 20:55:42.231129	2018-05-26 20:55:42.236575
181	2	Zeager	zeager	2018-05-26 20:55:42.180994	2018-05-26 20:55:42.188244
163	2	Guichard	guichard	2018-05-26 20:55:41.960142	2018-05-26 20:55:41.965597
154	2	Sekhon 	sekhon 	2018-05-26 20:55:41.831618	2018-05-26 20:55:41.837317
155	2	Lebl	lebl	2018-05-26 20:55:41.856065	2018-05-26 20:55:41.861723
141	2	Norwood	norwood	2018-05-26 20:55:41.713521	2018-05-26 20:55:41.730924
158	2	Brown 	brown 	2018-05-26 20:55:41.884705	2018-05-26 20:55:41.890346
159	2	Khalagai 	khalagai 	2018-05-26 20:55:41.896947	2018-05-26 20:55:41.902454
160	2	Book of Proofs	book of proofs	2018-05-26 20:55:41.909108	2018-05-26 20:55:41.914733
161	2	Strang 	strang 	2018-05-26 20:55:41.93297	2018-05-26 20:55:41.938591
162	2	Masenge	masenge	2018-05-26 20:55:41.946036	2018-05-26 20:55:41.952387
185	2	Alvarez	alvarez	2018-05-26 20:55:42.24316	2018-05-26 20:55:42.255277
186	2	Ghys	ghys	2018-05-26 20:55:42.244937	2018-05-26 20:55:42.257031
167	2	Rawley	rawley	2018-05-26 20:55:42.03659	2018-05-26 20:55:42.046682
187	2	Leys video 	leys video 	2018-05-26 20:55:42.246858	2018-05-26 20:55:42.25872
195	2	Olley	olley	2018-05-26 20:55:42.360446	2018-05-26 20:55:42.367976
138	2	Gross	gross	2018-05-26 20:55:41.708317	2018-05-26 20:55:41.725642
188	2	Levin	levin	2018-05-26 20:55:42.265271	2018-05-26 20:55:42.270722
171	2	Fan	fan	2018-05-26 20:55:42.066261	2018-05-26 20:55:42.077276
112	2	Czuba	czuba	2018-05-26 20:55:41.170647	2018-05-26 20:55:41.185753
143	2	Belloit	belloit	2018-05-26 20:55:41.716927	2018-05-26 20:55:41.735084
169	2	Almukkahal	almukkahal	2018-05-26 20:55:42.062771	2018-05-26 20:55:42.073676
121	2	Diouf	diouf	2018-05-26 20:55:41.282519	2018-05-26 20:55:41.290616
191	2	Redden	redden	2018-05-26 20:55:42.2946	2018-05-26 20:55:42.300237
192	2	Keisler	keisler	2018-05-26 20:55:42.307037	2018-05-26 20:55:42.312585
172	2	Jarvis 	jarvis 	2018-05-26 20:55:42.067951	2018-05-26 20:55:42.079055
139	2	Lippman	lippman	2018-05-26 20:55:41.710059	2018-05-26 20:55:41.727349
193	2	Trench	trench	2018-05-26 20:55:42.31942	2018-05-26 20:55:42.324826
194	2	Kuttler 	kuttler 	2018-05-26 20:55:42.344566	2018-05-26 20:55:42.350219
153	2	Levasseur 	levasseur 	2018-05-26 20:55:41.817964	2018-05-26 20:55:41.824959
199	2	Robbin	robbin	2018-05-26 20:55:42.437899	2018-05-26 20:55:42.446866
196	2	Blakely	blakely	2018-05-26 20:55:42.374644	2018-05-26 20:55:42.380122
197	2	Beezer  	beezer  	2018-05-26 20:55:42.386619	2018-05-26 20:55:42.39238
140	2	Rasmussen	rasmussen	2018-05-26 20:55:41.711816	2018-05-26 20:55:41.729081
198	2	Kaabar	kaabar	2018-05-26 20:55:42.399467	2018-05-26 20:55:42.404948
122	2	Crowell	crowell	2018-05-26 20:55:41.298732	2018-05-26 20:55:41.306008
189	2	Burzynski	burzynski	2018-05-26 20:55:42.277457	2018-05-26 20:55:42.284662
137	2	Falduto	falduto	2018-05-26 20:55:41.706174	2018-05-26 20:55:41.723955
200	2	Angenent	angenent	2018-05-26 20:55:42.439721	2018-05-26 20:55:42.448689
202	2	Fields	fields	2018-05-26 20:55:42.489037	2018-05-26 20:55:42.494893
110	2	Sharma 	sharma 	2018-05-26 20:55:41.151415	2018-05-26 20:55:41.162157
203	2	Cherinda	cherinda	2018-05-26 20:55:42.523215	2018-05-26 20:55:42.529208
204	2	College of the Redwoods	college of the redwoods	2018-05-26 20:55:42.53818	2018-05-26 20:55:42.546895
157	2	Scottsdale Community College	scottsdale community college	2018-05-26 20:55:41.870274	2018-05-26 20:55:41.877796
205	2	Redden 	redden 	2018-05-26 20:55:42.569565	2018-05-26 20:55:42.575216
108	2	Hinrichs	hinrichs	2018-05-26 20:55:41.147919	2018-05-26 20:55:41.158617
207	2	Kaw 	kaw 	2018-05-26 20:55:42.621016	2018-05-26 20:55:42.626652
208	2	Trench 	trench 	2018-05-26 20:55:42.633053	2018-05-26 20:55:42.639494
227	2	Anthony-Smith	anthony-smith	2018-05-26 20:55:42.903015	2018-05-26 20:55:42.911933
209	2	 Scottsdale Community College	 scottsdale community college	2018-05-26 20:55:42.648128	2018-05-26 20:55:42.655197
210	2	Hefferon	hefferon	2018-05-26 20:55:42.673776	2018-05-26 20:55:42.679204
213	2	Waldron	waldron	2018-05-26 20:55:42.689028	2018-05-26 20:55:42.697835
226	2	Maracek	maracek	2018-05-26 20:55:42.901288	2018-05-26 20:55:42.909212
211	2	Cherney	cherney	2018-05-26 20:55:42.685703	2018-05-26 20:55:42.694499
214	2	Nicholson	nicholson	2018-05-26 20:55:42.716045	2018-05-26 20:55:42.721332
215	2	Matos	matos	2018-05-26 20:55:42.743568	2018-05-26 20:55:42.749263
216	2	Kaslik 	kaslik 	2018-05-26 20:55:42.755858	2018-05-26 20:55:42.761299
218	2	Chihaka 	chihaka 	2018-05-26 20:55:42.803404	2018-05-26 20:55:42.80883
219	2	Teller 	teller 	2018-05-26 20:55:42.815188	2018-05-26 20:55:42.820701
220	2	Lebl 	lebl 	2018-05-26 20:55:42.829084	2018-05-26 20:55:42.834738
221	2	Cheqe 	cheqe 	2018-05-26 20:55:42.841356	2018-05-26 20:55:42.846846
222	2	Masenge 	masenge 	2018-05-26 20:55:42.86585	2018-05-26 20:55:42.871486
225	2	Nguyen 	nguyen 	2018-05-26 20:55:42.882273	2018-05-26 20:55:42.893274
242	2	Thompson	thompson	2018-05-26 20:55:43.242808	2018-05-26 20:55:43.25057
223	2	Kaw	kaw	2018-05-26 20:55:42.878552	2018-05-26 20:55:42.889315
240	2	Malcolm	malcolm	2018-05-26 20:55:43.225233	2018-05-26 20:55:43.233099
241	2	Leung	leung	2018-05-26 20:55:43.240929	2018-05-26 20:55:43.248865
228	2	College of Redwoods Mathematics 	college of redwoods mathematics 	2018-05-26 20:55:42.920847	2018-05-26 20:55:42.928656
229	2	Rasmussen 	rasmussen 	2018-05-26 20:55:42.993917	2018-05-26 20:55:43.000986
230	2	Chege	chege	2018-05-26 20:55:43.007701	2018-05-26 20:55:43.013233
231	2	Erdman 	erdman 	2018-05-26 20:55:43.019796	2018-05-26 20:55:43.0253
232	2	Morris 	morris 	2018-05-26 20:55:43.032398	2018-05-26 20:55:43.038285
233	2	  by Schremmer	  by schremmer	2018-05-26 20:55:43.073107	2018-05-26 20:55:43.078659
234	2	Schremmer	schremmer	2018-05-26 20:55:43.08514	2018-05-26 20:55:43.090859
264	2	Sutton	sutton	2018-05-26 20:55:43.48588	2018-05-26 20:55:43.493617
252	2	Berkman Center for Internet & Society	berkman center for internet & society	2018-05-26 20:55:43.361904	2018-05-26 20:55:43.370022
235	2	Brin	brin	2018-05-26 20:55:43.132664	2018-05-26 20:55:43.137994
236	2	Corral 	corral 	2018-05-26 20:55:43.14452	2018-05-26 20:55:43.149867
237	2	Brennan 	brennan 	2018-05-26 20:55:43.168117	2018-05-26 20:55:43.173301
238	2	Hannan	hannan	2018-05-26 20:55:43.19129	2018-05-26 20:55:43.196707
246	2	Tse	tse	2018-05-26 20:55:43.291845	2018-05-26 20:55:43.310227
239	2	ed. by Noronha	ed. by noronha	2018-05-26 20:55:43.223527	2018-05-26 20:55:43.231434
245	2	Beiderwell	beiderwell	2018-05-26 20:55:43.289999	2018-05-26 20:55:43.308413
248	2	deKanter	dekanter	2018-05-26 20:55:43.29579	2018-05-26 20:55:43.313679
243	2	Osman	osman	2018-05-26 20:55:43.258318	2018-05-26 20:55:43.264593
273	2	Razafimbelo	razafimbelo	2018-05-26 20:55:43.649937	2018-05-26 20:55:43.656506
244	2	Kort	kort	2018-05-26 20:55:43.272436	2018-05-26 20:55:43.278951
257	2	Yuhnke	yuhnke	2018-05-26 20:55:43.384927	2018-05-26 20:55:43.399662
247	2	Lochhaas	lochhaas	2018-05-26 20:55:43.293793	2018-05-26 20:55:43.311977
253	2	Electronic Information for Libraries	electronic information for libraries	2018-05-26 20:55:43.363702	2018-05-26 20:55:43.371787
255	2	Thomas	thomas	2018-05-26 20:55:43.381459	2018-05-26 20:55:43.396206
249	2	Benkler	benkler	2018-05-26 20:55:43.320768	2018-05-26 20:55:43.327152
250	2	Embozi	embozi	2018-05-26 20:55:43.334474	2018-05-26 20:55:43.340853
254	2	ed. by Lowenthal	ed. by lowenthal	2018-05-26 20:55:43.379707	2018-05-26 20:55:43.394438
263	2	Siefert	siefert	2018-05-26 20:55:43.484151	2018-05-26 20:55:43.491918
256	2	Thai	thai	2018-05-26 20:55:43.383147	2018-05-26 20:55:43.397912
268	2	Tittenberger Unknown License	tittenberger unknown license	2018-05-26 20:55:43.547845	2018-05-26 20:55:43.558986
258	2	Gasell	gasell	2018-05-26 20:55:43.38834	2018-05-26 20:55:43.403003
259	2	Nyagah	nyagah	2018-05-26 20:55:43.410597	2018-05-26 20:55:43.417231
260	2	Bueller	bueller	2018-05-26 20:55:43.426825	2018-05-26 20:55:43.433897
261	2	Edol	edol	2018-05-26 20:55:43.443863	2018-05-26 20:55:43.450191
274	2	ed. by Ally	ed. by ally	2018-05-26 20:55:43.667506	2018-05-26 20:55:43.673886
262	2	Kimani	kimani	2018-05-26 20:55:43.470987	2018-05-26 20:55:43.477108
285	2	Rey 	rey 	2018-05-26 20:55:43.854055	2018-05-26 20:55:43.862273
267	2	Siemens	siemens	2018-05-26 20:55:43.545865	2018-05-26 20:55:43.557204
251	2	Enosi	enosi	2018-05-26 20:55:43.347985	2018-05-26 20:55:43.354508
265	2	Richard Jewell	richard jewell	2018-05-26 20:55:43.514815	2018-05-26 20:55:43.520738
266	2	West	west	2018-05-26 20:55:43.528443	2018-05-26 20:55:43.534891
288	2	burrough	burrough	2018-05-26 20:55:43.92461	2018-05-26 20:55:43.932366
284	2	Raunig	raunig	2018-05-26 20:55:43.852262	2018-05-26 20:55:43.860493
292	2	Zucker	zucker	2018-05-26 20:55:44.049398	2018-05-26 20:55:44.057462
269	2	EduTech	edutech	2018-05-26 20:55:43.582588	2018-05-26 20:55:43.59011
270	2	ed. by Wiley	ed. by wiley	2018-05-26 20:55:43.602966	2018-05-26 20:55:43.614414
271	2	Okumu	okumu	2018-05-26 20:55:43.621934	2018-05-26 20:55:43.628573
272	2	Downes	downes	2018-05-26 20:55:43.636131	2018-05-26 20:55:43.642281
275	2	WikiEducator	wikieducator	2018-05-26 20:55:43.681299	2018-05-26 20:55:43.688071
276	2	Gunga	gunga	2018-05-26 20:55:43.713443	2018-05-26 20:55:43.724055
277	2	Boyle	boyle	2018-05-26 20:55:43.732324	2018-05-26 20:55:43.738789
278	2	Gatumu	gatumu	2018-05-26 20:55:43.746751	2018-05-26 20:55:43.762379
279	2	Mihamitsy	mihamitsy	2018-05-26 20:55:43.76988	2018-05-26 20:55:43.777027
280	2	Rutondoki	rutondoki	2018-05-26 20:55:43.784517	2018-05-26 20:55:43.798879
281	2	University of Leicester	university of leicester	2018-05-26 20:55:43.806073	2018-05-26 20:55:43.812268
282	2	Ndirangu	ndirangu	2018-05-26 20:55:43.819479	2018-05-26 20:55:43.829859
283	2	ed. by Anderson	ed. by anderson	2018-05-26 20:55:43.837103	2018-05-26 20:55:43.843368
289	2	Mandiberg 	mandiberg 	2018-05-26 20:55:43.926355	2018-05-26 20:55:43.93402
286	2	Virtual Training Suite 	virtual training suite 	2018-05-26 20:55:43.869631	2018-05-26 20:55:43.875688
287	2	Schmidt-Jones 	schmidt-jones 	2018-05-26 20:55:43.911683	2018-05-26 20:55:43.917559
212	2	Denton	denton	2018-05-26 20:55:42.687385	2018-05-26 20:55:42.696154
300	2	John 	john 	2018-05-26 20:55:44.27597	2018-05-26 20:55:44.283209
291	2	Harris	harris	2018-05-26 20:55:44.047671	2018-05-26 20:55:44.055455
298	2	Irvine	irvine	2018-05-26 20:55:44.222076	2018-05-26 20:55:44.23045
290	2	Schmidt-Jones	schmidt-jones	2018-05-26 20:55:43.972227	2018-05-26 20:55:43.982138
293	2	Reynolds	reynolds	2018-05-26 20:55:44.090866	2018-05-26 20:55:44.096496
294	2	Hansen	hansen	2018-05-26 20:55:44.117128	2018-05-26 20:55:44.123123
295	2	Stonebraker 	stonebraker 	2018-05-26 20:55:44.179661	2018-05-26 20:55:44.185298
296	2	livingecon.org	livingecon.org	2018-05-26 20:55:44.192529	2018-05-26 20:55:44.19848
299	2	Cooper	cooper	2018-05-26 20:55:44.27421	2018-05-26 20:55:44.281445
302	2	Karr	karr	2018-05-26 20:55:44.293216	2018-05-26 20:55:44.300391
297	2	Curtis	curtis	2018-05-26 20:55:44.220319	2018-05-26 20:55:44.228316
301	2	Conte	conte	2018-05-26 20:55:44.291517	2018-05-26 20:55:44.298668
224	2	Kalu	kalu	2018-05-26 20:55:42.880564	2018-05-26 20:55:42.891294
303	2	Wikipedia 	wikipedia 	2018-05-26 20:55:44.307331	2018-05-26 20:55:44.313349
18	2	Office of Social & Behavioral Sciences Research 	office of social & behavioral sciences research 	2018-05-26 20:55:39.468023	2018-05-26 20:55:39.478176
206	2	Hapanyengwi	hapanyengwi	2018-05-26 20:55:42.593905	2018-05-26 20:55:42.599481
327	2	Martin	martin	2018-05-26 20:55:44.895924	2018-05-26 20:55:44.901256
367	2	Belles Ramos	belles ramos	2018-05-26 20:55:45.618982	2018-05-26 20:55:45.630897
382	2	Mobbs	mobbs	2018-05-26 20:55:45.845049	2018-05-26 20:55:45.852021
307	2	Greenlaw	greenlaw	2018-05-26 20:55:44.354916	2018-05-26 20:55:44.362467
358	2	Haverbeke	haverbeke	2018-05-26 20:55:45.498559	2018-05-26 20:55:45.504261
328	2	Turner	turner	2018-05-26 20:55:44.90773	2018-05-26 20:55:44.913031
329	2	  by OpenLearn 	  by openlearn 	2018-05-26 20:55:44.964222	2018-05-26 20:55:44.969631
330	2	Lessig  	lessig  	2018-05-26 20:55:44.976054	2018-05-26 20:55:44.981608
339	2	Dyszlewski	dyszlewski	2018-05-26 20:55:45.17546	2018-05-26 20:55:45.183915
333	2	Steenken	steenken	2018-05-26 20:55:45.016341	2018-05-26 20:55:45.023666
322	2	Miller	miller	2018-05-26 20:55:44.723272	2018-05-26 20:55:44.728368
317	2	McFarland	mcfarland	2018-05-26 20:55:44.636714	2018-05-26 20:55:44.644336
312	2	Dabhi 	dabhi 	2018-05-26 20:55:44.544298	2018-05-26 20:55:44.55192
348	2	Pike	pike	2018-05-26 20:55:45.296264	2018-05-26 20:55:45.307361
345	2	Ledeen	ledeen	2018-05-26 20:55:45.276798	2018-05-26 20:55:45.285731
309	2	Tregarthen 	tregarthen 	2018-05-26 20:55:44.392155	2018-05-26 20:55:44.399733
311	2	Bohm	bohm	2018-05-26 20:55:44.542602	2018-05-26 20:55:44.550058
310	2	Bauman	bauman	2018-05-26 20:55:44.530103	2018-05-26 20:55:44.535855
332	2	Burnham	burnham	2018-05-26 20:55:44.99023	2018-05-26 20:55:44.99813
316	2	Park	park	2018-05-26 20:55:44.634971	2018-05-26 20:55:44.642598
313	2	U.S Department of State Bureau of International Information Programs	u.s department of state bureau of international information programs	2018-05-26 20:55:44.55887	2018-05-26 20:55:44.564437
314	2	Germain	germain	2018-05-26 20:55:44.595531	2018-05-26 20:55:44.601936
315	2	Kratzke	kratzke	2018-05-26 20:55:44.608369	2018-05-26 20:55:44.616431
334	2	Brooks	brooks	2018-05-26 20:55:45.018058	2018-05-26 20:55:45.02534
331	2	Juras	juras	2018-05-26 20:55:44.988531	2018-05-26 20:55:44.996526
335	2	Ricks	ricks	2018-05-26 20:55:45.032442	2018-05-26 20:55:45.038044
336	2	Witt	witt	2018-05-26 20:55:45.071502	2018-05-26 20:55:45.077474
318	2	Verkeke	verkeke	2018-05-26 20:55:44.650764	2018-05-26 20:55:44.656171
319	2	Keyser	keyser	2018-05-26 20:55:44.688143	2018-05-26 20:55:44.693536
320	2	Storm	storm	2018-05-26 20:55:44.699984	2018-05-26 20:55:44.705464
321	2	Hatfield	hatfield	2018-05-26 20:55:44.711856	2018-05-26 20:55:44.716966
337	2	Geier	geier	2018-05-26 20:55:45.097433	2018-05-26 20:55:45.103437
359	2	Moursund	moursund	2018-05-26 20:55:45.511528	2018-05-26 20:55:45.517597
360	2	FLOSS Manuals	floss manuals	2018-05-26 20:55:45.53713	2018-05-26 20:55:45.543033
361	2	Williams	williams	2018-05-26 20:55:45.562089	2018-05-26 20:55:45.568023
362	2	Zittrain	zittrain	2018-05-26 20:55:45.574434	2018-05-26 20:55:45.580289
323	2	eLangdell Press	elangdell press	2018-05-26 20:55:44.793267	2018-05-26 20:55:44.798587
340	2	Ortiz	ortiz	2018-05-26 20:55:45.177052	2018-05-26 20:55:45.185533
350	2	Lebovitz	lebovitz	2018-05-26 20:55:45.29972	2018-05-26 20:55:45.310971
338	2	Gotauco	gotauco	2018-05-26 20:55:45.173769	2018-05-26 20:55:45.182296
341	2	Wiley 	wiley 	2018-05-26 20:55:45.21521	2018-05-26 20:55:45.220537
363	2	Schmandt	schmandt	2018-05-26 20:55:45.58741	2018-05-26 20:55:45.593163
324	2	Legal Information Institute	legal information institute	2018-05-26 20:55:44.816509	2018-05-26 20:55:44.823523
325	2	Cornell Law School	cornell law school	2018-05-26 20:55:44.818214	2018-05-26 20:55:44.825108
343	2	Altenburg 	altenburg 	2018-05-26 20:55:45.239963	2018-05-26 20:55:45.245437
326	2	Robson	robson	2018-05-26 20:55:44.872742	2018-05-26 20:55:44.878154
346	2	Lewis 	lewis 	2018-05-26 20:55:45.27848	2018-05-26 20:55:45.287364
347	2	Frost	frost	2018-05-26 20:55:45.294571	2018-05-26 20:55:45.305449
344	2	Abelson	abelson	2018-05-26 20:55:45.275113	2018-05-26 20:55:45.283971
365	2	Suppi Boldrito	suppi boldrito	2018-05-26 20:55:45.602915	2018-05-26 20:55:45.610303
349	2	Kenyo	kenyo	2018-05-26 20:55:45.297905	2018-05-26 20:55:45.309259
364	2	Jorba Esteve	jorba esteve	2018-05-26 20:55:45.600346	2018-05-26 20:55:45.608607
356	2	Bru Martinez	bru martinez	2018-05-26 20:55:45.457435	2018-05-26 20:55:45.466412
351	2	Gundavaram 	gundavaram 	2018-05-26 20:55:45.346572	2018-05-26 20:55:45.353018
352	2	Moursund 	moursund 	2018-05-26 20:55:45.359858	2018-05-26 20:55:45.36533
342	2	Nilsson	nilsson	2018-05-26 20:55:45.227151	2018-05-26 20:55:45.233032
353	2	Power 	power 	2018-05-26 20:55:45.396898	2018-05-26 20:55:45.403116
366	2	Lopez Sanchez	lopez sanchez	2018-05-26 20:55:45.617188	2018-05-26 20:55:45.628906
369	2	Auli Llinas	auli llinas	2018-05-26 20:55:45.622788	2018-05-26 20:55:45.634759
354	2	Pilgrim	pilgrim	2018-05-26 20:55:45.425203	2018-05-26 20:55:45.430843
375	2	Myers	myers	2018-05-26 20:55:45.678597	2018-05-26 20:55:45.6895
368	2	Baig Vinas	baig vinas	2018-05-26 20:55:45.620748	2018-05-26 20:55:45.632746
372	2	Wentworth	wentworth	2018-05-26 20:55:45.672763	2018-05-26 20:55:45.683939
373	2	Elkner	elkner	2018-05-26 20:55:45.674443	2018-05-26 20:55:45.685679
370	2	Chifwepa	chifwepa	2018-05-26 20:55:45.641869	2018-05-26 20:55:45.647338
371	2	Bunks	bunks	2018-05-26 20:55:45.656987	2018-05-26 20:55:45.662586
357	2	Fernandez Monsalve	fernandez monsalve	2018-05-26 20:55:45.459129	2018-05-26 20:55:45.468405
374	2	Downey	downey	2018-05-26 20:55:45.676573	2018-05-26 20:55:45.687604
378	2	Sanchez Jiminez	sanchez jiminez	2018-05-26 20:55:45.772344	2018-05-26 20:55:45.779546
355	2	Albos Raya	albos raya	2018-05-26 20:55:45.455818	2018-05-26 20:55:45.46468
376	2	Sarr	sarr	2018-05-26 20:55:45.714014	2018-05-26 20:55:45.721056
377	2	Onwu	onwu	2018-05-26 20:55:45.727395	2018-05-26 20:55:45.734536
388	2	Seoane Pascual	seoane pascual	2018-05-26 20:55:45.908367	2018-05-26 20:55:45.917056
383	2	Carter	carter	2018-05-26 20:55:45.846826	2018-05-26 20:55:45.853677
379	2	ed. by Watson	ed. by watson	2018-05-26 20:55:45.798996	2018-05-26 20:55:45.804093
380	2	Gallaugher	gallaugher	2018-05-26 20:55:45.810202	2018-05-26 20:55:45.81537
381	2	Correll	correll	2018-05-26 20:55:45.833297	2018-05-26 20:55:45.838552
392	2	Perez Lopez	perez lopez	2018-05-26 20:55:45.993127	2018-05-26 20:55:46.000323
393	2	Ribas i Xirgo	ribas i xirgo	2018-05-26 20:55:45.994836	2018-05-26 20:55:46.00204
384	2	Wikiversity	wikiversity	2018-05-26 20:55:45.859925	2018-05-26 20:55:45.865446
385	2	Evans	evans	2018-05-26 20:55:45.871771	2018-05-26 20:55:45.876942
386	2	Feher	feher	2018-05-26 20:55:45.895051	2018-05-26 20:55:45.900315
389	2	Robles	robles	2018-05-26 20:55:45.910036	2018-05-26 20:55:45.918614
398	2	Fogel	fogel	2018-05-26 20:55:46.093999	2018-05-26 20:55:46.100707
387	2	Gonzalez Barahona	gonzalez barahona	2018-05-26 20:55:45.906621	2018-05-26 20:55:45.915362
390	2	University of Cape Town	university of cape town	2018-05-26 20:55:45.924766	2018-05-26 20:55:45.929978
391	2	Eck	eck	2018-05-26 20:55:45.981341	2018-05-26 20:55:45.986773
400	2	Kaashoek	kaashoek	2018-05-26 20:55:46.108632	2018-05-26 20:55:46.115248
397	2	Bar	bar	2018-05-26 20:55:46.092333	2018-05-26 20:55:46.099111
394	2	Mateau	mateau	2018-05-26 20:55:46.008535	2018-05-26 20:55:46.014093
395	2	Bain	bain	2018-05-26 20:55:46.032696	2018-05-26 20:55:46.03771
396	2	Briain	briain	2018-05-26 20:55:46.08087	2018-05-26 20:55:46.086207
402	2	Wong	wong	2018-05-26 20:55:46.123341	2018-05-26 20:55:46.130543
399	2	Saltzer	saltzer	2018-05-26 20:55:46.10706	2018-05-26 20:55:46.113689
401	2	Nguyen	nguyen	2018-05-26 20:55:46.12162	2018-05-26 20:55:46.128605
308	2	Taylor	taylor	2018-05-26 20:55:44.356687	2018-05-26 20:55:44.36458
306	2	Tregarthen	tregarthen	2018-05-26 20:55:44.34077	2018-05-26 20:55:44.348086
403	2	Busbee	busbee	2018-05-26 20:55:46.15056	2018-05-26 20:55:46.157316
404	2	Mundargi	mundargi	2018-05-26 20:55:46.164775	2018-05-26 20:55:46.170427
305	2	Rittenberg	rittenberg	2018-05-26 20:55:44.338896	2018-05-26 20:55:44.34634
406	2	Severance	severance	2018-05-26 20:55:46.207226	2018-05-26 20:55:46.213074
453	2	Zulu 	zulu 	2018-05-26 20:55:46.866272	2018-05-26 20:55:46.872262
407	2	Stiber	stiber	2018-05-26 20:55:46.23198	2018-05-26 20:55:46.233886
422	2	Riddle	riddle	2018-05-26 20:55:46.488991	2018-05-26 20:55:46.495758
410	2	Roubtsova	roubtsova	2018-05-26 20:55:46.253201	2018-05-26 20:55:46.264149
421	2	Hanneman	hanneman	2018-05-26 20:55:46.487247	2018-05-26 20:55:46.494007
419	2	Office of Behavioral	office of behavioral	2018-05-26 20:55:46.472596	2018-05-26 20:55:46.479481
472	2	Kaslick	kaslick	2018-05-26 20:55:47.179375	2018-05-26 20:55:47.185465
412	2	Sussman	sussman	2018-05-26 20:55:46.274755	2018-05-26 20:55:46.276686
413	2	Omwenga	omwenga	2018-05-26 20:55:46.293799	2018-05-26 20:55:46.299633
414	2	Mayfield	mayfield	2018-05-26 20:55:46.346348	2018-05-26 20:55:46.353229
415	2	Corrius i Llavina	corrius i llavina	2018-05-26 20:55:46.388492	2018-05-26 20:55:46.393826
416	2	St. Laurent	st. laurent	2018-05-26 20:55:46.400357	2018-05-26 20:55:46.405647
417	2	Bothell	bothell	2018-05-26 20:55:46.423915	2018-05-26 20:55:46.429545
418	2	ed. by Butler	ed. by butler	2018-05-26 20:55:46.447034	2018-05-26 20:55:46.452118
443	2	Choi	choi	2018-05-26 20:55:46.751574	2018-05-26 20:55:46.765086
426	2	Cody-Rydzewski	cody-rydzewski	2018-05-26 20:55:46.529664	2018-05-26 20:55:46.54769
424	2	Keirns	keirns	2018-05-26 20:55:46.526439	2018-05-26 20:55:46.544453
427	2	Scaramuzzo	scaramuzzo	2018-05-26 20:55:46.531288	2018-05-26 20:55:46.549197
428	2	Sadler	sadler	2018-05-26 20:55:46.532877	2018-05-26 20:55:46.550735
429	2	Vyain	vyain	2018-05-26 20:55:46.53444	2018-05-26 20:55:46.552355
430	2	Bry	bry	2018-05-26 20:55:46.536054	2018-05-26 20:55:46.554086
431	2	Jones	jones	2018-05-26 20:55:46.537853	2018-05-26 20:55:46.555808
445	2	Rye	rye	2018-05-26 20:55:46.75653	2018-05-26 20:55:46.770064
433	2	Cheney	cheney	2018-05-26 20:55:46.563637	2018-05-26 20:55:46.571716
442	2	Avisar	avisar	2018-05-26 20:55:46.74995	2018-05-26 20:55:46.763391
425	2	Strayer	strayer	2018-05-26 20:55:46.528084	2018-05-26 20:55:46.546074
454	2	Scheiner	scheiner	2018-05-26 20:55:46.883432	2018-05-26 20:55:46.885279
466	2	Gibbs	gibbs	2018-05-26 20:55:47.118706	2018-05-26 20:55:47.131952
435	2	Dunn	dunn	2018-05-26 20:55:46.602599	2018-05-26 20:55:46.60802
436	2	Marcuse 	marcuse 	2018-05-26 20:55:46.614202	2018-05-26 20:55:46.620287
471	2	Dean    	dean    	2018-05-26 20:55:47.164907	2018-05-26 20:55:47.172188
432	2	Hammond	hammond	2018-05-26 20:55:46.56192	2018-05-26 20:55:46.570161
497	2	Gildenhard	gildenhard	2018-05-26 20:55:47.520754	2018-05-26 20:55:47.532303
434	2	Pearsey	pearsey	2018-05-26 20:55:46.565219	2018-05-26 20:55:46.573322
437	2	Barkan 	barkan 	2018-05-26 20:55:46.688986	2018-05-26 20:55:46.693863
438	2	Barkan	barkan	2018-05-26 20:55:46.699899	2018-05-26 20:55:46.705106
439	2	Veblen 	veblen 	2018-05-26 20:55:46.710885	2018-05-26 20:55:46.716106
440	2	Rabotovoa	rabotovoa	2018-05-26 20:55:46.727185	2018-05-26 20:55:46.732283
441	2	Klymkowsky	klymkowsky	2018-05-26 20:55:46.738307	2018-05-26 20:55:46.743803
450	2	Akre	akre	2018-05-26 20:55:46.833699	2018-05-26 20:55:46.845051
444	2	Jurukovsi	jurukovsi	2018-05-26 20:55:46.754805	2018-05-26 20:55:46.768457
456	2	U.S. Department of Health	u.s. department of health	2018-05-26 20:55:46.943454	2018-05-26 20:55:46.950688
457	2	Human Services 	human services 	2018-05-26 20:55:46.945253	2018-05-26 20:55:46.952471
446	2	Twesigye	twesigye	2018-05-26 20:55:46.792362	2018-05-26 20:55:46.797992
447	2	Bergtrom	bergtrom	2018-05-26 20:55:46.805367	2018-05-26 20:55:46.81103
448	2	UNKNOWN	unknown	2018-05-26 20:55:46.818099	2018-05-26 20:55:46.823274
449	2	Brainard	brainard	2018-05-26 20:55:46.831813	2018-05-26 20:55:46.843125
468	2	Laverty	laverty	2018-05-26 20:55:47.122502	2018-05-26 20:55:47.135806
451	2	Wilkin 	wilkin 	2018-05-26 20:55:46.835637	2018-05-26 20:55:46.846788
452	2	Tekere 	tekere 	2018-05-26 20:55:46.853398	2018-05-26 20:55:46.859485
458	2	Zulu	zulu	2018-05-26 20:55:46.959076	2018-05-26 20:55:46.964852
473	2	Matloff 	matloff 	2018-05-26 20:55:47.192587	2018-05-26 20:55:47.198086
459	2	Carnegie Mellon University 	carnegie mellon university 	2018-05-26 20:55:46.999823	2018-05-26 20:55:47.005706
460	2	Randall  	randall  	2018-05-26 20:55:47.012331	2018-05-26 20:55:47.017933
461	2	The National Institute of General Medical Sciences	the national institute of general medical sciences	2018-05-26 20:55:47.024528	2018-05-26 20:55:47.029996
462	2	Farabee 	farabee 	2018-05-26 20:55:47.049491	2018-05-26 20:55:47.055228
463	2	Rakotondradona 	rakotondradona 	2018-05-26 20:55:47.078265	2018-05-26 20:55:47.084269
464	2	The National Institue of General Medical Sciences 	the national institue of general medical sciences 	2018-05-26 20:55:47.09081	2018-05-26 20:55:47.096907
465	2	Ahlfinger	ahlfinger	2018-05-26 20:55:47.116724	2018-05-26 20:55:47.130045
479	2	Zhang 	zhang 	2018-05-26 20:55:47.265421	2018-05-26 20:55:47.273315
467	2	Harrison	harrison	2018-05-26 20:55:47.120608	2018-05-26 20:55:47.133905
478	2	Shafer	shafer	2018-05-26 20:55:47.2637	2018-05-26 20:55:47.271419
469	2	Sterling 	sterling 	2018-05-26 20:55:47.124348	2018-05-26 20:55:47.137611
477	2	Dean	dean	2018-05-26 20:55:47.248828	2018-05-26 20:55:47.25619
482	2	Diez	diez	2018-05-26 20:55:47.311784	2018-05-26 20:55:47.321708
483	2	Barr	barr	2018-05-26 20:55:47.313563	2018-05-26 20:55:47.323551
493	2	Chisoni	chisoni	2018-05-26 20:55:47.439095	2018-05-26 20:55:47.461375
475	2	Snell 	snell 	2018-05-26 20:55:47.219073	2018-05-26 20:55:47.226797
476	2	Lavine 	lavine 	2018-05-26 20:55:47.233356	2018-05-26 20:55:47.239755
474	2	Grinstead	grinstead	2018-05-26 20:55:47.21737	2018-05-26 20:55:47.225147
495	2	Gulule	gulule	2018-05-26 20:55:47.44301	2018-05-26 20:55:47.464823
470	2	Illowsky	illowsky	2018-05-26 20:55:47.16323	2018-05-26 20:55:47.17053
488	2	Dean 	dean 	2018-05-26 20:55:47.371931	2018-05-26 20:55:47.379535
480	2	Stockburger 	stockburger 	2018-05-26 20:55:47.287136	2018-05-26 20:55:47.292968
481	2	Lane 	lane 	2018-05-26 20:55:47.29968	2018-05-26 20:55:47.304962
484	2	Çetinkaya-Rundel 	çetinkaya-rundel 	2018-05-26 20:55:47.315492	2018-05-26 20:55:47.325485
409	2	Heeren	heeren	2018-05-26 20:55:46.251204	2018-05-26 20:55:46.262276
485	2	Chege 	chege 	2018-05-26 20:55:47.332754	2018-05-26 20:55:47.338269
486	2	UCLA Statistics Online Computational Resource 	ucla statistics online computational resource 	2018-05-26 20:55:47.345233	2018-05-26 20:55:47.351215
487	2	Pishro-Nik	pishro-nik	2018-05-26 20:55:47.358208	2018-05-26 20:55:47.363752
489	2	 by Wikibooks 	 by wikibooks 	2018-05-26 20:55:47.385701	2018-05-26 20:55:47.391603
496	2	Salanje 	salanje 	2018-05-26 20:55:47.445062	2018-05-26 20:55:47.466595
498	2	Hodgson	hodgson	2018-05-26 20:55:47.540865	2018-05-26 20:55:47.550186
490	2	Sitima	sitima	2018-05-26 20:55:47.433955	2018-05-26 20:55:47.455743
420	2	Social Science Research 	social science research 	2018-05-26 20:55:46.474332	2018-05-26 20:55:46.481152
492	2	Mkandawire	mkandawire	2018-05-26 20:55:47.437406	2018-05-26 20:55:47.459188
494	2	Samu	samu	2018-05-26 20:55:47.440971	2018-05-26 20:55:47.463119
411	2	Stuurman	stuurman	2018-05-26 20:55:46.255064	2018-05-26 20:55:46.266074
491	2	Maulidi	maulidi	2018-05-26 20:55:47.435806	2018-05-26 20:55:47.45739
423	2	Griffiths	griffiths	2018-05-26 20:55:46.524767	2018-05-26 20:55:46.542909
500	2	Mulligan	mulligan	2018-05-26 20:55:47.558929	2018-05-26 20:55:47.564797
501	2	  by University of Texas	  by university of texas	2018-05-26 20:55:47.571647	2018-05-26 20:55:47.577557
502	2	Tucker	tucker	2018-05-26 20:55:47.584532	2018-05-26 20:55:47.591972
408	2	Bijlsma	bijlsma	2018-05-26 20:55:46.249579	2018-05-26 20:55:46.260645
499	2	et al.	et al.	2018-05-26 20:55:47.542542	2018-05-26 20:55:47.55184
405	2	Krishnamurthi	krishnamurthi	2018-05-26 20:55:46.177582	2018-05-26 20:55:46.183402
504	2	University of Texas 	university of texas 	2018-05-26 20:55:47.600667	2018-05-26 20:55:47.606369
511	2	Comer	comer	2018-05-26 20:55:47.726202	2018-05-26 20:55:47.73829
514	2	Smyslova	smyslova	2018-05-26 20:55:47.731872	2018-05-26 20:55:47.743509
507	2	Gasser 	gasser 	2018-05-26 20:55:47.656626	2018-05-26 20:55:47.662631
508	2	Mitchell 	mitchell 	2018-05-26 20:55:47.669386	2018-05-26 20:55:47.676857
509	2	Angelo	angelo	2018-05-26 20:55:47.698717	2018-05-26 20:55:47.70517
510	2	Learn NC 	learn nc 	2018-05-26 20:55:47.712615	2018-05-26 20:55:47.718935
520	2	Lenz	lenz	2018-05-26 20:55:47.877852	2018-05-26 20:55:47.885445
513	2	Perkins	perkins	2018-05-26 20:55:47.730035	2018-05-26 20:55:47.741673
518	2	Owen	owen	2018-05-26 20:55:47.826696	2018-05-26 20:55:47.834418
521	2	Holman	holman	2018-05-26 20:55:47.87969	2018-05-26 20:55:47.887219
576	2	Mhehe	mhehe	2018-05-26 20:55:48.958635	2018-05-26 20:55:48.965742
516	2	Weil	weil	2018-05-26 20:55:47.794419	2018-05-26 20:55:47.800909
542	2	Tomkin	tomkin	2018-05-26 20:55:48.317031	2018-05-26 20:55:48.324617
519	2	Ginley	ginley	2018-05-26 20:55:47.844028	2018-05-26 20:55:47.851489
538	2	White	white	2018-05-26 20:55:48.287736	2018-05-26 20:55:48.294731
539	2	Dennin	dennin	2018-05-26 20:55:48.289625	2018-05-26 20:55:48.296422
548	2	 ed. by Pecorino	 ed. by pecorino	2018-05-26 20:55:48.377513	2018-05-26 20:55:48.38387
523	2	Cook	cook	2018-05-26 20:55:47.897448	2018-05-26 20:55:47.906471
522	2	Paletz	paletz	2018-05-26 20:55:47.894	2018-05-26 20:55:47.902892
524	2	U.S. Central Intelligence Agency 	u.s. central intelligence agency 	2018-05-26 20:55:47.913069	2018-05-26 20:55:47.919084
525	2	de Tocqueville	de tocqueville	2018-05-26 20:55:47.925798	2018-05-26 20:55:47.931865
526	2	Affolter	affolter	2018-05-26 20:55:47.98736	2018-05-26 20:55:47.997768
557	2	Hill	hill	2018-05-26 20:55:48.605287	2018-05-26 20:55:48.613666
529	2	University of California College Prep 	university of california college prep 	2018-05-26 20:55:48.022485	2018-05-26 20:55:48.028037
530	2	Walker 	walker 	2018-05-26 20:55:48.04664	2018-05-26 20:55:48.052107
531	2	Mworia 	mworia 	2018-05-26 20:55:48.083505	2018-05-26 20:55:48.089285
532	2	Dorsner	dorsner	2018-05-26 20:55:48.096567	2018-05-26 20:55:48.102413
533	2	Duffield	duffield	2018-05-26 20:55:48.155389	2018-05-26 20:55:48.162282
534	2	Sass 	sass 	2018-05-26 20:55:48.157025	2018-05-26 20:55:48.164326
552	2	Archie 	archie 	2018-05-26 20:55:48.478914	2018-05-26 20:55:48.48622
515	2	Wikiversity 	wikiversity 	2018-05-26 20:55:47.764726	2018-05-26 20:55:47.772339
527	2	Inkenbrandt	inkenbrandt	2018-05-26 20:55:47.989527	2018-05-26 20:55:47.999403
528	2	Mosher	mosher	2018-05-26 20:55:47.991084	2018-05-26 20:55:48.001161
535	2	Segar	segar	2018-05-26 20:55:48.195568	2018-05-26 20:55:48.201565
536	2	DiBiase 	dibiase 	2018-05-26 20:55:48.235536	2018-05-26 20:55:48.241059
537	2	Lenkeit 	lenkeit 	2018-05-26 20:55:48.261788	2018-05-26 20:55:48.26803
544	2	Tilling 	tilling 	2018-05-26 20:55:48.332829	2018-05-26 20:55:48.340105
541	2	 ed. by Theis	 ed. by theis	2018-05-26 20:55:48.314955	2018-05-26 20:55:48.322781
540	2	National Institutes of Health 	national institutes of health 	2018-05-26 20:55:48.30293	2018-05-26 20:55:48.308356
547	2	Marans	marans	2018-05-26 20:55:48.362934	2018-05-26 20:55:48.370171
543	2	Kious	kious	2018-05-26 20:55:48.331164	2018-05-26 20:55:48.338041
550	2	Fischer 	fischer 	2018-05-26 20:55:48.419533	2018-05-26 20:55:48.427043
546	2	Pospesel	pospesel	2018-05-26 20:55:48.361181	2018-05-26 20:55:48.368451
545	2	Pecorino 	pecorino 	2018-05-26 20:55:48.348046	2018-05-26 20:55:48.35431
551	2	Archie	archie	2018-05-26 20:55:48.477302	2018-05-26 20:55:48.484595
565	2	The National Science Foundation	the national science foundation	2018-05-26 20:55:48.726701	2018-05-26 20:55:48.732288
566	2	Hutchinson	hutchinson	2018-05-26 20:55:48.739105	2018-05-26 20:55:48.744989
553	2	Magnus 	magnus 	2018-05-26 20:55:48.493039	2018-05-26 20:55:48.498514
579	2	Munyaki	munyaki	2018-05-26 20:55:49.01222	2018-05-26 20:55:49.018441
575	2	Daley	daley	2018-05-26 20:55:48.929356	2018-05-26 20:55:48.931094
568	2	Njenga	njenga	2018-05-26 20:55:48.794887	2018-05-26 20:55:48.800453
549	2	Dimmock	dimmock	2018-05-26 20:55:48.417441	2018-05-26 20:55:48.425382
569	2	Kowenje	kowenje	2018-05-26 20:55:48.8074	2018-05-26 20:55:48.812924
561	2	Gray	gray	2018-05-26 20:55:48.656423	2018-05-26 20:55:48.66568
572	2	Yusuf	yusuf	2018-05-26 20:55:48.872485	2018-05-26 20:55:48.880095
554	2	Thoreau 	thoreau 	2018-05-26 20:55:48.572312	2018-05-26 20:55:48.578197
580	2	Makokha	makokha	2018-05-26 20:55:49.038039	2018-05-26 20:55:49.04393
571	2	Shiundu	shiundu	2018-05-26 20:55:48.870729	2018-05-26 20:55:48.878187
556	2	Ball	ball	2018-05-26 20:55:48.60349	2018-05-26 20:55:48.612024
581	2	Reusch 	reusch 	2018-05-26 20:55:49.050766	2018-05-26 20:55:49.056488
559	2	Lower	lower	2018-05-26 20:55:48.639075	2018-05-26 20:55:48.644761
562	2	Haight	haight	2018-05-26 20:55:48.658165	2018-05-26 20:55:48.667596
574	2	Human Services	human services	2018-05-26 20:55:48.914543	2018-05-26 20:55:48.922022
560	2	Dickerson	dickerson	2018-05-26 20:55:48.654562	2018-05-26 20:55:48.663913
563	2	The Free High School Science Texts	the free high school science texts	2018-05-26 20:55:48.674733	2018-05-26 20:55:48.680332
564	2	Curriki	curriki	2018-05-26 20:55:48.688062	2018-05-26 20:55:48.693868
570	2	Carnegie Mellon University	carnegie mellon university	2018-05-26 20:55:48.844903	2018-05-26 20:55:48.85055
558	2	Scott	scott	2018-05-26 20:55:48.607049	2018-05-26 20:55:48.615464
573	2	Department of Health	department of health	2018-05-26 20:55:48.912601	2018-05-26 20:55:48.920211
567	2	Tessema	tessema	2018-05-26 20:55:48.764853	2018-05-26 20:55:48.771509
585	2	Mergel	mergel	2018-05-26 20:55:49.134058	2018-05-26 20:55:49.145443
587	2	Spike 	spike 	2018-05-26 20:55:49.137716	2018-05-26 20:55:49.148904
577	2	Korane	korane	2018-05-26 20:55:48.960297	2018-05-26 20:55:48.967584
584	2	Locks	locks	2018-05-26 20:55:49.132351	2018-05-26 20:55:49.143814
578	2	Soderberg	soderberg	2018-05-26 20:55:48.986573	2018-05-26 20:55:48.992659
555	2	LibreTexts	libretexts	2018-05-26 20:55:48.591484	2018-05-26 20:55:48.597056
582	2	Bureau of Internationla Information Programs 	bureau of internationla information programs 	2018-05-26 20:55:49.092395	2018-05-26 20:55:49.098068
592	2	National Archives	national archives	2018-05-26 20:55:49.224276	2018-05-26 20:55:49.231875
583	2	Maxfield	maxfield	2018-05-26 20:55:49.105192	2018-05-26 20:55:49.111763
586	2	Roseman	roseman	2018-05-26 20:55:49.135961	2018-05-26 20:55:49.147098
595	2	Janssen	janssen	2018-05-26 20:55:49.255939	2018-05-26 20:55:49.269667
593	2	Records Administration 	records administration 	2018-05-26 20:55:49.226196	2018-05-26 20:55:49.233482
588	2	Trowbridge	trowbridge	2018-05-26 20:55:49.156768	2018-05-26 20:55:49.162943
589	2	Sage	sage	2018-05-26 20:55:49.18366	2018-05-26 20:55:49.189976
590	2	Spackman	spackman	2018-05-26 20:55:49.197846	2018-05-26 20:55:49.204012
591	2	Curtis 	curtis 	2018-05-26 20:55:49.21137	2018-05-26 20:55:49.217214
597	2	Pfannestiel	pfannestiel	2018-05-26 20:55:49.259742	2018-05-26 20:55:49.276173
594	2	Corbett	corbett	2018-05-26 20:55:49.254153	2018-05-26 20:55:49.267745
506	2	Professional Communication 	professional communication 	2018-05-26 20:55:47.640537	2018-05-26 20:55:47.648154
596	2	Lund	lund	2018-05-26 20:55:49.258	2018-05-26 20:55:49.271526
505	2	The Cain Project in Engineering	the cain project in engineering	2018-05-26 20:55:47.638879	2018-05-26 20:55:47.646503
598	2	Vickery	vickery	2018-05-26 20:55:49.261524	2018-05-26 20:55:49.278209
599	2	Ross-Nazzal	ross-nazzal	2018-05-26 20:55:49.28511	2018-05-26 20:55:49.291425
503	2	Barton 	barton 	2018-05-26 20:55:47.586205	2018-05-26 20:55:47.593647
512	2	deBenedette	debenedette	2018-05-26 20:55:47.728149	2018-05-26 20:55:47.739982
631	2	Lovett	lovett	2018-05-26 20:55:49.904127	2018-05-26 20:55:49.916921
664	2	Tramer	tramer	2018-06-20 16:49:10.638537	2018-06-20 16:49:10.645272
632	2	Perlmutter	perlmutter	2018-05-26 20:55:49.905686	2018-05-26 20:55:49.918561
601	2	National Institutes of Health	national institutes of health	2018-05-26 20:55:49.313145	2018-05-26 20:55:49.318565
617	2	Commonwealth of Learning 	commonwealth of learning 	2018-05-26 20:55:49.570891	2018-05-26 20:55:49.57623
633	2	Pettinelli 	pettinelli 	2018-05-26 20:55:49.936288	2018-05-26 20:55:49.941645
606	2	Zemliansky 	zemliansky 	2018-05-26 20:55:49.373272	2018-05-26 20:55:49.378721
637	2	Dostoyevsky	dostoyevsky	2018-05-26 20:55:50.047875	2018-05-26 20:55:50.053658
625	2	Stangor	stangor	2018-05-26 20:55:49.830348	2018-05-26 20:55:49.835174
608	2	Krause 	krause 	2018-05-26 20:55:49.397011	2018-05-26 20:55:49.402794
618	2	 ed. by Lowe	 ed. by lowe	2018-05-26 20:55:49.582923	2018-05-26 20:55:49.590028
644	2	Memmott	memmott	2018-05-26 20:55:50.100301	2018-05-26 20:55:50.116287
643	2	 ed. by Borràs	 ed. by borràs	2018-05-26 20:55:50.098758	2018-05-26 20:55:50.114254
651	2	Steinberg	steinberg	2018-05-26 20:55:50.147365	2018-05-26 20:55:50.152631
656	2	VanSpanckeren	vanspanckeren	2018-05-26 20:55:50.198924	2018-05-26 20:55:50.204469
652	2	Shakespeare	shakespeare	2018-05-26 20:55:50.158946	2018-05-26 20:55:50.164438
638	2	Bulfinch	bulfinch	2018-05-26 20:55:50.060227	2018-05-26 20:55:50.069915
639	2	 ed. by Hayles	 ed. by hayles	2018-05-26 20:55:50.076196	2018-05-26 20:55:50.087343
634	2	Rio Salado College	rio salado college	2018-05-26 20:55:50.012143	2018-05-26 20:55:50.017568
635	2	Melville	melville	2018-05-26 20:55:50.024038	2018-05-26 20:55:50.029647
649	2	Garbe	garbe	2018-05-26 20:55:50.129055	2018-05-26 20:55:50.139429
650	2	Salter	salter	2018-05-26 20:55:50.13084	2018-05-26 20:55:50.141072
657	2	Turpin	turpin	2018-05-26 20:55:50.214834	2018-05-26 20:55:50.220002
636	2	Dickens	dickens	2018-05-26 20:55:50.036187	2018-05-26 20:55:50.041746
641	2	Rettberg	rettberg	2018-05-26 20:55:50.079801	2018-05-26 20:55:50.090544
653	2	Mellenthin	mellenthin	2018-05-26 20:55:50.171239	2018-05-26 20:55:50.178571
666	2	Chatto	chatto	2018-11-19 19:16:29.351187	2018-11-19 19:16:29.35923
654	2	Shapiro	shapiro	2018-05-26 20:55:50.172892	2018-05-26 20:55:50.180165
667	2	Mastromonico	mastromonico	2018-11-19 19:16:29.35298	2018-11-19 19:16:29.360849
655	2	Sophocles	sophocles	2018-05-26 20:55:50.18671	2018-05-26 20:55:50.192267
658	2	Zissos	zissos	2018-05-26 20:55:50.227947	2018-05-26 20:55:50.234908
647	2	 ed. by Boluk	 ed. by boluk	2018-05-26 20:55:50.125908	2018-05-26 20:55:50.136248
668	2	Jellum	jellum	2018-11-19 19:16:29.368507	2018-11-19 19:16:29.376489
179	2	Stitz	stitz	2018-05-26 20:55:42.164052	2018-05-26 20:55:42.171099
669	2	Mitofsky	mitofsky	2018-11-19 19:16:29.764515	2018-11-19 19:16:29.770654
156	2	Dept. of Mathematics	dept. of mathematics	2018-05-26 20:55:41.86843	2018-05-26 20:55:41.876082
168	2	Gloag	gloag	2018-05-26 20:55:42.038354	2018-05-26 20:55:42.040199
173	2	Greenberg	greenberg	2018-05-26 20:55:42.089216	2018-05-26 20:55:42.102069
174	2	Sconyers	sconyers	2018-05-26 20:55:42.091044	2018-05-26 20:55:42.103851
175	2	Zahner 	zahner 	2018-05-26 20:55:42.092805	2018-05-26 20:55:42.10572
176	2	Landers	landers	2018-05-26 20:55:42.112193	2018-05-26 20:55:42.119423
663	2	  by Tramer	  by tramer	2018-06-20 16:49:08.966891	2018-06-20 16:49:08.974249
661	2	Kuttler	kuttler	2018-06-20 16:49:03.418527	2018-06-20 16:49:03.428853
217	2	The Free High School Science Texts 	the free high school science texts 	2018-05-26 20:55:42.791071	2018-05-26 20:55:42.796995
603	2	by McCrimmon 	by mccrimmon 	2018-05-26 20:55:49.337198	2018-05-26 20:55:49.342655
136	2	Abramson	abramson	2018-05-26 20:55:41.704387	2018-05-26 20:55:41.722353
613	2	The Writing Center at UNC-Chapel Hill 	the writing center at unc-chapel hill 	2018-05-26 20:55:49.491029	2018-05-26 20:55:49.496588
619	2	Anderson	anderson	2018-05-26 20:55:49.617343	2018-05-26 20:55:49.626362
645	2	Raley	raley	2018-05-26 20:55:50.101827	2018-05-26 20:55:50.11797
609	2	OpenLearn /	openlearn /	2018-05-26 20:55:49.434627	2018-05-26 20:55:49.440612
455	2	Natioanal Center for Biotechnology Information	natioanal center for biotechnology information	2018-05-26 20:55:46.900656	2018-05-26 20:55:46.906268
662	2	Robeyns	robeyns	2018-06-20 16:49:05.471573	2018-06-20 16:49:05.477872
604	2	Poulter	poulter	2018-05-26 20:55:49.349317	2018-05-26 20:55:49.354801
600	2	 ed. by Ockerbloom	 ed. by ockerbloom	2018-05-26 20:55:49.301494	2018-05-26 20:55:49.306827
621	2	  by Wikibooks	  by wikibooks	2018-05-26 20:55:49.650315	2018-05-26 20:55:49.655507
610	2	Schall 	schall 	2018-05-26 20:55:49.450399	2018-05-26 20:55:49.456535
627	2	Spielman	spielman	2018-05-26 20:55:49.897752	2018-05-26 20:55:49.910713
646	2	Stefans  	stefans  	2018-05-26 20:55:50.103503	2018-05-26 20:55:50.119526
648	2	Flores	flores	2018-05-26 20:55:50.12748	2018-05-26 20:55:50.137847
605	2	Briggs 	briggs 	2018-05-26 20:55:49.361492	2018-05-26 20:55:49.366834
622	2	  by American Folklife Center	  by american folklife center	2018-05-26 20:55:49.661534	2018-05-26 20:55:49.666345
611	2	Vidoli 	vidoli 	2018-05-26 20:55:49.463531	2018-05-26 20:55:49.469343
642	2	Strickland	strickland	2018-05-26 20:55:50.08162	2018-05-26 20:55:50.092145
615	2	Writing commons	writing commons	2018-05-26 20:55:49.534915	2018-05-26 20:55:49.540667
177	2	Meery 	meery 	2018-05-26 20:55:42.113903	2018-05-26 20:55:42.121334
626	2	Denyeko	denyeko	2018-05-26 20:55:49.853173	2018-05-26 20:55:49.858168
623	2	Stebbins	stebbins	2018-05-26 20:55:49.683809	2018-05-26 20:55:49.688874
616	2	McLean	mclean	2018-05-26 20:55:49.547296	2018-05-26 20:55:49.552616
628	2	Dumper	dumper	2018-05-26 20:55:49.899328	2018-05-26 20:55:49.912338
624	2	Phiri	phiri	2018-05-26 20:55:49.768827	2018-05-26 20:55:49.773885
659	2	Lawrence	lawrence	2018-05-26 20:55:50.241278	2018-05-26 20:55:50.246285
517	2	University of Minnesota Libraries Publishing	university of minnesota libraries publishing	2018-05-26 20:55:47.808183	2018-05-26 20:55:47.818282
665	2	Flynn	flynn	2018-11-19 19:16:29.07638	2018-11-19 19:16:29.085677
660	2	Kafka	kafka	2018-05-26 20:55:50.252465	2018-05-26 20:55:50.257754
676	2	Brown	brown	2018-11-19 19:16:30.364265	2018-11-19 19:16:30.375842
620	2	Marman	marman	2018-05-26 20:55:49.619098	2018-05-26 20:55:49.627903
629	2	Jenkins	jenkins	2018-05-26 20:55:49.90095	2018-05-26 20:55:49.91382
640	2	Montfort	montfort	2018-05-26 20:55:50.077858	2018-05-26 20:55:50.088869
602	2	Fallows 	fallows 	2018-05-26 20:55:49.325331	2018-05-26 20:55:49.330657
612	2	Colomb 	colomb 	2018-05-26 20:55:49.477078	2018-05-26 20:55:49.484291
607	2	McMurrey	mcmurrey	2018-05-26 20:55:49.385404	2018-05-26 20:55:49.390904
614	2	Priebe	priebe	2018-05-26 20:55:49.503282	2018-05-26 20:55:49.510515
630	2	Lacombe	lacombe	2018-05-26 20:55:49.902596	2018-05-26 20:55:49.915418
670	2	Byars	byars	2018-11-19 19:16:30.03542	2018-11-19 19:16:30.043076
671	2	Stanberry	stanberry	2018-11-19 19:16:30.037313	2018-11-19 19:16:30.044863
672	2	Olivier	olivier	2018-11-19 19:16:30.091637	2018-11-19 19:16:30.099416
673	2	Gitman	gitman	2018-11-19 19:16:30.280424	2018-11-19 19:16:30.28799
674	2	Holmes	holmes	2018-11-19 19:16:30.29721	2018-11-19 19:16:30.306341
677	2	King	king	2018-11-19 19:16:30.366091	2018-11-19 19:16:30.377496
678	2	Vernier	vernier	2018-11-19 19:16:30.367984	2018-11-19 19:16:30.379209
675	2	Ogloblin	ogloblin	2018-11-19 19:16:30.362377	2018-11-19 19:16:30.373874
679	2	Hinrichs 	hinrichs 	2018-11-19 19:16:30.713858	2018-11-19 19:16:30.72139
680	2	Moebs	moebs	2018-11-19 19:16:31.104234	2018-11-19 19:16:31.112452
681	2	Ling	ling	2018-11-19 19:16:31.105885	2018-11-19 19:16:31.113965
682	2	Sanny	sanny	2018-11-19 19:16:31.10748	2018-11-19 19:16:31.115643
180	2	Zeager 	zeager 	2018-05-26 20:55:42.165692	2018-05-26 20:55:42.172778
683	2	Tiemeyer	tiemeyer	2018-11-19 19:16:31.311509	2018-11-19 19:16:31.317931
684	2	Schlieper	schlieper	2018-11-19 19:16:31.313042	2018-11-19 19:16:31.319609
685	2	Gonzalez	gonzalez	2018-11-19 19:16:31.57174	2018-11-19 19:16:31.580986
686	2	Hilgemann	hilgemann	2018-11-19 19:16:31.573286	2018-11-19 19:16:31.582633
687	2	Schmurr	schmurr	2018-11-19 19:16:31.575333	2018-11-19 19:16:31.584487
689	2	Anthony-Smith   	anthony-smith   	2018-11-19 19:16:31.675495	2018-11-19 19:16:31.68259
690	2	Hitchman	hitchman	2018-11-19 19:16:31.906496	2018-11-19 19:16:31.912204
688	2	Marecek	marecek	2018-11-19 19:16:31.673749	2018-11-19 19:16:31.680886
724	2	Hastings	hastings	2018-11-19 19:16:36.885051	2018-11-19 19:16:36.892181
692	2	Buller	buller	2018-11-19 19:16:32.70613	2018-11-19 19:16:32.711707
723	2	Stone	stone	2018-11-19 19:16:36.803393	2018-11-19 19:16:36.811216
691	2	Zhou	zhou	2018-11-19 19:16:32.562835	2018-11-19 19:16:32.570186
693	2	Scheffler	scheffler	2018-11-19 19:16:32.885145	2018-11-19 19:16:32.893982
694	2	Andrews	andrews	2018-11-19 19:16:32.886754	2018-11-19 19:16:32.895895
695	2	Sartin	sartin	2018-11-19 19:16:32.888615	2018-11-19 19:16:32.897681
725	2	Powell	powell	2018-11-19 19:16:36.948553	2018-11-19 19:16:36.95631
742	2	Cannon	cannon	2018-11-19 19:16:38.317248	2018-11-19 19:16:38.327653
758	2	Lee	lee	2018-11-19 19:16:39.182719	2018-11-19 19:16:39.189227
698	2	Sachant	sachant	2018-11-19 19:16:33.196732	2018-11-19 19:16:33.207123
699	2	Blood	blood	2018-11-19 19:16:33.198386	2018-11-19 19:16:33.208778
700	2	LeMieux	lemieux	2018-11-19 19:16:33.200334	2018-11-19 19:16:33.210383
701	2	Tekippe	tekippe	2018-11-19 19:16:33.201922	2018-11-19 19:16:33.212209
702	2	Mueller	mueller	2018-11-19 19:16:33.242339	2018-11-19 19:16:33.249224
704	2	Heflin	heflin	2018-11-19 19:16:33.324431	2018-11-19 19:16:33.335351
705	2	Kluball	kluball	2018-11-19 19:16:33.326222	2018-11-19 19:16:33.336894
706	2	Kramer 	kramer 	2018-11-19 19:16:33.328136	2018-11-19 19:16:33.338479
304	2	Carnegie Mellon University Open Learning Initiative	carnegie mellon university open learning initiative	2018-05-26 20:55:44.32116	2018-05-26 20:55:44.331931
707	2	Braunschweig	braunschweig	2018-11-19 19:16:35.248522	2018-11-19 19:16:35.256215
743	2	Nuckels	nuckels	2018-11-19 19:16:38.318919	2018-11-19 19:16:38.329576
709	2	  by DeCarlo	  by decarlo	2018-11-19 19:16:35.7469	2018-11-19 19:16:35.751901
703	2	Clark	clark	2018-11-19 19:16:33.322658	2018-11-19 19:16:33.333599
710	2	Douglas	douglas	2018-11-19 19:16:35.924803	2018-11-19 19:16:35.933994
711	2	Zedalis	zedalis	2018-11-19 19:16:35.940342	2018-11-19 19:16:35.94724
712	2	Eggebrecht	eggebrecht	2018-11-19 19:16:35.942131	2018-11-19 19:16:35.948946
713	2	Fowler	fowler	2018-11-19 19:16:35.979438	2018-11-19 19:16:35.988393
714	2	Roush	roush	2018-11-19 19:16:35.981177	2018-11-19 19:16:35.990523
726	2	Krutz	krutz	2018-11-19 19:16:37.084209	2018-11-19 19:16:37.091156
727	2	Waskiewicz	waskiewicz	2018-11-19 19:16:37.086081	2018-11-19 19:16:37.09269
717	2	Parker	parker	2018-11-19 19:16:36.121001	2018-11-19 19:16:36.128589
744	2	Khatmullin	khatmullin	2018-11-19 19:16:38.320668	2018-11-19 19:16:38.331338
708	2	Horne	horne	2018-11-19 19:16:35.722279	2018-11-19 19:16:35.728089
728	2	Franknoi	franknoi	2018-11-19 19:16:37.244463	2018-11-19 19:16:37.252809
715	2	Smith	smith	2018-11-19 19:16:36.093104	2018-11-19 19:16:36.100081
716	2	Selby	selby	2018-11-19 19:16:36.094691	2018-11-19 19:16:36.101643
718	2	Harmon 	harmon 	2018-11-19 19:16:36.240051	2018-11-19 19:16:36.245578
719	2	Harnden	harnden	2018-11-19 19:16:36.263224	2018-11-19 19:16:36.270716
720	2	Bridges	bridges	2018-11-19 19:16:36.265084	2018-11-19 19:16:36.272261
729	2	Morrison	morrison	2018-11-19 19:16:37.246173	2018-11-19 19:16:37.254339
730	2	Wolff 	wolff 	2018-11-19 19:16:37.247992	2018-11-19 19:16:37.256169
731	2	Zehnder	zehnder	2018-11-19 19:16:37.383578	2018-11-19 19:16:37.390018
721	2	Burran	burran	2018-11-19 19:16:36.279287	2018-11-19 19:16:36.286286
722	2	DesRochers	desrochers	2018-11-19 19:16:36.281163	2018-11-19 19:16:36.28807
745	2	Lauer	lauer	2018-11-19 19:16:38.32217	2018-11-19 19:16:38.332845
732	2	Deline	deline	2018-11-19 19:16:37.441189	2018-11-19 19:16:37.449492
733	2	Tefend	tefend	2018-11-19 19:16:37.444348	2018-11-19 19:16:37.453072
746	2	McKinney	mckinney	2018-11-19 19:16:38.561741	2018-11-19 19:16:38.56956
747	2	Shepard	shepard	2018-11-19 19:16:38.563365	2018-11-19 19:16:38.571083
748	2	Berger	berger	2018-11-19 19:16:38.577828	2018-11-19 19:16:38.585917
749	2	Hall	hall	2018-11-19 19:16:38.626969	2018-11-19 19:16:38.634794
750	2	Wallace	wallace	2018-11-19 19:16:38.62878	2018-11-19 19:16:38.639009
734	2	Hesse	hesse	2018-11-19 19:16:37.577539	2018-11-19 19:16:37.591567
696	2	Cozart	cozart	2018-11-19 19:16:32.963252	2018-11-19 19:16:32.970322
735	2	Szymik	szymik	2018-11-19 19:16:37.582014	2018-11-19 19:16:37.594968
736	2	Nichols	nichols	2018-11-19 19:16:37.58602	2018-11-19 19:16:37.596656
751	2	Venus	venus	2018-11-19 19:16:38.6821	2018-11-19 19:16:38.689939
759	2	Spielman et al.	spielman et al.	2018-11-19 19:16:39.297345	2018-11-19 19:16:39.30239
697	2	Cengage Learning	cengage learning	2018-11-19 19:16:32.992989	2018-11-19 19:16:32.998164
737	2	Flowers	flowers	2018-11-19 19:16:37.940027	2018-11-19 19:16:37.951624
738	2	Theopold	theopold	2018-11-19 19:16:37.94247	2018-11-19 19:16:37.95366
739	2	Langley	langley	2018-11-19 19:16:37.944361	2018-11-19 19:16:37.955263
741	2	Neth	neth	2018-11-19 19:16:37.980685	2018-11-19 19:16:37.993728
740	2	Robinson	robinson	2018-11-19 19:16:37.946353	2018-11-19 19:16:37.957228
752	2	Crisp	crisp	2018-11-19 19:16:38.785412	2018-11-19 19:16:38.794413
753	2	Postell	postell	2018-11-19 19:16:38.787128	2018-11-19 19:16:38.795996
754	2	Whitesell	whitesell	2018-11-19 19:16:38.789018	2018-11-19 19:16:38.79769
755	2	Crowther	crowther	2018-11-19 19:16:38.842142	2018-11-19 19:16:38.849488
756	2	et al. /	et al. /	2018-11-19 19:16:38.843993	2018-11-19 19:16:38.850972
760	2	Kunkel	kunkel	2018-11-19 19:16:39.375487	2018-11-19 19:16:39.38435
757	2	Kearns	kearns	2018-11-19 19:16:39.181188	2018-11-19 19:16:39.187701
761	2	Bagwell	bagwell	2018-11-19 19:16:39.377095	2018-11-19 19:16:39.386064
762	2	McCrae	mccrae	2018-11-19 19:16:39.379052	2018-11-19 19:16:39.387748
763	2	Getty	getty	2018-11-19 19:16:39.545848	2018-11-19 19:16:39.552512
764	2	Kwon	kwon	2018-11-19 19:16:39.547411	2018-11-19 19:16:39.554064
765	2	ed. by Barrington	ed. by barrington	2018-11-19 19:16:39.680526	2018-11-19 19:16:39.688267
766	2	Hrach	hrach	2018-11-19 19:16:39.696383	2018-11-19 19:16:39.704364
767	2	Koech	koech	2018-11-19 19:16:39.698156	2018-11-19 19:16:39.706431
773	2	Davis	davis	2018-11-19 19:16:39.80783	2018-11-19 19:16:39.81799
768	2	Kelley	kelley	2018-11-19 19:16:39.782287	2018-11-19 19:16:39.793716
769	2	Thomson	thomson	2018-11-19 19:16:39.783979	2018-11-19 19:16:39.795443
770	2	Berke	berke	2018-11-19 19:16:39.802321	2018-11-19 19:16:39.813138
771	2	Bleil	bleil	2018-11-19 19:16:39.80435	2018-11-19 19:16:39.814871
772	2	Cofer	cofer	2018-11-19 19:16:39.805967	2018-11-19 19:16:39.816347
\.


--
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('author_id_seq', 773, true);


--
-- Data for Name: chapter_review; Type: TABLE DATA; Schema: public; Owner: api
--

COPY chapter_review (id, review_id, chapter, comments, created_date, updated_date) FROM stdin;
\.


--
-- Name: chapter_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('chapter_review_id_seq', 1, false);


--
-- Data for Name: chapter_review_score; Type: TABLE DATA; Schema: public; Owner: api
--

COPY chapter_review_score (id, chapter_review_id, review_category_id, score, created_date, updated_date) FROM stdin;
\.


--
-- Name: chapter_review_score_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('chapter_review_score_id_seq', 1, false);


--
-- Data for Name: editor; Type: TABLE DATA; Schema: public; Owner: api
--

COPY editor (id, name, search_name, created_date, updated_date) FROM stdin;
\.


--
-- Name: editor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('editor_id_seq', 1, false);


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: api
--

COPY organization (id, name, url, logo_url, search_name, created_date, updated_date) FROM stdin;
1	Florida Virtual Campus	https://www.floridashines.org/orange-grove	https://www.floridashines.org/floridaShines.org-theme/images/flvc.png	florida virtual campus	2018-05-26 18:50:41.14422	\N
2	College Open Textbooks	http://collegeopentextbooks.org	http://www.collegeopentextbooks.org/images/logo-inner.png	college open textbooks	2018-05-26 18:50:41.161005	\N
3	BC Campus	"https://bccampus.ca/"	"https://bccampus.ca/wp-content/themes/wordpress-bootstrap-child/images/bccampus-logo.png"	"bc campus"	2018-05-26 18:50:41.177359	\N
4	BC Campus	https://bccampus.ca	https://bccampus.ca/wp-content/themes/wordpress-bootstrap-child/images/bccampus-logo.png	bc campus	\N	\N
\.


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('organization_id_seq', 4, true);


--
-- Data for Name: repository; Type: TABLE DATA; Schema: public; Owner: api
--

COPY repository (id, organization_id, name, url, search_name, last_imported_date, created_date, updated_date) FROM stdin;
1	1	Orange Grove	https://florida.theorangegrove.org/og/oai	orange grove	2000-01-01 00:00:00	2018-05-26 18:50:41.152692	\N
2	2	College Open Textbooks	http://www.collegeopentextbooks.org	college open textbooks	2000-01-01 00:00:00	2018-05-26 18:50:41.169181	\N
3	3	BC Campus SOLR	http://solr.bccampus.ca:8001/bcc/oai	bc campus solr	2000-01-01 00:00:00	2018-05-26 18:50:42.78553	2018-05-26 20:51:52.85269
\.


--
-- Name: repository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('repository_id_seq', 4, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: api
--

COPY resource (id, repository_id, title, url, ancillaries_url, cot_review_url, license_name, license_url, search_license, search_title, external_id, created_date, updated_date) FROM stdin;
2	2	Anatomy and Physiology	https://openstax.org/details/anatomy-and-physiology	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	anatomy and physiology	\N	2018-05-26 20:55:39.242643	2018-05-26 21:20:41.729271
3	2	Comparative Emergency Management Book	https://training.fema.gov/hiedu/aemrc/booksdownload/compemmgmtbookproject/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	comparative emergency management book	\N	2018-05-26 20:55:39.309023	2018-05-26 21:20:41.773584
4	2	Contemporary Health Issues	http://hlth21fall2012.wikispaces.com/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	contemporary health issues	\N	2018-05-26 20:55:39.328729	2018-05-26 21:20:41.785173
5	2	Critical Issues in Disaster Science and Management	https://training.fema.gov/hiedu/aemrc/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	critical issues in disaster science and management	\N	2018-05-26 20:55:39.346408	2018-05-26 21:20:41.802412
6	2	Disciplines, Disasters and Emergency Management Textbook	https://training.fema.gov/hiedu/aemrc/booksdownload/ddemtextbook/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	disciplines, disasters and emergency management textbook	\N	2018-05-26 20:55:39.372441	2018-05-26 21:20:41.814775
7	2	Diversity and Difference in Communication	http://openlearn.open.ac.uk/course/view.php?id=1536	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	diversity and difference in communication	\N	2018-05-26 20:55:39.389598	2018-05-26 21:20:41.827376
8	2	Drugs, Brains, and Behavior – The Science of Addiction	http://www.nida.nih.gov/scienceofaddiction/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	drugs, brains, and behavior – the science of addiction	\N	2018-05-26 20:55:39.407237	2018-05-26 21:20:41.83986
9	2	Emergency and Risk Management Case Studies Textbook	http://training.fema.gov/EMIWeb/edu/emoutline.asp	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	emergency and risk management case studies textbook	\N	2018-05-26 20:55:39.432766	2018-05-26 21:20:41.855895
10	2	Epidemiology and Prevention of Vaccine Preventable Disease 13th ed.	http://www.cdc.gov/vaccines/pubs/pinkbook/index.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	epidemiology and prevention of vaccine preventable disease 13th ed.	\N	2018-05-26 20:55:39.447949	2018-05-26 21:20:41.868262
12	2	First Aid	http://en.wikibooks.org/wiki/First_Aid	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	first aid	\N	2018-05-26 20:55:39.485371	2018-05-26 21:20:41.898601
13	2	Fundamentals of Emergency Management	http://training.fema.gov/EMIWeb/edu/fem.asp	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	fundamentals of emergency management	\N	2018-05-26 20:55:39.499603	2018-05-26 21:20:41.911649
15	2	Health Education	http://cnx.org/content/col10330/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	health education	\N	2018-05-26 20:55:39.528898	2018-05-26 21:20:41.937092
16	2	Health is Everywhere: Unraveling the Mystery of Health	http://www.open.edu/openlearn/health-sports-psychology/health/health-studies/health-everywhere-unravelling-the-mystery-health/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	health is everywhere: unraveling the mystery of health	\N	2018-05-26 20:55:39.54303	2018-05-26 21:20:41.948763
17	2	Integrated Safety, Health and Environmental Management: An Introduction	http://openlearn.open.ac.uk/course/view.php?id=3303	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	integrated safety, health and environmental management: an introduction	\N	2018-05-26 20:55:39.558294	2018-05-26 21:20:41.962668
18	2	International Journal of Mass Emergency and Disasters 1983-2002	https://training.fema.gov/hiedu/aemrc/booksdownload/ijmems/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	international journal of mass emergency and disasters 1983-2002	\N	2018-05-26 20:55:39.57274	2018-05-26 21:20:41.975614
19	2	Issues in Complementary and Alternative Medicine	http://www.open.edu/openlearn/health-sports-psychology/health/health-studies/issues-complementary-and-alternative-medicine/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	issues in complementary and alternative medicine	\N	2018-05-26 20:55:39.589901	2018-05-26 21:20:41.988962
20	2	Medical Knowledge Base	http://www.ganfyd.org/index.php?title=Textbook	\N	\N	Custom	http://www.ganfyd.org/deeds/commons.html	CUSTOM	medical knowledge base	\N	2018-05-26 20:55:39.603944	2018-05-26 21:20:42.001822
21	2	Medicine Transformed: On Access to Health Care	http://www.open.edu/openlearn/history-the-arts/history/history-science-technology-and-medicine/history-medicine/medicine-transformed-on-access-healthcare/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	medicine transformed: on access to health care	\N	2018-05-26 20:55:39.620526	2018-05-26 21:20:42.015321
22	2	Nutrition: Proteins	http://openlearn.open.ac.uk/course/view.php?id=1605	\N	http://www.newcotorg.cot.education/health-nursing-reviews/#nutr_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	nutrition: proteins	\N	2018-05-26 20:55:39.635168	2018-05-26 21:20:42.028868
23	2	Obesity: Balanced Diets and Treatment	http://www.open.edu/openlearn/science-maths-technology/biology/obesity-balanced-diets-and-treatment/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	obesity: balanced diets and treatment	\N	2018-05-26 20:55:39.657142	2018-05-26 21:20:42.041911
24	2	Public Health	http://www.healthknowledge.org.uk/public-health-textbook	\N	\N	Custom	https://www.healthknowledge.org.uk/about-us/terms-and-conditions	CUSTOM	public health	\N	2018-05-26 20:55:39.674607	2018-05-26 21:20:42.055628
25	2	Understanding Cardiovascular Diseases	http://openlearn.open.ac.uk/course/view.php?id=3928	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	understanding cardiovascular diseases	\N	2018-05-26 20:55:39.690225	2018-05-26 21:20:42.071838
26	2	Vaccination	http://openlearn.open.ac.uk/course/view.php?id=2642	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	vaccination	\N	2018-05-26 20:55:39.704373	2018-05-26 21:20:42.083712
28	2	Accounting Principles: A Business Perspective	https://open.bccampus.ca/find-open-textbooks/?uuid=fa667d22-26c7-487e-8d75-0e57ef8eece7	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	accounting principles: a business perspective	\N	2018-05-26 20:55:39.756046	2018-05-26 21:20:42.112528
27	2	Accounting	https://www.boundless.com/accounting/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	accounting	\N	2018-05-26 20:55:39.737133	2018-05-26 21:20:42.097389
29	2	Corporate Finance, 2nd ed.	http://book.ivo-welch.info/	\N	\N	Custom	http://book.ivo-welch.info/ed3/	CUSTOM	corporate finance, 2nd ed.	\N	2018-05-26 20:55:39.777769	2018-05-26 21:20:42.131353
30	2	Finance	https://www.boundless.com/finance/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	finance	\N	2018-05-26 20:55:39.791072	2018-05-26 21:20:42.144678
1	2	Active Healthy Lifestyles	http://www.open.edu/openlearn/health-sports-psychology/health/sport-and-fitness/physical-fitness/active-healthy-lifestyles/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	active healthy lifestyles	\N	2018-05-26 20:55:39.166977	2018-05-26 21:20:41.714251
32	2	Historical Beginnings...The Federal Reserve	https://www.bostonfed.org/publications/economic-education/historical-beginnings.aspx	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	historical beginnings...the federal reserve	\N	2018-05-26 20:55:39.822415	2018-05-26 21:20:42.174413
34	2	Intermediate Financial Accounting Volume 2	http://lyryx.com/products/accounting/intermediate-financial-accounting-volume-2/	http://lyryx.com/products/accounting/intermediate-financial-accounting-volume-2/	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	intermediate financial accounting volume 2	\N	2018-05-26 20:55:39.858791	2018-05-26 21:20:42.203198
35	2	International Finance: Theory and Policy	http://catalog.flatworldknowledge.com/catalog/editions/suranfin-international-finance-theory-and-policy-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	international finance: theory and policy	\N	2018-05-26 20:55:39.877224	2018-05-26 21:20:42.220271
37	2	Introduction to Economic Analysis	http://catalog.flatworldknowledge.com/catalog/editions/mcafee-introduction-to-economic-analysis-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	introduction to economic analysis	\N	2018-05-26 20:55:39.904312	2018-05-26 21:20:42.246318
38	2	Introducation to Financial Accounting	http://lyryx.com/products/accounting/introduction-financial-accounting/	http://lyryx.com/products/accounting/introduction-financial-accounting/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introducation to financial accounting	\N	2018-05-26 20:55:39.924314	2018-05-26 21:20:42.264156
40	2	Management Accounting Concepts and Techniques	http://www.introtocost.info/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	management accounting concepts and techniques	\N	2018-05-26 20:55:39.960921	2018-05-26 21:20:42.293598
41	2	Money and Banking	http://catalog.flatworldknowledge.com/catalog/editions/wright_2-0-money-and-banking-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	money and banking	\N	2018-05-26 20:55:39.974681	2018-05-26 21:20:42.306584
42	2	Money, Banking, and International Finance	http://www.ken-szulczyk.com/money_and_banking_book.html	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	money, banking, and international finance	\N	2018-05-26 20:55:39.9891	2018-05-26 21:20:42.318598
43	2	Personal Finance v. 1.1	http://catalog.flatworldknowledge.com/catalog/editions/siegel_1_1-personal-finance-1-1	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	personal finance v. 1.1	\N	2018-05-26 20:55:40.003934	2018-05-26 21:20:42.331
44	2	Principles of Accounting	http://www.principlesofaccounting.com/	\N	\N	Custom	http://www.principlesofaccounting.com/terms/	CUSTOM	principles of accounting	\N	2018-05-26 20:55:40.020974	2018-05-26 21:20:42.347981
45	2	AC Electrical Circuits - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ac electrical circuits - laboratory manual	\N	2018-05-26 20:55:40.049072	2018-05-26 21:20:42.366442
46	2	Communication Systems	http://en.wikibooks.org/wiki/Communication_Systems	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	communication systems	\N	2018-05-26 20:55:40.062859	2018-05-26 21:20:42.378359
47	2	Computer Programming with Python and Multisim - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	computer programming with python and multisim - laboratory manual	\N	2018-05-26 20:55:40.075412	2018-05-26 21:20:42.391689
48	2	Data Coding Theory	http://en.wikibooks.org/wiki/Data_Coding_Theory	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	data coding theory	\N	2018-05-26 20:55:40.087844	2018-05-26 21:20:42.404797
49	2	DC Electrical Circuits - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	dc electrical circuits - laboratory manual	\N	2018-05-26 20:55:40.102472	2018-05-26 21:20:42.418133
50	2	Digital Circuit Projects: An Overview of Digital Circuits Through Implementing Integrated Circuits	http://cupola.gettysburg.edu/oer/1/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	digital circuit projects: an overview of digital circuits through implementing integrated circuits	\N	2018-05-26 20:55:40.115247	2018-05-26 21:20:42.430593
51	2	Discrete Time Signals and Systems	https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-003-signals-and-systems-fall-2011/readings/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	discrete time signals and systems	\N	2018-05-26 20:55:40.128216	2018-05-26 21:20:42.443803
52	2	Electronics	https://oer.avu.org/handle/123456789/25	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	electronics	\N	2018-05-26 20:55:40.145189	2018-05-26 21:20:42.460498
53	2	Embedded Controllers Using C and Arduino - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	embedded controllers using c and arduino - laboratory manual	\N	2018-05-26 20:55:40.157857	2018-05-26 21:20:42.473115
54	2	A First Course in Electrical and Computer Engineering	http://cnx.org/content/col10685/latest/	\N	http://www.newcotorg.cot.education/engineering-electronics-reviews/#first_course_ece_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	a first course in electrical and computer engineering	\N	2018-05-26 20:55:40.170365	2018-05-26 21:20:42.485176
55	2	Fundamentals of Compressible Flow Mechanics	http://www.potto.org/downloadsGD.php	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	fundamentals of compressible flow mechanics	\N	2018-05-26 20:55:40.183025	2018-05-26 21:20:42.498072
56	2	Fundamentals of Die Casting Design	http://www.potto.org/downloadsDC.php	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	fundamentals of die casting design	\N	2018-05-26 20:55:40.196903	2018-05-26 21:20:42.511255
57	2	Fundamentals of Electrical Engineering I	http://cnx.org/content/col10040/latest/	\N	http://www.newcotorg.cot.education/engineering-electronics-reviews/#fund_ee_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	fundamentals of electrical engineering i	\N	2018-05-26 20:55:40.210636	2018-05-26 21:20:42.524318
58	2	Implementing a One Address CPU in Logisim	http://cupola.gettysburg.edu/oer/3/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	implementing a one address cpu in logisim	\N	2018-05-26 20:55:40.223743	2018-05-26 21:20:42.536931
59	2	Introduction to Physical Electronics	http://cnx.org/content/col10114/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to physical electronics	\N	2018-05-26 20:55:40.237296	2018-05-26 21:20:42.548766
101	2	Project Management: from Simple to Complex v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/preston-project-management-from-simple-to-complex-1-0	\N	http://www.newcotorg.cot.education/business-reviews/#proj_mgmt_d&p_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	project management: from simple to complex v. 1.0	\N	2018-05-26 20:55:40.932872	2018-05-26 21:20:43.175535
61	2	Lessons in Electric Circuits, Vol I DC	http://www.ibiblio.org/kuphaldt/electricCircuits/DC/index.html	\N	http://www.newcotorg.cot.education/engineering-electronics-reviews/#lessons_ec_review	Custom	http://www.ibiblio.org/kuphaldt/electricCircuits/DC/DC_A3.html	CUSTOM	lessons in electric circuits, vol i dc	\N	2018-05-26 20:55:40.267945	2018-05-26 21:20:42.573443
62	2	Mechanics of Materials - Advanced	http://madhuvable.org/books-2/advanced/	http://madhuvable.org/free-downloads/advanced/	\N	Custom	http://madhuvable.org/free-downloads/advanced/	CUSTOM	mechanics of materials - advanced	\N	2018-05-26 20:55:40.281131	2018-05-26 21:20:42.586197
63	2	Mechanics of Materials - Intermediate	http://madhuvable.org/books-2/intermediate/	http://madhuvable.org/free-downloads/intermediate/	\N	Custom	http://madhuvable.org/free-downloads/intermediate/	CUSTOM	mechanics of materials - intermediate	\N	2018-05-26 20:55:40.295743	2018-05-26 21:20:42.599184
64	2	Mechanics of Materials - Introductory	http://madhuvable.org/books-2/introduction/	http://madhuvable.org/free-downloads/introduction/	http://www.newcotorg.cot.education/engineering-electronics-reviews/#mech_mat_review	Custom	http://madhuvable.org/books-2/introduction/	CUSTOM	mechanics of materials - introductory	\N	2018-05-26 20:55:40.308199	2018-05-26 21:20:42.61125
66	2	Science of Sound - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	science of sound - laboratory manual	\N	2018-05-26 20:55:40.336152	2018-05-26 21:20:42.636476
67	2	Semiconductor Devices: Theory and Application - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	semiconductor devices: theory and application - laboratory manual	\N	2018-05-26 20:55:40.348375	2018-05-26 21:20:42.648868
72	2	The Business Ethics Workshop v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/brusseau_2_0-the-business-ethics-workshop-2-0	\N	\N	Custom	http://www.flatworldknowledge.com/legal	CUSTOM	the business ethics workshop v. 2.0	\N	2018-05-26 20:55:40.434321	2018-05-26 21:20:42.726263
68	2	Business	https://www.boundless.com/business/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	business	\N	2018-05-26 20:55:40.378613	2018-05-26 21:20:42.666645
75	2	Core Concepts of Marketing	http://archive.org/details/ost-business-core-concepts-of-marketing	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	core concepts of marketing	\N	2018-05-26 20:55:40.474312	2018-05-26 21:20:42.767716
71	2	Business Ethics	http://cnx.org/content/col10491/latest/	\N	http://www.newcotorg.cot.education/business-reviews/#bus_ethics_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	business ethics	\N	2018-05-26 20:55:40.417867	2018-05-26 21:20:42.706038
73	2	Business Fundamentals	http://cnx.org/content/col11227/latest/	\N	http://www.newcotorg.cot.education/business-reviews/#bus_fundamentals_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	business fundamentals	\N	2018-05-26 20:55:40.447823	2018-05-26 21:20:42.73902
77	2	Electronic Commerce: The Strategic Perspective (2nd ed.)	http://florida.theorangegrove.org/og/file/29589c3c-8bcd-72c1-b2f2-37789232eb3c/1/Electronic_Commerce.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	electronic commerce: the strategic perspective (2nd ed.)	\N	2018-05-26 20:55:40.499557	2018-05-26 21:20:42.798518
60	2	Laboratory Manual for Linear Electronics	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	laboratory manual for linear electronics	\N	2018-05-26 20:55:40.251208	2018-05-26 21:20:42.561451
76	2	Democratizing Innovation	http://web.mit.edu/evhippel/www/democ1.htm	\N	http://www.newcotorg.cot.education/business-reviews/#democratizing_innov_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	democratizing innovation	\N	2018-05-26 20:55:40.486944	2018-05-26 21:20:42.78633
78	2	Ethics and Economy: After Levinas	http://mayflybooks.org/?page_id=19	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	ethics and economy: after levinas	\N	2018-05-26 20:55:40.523373	2018-05-26 21:20:42.820951
79	2	eMarketing: The Essential Guide to Online Marketing	http://catalog.flatworldknowledge.com/catalog/editions/quirk-emarketing-the-essential-guide-to-online-marketing-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	emarketing: the essential guide to online marketing	\N	2018-05-26 20:55:40.536406	2018-05-26 21:20:42.834239
80	2	Entrepreneurial Behavior	http://openlearn.open.ac.uk/course/view.php?id=3038	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	entrepreneurial behavior	\N	2018-05-26 20:55:40.54982	2018-05-26 21:20:42.847411
81	2	Exploring Business v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/collins-exploring-business-1-0	\N	http://www.newcotorg.cot.education/business-reviews/#exploring_bus_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	exploring business v. 1.0	\N	2018-05-26 20:55:40.56609	2018-05-26 21:20:42.860939
82	2	Exploring Business v. 2.1	http://catalog.flatworldknowledge.com/catalog/editions/collins_2_1-exploring-business-2-1	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	exploring business v. 2.1	\N	2018-05-26 20:55:40.579518	2018-05-26 21:20:42.873871
83	2	Green IS: Building Sustainable Business Practices	http://www.ceport.com/files/file/Green%20IS%20CePORT%20Article.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	green is: building sustainable business practices	\N	2018-05-26 20:55:40.593431	2018-05-26 21:20:42.88685
84	2	Industrial Organization a Contract Based Approach	https://archive.org/details/ost-business-boccard_industrialorg	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	industrial organization a contract based approach	\N	2018-05-26 20:55:40.607391	2018-05-26 21:20:42.899236
85	2	Innovation Happens Elsewhere	http://www.dreamsongs.com/IHE/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	innovation happens elsewhere	\N	2018-05-26 20:55:40.620524	2018-05-26 21:20:42.911936
173	2	College Algebra	https://openstax.org/details/college-algebra	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	college algebra	\N	2018-05-26 20:55:42.127126	2018-05-26 21:20:44.288871
74	2	Communication Skills for Personal and Professional Development: The Seven Challenges Approach	http://cnx.org/contents/BWdaLGOk@2.2:0PlKUXZf@1	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	communication skills for personal and professional development: the seven challenges approach	\N	2018-05-26 20:55:40.4605	2018-05-26 20:55:47.472939
172	2	CK-12 Trigonometry	http://cafreetextbooks.ck12.org/math/CK12_Trigonometry.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ck-12 trigonometry	\N	2018-05-26 20:55:42.111197	2018-05-26 21:20:44.272387
89	2	Managing Groups and Teams	http://en.wikibooks.org/wiki/Managing_Groups_and_Teams	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	managing groups and teams	\N	2018-05-26 20:55:40.688643	2018-05-26 21:20:42.97342
88	2	Management	https://www.boundless.com/management/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	management	\N	2018-05-26 20:55:40.675544	2018-05-26 21:20:42.960598
90	2	The Market-Led Organisation	http://openlearn.open.ac.uk/course/view.php?id=1651	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the market-led organisation	\N	2018-05-26 20:55:40.705662	2018-05-26 21:20:42.986106
92	2	Organizational Behavior v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/bauer_2-0-organizational-behavior-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	organizational behavior v. 2.0	\N	2018-05-26 20:55:40.73822	2018-05-26 21:20:43.01252
91	2	Marketing	https://www.boundless.com/marketing/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	marketing	\N	2018-05-26 20:55:40.720378	2018-05-26 21:20:42.999258
93	2	Planning a Project	http://www.open.edu/openlearn/money-management/management/business-studies/planning-project/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	planning a project	\N	2018-05-26 20:55:40.758856	2018-05-26 21:20:43.029409
94	2	Preparing a Project	http://www.open.edu/openlearn/money-management/management/business-studies/preparing-project/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	preparing a project	\N	2018-05-26 20:55:40.773979	2018-05-26 21:20:43.042096
95	2	Principles of Entrepreneurship	http://iipdigital.usembassy.gov/st/english/publication/2011/07/20110727111003su0.1185528.html#axzz39kNOfQ4I	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	principles of entrepreneurship	\N	2018-05-26 20:55:40.79258	2018-05-26 21:20:43.055087
96	2	The Principles of Management v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/carpenter-principles-of-management-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	the principles of management v. 1.0	\N	2018-05-26 20:55:40.80621	2018-05-26 21:20:43.067742
100	2	Project Management for Scientists and Engineers	http://cnx.org/content/col11120/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	project management for scientists and engineers	\N	2018-05-26 20:55:40.916698	2018-05-26 21:20:43.158278
102	2	Project Management: from Simple to Complex v. 1.1	http://catalog.flatworldknowledge.com/catalog/editions/preston_1-1-project-management-from-simple-to-complex-1-1	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	project management: from simple to complex v. 1.1	\N	2018-05-26 20:55:40.949151	2018-05-26 21:20:43.191836
104	2	Risk Management for Enterprises and Individuals	http://www.flatworldknowledge.com/printed-book/1635	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	risk management for enterprises and individuals	\N	2018-05-26 20:55:40.98827	2018-05-26 21:20:43.221775
105	2	Six Steps to Job Search Success	http://catalog.flatworldknowledge.com/catalog/editions/412	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	six steps to job search success	\N	2018-05-26 20:55:41.009308	2018-05-26 21:20:43.243322
106	2	Social Marketing	http://openlearn.open.ac.uk/course/view.php?id=3734	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	social marketing	\N	2018-05-26 20:55:41.035363	2018-05-26 21:20:43.260684
107	2	Sustainability, Innovation, and Entrepreneurship	http://www.flatworldknowledge.com/printed-book/1637	\N	http://www.newcotorg.cot.education/business-reviews/#sust_inno_entr_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	sustainability, innovation, and entrepreneurship	\N	2018-05-26 20:55:41.050733	2018-05-26 21:20:43.274005
108	2	The Legal and Ethical Environment of Business v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/lau_2_0-the-legal-and-ethical-environment-of-business-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	the legal and ethical environment of business v. 2.0	\N	2018-05-26 20:55:41.064816	2018-05-26 21:20:43.286747
109	2	Tourism The International Business	http://dl.dropbox.com/u/31779972/Tourism%20The%20International%20Business.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	tourism the international business	\N	2018-05-26 20:55:41.081333	2018-05-26 21:20:43.310136
110	2	Atomic Physics	https://oer.avu.org/handle/123456789/23	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	atomic physics	\N	2018-05-26 20:55:41.106598	2018-05-26 21:20:43.324247
111	2	Calculus-Based Physics	http://www.anselm.edu/internet/physics/cbphysics/index.html	\N	http://www.newcotorg.cot.education/physics-reviews/#calc_phys_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	calculus-based physics	\N	2018-05-26 20:55:41.119309	2018-05-26 21:20:43.335809
112	2	Chaos: Classical and Quantum	http://chaosbook.org/	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	chaos: classical and quantum	\N	2018-05-26 20:55:41.131197	2018-05-26 21:20:43.347196
113	2	College Physics	http://openstaxcollege.org/textbooks/college-physics	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	college physics	\N	2018-05-26 20:55:41.144983	2018-05-26 21:20:43.358349
115	2	Conceptual Physics	http://www.lightandmatter.com/cp/index.html	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	conceptual physics	\N	2018-05-26 20:55:41.198798	2018-05-26 21:20:43.414211
114	2	College Physics for AP Courses	https://openstax.org/details/college-physics-ap-courses	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	college physics for ap courses	\N	2018-05-26 20:55:41.167841	2018-05-26 21:20:43.383038
116	2	Electricity and Magnetism	https://oer.avu.org/handle/123456789/24	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	electricity and magnetism	\N	2018-05-26 20:55:41.211508	2018-05-26 21:20:43.427397
117	2	Electricity and Magnetism 2	https://oer.avu.org/handle/123456789/150	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	electricity and magnetism 2	\N	2018-05-26 20:55:41.224186	2018-05-26 21:20:43.440081
118	2	FHSST Physics	http://en.wikibooks.org/wiki/FHSST_Physics	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	fhsst physics	\N	2018-05-26 20:55:41.237	2018-05-26 21:20:43.452312
174	2	College Algebra 	http://www.stitz-zeager.com/szca07042013.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	college algebra 	\N	2018-05-26 20:55:42.163057	2018-05-26 21:20:44.328033
98	2	Project Management	http://open.bccampus.ca/find-open-textbooks/?uuid=8678fbae-6724-454c-a796-3c6667d826be	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	project management	\N	2018-05-26 20:55:40.867072	2018-05-26 20:55:40.884727
99	2	Project Management Skills for All Careers - 2nd edition	http://www.academicpub.com/projectmanagementskills.html	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	project management skills for all careers - 2nd edition	\N	2018-05-26 20:55:40.897031	2018-05-26 21:20:43.141881
205	2	Linear Algebra with Applications	https://lyryx.com/products/mathematics/linear-algebra-applications/	https://lyryx.com/products/mathematics/linear-algebra-applications/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	linear algebra with applications	\N	2018-05-26 20:55:42.714951	2018-05-26 21:20:44.868204
120	2	Geometrical Optics and Physical Optics	https://oer.avu.org/handle/123456789/58	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	geometrical optics and physical optics	\N	2018-05-26 20:55:41.263248	2018-05-26 21:20:43.477329
122	2	Light and Matter	http://www.lightandmatter.com/lm/	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	light and matter	\N	2018-05-26 20:55:41.297548	2018-05-26 21:20:43.505363
119	2	General Relativity	http://www.lightandmatter.com/genrel/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	general relativity	\N	2018-05-26 20:55:41.250018	2018-05-26 21:20:43.465219
123	2	Mathematical Physics 1	https://oer.avu.org/handle/123456789/251	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	mathematical physics 1	\N	2018-05-26 20:55:41.315569	2018-05-26 21:20:43.517643
124	2	Mathematical Physics 2	https://oer.avu.org/handle/123456789/56	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	mathematical physics 2	\N	2018-05-26 20:55:41.335044	2018-05-26 21:20:43.53042
126	2	Mechanics 1	https://oer.avu.org/handle/123456789/151	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	mechanics 1	\N	2018-05-26 20:55:41.379377	2018-05-26 21:20:43.568132
127	2	Mechanics II	https://oer.avu.org/handle/123456789/57	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	mechanics ii	\N	2018-05-26 20:55:41.392496	2018-05-26 21:20:43.580752
129	2	Nuclear Physics	https://oer.avu.org/handle/123456789/26	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	nuclear physics	\N	2018-05-26 20:55:41.422047	2018-05-26 21:20:43.605955
130	2	Physics for K-12	http://cnx.org/content/col10322/1.175	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	physics for k-12	\N	2018-05-26 20:55:41.436645	2018-05-26 21:20:43.619497
132	2	Problems in Introductory Physics	http://www.lightandmatter.com/problems/	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	problems in introductory physics	\N	2018-05-26 20:55:41.461905	2018-05-26 21:20:43.645468
133	2	Properties of Matter	https://oer.avu.org/handle/123456789/27	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	properties of matter	\N	2018-05-26 20:55:41.473722	2018-05-26 21:20:43.657093
134	2	Quantum Mechanics	https://oer.avu.org/handle/123456789/59	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	quantum mechanics	\N	2018-05-26 20:55:41.486145	2018-05-26 21:20:43.668421
135	2	A Radically Modern Approach to Introductory Physics - Vol. 1	https://florida.theorangegrove.org/og/items/68e10bba-1ba4-7ba0-dc7b-4bfa59bd8ea8/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	a radically modern approach to introductory physics - vol. 1	\N	2018-05-26 20:55:41.502528	2018-05-26 21:20:43.680168
136	2	A Radically Modern Approach to Introductory Physics - Vol. 2	https://florida.theorangegrove.org/og/items/91615c2e-fd3e-f43f-290f-fa8fe3b22b11/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	a radically modern approach to introductory physics - vol. 2	\N	2018-05-26 20:55:41.517416	2018-05-26 21:20:43.691494
137	2	Relativity for Poets	http://www.lightandmatter.com/poets/	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	relativity for poets	\N	2018-05-26 20:55:41.529786	2018-05-26 21:20:43.703579
138	2	The Restless Universe	http://openlearn.open.ac.uk/course/view.php?id=3267	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the restless universe	\N	2018-05-26 20:55:41.542174	2018-05-26 21:20:43.715145
139	2	Simple Nature	http://www.lightandmatter.com/area1sn.html	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	simple nature	\N	2018-05-26 20:55:41.55432	2018-05-26 21:20:43.726402
140	2	Solid State Physics	https://oer.avu.org/handle/123456789/28	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	solid state physics	\N	2018-05-26 20:55:41.566436	2018-05-26 21:20:43.737898
141	2	Statistical Physics	https://oer.avu.org/handle/123456789/29	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	statistical physics	\N	2018-05-26 20:55:41.578436	2018-05-26 21:20:43.749319
142	2	Special Relativity	http://www.lightandmatter.com/sr/	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	special relativity	\N	2018-05-26 20:55:41.591707	2018-05-26 21:20:43.761044
143	2	Thermal Physics	https://oer.avu.org/handle/123456789/31	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	thermal physics	\N	2018-05-26 20:55:41.603653	2018-05-26 21:20:43.772599
144	2	Abstract Algebra: Theory and Applications	http://abstract.ups.edu/	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	abstract algebra: theory and applications	\N	2018-05-26 20:55:41.642622	2018-05-26 21:20:43.794465
145	2	Advanced Algebra II: Conceptual	http://cnx.org/content/col10624/latest/	\N	\N	Explanations	http://cnx.org/content/col10624/latest/	EXPLANATIONS	advanced algebra ii: conceptual	\N	2018-05-26 20:55:41.655283	2018-05-26 21:20:43.805992
146	2	Advanced Algebra II: Activities and Homework	http://cnx.org/content/col10686/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	advanced algebra ii: activities and homework	\N	2018-05-26 20:55:41.667415	2018-05-26 21:20:43.817852
147	2	AAdvanced Problems in Mathematics: Preparing for University	https://www.openbookpublishers.com/product/342	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	aadvanced problems in mathematics: preparing for university	\N	2018-05-26 20:55:41.679342	2018-05-26 21:20:43.829032
149	2	Algebra and Trigonometry	https://www.openstaxcollege.org/textbooks/algebra-and-trigonometry	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	algebra and trigonometry	\N	2018-05-26 20:55:41.703326	2018-05-26 21:20:43.852696
150	2	Algebra is Vital	http://www2.sunysuffolk.edu/buckl/Table%20of%20Contents.htm	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	algebra is vital	\N	2018-05-26 20:55:41.740588	2018-05-26 21:20:43.890388
148	2	Algebra	https://www.boundless.com/algebra/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	algebra	\N	2018-05-26 20:55:41.691224	2018-05-26 21:20:43.84089
151	2	Algebra Review	http://www.geogebra.org/en/wiki/index.php/Self-Assess_Algebra_Review	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	algebra review	\N	2018-05-26 20:55:41.753169	2018-05-26 21:20:43.903477
152	2	Analysis 1	http://oer.avu.org/handle/123456789/14	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	analysis 1	\N	2018-05-26 20:55:41.765109	2018-05-26 21:20:43.916336
153	2	Analysis 2	https://oer.avu.org/handle/123456789/274	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	analysis 2	\N	2018-05-26 20:55:41.777234	2018-05-26 21:20:43.928187
154	2	APEX Calculus	http://www.apexcalculus.com	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	apex calculus	\N	2018-05-26 20:55:41.789305	2018-05-26 21:20:43.941499
272	2	The Theory and Practice of Online Learning, Second Edition	http://cde.athabascau.ca/online_book/second_edition.html	\N	http://www.newcotorg.cot.education/education-reviews#online_learning_review	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	the theory and practice of online learning, second edition	\N	2018-05-26 20:55:43.836116	2018-05-26 21:20:45.890076
157	2	Basic Algebra	http://en.wikibooks.org/wiki/Basic_Algebra	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	basic algebra	\N	2018-05-26 20:55:41.843179	2018-05-26 21:20:43.996013
159	2	Basic Arithmetic Student Handbook	http://sccmath.files.wordpress.com/2013/04/082_final_wkbook__2nded.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	basic arithmetic student handbook	\N	2018-05-26 20:55:41.867444	2018-05-26 21:20:44.020867
160	2	Basic Math Textbook for the Community College	http://cnx.org/content/col10726/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	basic math textbook for the community college	\N	2018-05-26 20:55:41.883695	2018-05-26 21:20:44.040032
161	2	Basic Mathematics	http://oer.avu.org/handle/123456789/18	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	basic mathematics	\N	2018-05-26 20:55:41.895742	2018-05-26 21:20:44.052481
162	2	Book of Proofs	http://www.bookofproofs.org/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	book of proofs	\N	2018-05-26 20:55:41.908179	2018-05-26 21:20:44.065842
163	2	Brief Calculus	http://www.lightandmatter.com/calc/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	brief calculus	\N	2018-05-26 20:55:41.920106	2018-05-26 21:20:44.078616
164	2	Calculus	http://florida.theorangegrove.org/og/items/91a188c0-1d3a-4fe4-bae2-54fb03b06560/1/?tempwn.b=access%2Fsearch.do%3Fpg.e%3Dtrue%26pg_pp%3D10%26pg_pg%3D1%26hier.topic%3Dd37c6ed5-3822-84a6-721c-6d9033a88541%26qs.tq%3D%26sort_s%3DRANK%26she_canDisplay%3Dchecked	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	calculus	\N	2018-05-26 20:55:41.931994	2018-05-26 20:55:41.944931
166	2	Calculus Volume 2	https://openstax.org/details/calculus-volume-2	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	calculus volume 2	\N	2018-05-26 20:55:41.98738	2018-05-26 21:20:44.152985
167	2	Calculus Volume 3	https://openstax.org/details/calculus-volume-3	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	calculus volume 3	\N	2018-05-26 20:55:42.003238	2018-05-26 21:20:44.17414
168	2	Calculus: Early Transcendentals	http://lyryx.com/products/mathematics/calculus-early-transcendentals/	http://lyryx.com/products/mathematics/calculus-early-transcendentals/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	calculus: early transcendentals	\N	2018-05-26 20:55:42.022962	2018-05-26 21:20:44.188781
175	2	College Trigonometry	http://www.stitz-zeager.com/szct07042013.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	college trigonometry	\N	2018-05-26 20:55:42.17822	2018-05-26 21:20:44.344025
169	2	CK-12 Algebra I	http://www.ck12.org/book/CK-12-Algebra-I-Second-Edition/r17/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	ck-12 algebra i	\N	2018-05-26 20:55:42.035614	2018-05-26 21:20:44.2002
170	2	CK-12 Single Variable Calculus	http://cafreetextbooks.ck12.org/math/CK12_Calculus.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ck-12 single variable calculus	\N	2018-05-26 20:55:42.061772	2018-05-26 21:20:44.225026
171	2	CK-12 Geometry	http://cafreetextbooks.ck12.org/math/CK12_Geometry.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ck-12 geometry	\N	2018-05-26 20:55:42.084722	2018-05-26 21:20:44.247354
177	2	Diagrams, Charts and Graphs	http://openlearn.open.ac.uk/course/view.php?id=3364	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	diagrams, charts and graphs	\N	2018-05-26 20:55:42.205775	2018-05-26 21:20:44.372362
178	2	Difference Equations to Differential Equations	http://synechism.org/drupal/de2de/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	difference equations to differential equations	\N	2018-05-26 20:55:42.217965	2018-05-26 21:20:44.383863
179	2	Differential Equations	http://oer.avu.org/handle/123456789/15	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	differential equations	\N	2018-05-26 20:55:42.230139	2018-05-26 21:20:44.39514
180	2	Dimensions	http://www.dimensions-math.org/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	dimensions	\N	2018-05-26 20:55:42.242162	2018-05-26 21:20:44.407723
181	2	Discrete Mathematics, An Open Introduction	http://discretetext.oscarlevin.com/home.php	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	discrete mathematics, an open introduction	\N	2018-05-26 20:55:42.2643	2018-05-26 21:20:44.42683
184	2	Elementary Differential Equations	http://digitalcommons.trinity.edu/mono/8/	http://digitalcommons.trinity.edu/mono/10/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	elementary differential equations	\N	2018-05-26 20:55:42.31844	2018-05-26 21:20:44.486519
185	2	Elementary Differential Equations with Boundary Value Problems	http://digitalcommons.trinity.edu/mono/9/	http://digitalcommons.trinity.edu/mono/10/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	elementary differential equations with boundary value problems	\N	2018-05-26 20:55:42.33102	2018-05-26 21:20:44.499499
186	2	Elementary Linear Algebra	http://www.saylor.org/courses/ma211/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	elementary linear algebra	\N	2018-05-26 20:55:42.343101	2018-05-26 21:20:44.511583
188	2	The Essential Elementary & Intermediate Algebra	http://www.jonblakely.com/text-book/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the essential elementary & intermediate algebra	\N	2018-05-26 20:55:42.373631	2018-05-26 21:20:44.538309
289	2	Econometrics	http://www.ssc.wisc.edu/~bhansen/econometrics	\N	\N	Custom	http://www.ssc.wisc.edu/~bhansen/econometrics/	CUSTOM	econometrics	\N	2018-05-26 20:55:44.116183	2018-05-26 21:20:46.14484
290	2	Economics	https://www.boundless.com/economics/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	economics	\N	2018-05-26 20:55:44.130365	2018-05-26 21:20:46.15766
688	2	Concepts of Fitness and Wellness	https://oer.galileo.usg.edu/health-textbooks/4/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	concepts of fitness and wellness	\N	2018-11-19 19:16:29.073807	\N
156	2	Applied Finite Mathematics	http://cnx.org/content/col10613/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	applied finite mathematics	\N	2018-05-26 20:55:41.830603	2018-05-26 21:20:43.983872
165	2	Calculus Volume 1	https://openstax.org/details/calculus-volume-1	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	calculus volume 1	\N	2018-05-26 20:55:41.971054	2018-05-26 21:20:44.137091
183	2	Elementary Calculus An Approach Using Infinitesimals	http://www.math.wisc.edu/%7Ekeisler/calc.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	elementary calculus an approach using infinitesimals	\N	2018-05-26 20:55:42.305974	2018-05-26 21:20:44.473981
182	2	Elementary Algebra	http://catalog.flatworldknowledge.com/catalog/editions/redden-elementary-algebra-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	elementary algebra	\N	2018-05-26 20:55:42.276358	2018-05-26 20:55:42.293478
191	2	Fundamentals of Calculus	http://www.lightandmatter.com/fund/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	fundamentals of calculus	\N	2018-05-26 20:55:42.434939	2018-05-26 21:20:44.598008
192	2	Fundamentals of Mathematics	http://cnx.org/content/col10615/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	fundamentals of mathematics	\N	2018-05-26 20:55:42.455305	2018-05-26 21:20:44.616733
193	2	Fundamentals of Matrix Algebra	http://www.vmi.edu/content.aspx?tid=36957&id=10737419979	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	fundamentals of matrix algebra	\N	2018-05-26 20:55:42.475791	2018-05-26 21:20:44.632791
194	2	Gentle Introduction to the Arts of Mathematics	http://www.southernct.edu/~fields/GIAM/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	gentle introduction to the arts of mathematics	\N	2018-05-26 20:55:42.487965	2018-05-26 21:20:44.646446
198	2	An Introduction to Complex Numbers	http://openlearn.open.ac.uk/course/view.php?id=2819	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introduction to complex numbers	\N	2018-05-26 20:55:42.580784	2018-05-26 21:20:44.729558
199	2	Introduction to ICT	https://oer.avu.org/handle/123456789/82	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to ict	\N	2018-05-26 20:55:42.59289	2018-05-26 21:20:44.741445
200	2	An Introduction to MATLAB and Mathcad	http://www.vmi.edu/content.aspx?tid=36957&id=10737419979	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	an introduction to matlab and mathcad	\N	2018-05-26 20:55:42.604975	2018-05-26 21:20:44.75826
201	2	Introduction to Matrix Algebra	http://numericalmethods.eng.usf.edu/matrixalgebrabook/index.html	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	introduction to matrix algebra	\N	2018-05-26 20:55:42.619867	2018-05-26 21:20:44.770056
202	2	Introduction to Real Analysis	http://digitalcommons.trinity.edu/mono/7/	http://digitalcommons.trinity.edu/mono/7/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to real analysis	\N	2018-05-26 20:55:42.632103	2018-05-26 20:55:42.660759
207	2	Linear Programming	https://oer.avu.org/handle/123456789/17	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	linear programming	\N	2018-05-26 20:55:42.741379	2018-05-26 21:20:44.898753
125	2	Mechanics	http://oer.avu.org/handle/123456789/55	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	mechanics	\N	2018-05-26 20:55:41.352323	2018-05-26 20:55:41.365757
211	2	Notes on Diffy Qs: Differential Equations for Engineers	http://www.jirka.org/diffyqs/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	notes on diffy qs: differential equations for engineers	\N	2018-05-26 20:55:42.827883	2018-05-26 21:20:44.971919
212	2	Number Theory	http://oer.avu.org/handle/123456789/7	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	number theory	\N	2018-05-26 20:55:42.84031	2018-05-26 21:20:44.983776
213	2	Numbers, Units, and Arithmetic	http://openlearn.open.ac.uk/course/view.php?id=3345	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	numbers, units, and arithmetic	\N	2018-05-26 20:55:42.85264	2018-05-26 21:20:45.002496
214	2	Numerical Methods	http://oer.avu.org/handle/123456789/19	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	numerical methods	\N	2018-05-26 20:55:42.864874	2018-05-26 21:20:45.01515
215	2	Numerical Methods with Applications	http://numericalmethods.eng.usf.edu/topics/textbook_index.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	numerical methods with applications	\N	2018-05-26 20:55:42.87748	2018-05-26 21:20:45.027364
216	2	Prealgebra	https://openstax.org/details/prealgebra	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	prealgebra	\N	2018-05-26 20:55:42.899119	2018-05-26 21:20:45.045969
217	2	Prealgebra Textbook	http://msenux.redwoods.edu/PreAlgText/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	prealgebra textbook	\N	2018-05-26 20:55:42.919601	2018-05-26 21:20:45.062447
221	2	A Problem Text in Advanced Calculus	http://www.web.pdx.edu/~erdman/PTAC/problemtext_pdf.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	a problem text in advanced calculus	\N	2018-05-26 20:55:43.018817	2018-05-26 21:20:45.160607
684	2	Wellbeing, Freedom and Social Justice: The Capability Approach Re-Examined	https://www.openbookpublishers.com/product/682	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	wellbeing, freedom and social justice: the capability approach re-examined	\N	2018-06-20 16:49:05.469175	2018-06-20 16:49:07.730698
190	2	A Friendly Introduction to Differential Equations	http://www.mohammed-kaabar.net/#!books/c10nk	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	a friendly introduction to differential equations	\N	2018-05-26 20:55:42.422583	2018-05-26 21:20:44.586791
195	2	Geometry	http://oer.avu.org/handle/123456789/54	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	geometry	\N	2018-05-26 20:55:42.500908	2018-05-26 20:55:42.521973
196	2	Intermediate Algebra	http://catalog.flatworldknowledge.com/catalog/editions/reddenint-intermediate-algebra-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	intermediate algebra	\N	2018-05-26 20:55:42.534874	2018-05-26 20:55:42.568556
197	2	Intermediate Algebra Student Workbook	http://sccmath.files.wordpress.com/2013/02/mat12x_workbook_thirdedition_3-11.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	intermediate algebra student workbook	\N	2018-05-26 20:55:42.55261	2018-05-26 21:20:44.701309
203	2	Introductory Algebra Student Handbook	http://sccmath.files.wordpress.com/2013/04/09xworkbook_3rdedition.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introductory algebra student handbook	\N	2018-05-26 20:55:42.645201	2018-05-26 21:20:44.794685
204	2	Linear Algebra	http://oer.avu.org/handle/123456789/16	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	linear algebra	\N	2018-05-26 20:55:42.672798	2018-05-26 20:55:42.684796
206	2	Linear Algebra, Theory and Applications	http://www.saylor.org/courses/ma212/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	linear algebra, theory and applications	\N	2018-05-26 20:55:42.726685	2018-05-26 21:20:44.887269
208	2	Math in Society	http://dlippman.imathas.com/mathinsociety/	\N	http://www.collegeopentextbooks.org/mathematics-reviews/#math_soc_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	math in society	\N	2018-05-26 20:55:42.754812	2018-05-26 20:55:42.766841
209	2	Mathematics	http://www.themathsportal.org.za/index.php?option=com_content&view=article&id=29&Itemid=21	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	mathematics	\N	2018-05-26 20:55:42.790005	2018-05-26 21:20:44.933632
210	2	A Modern Formal Logic Primer	http://tellerprimer.ucdavis.edu/	\N	\N	Custom	http://tellerprimer.ucdavis.edu/	CUSTOM	a modern formal logic primer	\N	2018-05-26 20:55:42.814228	2018-05-26 21:20:44.958616
218	2	Precalculus	http://www.stitz-zeager.com/szprecalculus07042013.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	precalculus	\N	2018-05-26 20:55:42.938279	2018-05-26 20:55:42.975049
219	2	Precalculus: An Investigation of Functions	http://www.opentextbookstore.com/precalc/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	precalculus: an investigation of functions	\N	2018-05-26 20:55:42.991081	2018-05-26 21:20:45.131829
224	2	Real Functions and Graphs	http://openlearn.open.ac.uk/course/view.php?id=3674	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	real functions and graphs	\N	2018-05-26 20:55:43.059741	2018-05-26 21:20:45.200729
225	2	Reasonable Algebraic Functions	http://www.freemathtexts.org/Standalones/RAF/index.php	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	reasonable algebraic functions	\N	2018-05-26 20:55:43.072116	2018-05-26 21:20:45.212707
226	2	Reasonable Basic Algebra	http://www.freemathtexts.org/Standalones/RBA/index.php	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	reasonable basic algebra	\N	2018-05-26 20:55:43.084113	2018-05-26 21:20:45.225481
227	2	Reasonable Decimal Arithmetic	http://www.freemathtexts.org/Standalones/RDA/index.php	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	reasonable decimal arithmetic	\N	2018-05-26 20:55:43.096404	2018-05-26 21:20:45.237905
228	2	Rounding and Estimation	http://openlearn.open.ac.uk/course/view.php?id=3502	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	rounding and estimation	\N	2018-05-26 20:55:43.108107	2018-05-26 21:20:45.250115
229	2	Squares, Roots and Powers	http://openlearn.open.ac.uk/course/view.php?id=3391	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	squares, roots and powers	\N	2018-05-26 20:55:43.120002	2018-05-26 21:20:45.262862
233	2	Vector Calculus	http://www.mecmath.net/	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	vector calculus	\N	2018-05-26 20:55:43.178676	2018-05-26 21:20:45.324053
234	2	wxMaxima for Calculus I	https://wxmaximafor.wordpress.com/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	wxmaxima for calculus i	\N	2018-05-26 20:55:43.19035	2018-05-26 21:20:45.335948
235	2	wxMaxima for Calculus II	https://wxmaximafor.wordpress.com/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	wxmaxima for calculus ii	\N	2018-05-26 20:55:43.202274	2018-05-26 21:20:45.347847
237	2	The Art of Reading	http://solr.bccampus.ca:8001/bcc/items/2e96a34b-4ccc-f1c2-a387-81dd86a52ca7/1/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the art of reading	\N	2018-05-26 20:55:43.239964	2018-05-26 21:20:45.386744
238	2	Classroom Management and Supervision	https://oer.avu.org/handle/123456789/75	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	classroom management and supervision	\N	2018-05-26 20:55:43.257342	2018-05-26 21:20:45.4035
239	2	Cognition, Affect, and Learning	https://sites.google.com/site/barrykort/home/cognition-affect-and-learning	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cognition, affect, and learning	\N	2018-05-26 20:55:43.27142	2018-05-26 21:20:45.415772
240	2	College Success	http://catalog.flatworldknowledge.com/catalog/editions/lochhaas_2_0-college-success-2-0	\N	\N	Custom	http://www.flatworldknowledge.com/legal	CUSTOM	college success	\N	2018-05-26 20:55:43.288967	2018-05-26 21:20:45.428156
242	2	Comparative Education	https://oer.avu.org/handle/123456789/69	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	comparative education	\N	2018-05-26 20:55:43.333113	2018-05-26 21:20:45.465002
243	2	Contemporary Issues in Education	https://oer.avu.org/handle/123456789/152	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	contemporary issues in education	\N	2018-05-26 20:55:43.346968	2018-05-26 21:20:45.478267
245	2	The CU Online Handbook, 2011	http://www.ucdenver.edu/academics/CUOnline/FacultySupport/Handbook/cuonlinehandbook2011/Pages/default.aspx	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the cu online handbook, 2011	\N	2018-05-26 20:55:43.37871	2018-05-26 21:20:45.508015
236	2	Access to Knowledge: A Guide for Everyone	http://a2knetwork.org/sites/default/files/handbook/a2k-english.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	access to knowledge: a guide for everyone	\N	2018-05-26 20:55:43.222522	2018-05-26 21:20:45.370451
246	2	Curriculum Studies	https://oer.avu.org/handle/123456789/73	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	curriculum studies	\N	2018-05-26 20:55:43.409449	2018-05-26 21:20:45.538142
247	2	Distinction Through Discovery : A Research-Oriented First Year Experience	http://ufdc.ufl.edu/AA00016299/00001	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	distinction through discovery : a research-oriented first year experience	\N	2018-05-26 20:55:43.42583	2018-05-26 21:20:45.554475
248	2	Educational Communication	https://oer.avu.org/handle/123456789/76	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	educational communication	\N	2018-05-26 20:55:43.44004	2018-05-26 21:20:45.567556
249	2	Educational Evaluation and Testing	https://oer.avu.org/handle/123456789/78	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	educational evaluation and testing	\N	2018-05-26 20:55:43.456808	2018-05-26 21:20:45.584053
250	2	Educational Management	https://oer.avu.org/handle/123456789/79	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	educational management	\N	2018-05-26 20:55:43.470026	2018-05-26 21:20:45.599567
252	2	Educational Research	https://oer.avu.org/handle/123456789/80	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	educational research	\N	2018-05-26 20:55:43.500743	2018-05-26 21:20:45.626066
244	2	Copyright for Librarians	https://oer.avu.org/handle/123456789/263	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	copyright for librarians	\N	2018-05-26 20:55:43.36078	2018-05-26 21:20:45.491431
253	2	Experiencing the Humanities	http://www.collegehumanities.org/	\N	\N	Custom	http://www.collegehumanities.org/	CUSTOM	experiencing the humanities	\N	2018-05-26 20:55:43.513839	2018-05-26 21:20:45.63836
254	2	Foundations of Learning and Instructional Design Technology	https://lidtfoundations.pressbooks.com/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	foundations of learning and instructional design technology	\N	2018-05-26 20:55:43.527441	2018-05-26 21:20:45.651705
255	2	Handbook of Emerging Technologies for Learning	http://elearnspace.org/Articles/HETL.pdf	\N	\N	\N	\N	\N	handbook of emerging technologies for learning	\N	2018-05-26 20:55:43.543506	2018-05-26 21:20:45.664298
256	2	History of Education	https://oer.avu.org/handle/123456789/68	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	history of education	\N	2018-05-26 20:55:43.565998	2018-05-26 21:20:45.680478
320	2	Criminal Law	http://catalog.flatworldknowledge.com/bookhub/reader/4373	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	criminal law	\N	2018-05-26 20:55:44.698938	2018-05-26 21:20:46.681975
689	2	Physical Therapy Applications for Individuals with Neurologic Dysfunctiont	https://oer.galileo.usg.edu/health-textbooks/2/	\N	\N	CUSTOM	https://oer.galileo.usg.edu/faq.html#faq-5	CUSTOM	physical therapy applications for individuals with neurologic dysfunctiont	\N	2018-11-19 19:16:29.349828	\N
231	2	Trigonometry	http://en.wikibooks.org/wiki/Trigonometry	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	trigonometry	\N	2018-05-26 20:55:43.143577	2018-05-26 20:55:43.155333
232	2	Understanding Algebra	http://www.jamesbrennan.org/algebra/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	understanding algebra	\N	2018-05-26 20:55:43.16721	2018-05-26 21:20:45.311278
259	2	Introduction to Guidance and Counseling	https://oer.avu.org/handle/123456789/153	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to guidance and counseling	\N	2018-05-26 20:55:43.620821	2018-05-26 21:20:45.718391
261	2	Managing a School's Educational Resources	https://oer.avu.org/handle/123456789/154	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	managing a school's educational resources	\N	2018-05-26 20:55:43.648956	2018-05-26 21:20:45.748503
276	2	The Basic Elements of Music	http://cnx.org/content/col10218/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	the basic elements of music	\N	2018-05-26 20:55:43.910542	2018-05-26 21:20:45.964795
263	2	OER Handbook for Educators 1.0	http://wikieducator.org/OER_Handbook/educator_version_one	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	oer handbook for educators 1.0	\N	2018-05-26 20:55:43.680254	2018-05-26 21:20:45.77197
264	2	Open Educational Content – Introduction and Tutorials	http://www.wikieducator.org/Open_Educational_Content	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	open educational content – introduction and tutorials	\N	2018-05-26 20:55:43.697224	2018-05-26 21:20:45.784769
265	2	Philosophy of Education	https://oer.avu.org/handle/123456789/70	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	philosophy of education	\N	2018-05-26 20:55:43.712413	2018-05-26 21:20:45.798646
266	2	The Public Domain Enclosing the Commons of the Mind	http://www.thepublicdomain.org/download/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the public domain enclosing the commons of the mind	\N	2018-05-26 20:55:43.731045	2018-05-26 21:20:45.812354
267	2	Reflective Teaching	https://oer.avu.org/handle/123456789/155	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	reflective teaching	\N	2018-05-26 20:55:43.745619	2018-05-26 21:20:45.825116
268	2	Sociology of Education	https://oer.avu.org/handle/123456789/156	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	sociology of education	\N	2018-05-26 20:55:43.768895	2018-05-26 21:20:45.838558
269	2	Special Needs Education	https://oer.avu.org/handle/123456789/157	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	special needs education	\N	2018-05-26 20:55:43.783396	2018-05-26 21:20:45.851277
270	2	Study Skills	http://www2.le.ac.uk/projects/oer/oers/ssds/study-skills	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	study skills	\N	2018-05-26 20:55:43.805066	2018-05-26 21:20:45.863544
271	2	Teaching Methodology	https://oer.avu.org/handle/123456789/74	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	teaching methodology	\N	2018-05-26 20:55:43.818464	2018-05-26 21:20:45.876292
273	2	Art and Contemporary Critical Practice: Reinventing Institutional Critique	http://www.scribd.com/doc/19439530/Art-Contemporary-Critical-Practice-Reinventing-Institutional-Critique	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	art and contemporary critical practice: reinventing institutional critique	\N	2018-05-26 20:55:43.851252	2018-05-26 21:20:45.91046
274	2	Art and Design	http://www.vtstutorials.co.uk/tutorial/artanddesign/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	art and design	\N	2018-05-26 20:55:43.86856	2018-05-26 21:20:45.92676
275	2	Art History	http://en.wikibooks.org/wiki/Art_History	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	art history	\N	2018-05-26 20:55:43.88195	2018-05-26 20:55:43.897018
277	2	Digital Foundations: Introduction to Media Design with the Adobe Creative Suite	http://digital-foundations.net/	\N	http://www.newcotorg.cot.education/fine-arts-reviews/#dig_fnd_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	digital foundations: introduction to media design with the adobe creative suite	\N	2018-05-26 20:55:43.923677	2018-05-26 21:20:45.977494
278	2	Digital Foundations: Introduction to Media Design with the Adobe Creative Suite - FLOSSManuals Edition	http://write.flossmanuals.net/digital-foundations/introduction/	\N	http://www.newcotorg.cot.education/fine-arts-reviews/#dig_fnd_floss_review	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	digital foundations: introduction to media design with the adobe creative suite - flossmanuals edition	\N	2018-05-26 20:55:43.940438	2018-05-26 21:20:45.994139
279	2	Guitar	http://en.wikibooks.org/wiki/Guitar	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	guitar	\N	2018-05-26 20:55:43.957327	2018-05-26 21:20:46.010622
280	2	Introduction to Music Theory	http://cnx.org/content/col10208/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to music theory	\N	2018-05-26 20:55:43.971047	2018-05-26 21:20:46.023744
281	2	Music	http://www.vtstutorials.co.uk/Content/ContentDetail.aspx?q=CB9557A1-348E-4F46-B594-DD0B22ED062C	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	music	\N	2018-05-26 20:55:43.988285	2018-05-26 21:20:46.036186
282	2	Open Content Photography Program	http://en.wikibooks.org/wiki/OC_Photography_Program	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	open content photography program	\N	2018-05-26 20:55:44.002659	2018-05-26 21:20:46.048983
283	2	Performing Arts	http://www.vtstutorials.co.uk/tutorial/performingarts/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	performing arts	\N	2018-05-26 20:55:44.017609	2018-05-26 21:20:46.062128
284	2	Reading Music: Common Notation	http://cnx.org/content/col10209/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	reading music: common notation	\N	2018-05-26 20:55:44.032625	2018-05-26 21:20:46.074603
285	2	Smarthistory: Art History on Khan Academy	http://smarthistory.khanacademy.org/	\N	http://www.newcotorg.cot.education/fine-arts-reviews/#sm_hist_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	smarthistory: art history on khan academy	\N	2018-05-26 20:55:44.046508	2018-05-26 21:20:46.086914
286	2	Understanding Basic Music Theory	http://cnx.org/content/col10363	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	understanding basic music theory	\N	2018-05-26 20:55:44.06383	2018-05-26 21:20:46.103196
287	2	Alternative Microeconomics	https://www.textbookequity.org/reynolds-alternative-microeconomics-2006/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	alternative microeconomics	\N	2018-05-26 20:55:44.089723	2018-05-26 21:20:46.119121
288	2	Basic Microeconomics	https://www.free-ebooks.net/ebook/Basic-Microeconomics	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	basic microeconomics	\N	2018-05-26 20:55:44.101887	2018-05-26 21:20:46.131775
690	2	Principles of Nutrition	https://oer.galileo.usg.edu/health-textbooks/5/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	principles of nutrition	\N	2018-11-19 19:16:29.366917	\N
691	2	Walking and Jogging for Fitness	https://oer.galileo.usg.edu/health-textbooks/3/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	walking and jogging for fitness	\N	2018-11-19 19:16:29.422979	\N
31	2	Financial Analysis	http://www.peoi.org/Courses/Coursesen/finanal/FN501EN.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	financial analysis	\N	2018-05-26 20:55:39.807439	2018-05-26 21:20:42.162234
292	2	The Joy of Economics	http://faculty.winthrop.edu/stonebrakerr/book.htm	\N	\N	Custom	http://faculty.winthrop.edu/stonebrakerr/book.htm	CUSTOM	the joy of economics	\N	2018-05-26 20:55:44.178525	2018-05-26 21:20:46.19576
293	2	Living Economics	http://livingeconomics.org/about.asp	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	living economics	\N	2018-05-26 20:55:44.191499	2018-05-26 21:20:46.208194
294	2	Macroeconomics: Fundamentals of Economics I	http://www.peoi.org/Courses/Coursesen/mac/EC101EN.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	macroeconomics: fundamentals of economics i	\N	2018-05-26 20:55:44.204897	2018-05-26 21:20:46.21995
296	2	Microeconomics: Fundamentals of Economics II	http://www.peoi.org/Courses/Coursesen/mic/EC102EN.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	microeconomics: fundamentals of economics ii	\N	2018-05-26 20:55:44.236606	2018-05-26 21:20:46.249123
298	2	Microeconomics: Theory Through Applications	http://catalog.flatworldknowledge.com/catalog/editions/coopermicro-microeconomics-theory-through-applications-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	microeconomics: theory through applications	\N	2018-05-26 20:55:44.27324	2018-05-26 21:20:46.277532
299	2	Outline of the U.S. Economy	http://usa.usembassy.de/etexts/oecon/index.htm	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	outline of the u.s. economy	\N	2018-05-26 20:55:44.290598	2018-05-26 21:20:46.293918
300	2	Political Economy	http://en.wikibooks.org/wiki/Political_Economy/General	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	political economy	\N	2018-05-26 20:55:44.306368	2018-05-26 21:20:46.31108
304	2	Principles of Macroeconomics v. 2.1	http://catalog.flatworldknowledge.com/catalog/editions/rittenmacro_2_1-principles-of-macroeconomics-2-1	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	principles of macroeconomics v. 2.1	\N	2018-05-26 20:55:44.405745	2018-05-26 21:20:46.400135
302	2	Principles of Macroeconomics	https://openstax.org/details/principles-macroeconomics	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	principles of macroeconomics	\N	2018-05-26 20:55:44.370704	2018-05-26 20:55:44.422825
307	2	Principles of Microeconomics v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/rittenmicro_2-0-principles-of-microeconomics-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	principles of microeconomics v. 2.0	\N	2018-05-26 20:55:44.491414	2018-05-26 21:20:46.483099
305	2	Principles of Microeconomics	https://openstax.org/details/principles-microeconomics	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	principles of microeconomics	\N	2018-05-26 20:55:44.440284	2018-05-26 20:55:44.457948
309	2	Upsetting the Offset: The Political Economy of Carbon Markets	http://mayflybooks.org/?page_id=21	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	upsetting the offset: the political economy of carbon markets	\N	2018-05-26 20:55:44.541644	2018-05-26 21:20:46.528204
310	2	USA Economy in Brief	http://iipdigital.usembassy.gov/st/english/publication/2011/04/20110426155516su0.2689717.html#axzz4Ou37rVCU	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	usa economy in brief	\N	2018-05-26 20:55:44.557848	2018-05-26 21:20:46.548491
311	2	The Wealth of Networks: How Social Production Transforms Markets and Freedom	http://cyber.law.harvard.edu/wealth_of_networks/Main_Page	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the wealth of networks: how social production transforms markets and freedom	\N	2018-05-26 20:55:44.570443	2018-05-26 21:20:46.560608
312	2	Bankruptcy Law and Practice	https://www.cali.org/books/bankruptcy-law-and-practice	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	bankruptcy law and practice	\N	2018-05-26 20:55:44.594508	2018-05-26 21:20:46.57843
313	2	Basic Income Tax	https://www.cali.org/books/basic-income-tax	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	basic income tax	\N	2018-05-26 20:55:44.607411	2018-05-26 21:20:46.590715
314	2	Civil Procedure: Pleading	http://elangdell.cali.org/content/civil-procedure-pleading	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	civil procedure: pleading	\N	2018-05-26 20:55:44.622025	2018-05-26 21:20:46.602904
315	2	Computer-Aided Exercises in Civil Procedure, 7th Edition	https://www.cali.org/books/computer-aided-exercises-civil-procedure-7th-edition	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	computer-aided exercises in civil procedure, 7th edition	\N	2018-05-26 20:55:44.634003	2018-05-26 21:20:46.615019
316	2	Contract Doctrine, Theory, and Practice - Volume One	https://www.cali.org/books/contract-doctrine-theory-practice-volume-1	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	contract doctrine, theory, and practice - volume one	\N	2018-05-26 20:55:44.649747	2018-05-26 21:20:46.631884
317	2	Contract Doctrine, Theory, and Practice - Volume Two	https://www.cali.org/books/contract-doctrine-theory-practice-volume-2	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	contract doctrine, theory, and practice - volume two	\N	2018-05-26 20:55:44.663141	2018-05-26 21:20:46.644764
318	2	Contract Doctrine, Theory, and Practice - Volume Three	https://www.cali.org/books/contract-doctrine-theory-practice-volume-3	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	contract doctrine, theory, and practice - volume three	\N	2018-05-26 20:55:44.6747	2018-05-26 21:20:46.656926
319	2	Copyright Basics	http://cnx.org/contents/VjQe4z2i@2.1Fw8kKsmy@6	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	copyright basics	\N	2018-05-26 20:55:44.68694	2018-05-26 21:20:46.669349
698	2	University Physics Volume 1	https://openstax.org/details/books/university-physics-volume-1	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	university physics volume 1	\N	2018-11-19 19:16:31.103115	\N
699	2	University Physics Volume 2	https://openstax.org/details/books/university-physics-volume-2	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	university physics volume 2	\N	2018-11-19 19:16:31.120681	\N
301	2	Principles of Economics	https://openstax.org/details/principles-economics	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	principles of economics	\N	2018-05-26 20:55:44.31989	2018-05-26 20:55:44.337949
303	2	Principles of Macroeconomics v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/rittenmacro-principles-of-macroeconomics-1-0	\N	http://collegeopentextbooks.org/economics-reviews/#prin_macroecon_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	principles of macroeconomics v. 1.0	\N	2018-05-26 20:55:44.389111	2018-05-26 21:20:46.384783
306	2	Principles of Microeconomics v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/rittenberg-principles-of-microeconomics-1-0	\N	http://collegeopentextbooks.org/economics-reviews/#prin_microecon_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	principles of microeconomics v. 1.0	\N	2018-05-26 20:55:44.474907	2018-05-26 21:20:46.466147
308	2	Quantum Microeconomics	http://www.smallparty.org/yoram/quantum/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	quantum microeconomics	\N	2018-05-26 20:55:44.529108	2018-05-26 21:20:46.515261
322	2	Evidence: Best Evidence Rule	http://elangdell.cali.org/content/evidence-best-evidence-rule	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	evidence: best evidence rule	\N	2018-05-26 20:55:44.722411	2018-05-26 21:20:46.705709
323	2	Evidence: Impeachment by Evidence of a Criminal Conviction	https://www.cali.org/books/evidence-impeachment-evidence-criminal-conviction	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	evidence: impeachment by evidence of a criminal conviction	\N	2018-05-26 20:55:44.733745	2018-05-26 21:20:46.718157
324	2	Evidence: Jury Impeachment	http://elangdell.cali.org/content/evidence-jury-impeachment	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	evidence: jury impeachment	\N	2018-05-26 20:55:44.745294	2018-05-26 21:20:46.730452
325	2	Evidence: Plea and Plea-Related Statements (Rule 410)	https://www.cali.org/books/evidence-plea-plea-related-statements-rule-410	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	evidence: plea and plea-related statements (rule 410)	\N	2018-05-26 20:55:44.757094	2018-05-26 21:20:46.743716
326	2	Evidence: Propensity Character Evidence (Rule 404)	https://www.cali.org/books/evidence-propensity-character-evidence-rule-404	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	evidence: propensity character evidence (rule 404)	\N	2018-05-26 20:55:44.768758	2018-05-26 21:20:46.755805
327	2	Evidence: Rape Shield Rule	http://elangdell.cali.org/content/evidence-rape-shield-rule	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	evidence: rape shield rule	\N	2018-05-26 20:55:44.780467	2018-05-26 21:20:46.768625
328	2	Federal Rules of Appellate Procedure 2014-2015	https://www.cali.org/books/federal-rules-appellate-procedure-2014-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	federal rules of appellate procedure 2014-2015	\N	2018-05-26 20:55:44.792161	2018-05-26 21:20:46.781304
329	2	Federal Rules of Bankruptcy Procedure 2014-2015	https://www.cali.org/books/federal-rules-bankruptcy-procedure-2014-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	federal rules of bankruptcy procedure 2014-2015	\N	2018-05-26 20:55:44.804155	2018-05-26 21:20:46.796411
330	2	Federal Rules of Civil Procedure 2015	https://www.cali.org/books/federal-rules-civil-procedure-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	federal rules of civil procedure 2015	\N	2018-05-26 20:55:44.81546	2018-05-26 21:20:46.809423
331	2	Federal Rules of Criminal Procedure 2015	https://www.cali.org/books/federal-rules-criminal-procedure-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	federal rules of criminal procedure 2015	\N	2018-05-26 20:55:44.830463	2018-05-26 21:20:46.824916
332	2	Federal Rules of Evidence 2015	https://www.cali.org/books/federal-rules-evidence-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	federal rules of evidence 2015	\N	2018-05-26 20:55:44.845242	2018-05-26 21:20:46.841111
333	2	The Federalist Papers	https://www.cali.org/books/federalist-papers	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the federalist papers	\N	2018-05-26 20:55:44.859895	2018-05-26 21:20:46.855717
335	2	The Foundational Documents of the American Legal System	https://www.cali.org/books/foundational-documents-american-legal-system	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the foundational documents of the american legal system	\N	2018-05-26 20:55:44.88376	2018-05-26 21:20:46.878489
336	2	Introduction to Basic Legal Citation	http://elangdell.cali.org/content/introduction-basic-legal-citation	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to basic legal citation	\N	2018-05-26 20:55:44.894972	2018-05-26 21:20:46.889925
337	2	Land Use	http://elangdell.cali.org/content/land-use	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	land use	\N	2018-05-26 20:55:44.906779	2018-05-26 21:20:46.901337
338	2	The Law of Trusts	https://www.cali.org/books/law-trusts	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the law of trusts	\N	2018-05-26 20:55:44.917941	2018-05-26 21:20:46.91275
339	2	Law of Wills	https://www.cali.org/books/law-wills	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	law of wills	\N	2018-05-26 20:55:44.929318	2018-05-26 21:20:46.923615
340	2	Property Volume 1	https://www.cali.org/books/property-volume-1	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	property volume 1	\N	2018-05-26 20:55:44.94039	2018-05-26 21:20:46.934836
341	2	Property Volume 2	https://www.cali.org/books/property-volume-2	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	property volume 2	\N	2018-05-26 20:55:44.951518	2018-05-26 21:20:46.947193
103	2	Remix: Making Art and Commerce Thrive in the Hybrid Economy	https://www.bloomsburycollections.com/book/remix-making-art-and-commerce-thrive-in-the-hybrid-economy/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	remix: making art and commerce thrive in the hybrid economy	\N	2018-05-26 20:55:40.966565	2018-05-26 20:55:44.975112
344	2	Selected Materials on the Law of Evidence	https://www.cali.org/books/selected-materials-law-evidence	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	selected materials on the law of evidence	\N	2018-05-26 20:55:45.003581	2018-05-26 21:20:47.001666
345	2	Sources of American Law: An Introduction to Legal Research	https://www.cali.org/books/sources-american-law-introduction-legal-research	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	sources of american law: an introduction to legal research	\N	2018-05-26 20:55:45.015381	2018-05-26 21:20:47.017475
346	2	The Story of Contract Law: Formation	https://www.cali.org/books/story-contract-law-formation	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the story of contract law: formation	\N	2018-05-26 20:55:45.031489	2018-05-26 21:20:47.034346
347	2	Torts: Cases and Contexts Volume 1	https://www.cali.org/books/torts-cases-and-contexts-volume-1	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	torts: cases and contexts volume 1	\N	2018-05-26 20:55:45.043631	2018-05-26 21:20:47.046603
348	2	Torts: Cases and Contexts Volume 2	https://www.cali.org/books/torts-cases-and-contexts-volume-2	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	torts: cases and contexts volume 2	\N	2018-05-26 20:55:45.057152	2018-05-26 21:20:47.059559
349	2	Torts: Cases, Principles, and Institutions	https://www.cali.org/books/torts-cases-principles-and-institutions	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	torts: cases, principles, and institutions	\N	2018-05-26 20:55:45.070628	2018-05-26 21:20:47.072429
350	2	The Wealth of Networks	http://cyber.law.harvard.edu/wealth_of_networks/Main_Page	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the wealth of networks	\N	2018-05-26 20:55:45.08372	2018-05-26 21:20:47.085597
700	2	University Physics Volume 3	https://openstax.org/details/books/university-physics-volume-3	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	university physics volume 3	\N	2018-11-19 19:16:31.137359	\N
343	2	Sales and Leases: A Problem-based Approach	https://www.cali.org/books/sales-and-leases-problem-based-approach	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	sales and leases: a problem-based approach	\N	2018-05-26 20:55:44.987076	2018-05-26 21:20:46.985097
353	2	United States Copyright Law	https://www.cali.org/books/united-states-copyright-law	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	united states copyright law	\N	2018-05-26 20:55:45.122104	2018-05-26 21:20:47.123046
354	2	United States Patent Law	https://www.cali.org/books/united-states-patent-law	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	united states patent law	\N	2018-05-26 20:55:45.135294	2018-05-26 21:20:47.135538
355	2	United States Trademark Law	https://www.cali.org/books/united-states-trademark-law	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	united states trademark law	\N	2018-05-26 20:55:45.147813	2018-05-26 21:20:47.149286
356	2	Wetlands Law: A Course Source	https://www.cali.org/books/wetlands-law-course-source	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	wetlands law: a course source	\N	2018-05-26 20:55:45.160308	2018-05-26 21:20:47.161811
357	2	What Color is Your C.F.R.?	https://www.cali.org/books/what-color-your-cfr	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	what color is your c.f.r.?	\N	2018-05-26 20:55:45.172649	2018-05-26 21:20:47.174443
358	2	Accessibility of eLearning	http://openlearn.open.ac.uk/course/view.php?id=3049	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	accessibility of elearning	\N	2018-05-26 20:55:45.202597	2018-05-26 21:20:47.202224
361	2	Applescript for Absolute Starters	http://www.fischer-bayern.de/applescript/html/ebook.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	applescript for absolute starters	\N	2018-05-26 20:55:45.238847	2018-05-26 21:20:47.238768
362	2	Basic Computing Using Windows	http://en.wikibooks.org/wiki/Basic_Computing_Using_Windows	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	basic computing using windows	\N	2018-05-26 20:55:45.251791	2018-05-26 21:20:47.25149
364	2	Business Information Systems: Design an App for That	http://www.flatworldknowledge.com/printed-book/337956	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	business information systems: design an app for that	\N	2018-05-26 20:55:45.293592	2018-05-26 21:20:47.28305
365	2	Cascading Style Sheets	http://en.wikibooks.org/wiki/Cascading_Style_Sheets	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	cascading style sheets	\N	2018-05-26 20:55:45.317121	2018-05-26 21:20:47.306354
360	2	Algorithms	http://yourbasic.org/algorithms/	\N	\N	CC BY	https://creativecommons.org/licenses/by/3.0/	CCBY	algorithms	\N	2018-05-26 20:55:45.226146	2018-05-26 21:20:47.226242
366	2	The Cathedral and the Bazaar	http://www.catb.org/%7Eesr/writings/cathedral-bazaar/cathedral-bazaar/	\N	\N	OPL	https://www.opencontent.org/openpub/	OPL	the cathedral and the bazaar	\N	2018-05-26 20:55:45.329726	2018-05-26 21:20:47.318471
367	2	CGI Programming on the World Wide Web 1st ed.	http://oreilly.com/openbook/cgi/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	cgi programming on the world wide web 1st ed.	\N	2018-05-26 20:55:45.345388	2018-05-26 21:20:47.33085
368	2	A College Student's Guide to Computers in Education	http://pages.uoregon.edu/moursund/Books/CollegeStudent/CollegeStudent.html	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	a college student's guide to computers in education	\N	2018-05-26 20:55:45.358868	2018-05-26 21:20:47.342598
369	2	Concurrent Programming	http://yourbasic.org/golang/concurrent-programming/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by/3.0/	CCBYNC	concurrent programming	\N	2018-05-26 20:55:45.37059	2018-05-26 21:20:47.355021
370	2	Database Development Lifecycle	http://openlearn.open.ac.uk/course/view.php?id=2463	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	database development lifecycle	\N	2018-05-26 20:55:45.383214	2018-05-26 21:20:47.370259
371	2	A Designer’s Log: Case Studies in Instructional Design	http://www.aupress.ca/index.php/books/120161	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	a designer’s log: case studies in instructional design	\N	2018-05-26 20:55:45.395952	2018-05-26 21:20:47.38175
372	2	Designing the User Interface	http://openlearn.open.ac.uk/course/view.php?id=1779	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	designing the user interface	\N	2018-05-26 20:55:45.409231	2018-05-26 21:20:47.393214
374	2	Dive into Python	http://www.diveintopython.net/	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	dive into python	\N	2018-05-26 20:55:45.443281	2018-05-26 21:20:47.42189
375	2	Economic Aspects and Business Models of Free Software	http://ftacademy.org/courses/economic-aspects-of-free-software#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	economic aspects and business models of free software	\N	2018-05-26 20:55:45.454801	2018-05-26 21:20:47.435834
376	2	Electronic Commerce: The Strategic Perspective	https://archive.org/details/ost-business-electronic-commerce	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	electronic commerce: the strategic perspective	\N	2018-05-26 20:55:45.474629	2018-05-26 21:20:47.456976
377	2	Eloquent JavaScript: A modern Intro to Programming	http://eloquentjavascript.net/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	eloquent javascript: a modern intro to programming	\N	2018-05-26 20:55:45.497488	2018-05-26 21:20:47.482935
373	2	Dive into HTML5	http://diveintohtml5.info/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	dive into html5	\N	2018-05-26 20:55:45.424269	2018-05-26 21:20:47.40702
378	2	A Faculty Member's Guide to Computers in Higher Education	http://pages.uoregon.edu/moursund/Books/Faculty/Faculty.html	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	a faculty member's guide to computers in higher education	\N	2018-05-26 20:55:45.510536	2018-05-26 21:20:47.497433
379	2	Finding Information in Information Technology and Computing	http://openlearn.open.ac.uk/course/view.php?id=2370	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	finding information in information technology and computing	\N	2018-05-26 20:55:45.523609	2018-05-26 21:20:47.51111
380	2	Firefox Manual	http://en.flossmanuals.net/firefox	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	firefox manual	\N	2018-05-26 20:55:45.536129	2018-05-26 21:20:47.524193
381	2	Flash Tutorials	http://edutechwiki.unige.ch/en/EduTech_Wiki:Books/Flash_tutorials	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	flash tutorials	\N	2018-05-26 20:55:45.548429	2018-05-26 21:20:47.536649
382	2	Free as in Freedom	http://oreilly.com/openbook/freedom/index.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	free as in freedom	\N	2018-05-26 20:55:45.560905	2018-05-26 21:20:47.549939
413	2	LaTeX	http://en.wikibooks.org/wiki/LaTeX	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	latex	\N	2018-05-26 20:55:46.019955	2018-05-26 21:20:48.010406
701	2	Armstrong Calculus	https://oer.galileo.usg.edu/mathematics-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	armstrong calculus	\N	2018-11-19 19:16:31.310353	\N
693	2	Business Math: A Step-by-Step Handbook	https://lyryx.com/products/business-mathematics/	https://lyryx.com/products/business-mathematics/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	business math: a step-by-step handbook	\N	2018-11-19 19:16:30.090518	2018-11-19 19:16:31.404474
394	2	Information on the Web	http://openlearn.open.ac.uk/course/view.php?id=1345	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	information on the web	\N	2018-05-26 20:55:45.786455	2018-05-26 21:20:47.767914
385	2	GNU/Linux Advanced Administration	http://ftacademy.org/courses/gnu-linux-advanced#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	gnu/linux advanced administration	\N	2018-05-26 20:55:45.599245	2018-05-26 21:20:47.587302
386	2	GNU/Linux Basic	http://ftacademy.org/courses/gnu-linux-basic#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	gnu/linux basic	\N	2018-05-26 20:55:45.616011	2018-05-26 21:20:47.602812
387	2	Graphics and Information Management Systems	https://oer.avu.org/handle/123456789/84	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	graphics and information management systems	\N	2018-05-26 20:55:45.640755	2018-05-26 21:20:47.626768
395	2	Information Systems	http://ufdcimages.uflib.ufl.edu/AA/00/01/17/04/00001/InformationSystems.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	information systems	\N	2018-05-26 20:55:45.798019	2018-05-26 21:20:47.779777
388	2	Grokking the Gimp	http://gimp-savvy.com/BOOK/index.html	\N	\N	OPL	https://www.opencontent.org/openpub/	OPL	grokking the gimp	\N	2018-05-26 20:55:45.655634	2018-05-26 21:20:47.63879
390	2	HyperText Markup Language	http://en.wikibooks.org/wiki/HTML	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	hypertext markup language	\N	2018-05-26 20:55:45.699293	2018-05-26 21:20:47.678254
393	2	Implementation of Free Software Systems	http://ftacademy.org/courses/deployment-of-free-software-and-case-studies#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	implementation of free software systems	\N	2018-05-26 20:55:45.771399	2018-05-26 21:20:47.752274
363	2	Blown to Bits: Your Life, Liberty, and Happiness After the Digital Explosion	http://www.bitsbook.com/excerpts/	\N	http://www.newcotorg.cot.education/computer-information-science-reviews/#blown_to_bits_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	blown to bits: your life, liberty, and happiness after the digital explosion	\N	2018-05-26 20:55:45.27414	2018-05-26 21:20:47.263196
396	2	Information Systems: A Manager's Guide to Harnessing Technology v. 5.0	http://www.flatworldknowledge.com/printed-book/227252	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	information systems: a manager's guide to harnessing technology v. 5.0	\N	2018-05-26 20:55:45.809265	2018-05-26 21:20:47.792362
397	2	Introducing ICT Systems	http://openlearn.open.ac.uk/course/view.php?id=1512	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introducing ict systems	\N	2018-05-26 20:55:45.820785	2018-05-26 21:20:47.8053
398	2	Introduction to Autonomous Robots	https://github.com/correll/Introduction-to-Autonomous-Robots/releases	https://github.com/correll/Introduction-to-Autonomous-Robots	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	introduction to autonomous robots	\N	2018-05-26 20:55:45.832359	2018-05-26 21:20:47.817823
399	2	Introduction to C Programming	http://www2.le.ac.uk/projects/oer/oers/beyond-distance-research-alliance/introduction-to-c-programming	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to c programming	\N	2018-05-26 20:55:45.844107	2018-05-26 21:20:47.830259
400	2	Introduction to Computer Science	http://en.wikiversity.org/wiki/Introduction_to_Computer_Science	\N	http://www.newcotorg.cot.education/computer-information-science-reviews/#intro_cs_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to computer science	\N	2018-05-26 20:55:45.85899	2018-05-26 21:20:47.84633
401	2	Introduction to Computing Explorations in Language, Logic, and Machines	http://www.computingbook.org/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to computing explorations in language, logic, and machines	\N	2018-05-26 20:55:45.870744	2018-05-26 21:20:47.858593
402	2	An introduction to Data and Information	http://openlearn.open.ac.uk/course/view.php?id=2355	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introduction to data and information	\N	2018-05-26 20:55:45.8823	2018-05-26 21:20:47.871454
403	2	Introduction to Digital Logic with Laboratory Exercises	http://ufdcimages.uflib.ufl.edu/AA/00/01/16/38/00001/DigitalLogic.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to digital logic with laboratory exercises	\N	2018-05-26 20:55:45.894055	2018-05-26 21:20:47.88389
404	2	Introduction to Free Software	http://ftacademy.org/courses/concepts-free-software-open-standards#materials	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to free software	\N	2018-05-26 20:55:45.905657	2018-05-26 21:20:47.896102
405	2	Introduction to Microsoft Excel 2007	https://vula.uct.ac.za/web/learnonline/manuals/CET%20MS%20Excel%202007%20Training%20Manual%20v1.1.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to microsoft excel 2007	\N	2018-05-26 20:55:45.923869	2018-05-26 21:20:47.914809
407	2	Introduction to Microsoft Windows XP	https://vula.uct.ac.za/web/learnonline/manuals/CET%20Windows%20XP%20Training%20Manual%20v1.1.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to microsoft windows xp	\N	2018-05-26 20:55:45.946211	2018-05-26 21:20:47.937103
408	2	Introduction to Microsoft Word 2007	https://vula.uct.ac.za/web/learnonline/manuals/CET%20MS%20Word%202007%20Training%20Manual%20v1.2.pdf	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to microsoft word 2007	\N	2018-05-26 20:55:45.957305	2018-05-26 21:20:47.948535
409	2	Introduction to MIPS Assembly Language Programming	http://cupola.gettysburg.edu/oer/2/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to mips assembly language programming	\N	2018-05-26 20:55:45.968414	2018-05-26 21:20:47.959866
410	2	Introduction to Programming Using Java	http://math.hws.edu/javanotes/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to programming using java	\N	2018-05-26 20:55:45.980349	2018-05-26 21:20:47.971337
411	2	Introduction to Software Development	http://ftacademy.org/courses/software-development#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	introduction to software development	\N	2018-05-26 20:55:45.99214	2018-05-26 21:20:47.983015
412	2	Introduction to Web Applications Development	http://ftacademy.org/courses/web-applications-development#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	introduction to web applications development	\N	2018-05-26 20:55:46.007587	2018-05-26 21:20:47.998533
392	2	ICT Integration in Chemistry	https://oer.avu.org/handle/123456789/67	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ict integration in chemistry	\N	2018-05-26 20:55:45.726415	2018-05-26 20:55:48.777555
187	2	ICT Integration in Mathematics	https://oer.avu.org/handle/123456789/65	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ict integration in mathematics	\N	2018-05-26 20:55:42.357662	2018-05-26 20:55:45.741935
384	2	GIS Commons: An Introductory Textbook on Geographic Information Systems	http://giscommons.org/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	gis commons: an introductory textbook on geographic information systems	\N	2018-05-26 20:55:45.586368	2018-05-26 21:20:47.575511
417	2	Non-Programmer's Tutorial for Python 2.0	http://en.wikibooks.org/wiki/Non-Programmer%27s_Tutorial_for_Python	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	non-programmer's tutorial for python 2.0	\N	2018-05-26 20:55:46.068541	2018-05-26 21:20:48.062254
418	2	Open Networks	http://ftacademy.org/courses/open-network-technologies#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	open networks	\N	2018-05-26 20:55:46.079941	2018-05-26 21:20:48.075228
419	2	Open Source Development with CVS, 3rd Edition	http://cvsbook.red-bean.com/OSDevWithCVS_3E.pdf	\N	\N	GGPL	https://www.gnu.org/licenses/gpl.html	GGPL	open source development with cvs, 3rd edition	\N	2018-05-26 20:55:46.091456	2018-05-26 21:20:48.088121
421	2	Principles of Object-Oriented Programming	http://cnx.org/content/m11785/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	principles of object-oriented programming	\N	2018-05-26 20:55:46.120655	2018-05-26 21:20:48.120831
422	2	Producing Open Source Software	http://producingoss.com/en/index.html	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	producing open source software	\N	2018-05-26 20:55:46.136864	2018-05-26 21:20:48.138532
424	2	Programming in C	http://www.peoi.org/Courses/Coursesen/cprog/fram1.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	programming in c	\N	2018-05-26 20:55:46.163792	2018-05-26 21:20:48.163807
423	2	Programming Fundamentals – A Modular Structured Approach	http://cnx.org/content/col10621/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	programming fundamentals – a modular structured approach	\N	2018-05-26 20:55:46.14947	2018-05-26 21:20:48.151548
425	2	Programming Languages: Application and Interpretation	http://www.cs.brown.edu/%7Esk/Publications/Books/ProgLangs/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	programming languages: application and interpretation	\N	2018-05-26 20:55:46.176509	2018-05-26 21:20:48.176024
426	2	Project Management from Simple to Complex	http://catalog.flatworldknowledge.com/catalog/editions/preston_1-1-project-management-from-simple-to-complex-1-1	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	project management from simple to complex	\N	2018-05-26 20:55:46.189074	2018-05-26 21:20:48.188129
427	2	Python for Informatics: Exploring Information	https://source.sakaiproject.org/contrib//csev/trunk/pyinf/tex/book_03.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	python for informatics: exploring information	\N	2018-05-26 20:55:46.20608	2018-05-26 21:20:48.204099
428	2	Representing and Manipulating Data in Computers	http://openlearn.open.ac.uk/course/view.php?id=2575	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	representing and manipulating data in computers	\N	2018-05-26 20:55:46.218407	2018-05-26 21:20:48.216445
429	2	Signal Computing: Digital Signals in the Software Domain	http://faculty.washington.edu/stiber/pubs/Signal-Computing/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	signal computing: digital signals in the software domain	\N	2018-05-26 20:55:46.230824	2018-05-26 21:20:48.228292
430	2	Software Architecture	http://ftacademy.org/courses/software-architecture#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	software architecture	\N	2018-05-26 20:55:46.248638	2018-05-26 21:20:48.251118
432	2	Text-Based Productivity Tools	https://oer.avu.org/handle/123456789/83	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	text-based productivity tools	\N	2018-05-26 20:55:46.29285	2018-05-26 21:20:48.29458
433	2	Think Bayes: Bayesian Statistics Made Simple	http://greenteapress.com/wp/think-bayes/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	think bayes: bayesian statistics made simple	\N	2018-05-26 20:55:46.305559	2018-05-26 21:20:48.306925
434	2	Think Complexity	http://greenteapress.com/wp/think-complexity-2e/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	think complexity	\N	2018-05-26 20:55:46.318026	2018-05-26 21:20:48.31968
435	2	Think DSP: Digital Signal Processing in Python	http://greenteapress.com/wp/think-dsp/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	think dsp: digital signal processing in python	\N	2018-05-26 20:55:46.331454	2018-05-26 21:20:48.331248
436	2	Think Java: How to Think Like a Computer Scientist	http://greenteapress.com/wp/think-java/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	think java: how to think like a computer scientist	\N	2018-05-26 20:55:46.343729	2018-05-26 21:20:48.342395
437	2	Think Python: How to Think Like a Computer Scientist	http://www.greenteapress.com/thinkpython/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	think python: how to think like a computer scientist	\N	2018-05-26 20:55:46.359005	2018-05-26 21:20:48.357119
438	2	Think Stats: Exploratory Data Analysis in Python	http://greenteapress.com/wp/think-stats-2e/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	think stats: exploratory data analysis in python	\N	2018-05-26 20:55:46.371235	2018-05-26 21:20:48.368059
439	2	Tools and Utilities in Free Software	http://ftacademy.org/courses/free-software-tools-and-utilities#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	tools and utilities in free software	\N	2018-05-26 20:55:46.3875	2018-05-26 21:20:48.378874
440	2	Understanding Open Source and Free Software Licensing	http://oreilly.com/catalog/osfreesoft/book/	\N	\N	CC BY-ND	https://creativecommons.org/licenses/by-nd/4.0/	CCBYND	understanding open source and free software licensing	\N	2018-05-26 20:55:46.399369	2018-05-26 21:20:48.39015
441	2	Wealth of Networks	http://yupnet.org/benkler/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	wealth of networks	\N	2018-05-26 20:55:46.411263	2018-05-26 21:20:48.40132
442	2	Web Authoring Boot Camp	http://www.studiobast.com/sb_students/content/WABC_Book.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	web authoring boot camp	\N	2018-05-26 20:55:46.42293	2018-05-26 21:20:48.412894
443	2	What is a Wiki?	http://wikieducator.org/images/3/34/Newbie_Tut1.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	what is a wiki?	\N	2018-05-26 20:55:46.434954	2018-05-26 21:20:48.425437
444	2	Wireless Networking in the Developing World	http://wndw.net/index.html	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	wireless networking in the developing world	\N	2018-05-26 20:55:46.446104	2018-05-26 21:20:48.437808
445	2	XML – Managing Data Exchange	http://en.wikibooks.org/wiki/XML_-_Managing_Data_Exchange	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	xml – managing data exchange	\N	2018-05-26 20:55:46.457239	2018-05-26 21:20:48.450521
383	2	The Future of the Internet and How to Stop It	http://futureoftheinternet.org/static/ZittrainTheFutureoftheInternet.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the future of the internet and how to stop it	\N	2018-05-26 20:55:45.573373	2018-05-26 21:20:47.562776
416	2	Network Security	http://openlearn.open.ac.uk/course/view.php?id=2587	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	network security	\N	2018-05-26 20:55:46.054087	2018-05-26 21:20:48.048715
473	2	Macromolecules in the Biological System	https://oer.avu.org/handle/123456789/44	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	macromolecules in the biological system	\N	2018-05-26 20:55:46.958138	2018-05-26 21:20:48.97385
447	2	An Introtroduction to Social Work	http://www.open.edu/openlearn/health-sports-psychology/social-care/social-work/introduction-social-work/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introtroduction to social work	\N	2018-05-26 20:55:46.500857	2018-05-26 21:20:48.496019
450	2	The Meaning of Crime	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/the-meaning-crime/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the meaning of crime	\N	2018-05-26 20:55:46.58977	2018-05-26 21:20:48.596518
451	2	Minority Studies: A Brief Sociological Text	http://cnx.org/content/col11183/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	minority studies: a brief sociological text	\N	2018-05-26 20:55:46.601652	2018-05-26 21:20:48.609093
452	2	Negation: Essays in Critical Thinking	http://mayflybooks.org/?page_id=18	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	negation: essays in critical thinking	\N	2018-05-26 20:55:46.613334	2018-05-26 21:20:48.621376
454	2	Social Problems: Who Makes Them?	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/social-problems-who-makes-them/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	social problems: who makes them?	\N	2018-05-26 20:55:46.64805	2018-05-26 21:20:48.658512
474	2	Microbiology	https://openstax.org/details/books/microbiology	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	microbiology	\N	2018-05-26 20:55:46.970531	2018-05-26 21:20:48.986553
456	2	Sociology of the Family	http://freesociologybooks.com/Sociology_Of_The_Family/01_Changes_and_Definitions.php	\N	\N	Custom	http://freesociologybooks.com/	CUSTOM	sociology of the family	\N	2018-05-26 20:55:46.670353	2018-05-26 21:20:48.683421
455	2	Sociology	https://www.boundless.com/sociology/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	sociology	\N	2018-05-26 20:55:46.659416	2018-05-26 21:20:48.671118
457	2	Sociology: Understanding and Changing the Social World, Brief Ed.	http://catalog.flatworldknowledge.com/catalog/editions/1115	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	sociology: understanding and changing the social world, brief ed.	\N	2018-05-26 20:55:46.68805	2018-05-26 21:20:48.703779
459	2	The Theory of the Leisure Class	http://xroads.virginia.edu/~HYPER/VEBLEN/veblenhp.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the theory of the leisure class	\N	2018-05-26 20:55:46.70997	2018-05-26 21:20:48.729606
460	2	Animal Diversity	http://oer.avu.org/handle/123456789/51	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	animal diversity	\N	2018-05-26 20:55:46.726073	2018-05-26 21:20:48.744915
461	2	BioFundamentals: Introductory Molecular Biology	http://virtuallaboratory.colorado.edu/Biofundamentals/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	biofundamentals: introductory molecular biology	\N	2018-05-26 20:55:46.737373	2018-05-26 21:20:48.75729
462	2	Biology	https://openstax.org/details/biology	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	biology	\N	2018-05-26 20:55:46.749025	2018-05-26 20:55:46.778978
464	2	Cell and Molecular Biology	http://dc.uwm.edu/biosci_facbooks_bergtrom/5/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cell and molecular biology	\N	2018-05-26 20:55:46.804348	2018-05-26 21:20:48.826601
467	2	Diversity of Algae and Plants	http://oer.avu.org/handle/123456789/33	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	diversity of algae and plants	\N	2018-05-26 20:55:46.852419	2018-05-26 21:20:48.874642
465	2	CK-12 Biology	http://www.ck12.org/flexbook/book/2537	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	ck-12 biology	\N	2018-05-26 20:55:46.817202	2018-05-26 21:20:48.838944
466	2	CK-12 Biology I - Honors	http://www.ck12.org/flexr/flexbook/829/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ck-12 biology i - honors	\N	2018-05-26 20:55:46.828981	2018-05-26 21:20:48.851178
468	2	Evolution Biology	http://oer.avu.org/handle/123456789/35	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	evolution biology	\N	2018-05-26 20:55:46.865107	2018-05-26 21:20:48.887451
469	2	Foundations of Biology	http://www.foundationsofbiology.com/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	foundations of biology	\N	2018-05-26 20:55:46.882302	2018-05-26 21:20:48.899906
470	2	Genes and Disease	http://www.ncbi.nlm.nih.gov/books/NBK22183/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	genes and disease	\N	2018-05-26 20:55:46.899731	2018-05-26 21:20:48.916243
471	2	Human Physiology	http://en.wikibooks.org/wiki/Human_Physiology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	human physiology	\N	2018-05-26 20:55:46.912155	2018-05-26 21:20:48.929496
391	2	ICT Integration in Biology	https://oer.avu.org/handle/123456789/66	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ict integration in biology	\N	2018-05-26 20:55:45.711238	2018-05-26 20:55:46.9258
121	2	ICT Integration in Physics	https://oer.avu.org/handle/123456789/64	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ict integration in physics	\N	2018-05-26 20:55:41.279527	2018-05-26 20:55:45.756968
475	2	Microbiology and Mycology	http://oer.avu.org/handle/123456789/36	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	microbiology and mycology	\N	2018-05-26 20:55:46.985632	2018-05-26 21:20:48.999033
446	2	Introduction to Social Network Methods	http://faculty.ucr.edu/%7Ehanneman/nettext/	\N	\N	Custom	http://faculty.ucr.edu/~hanneman/nettext/	CUSTOM	introduction to social network methods	\N	2018-05-26 20:55:46.486282	2018-05-26 21:20:48.480108
472	2	Inside the Cell – Biology	http://publications.nigms.nih.gov/insidethecell/index.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	inside the cell – biology	\N	2018-05-26 20:55:46.942394	2018-05-26 21:20:48.959322
448	2	Introduction to Sociology	http://freesociologybooks.com/Introduction_To_Sociology/01_History_and_Introduction.php	\N	http://www.collegeopentextbooks.org/sociology-reviews/#intro_soc_review	Custom	http://freesociologybooks.com/	CUSTOM	introduction to sociology	\N	2018-05-26 20:55:46.512316	2018-05-26 20:55:46.523863
449	2	Living in a Globalised World	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/living-globalised-world/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	living in a globalised world	\N	2018-05-26 20:55:46.578426	2018-05-26 21:20:48.583487
463	2	Cell Biology and Genetics	http://oer.avu.org/handle/123456789/32	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cell biology and genetics	\N	2018-05-26 20:55:46.791431	2018-05-26 21:20:48.813398
477	2	Molecular Biology Laboratory Manual	http://www.archive.org/details/MolecularBiologyLaboratoryManual_456	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	molecular biology laboratory manual	\N	2018-05-26 20:55:47.011416	2018-05-26 21:20:49.02489
478	2	The New Genetics	http://publications.nigms.nih.gov/thenewgenetics/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the new genetics	\N	2018-05-26 20:55:47.023543	2018-05-26 21:20:49.037354
479	2	Nucleic Acids and Chromatin	http://openlearn.open.ac.uk/course/view.php?id=2645	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	nucleic acids and chromatin	\N	2018-05-26 20:55:47.036347	2018-05-26 21:20:49.04968
480	2	Online Biology Book	http://www.estrellamountain.edu/faculty/farabee/biobk/biobooktoc.html	\N	\N	Custom	http://www2.estrellamountain.edu/faculty/farabee/biobk/biobooktoc.html	CUSTOM	online biology book	\N	2018-05-26 20:55:47.048575	2018-05-26 21:20:49.062225
482	2	Plant and Animal Physiology	http://oer.avu.org/handle/123456789/50	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	plant and animal physiology	\N	2018-05-26 20:55:47.077235	2018-05-26 21:20:49.087693
481	2	Physiology	https://www.boundless.com/physiology/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	physiology	\N	2018-05-26 20:55:47.064181	2018-05-26 21:20:49.074721
483	2	The Structures of Life	http://publications.nigms.nih.gov/structlife/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the structures of life	\N	2018-05-26 20:55:47.089883	2018-05-26 21:20:49.100313
484	2	What Do Genes Do?	http://openlearn.open.ac.uk/course/view.php?id=2387	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	what do genes do?	\N	2018-05-26 20:55:47.102664	2018-05-26 21:20:49.112821
485	2	What is Biodiversity	http://cnx.org/content/col10639/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	what is biodiversity	\N	2018-05-26 20:55:47.115575	2018-05-26 21:20:49.125614
486	2	What is the Genome Made of?	http://openlearn.open.ac.uk/course/view.php?id=2360	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	what is the genome made of?	\N	2018-05-26 20:55:47.143295	2018-05-26 21:20:49.151286
488	2	Foundations in Statistical Reasoning	https://sites.google.com/site/offthebeatenmathpath/foundations-in-statistical-reasoning	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	foundations in statistical reasoning	\N	2018-05-26 20:55:47.178321	2018-05-26 21:20:49.179606
491	2	Introduction to Probability	http://www.dartmouth.edu/%7Echance/teaching_aids/books_articles/probability_book/book.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	introduction to probability	\N	2018-05-26 20:55:47.216454	2018-05-26 21:20:49.216148
492	2	Introduction to Statistical Thought	http://www.math.umass.edu/%7Elavine/Book/book.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to statistical thought	\N	2018-05-26 20:55:47.232401	2018-05-26 21:20:49.231168
493	2	Introductory Statistics	http://catalog.flatworldknowledge.com/catalog/editions/2208	\N	\N	Custom	%20http:/catalog.flatworldknowledge.com/legal	CUSTOM	introductory statistics	\N	2018-05-26 20:55:47.245922	2018-05-26 20:55:47.262724
495	2	Online Statistics: An Interactive Multimedia Course of Study	http://onlinestatbook.com/index.html	\N	http://www.newcotorg.cot.education/statistics-probability-reviews/#onl_stat_review	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	online statistics: an interactive multimedia course of study	\N	2018-05-26 20:55:47.298741	2018-05-26 21:20:49.288688
496	2	OpenIntro Statistics	http://www.openintro.org/stat/textbook.php	https://www.openintro.org/stat/index.php	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	openintro statistics	\N	2018-05-26 20:55:47.310813	2018-05-26 21:20:49.30071
497	2	Probability, Statistics and Random Processes	http://www.probabilitycourse.com/	https://www.probabilitycourse.com/	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	probability, statistics and random processes	\N	2018-05-26 20:55:47.357289	2018-05-26 21:20:49.342645
498	2	Quantitative Information Analysis III	http://cnx.org/content/col11155/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	quantitative information analysis iii	\N	2018-05-26 20:55:47.369321	2018-05-26 21:20:49.353695
499	2	Statistics	http://en.wikibooks.org/wiki/Statistics	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	statistics	\N	2018-05-26 20:55:47.384751	2018-05-26 21:20:49.369087
500	2	Communications Skills	http://www.oerafrica.org/node/8459	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	communications skills	\N	2018-05-26 20:55:47.432686	2018-05-26 21:20:49.415078
501	2	Communication Theory	http://en.wikibooks.org/wiki/Communication_Theory	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	communication theory	\N	2018-05-26 20:55:47.492683	2018-05-26 21:20:49.463721
503	2	Cicero, "Against Verres", 2.1.53-86	https://www.openbookpublishers.com/product/96	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cicero, "against verres", 2.1.53-86	\N	2018-05-26 20:55:47.519736	2018-05-26 21:20:49.489714
502	2	Communications	https://www.boundless.com/communications/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	communications	\N	2018-05-26 20:55:47.505325	2018-05-26 21:20:49.476791
504	2	Cicero, "On Pompey’s Command (De Imperio)", 27-49	https://www.openbookpublishers.com/product/284	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cicero, "on pompey’s command (de imperio)", 27-49	\N	2018-05-26 20:55:47.538237	2018-05-26 21:20:49.503203
505	2	Cornelius Nepos, "Life of Hannibal"	https://www.openbookpublishers.com/product/284	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	cornelius nepos, "life of hannibal"	\N	2018-05-26 20:55:47.557792	2018-05-26 21:20:49.523555
702	2	Dalton State College APEX Calculus	https://oer.galileo.usg.edu/mathematics-textbooks/16/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	dalton state college apex calculus	\N	2018-11-19 19:16:31.570408	\N
703	2	Geometry with an Introduction to Cosmic Topology	http://mphitchman.com/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	geometry with an introduction to cosmic topology	\N	2018-11-19 19:16:31.905377	\N
415	2	Multimedia Design and Applications	https://oer.avu.org/handle/123456789/85	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	multimedia design and applications	\N	2018-05-26 20:55:46.042855	2018-05-26 21:20:48.035931
476	2	Modern Biology	http://oli.cmu.edu/courses/free-open/biology-course-details/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	modern biology	\N	2018-05-26 20:55:46.99869	2018-05-26 21:20:49.011547
494	2	Introductory Statistics: Concepts, Models, and Applications	http://www.oercommons.org/courses/introductory-statistics-concepts-models-and-applications	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	introductory statistics: concepts, models, and applications	\N	2018-05-26 20:55:47.286138	2018-05-26 21:20:49.276197
508	2	Francais Interactif	http://www.laits.utexas.edu/fi/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	francais interactif	\N	2018-05-26 20:55:47.599685	2018-05-26 21:20:49.565689
507	2	Exploring Public Speaking: 2nd Revision	http://oer.galileo.usg.edu/communication-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	exploring public speaking: 2nd revision	\N	2018-05-26 20:55:47.583464	2018-05-26 21:20:49.549852
510	2	Hearing	http://www.open.edu/openlearn/science-maths-technology/science/biology/hearing/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	hearing	\N	2018-05-26 20:55:47.625218	2018-05-26 21:20:49.590317
511	2	How to Communicate as a Health Volunteer	http://cnx.org/contents/K4Z5uuty@2/How-to-Communicate-as-a-Health	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	how to communicate as a health volunteer	\N	2018-05-26 20:55:47.637909	2018-05-26 21:20:49.607315
535	2	Comparing Stars	http://openlearn.open.ac.uk/course/view.php?id=2796	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	comparing stars	\N	2018-05-26 20:55:48.033781	2018-05-26 21:20:49.977125
512	2	How Language Works: The Cognitive Science of Linguistics	http://www.indiana.edu/~hlw/index.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	how language works: the cognitive science of linguistics	\N	2018-05-26 20:55:47.65413	2018-05-26 21:20:49.631496
513	2	How to Present with Twitter (and other channels)	http://www.speakingaboutpresenting.com/wp-content/uploads/Twitter.pdf	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	how to present with twitter (and other channels)	\N	2018-05-26 20:55:47.668431	2018-05-26 21:20:49.644397
514	2	Key Skill Assessment: Communication	http://openlearn.open.ac.uk/course/view.php?id=2960	\N	http://www.newcotorg.cot.education/languages-communication-reviews/#key_sk_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	key skill assessment: communication	\N	2018-05-26 20:55:47.683429	2018-05-26 21:20:49.658363
515	2	Liberté: a first-year French textbook	http://www.lightandmatter.com/french/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	liberté: a first-year french textbook	\N	2018-05-26 20:55:47.697784	2018-05-26 21:20:49.670835
516	2	Mandarin Chinese	http://www.learnnc.org/lp/editions/mandarin1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	mandarin chinese	\N	2018-05-26 20:55:47.711463	2018-05-26 21:20:49.684165
517	2	Mezhdu Nami	http://www.mezhdunami.org/	http://www.mezhdunami.org/instructors/workbooks.shtml	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	mezhdu nami	\N	2018-05-26 20:55:47.725284	2018-05-26 21:20:49.696596
518	2	Spanish	http://en.wikibooks.org/wiki/Spanish	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	spanish	\N	2018-05-26 20:55:47.74969	2018-05-26 21:20:49.719139
519	2	Spanish I	http://en.wikiversity.org/wiki/Spanish_1	\N	http://www.newcotorg.cot.education/languages-communication-reviews/#span_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	spanish i	\N	2018-05-26 20:55:47.76366	2018-05-26 21:20:49.736139
520	2	Spanish II	https://en.wikiversity.org/wiki/Spanish_2	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	spanish ii	\N	2018-05-26 20:55:47.779037	2018-05-26 21:20:49.747707
521	2	Speaking of Culture	https://press.rebus.community/originsofthehumanfamily/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	speaking of culture	\N	2018-05-26 20:55:47.793399	2018-05-26 21:20:49.759703
506	2	Deutsch im Blick	http://coerll.utexas.edu/dib/	http://coerll.utexas.edu/gg/	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	deutsch im blick	\N	2018-05-26 20:55:47.570619	2018-05-26 21:20:49.536286
523	2	Tacitus, "Annals", 15.20­-23, 33­-45	https://www.openbookpublishers.com/product/215	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	tacitus, "annals", 15.20­-23, 33­-45	\N	2018-05-26 20:55:47.825638	2018-05-26 21:20:49.785915
524	2	Using Your Speech Power!	https://usingyourspeechpower.com/textbook-1	https://usingyourspeechpower.com/	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	using your speech power!	\N	2018-05-26 20:55:47.843027	2018-05-26 21:20:49.802432
525	2	Virgil, "Aeneid", 4.1-299	https://www.openbookpublishers.com/product/162	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	virgil, "aeneid", 4.1-299	\N	2018-05-26 20:55:47.857613	2018-05-26 21:20:49.814635
527	2	American Government and Politics in the Information Age, v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/paletz_1-1-american-government-and-politics-in-the-information-age-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	american government and politics in the information age, v. 2.0	\N	2018-05-26 20:55:47.892914	2018-05-26 21:20:49.844225
526	2	American Government	https://openstax.org/details/books/american-government	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	american government	\N	2018-05-26 20:55:47.876864	2018-05-26 21:20:49.828447
528	2	The CIA World Factbook	https://www.cia.gov/library/publications/the-world-factbook/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the cia world factbook	\N	2018-05-26 20:55:47.9122	2018-05-26 21:20:49.865063
529	2	Democracy in America: Historical-Critical Edition, 4 vols.	http://oll.libertyfund.org/titles/tocqueville-democracy-in-america-historical-critical-edition-4-vols-lf-ed-2010	\N	\N	Custom	http://oll.libertyfund.org/titles/tocqueville-democracy-in-america-historical-critical-edition-4-vols-lf-ed-2010	CUSTOM	democracy in america: historical-critical edition, 4 vols.	\N	2018-05-26 20:55:47.924687	2018-05-26 21:20:49.877044
530	2	Nationalism, Self-determination and Succession	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/politics/nationalism-self-determination-and-secession/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	nationalism, self-determination and succession	\N	2018-05-26 20:55:47.939957	2018-05-26 21:20:49.888591
533	2	Anatomy and Physiology of Animals	http://en.wikibooks.org/wiki/Anatomy_and_Physiology_of_Animals	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	anatomy and physiology of animals	\N	2018-05-26 20:55:48.007668	2018-05-26 21:20:49.952361
531	2	Political Science	https://www.boundless.com/political-science/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	political science	\N	2018-05-26 20:55:47.953175	2018-05-26 21:20:49.901173
534	2	AP Environmental Science	http://cnx.org/content/col10548/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ap environmental science	\N	2018-05-26 20:55:48.021456	2018-05-26 21:20:49.964318
420	2	Principles of Computer System Design: An Introduction - Part II	http://ocw.mit.edu/ans7870/resources/system/index.htm	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	principles of computer system design: an introduction - part ii	\N	2018-05-26 20:55:46.106061	2018-05-26 21:20:48.104737
522	2	Stand up, Speak out: The Practice and Ethics of Public Speaking	https://open.umn.edu/opentextbooks/BookDetail.aspx?bookId=77	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	stand up, speak out: the practice and ethics of public speaking	\N	2018-05-26 20:55:47.807254	2018-05-26 21:20:49.773258
538	2	Earthquakes	http://openlearn.open.ac.uk/course/view.php?id=1648	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	earthquakes	\N	2018-05-26 20:55:48.071079	2018-05-26 21:20:50.014915
539	2	Ecology and Environment	http://oer.avu.org/handle/123456789/34	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ecology and environment	\N	2018-05-26 20:55:48.082474	2018-05-26 21:20:50.027166
541	2	Evolution through Natural Selection	http://openlearn.open.ac.uk/course/view.php?id=1646	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	evolution through natural selection	\N	2018-05-26 20:55:48.108376	2018-05-26 21:20:50.05149
540	2	Essentials of Environmental Science	http://www.ck12.org/user:zg9yc25lckbnbwfpbc5jb20./book/Essentials-of-Environmental-Science/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	essentials of environmental science	\N	2018-05-26 20:55:48.095406	2018-05-26 21:20:50.039359
542	2	Gene Manipulation in Plants	http://openlearn.open.ac.uk/course/view.php?id=2808	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	gene manipulation in plants	\N	2018-05-26 20:55:48.121455	2018-05-26 21:20:50.063565
543	2	Genes, Technology and Policy/The Science	http://en.wikibooks.org/wiki/Genes,_Technology_and_Policy/The_Science	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	genes, technology and policy/the science	\N	2018-05-26 20:55:48.135012	2018-05-26 21:20:50.075512
544	2	Geothermal Energy—Clean Power From the Earth’s Heat	http://pubs.usgs.gov/circ/2004/c1249/	\N	\N	PD	https://en.wikipedia.org/wiki/Public_domain	PD	geothermal energy—clean power from the earth’s heat	\N	2018-05-26 20:55:48.15426	2018-05-26 21:20:50.086428
545	2	Introduction to Ocean Science	http://www.reefimages.com/oceansci.php	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	introduction to ocean science	\N	2018-05-26 20:55:48.194414	2018-05-26 21:20:50.126203
546	2	An Introduction to Sustainable Energy	http://openlearn.open.ac.uk/course/view.php?id=1223	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introduction to sustainable energy	\N	2018-05-26 20:55:48.208492	2018-05-26 21:20:50.142137
547	2	Life in the Palaeozoic	http://openlearn.open.ac.uk/course/view.php?id=2659	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	life in the palaeozoic	\N	2018-05-26 20:55:48.222225	2018-05-26 21:20:50.154972
548	2	The Nature of Geographic Information	https://www.e-education.psu.edu/natureofgeoinfo/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the nature of geographic information	\N	2018-05-26 20:55:48.234471	2018-05-26 21:20:50.168123
550	2	Physical Geography	http://sofia.fhda.edu/gallery/geography/index.html	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	physical geography	\N	2018-05-26 20:55:48.260659	2018-05-26 21:20:50.191722
551	2	Plate Tectonics	http://openlearn.open.ac.uk/course/view.php?id=2717	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	plate tectonics	\N	2018-05-26 20:55:48.273672	2018-05-26 21:20:50.20427
553	2	NIH Curriculum Supplement Series	http://www.ncbi.nlm.nih.gov/sites/entrez?db=books&doptcmdl=TOCView&term=science+AND+curriculum[book]	\N	\N	PD	https://en.wikipedia.org/wiki/Public_domain	PD	nih curriculum supplement series	\N	2018-05-26 20:55:48.302002	2018-05-26 21:20:50.232458
554	2	Sustainability: A Comprehensive Foundation	http://cnx.org/content/col11325/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	sustainability: a comprehensive foundation	\N	2018-05-26 20:55:48.313817	2018-05-26 21:20:50.244476
555	2	This Dynamic Earth: The Story of Plate Tectonics	http://pubs.usgs.gov/gip/dynamic/dynamic.html	\N	\N	PD	https://en.wikipedia.org/wiki/Public_domain	PD	this dynamic earth: the story of plate tectonics	\N	2018-05-26 20:55:48.330078	2018-05-26 21:20:50.259789
556	2	An Introduction to Philosophy	http://www.qcc.cuny.edu/SocialSciences/ppecorino/INTRO_TEXT/CONTENTS.htm	\N	http://www.newcotorg.cot.education/philosophy-reviews/#intro_phil_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	an introduction to philosophy	\N	2018-05-26 20:55:48.347073	2018-05-26 21:20:50.277715
557	2	Arguments: Deductive Logic Exercises	http://arguments.dss.ucdavis.edu/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	arguments: deductive logic exercises	\N	2018-05-26 20:55:48.36029	2018-05-26 21:20:50.29009
558	2	Computers, Information Technology, the Internet, Ethics, Society and Human Values	http://www.qcc.cuny.edu/SocialSciences/ppecorino/CISESHV_TEXT/CONTENTS.html	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	computers, information technology, the internet, ethics, society and human values	\N	2018-05-26 20:55:48.376475	2018-05-26 21:20:50.305239
559	2	Consciousness Studies	http://en.wikibooks.org/wiki/Consciousness_studies	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	consciousness studies	\N	2018-05-26 20:55:48.389739	2018-05-26 21:20:50.317351
560	2	David Hume	http://www.open.edu/openlearn/history-the-arts/history/history-art/david-hume/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	david hume	\N	2018-05-26 20:55:48.403144	2018-05-26 21:20:50.329392
561	2	Ethics for A-Level	 https://www.openbookpublishers.com/product/639/62d9daacae8a299df1d894ec2c70c74f 	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ethics for a-level	\N	2018-05-26 20:55:48.416552	2018-05-26 21:20:50.342164
562	2	Formal Logic	http://en.wikibooks.org/wiki/Formal_Logic	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	formal logic	\N	2018-05-26 20:55:48.433626	2018-05-26 21:20:50.358174
563	2	Historical Introduction to Philosophy	http://en.wikiversity.org/wiki/Historical_Introduction_to_Philosophy	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	historical introduction to philosophy	\N	2018-05-26 20:55:48.45242	2018-05-26 21:20:50.371009
564	2	Introducing Philosophy	http://openlearn.open.ac.uk/mod/oucontent/view.php?id=397165&direct=1	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introducing philosophy	\N	2018-05-26 20:55:48.46458	2018-05-26 21:20:50.383207
565	2	Introduction to Ethical Studies	http://philosophy.lander.edu/ethics/ethicsbook/book1.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	introduction to ethical studies	\N	2018-05-26 20:55:48.47639	2018-05-26 21:20:50.39609
566	2	Introduction to Formal Logic	http://www.fecundity.com/logic/download.html	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to formal logic	\N	2018-05-26 20:55:48.492145	2018-05-26 21:20:50.412614
685	2	Your Basic Algorithms	http://yourbasic.org/algorithms/	\N	\N	CC BY	https://creativecommons.org/licenses/by/3.0/	CCBY	your basic algorithms	\N	2018-06-20 16:49:07.422614	2018-11-19 19:16:35.563016
537	2	Earth’s Physical Resources: Petroleum	http://openlearn.open.ac.uk/course/view.php?id=2292	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	earth’s physical resources: petroleum	\N	2018-05-26 20:55:48.058218	2018-05-26 21:20:50.003019
570	2	Philosophy of Religion	http://www.qcc.cuny.edu/SocialSciences/ppecorino/PHIL_of_RELIGION_TEXT/TABLE_of_CONTENTS.htm	\N	http://www.newcotorg.cot.education/philosophy-reviews/#phil_rel_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	philosophy of religion	\N	2018-05-26 20:55:48.543326	2018-05-26 21:20:50.464248
572	2	Walden	http://xroads.virginia.edu/~HYPER/WALDEN/walden.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	walden	\N	2018-05-26 20:55:48.571276	2018-05-26 21:20:50.497098
573	2	Analytical Chemistry	http://chem.libretexts.org/Core/Analytical_Chemistry	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	analytical chemistry	\N	2018-05-26 20:55:48.590519	2018-05-26 21:20:50.511508
574	2	The Basics of General, Organic, and Biological Chemistry	http://catalog.flatworldknowledge.com/catalog/editions/ballgob-the-basics-of-general-organic-and-biological-chemistry-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	the basics of general, organic, and biological chemistry	\N	2018-05-26 20:55:48.602446	2018-05-26 21:20:50.528319
575	2	Biological Chemistry	http://chem.libretexts.org/Core/Biological_Chemistry	\N	http://www.collegeopentextbooks.org/chemistry-reviews/#bio_chem_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	biological chemistry	\N	2018-05-26 20:55:48.620897	2018-05-26 21:20:50.547363
576	2	Chem I Virtual Textbook	http://www.chem1.com/acad/webtext/virtualtextbook.html	\N	http://www.collegeopentextbooks.org/chemistry-reviews/#chem1_review	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	chem i virtual textbook	\N	2018-05-26 20:55:48.637948	2018-05-26 21:20:50.559815
577	2	Chemical Principles:Third Edition	http://resolver.caltech.edu/CaltechBOOK:1979.001	\N	\N	Custom	http://authors.library.caltech.edu/policies.html	CUSTOM	chemical principles:third edition	\N	2018-05-26 20:55:48.653365	2018-05-26 21:20:50.572038
580	2	ChemPrime	http://wiki.chemprime.chemeddl.org/index.php/Main_Page	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	chemprime	\N	2018-05-26 20:55:48.725741	2018-05-26 21:20:50.641902
581	2	Concept Development Studies in Chemistry	http://cnx.org/content/col10264/latest/	\N	http://www.collegeopentextbooks.org/chemistry-reviews/#concept_dev_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	concept development studies in chemistry	\N	2018-05-26 20:55:48.738059	2018-05-26 21:20:50.654219
586	2	Introduction to Chemistry	http://oli.cmu.edu/courses/free-open/chemistry/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to chemistry	\N	2018-05-26 20:55:48.843922	2018-05-26 21:20:50.756277
588	2	Introductory Chemistry 1	http://oer.avu.org/handle/123456789/42	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introductory chemistry 1	\N	2018-05-26 20:55:48.869747	2018-05-26 21:20:50.781596
589	2	Introductory Chemistry 2	http://oer.avu.org/handle/123456789/43	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introductory chemistry 2	\N	2018-05-26 20:55:48.886459	2018-05-26 21:20:50.796183
590	2	Macromolecules in Biological System	http://oer.avu.org/handle/123456789/44	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	macromolecules in biological system	\N	2018-05-26 20:55:48.898983	2018-05-26 21:20:50.807563
591	2	NIOSH Pocket Guide to Chemical Hazards	http://www.cdc.gov/niosh/npg/default.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	niosh pocket guide to chemical hazards	\N	2018-05-26 20:55:48.911678	2018-05-26 21:20:50.818696
594	2	Organic Chemistry 2	http://oer.avu.org/handle/123456789/46	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	organic chemistry 2	\N	2018-05-26 20:55:48.97302	2018-05-26 21:20:50.882174
595	2	Organic Chemistry With a Biological Emphasis	http://facultypages.morris.umn.edu/~soderbt/textbook_website.htm	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	organic chemistry with a biological emphasis	\N	2018-05-26 20:55:48.985444	2018-05-26 21:20:50.893458
596	2	Physical and Theoretical Chemistry	http://chem.libretexts.org/Core/Physical_and_Theoretical_Chemistry	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	physical and theoretical chemistry	\N	2018-05-26 20:55:48.998735	2018-05-26 21:20:50.904886
597	2	Physical Chemistry 1	http://oer.avu.org/handle/123456789/47	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	physical chemistry 1	\N	2018-05-26 20:55:49.011279	2018-05-26 21:20:50.916137
598	2	Physical Chemistry 2	http://oer.avu.org/handle/123456789/48	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	physical chemistry 2	\N	2018-05-26 20:55:49.024089	2018-05-26 21:20:50.92742
599	2	Separation, Electroanalytical and Spectrochemical Techniques	http://oer.avu.org/handle/123456789/38	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	separation, electroanalytical and spectrochemical techniques	\N	2018-05-26 20:55:49.036871	2018-05-26 21:20:50.938733
568	2	Logic Gallery	http://humbox.ac.uk/3682/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	logic gallery	\N	2018-05-26 20:55:48.518671	2018-05-26 21:20:50.438952
11	2	eSource: Behavioral and Social Science Research	http://www.esourceresearch.org/tabid/36/Default.aspx	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	esource: behavioral and social science research	\N	2018-05-26 20:55:39.466814	2018-05-26 20:55:46.471662
578	2	Chemistry	http://nongnu.askapache.com/fhsst/Chemistry_Grade_10-12.pdf	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	chemistry	\N	2018-05-26 20:55:48.673581	2018-05-26 20:55:48.687026
579	2	Chemistry LibreTexts Library	http://chem.libretexts.org/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	chemistry libretexts library	\N	2018-05-26 20:55:48.713578	2018-05-26 21:20:50.628529
582	2	Environmental Chemistry	http://oer.avu.org/handle/123456789/39	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	environmental chemistry	\N	2018-05-26 20:55:48.751164	2018-05-26 20:55:48.76386
583	2	Industrial Chemistry	http://oer.avu.org/handle/123456789/40	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	industrial chemistry	\N	2018-05-26 20:55:48.79394	2018-05-26 21:20:50.707647
584	2	Inorganic Chemistry	http://chem.libretexts.org/Core/Inorganic_Chemistry	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	inorganic chemistry	\N	2018-05-26 20:55:48.806377	2018-05-26 20:55:48.818475
585	2	Internet for Chemistry	http://www.vtstutorials.co.uk/Content/ContentDetail.aspx?q=13F12AA6-7375-4B2B-9EB0-E48B70A9182B	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	internet for chemistry	\N	2018-05-26 20:55:48.83103	2018-05-26 21:20:50.743923
592	2	Organic Chemistry	http://chem.libretexts.org/Core/Organic_Chemistry	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	organic chemistry	\N	2018-05-26 20:55:48.92828	2018-05-26 20:55:48.944404
593	2	Organic Chemistry 1	http://oer.avu.org/handle/123456789/45	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	organic chemistry 1	\N	2018-05-26 20:55:48.957343	2018-05-26 21:20:50.863345
602	2	American Music and Popular Culture	http://humbox.ac.uk/2313/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	american music and popular culture	\N	2018-05-26 20:55:49.077869	2018-05-26 21:20:50.978412
603	2	The Berlin Wall 20 Years After	http://photos.state.gov/libraries/amgov/30145/publications-english/the-berlin-wall.pdf	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the berlin wall 20 years after	\N	2018-05-26 20:55:49.091476	2018-05-26 21:20:50.990184
604	2	A Comprehensive Outline of World History	http://cnx.org/content/col10595/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	a comprehensive outline of world history	\N	2018-05-26 20:55:49.104055	2018-05-26 21:20:51.001611
605	2	French Revolution	http://openlearn.open.ac.uk/course/view.php?id=1515	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	french revolution	\N	2018-05-26 20:55:49.118095	2018-05-26 21:20:51.012712
606	2	History in the Making: A History of the People of the United States of America to 1877	http://digitalcommons.northgeorgia.edu/books/1/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	history in the making: a history of the people of the united states of america to 1877	\N	2018-05-26 20:55:49.131448	2018-05-26 21:20:51.023932
607	2	A History of the United States, Vol. 2	http://catalog.flatworldknowledge.com/catalog/editions/2217	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	a history of the united states, vol. 2	\N	2018-05-26 20:55:49.15563	2018-05-26 21:20:51.044782
608	2	The Holocaust	http://openlearn.open.ac.uk/course/view.php?id=2091	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the holocaust	\N	2018-05-26 20:55:49.169754	2018-05-26 21:20:51.056963
609	2	Sage American History	http://sageamericanhistory.net/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	sage american history	\N	2018-05-26 20:55:49.182643	2018-05-26 21:20:51.068833
610	2	A Short Introduction to Japanese History (Shotoku)	http://www.openhistory.org/jhdp/intro/index.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	a short introduction to japanese history (shotoku)	\N	2018-05-26 20:55:49.196798	2018-05-26 21:20:51.081354
611	2	Stories of the Underground Railroad	http://www.shockfamily.info/underground/index.html	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	stories of the underground railroad	\N	2018-05-26 20:55:49.210334	2018-05-26 21:20:51.092958
612	2	Teaching with Documents: Lesson Plans	http://www.oercommons.org/courses/national-history-day-research	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	teaching with documents: lesson plans	\N	2018-05-26 20:55:49.223299	2018-05-26 21:20:51.105766
613	2	U.S. History	https://openstax.org/details/us-history	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	u.s. history	\N	2018-05-26 20:55:49.23939	2018-05-26 20:55:49.253152
615	2	A Celebration of Women Writers	http://digital.library.upenn.edu/women/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	a celebration of women writers	\N	2018-05-26 20:55:49.300509	2018-05-26 21:20:51.177428
616	2	Clear & Simple	https://www.nih.gov/institutes-nih/nih-office-director/office-communications-public-liaison/clear-communication/clear-simple	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	clear & simple	\N	2018-05-26 20:55:49.312272	2018-05-26 21:20:51.190329
618	2	The Flat World Knowledge Handbook	http://www.flatworldknowledge.com/printed-book/356439	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	the flat world knowledge handbook	\N	2018-05-26 20:55:49.336112	2018-05-26 21:20:51.216491
619	2	Frameworks for Academic Writing 2nd ed.	http://spoulter6.wix.com/frameworks	\N	http://www.newcotorg.cot.education/english-composition-reviews/#frameworks_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	frameworks for academic writing 2nd ed.	\N	2018-05-26 20:55:49.348366	2018-05-26 21:20:51.22806
620	2	Journalism 2.0	http://kcnn.org/reports/journalism-2-0/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	journalism 2.0	\N	2018-05-26 20:55:49.360384	2018-05-26 21:20:51.239536
621	2	Methods of Discovery	https://threerivers.digication.com/mod/modhome/published	\N	http://www.newcotorg.cot.education/english-composition-reviews/#methods_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	methods of discovery	\N	2018-05-26 20:55:49.372276	2018-05-26 21:20:51.251211
622	2	Online Technical Writing	https://www.prismnet.com/~hcexres/textbook/	\N	http://www.newcotorg.cot.education/english-composition-reviews/#onl_tch_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	online technical writing	\N	2018-05-26 20:55:49.384338	2018-05-26 21:20:51.263802
623	2	The Process of Research Writing	http://www.stevendkrause.com/tprw/	\N	http://www.newcotorg.cot.education/english-composition-reviews/#proc_res_wr_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the process of research writing	\N	2018-05-26 20:55:49.396079	2018-05-26 21:20:51.276202
624	2	Rhetoric and Composition	http://en.wikibooks.org/wiki/Rhetoric_and_Composition	\N	http://www.newcotorg.cot.education/english-composition-reviews/#rhet_comp_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	rhetoric and composition	\N	2018-05-26 20:55:49.40864	2018-05-26 21:20:51.294365
625	2	Start Writing Fiction	http://www.open.edu/openlearn/history-the-arts/culture/literature-and-creative-writing/creative-writing/start-writing-fiction/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	start writing fiction	\N	2018-05-26 20:55:49.421486	2018-05-26 21:20:51.307434
626	2	Start Writing Plays	http://www.open.edu/openlearn/history-the-arts/start-writing-plays?in_menu=317701	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	start writing plays	\N	2018-05-26 20:55:49.433469	2018-05-26 21:20:51.320337
627	2	Style for Students Online: Effective Technical Writing in the Information Age	https://www.e-education.psu.edu/styleforstudents/	\N	http://www.newcotorg.cot.education/english-composition-reviews/#style_stu_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	style for students online: effective technical writing in the information age	\N	2018-05-26 20:55:49.449453	2018-05-26 21:20:51.332728
628	2	Technical Report Writing	https://ntrs.nasa.gov/search.jsp?R=19930013813	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	technical report writing	\N	2018-05-26 20:55:49.462405	2018-05-26 21:20:51.345258
629	2	Three Modules on Clear Writing Style: An Introduction to The Craft of Argument	http://cnx.org/content/col10551/latest/	\N	http://www.newcotorg.cot.education/english-composition-reviews/#3_mods_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	three modules on clear writing style: an introduction to the craft of argument	\N	2018-05-26 20:55:49.474658	2018-05-26 21:20:51.357235
601	2	Volumetric Chemical Analysis	http://oer.avu.org/handle/123456789/52	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	volumetric chemical analysis	\N	2018-05-26 20:55:49.06226	2018-05-26 21:20:50.960759
614	2	US History since 1877	http://cnx.org/content/col10669/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	us history since 1877	\N	2018-05-26 20:55:49.28413	2018-05-26 21:20:51.159982
633	2	Writing Commons	http://writingcommons.org/open-text	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	writing commons	\N	2018-05-26 20:55:49.534018	2018-05-26 21:20:51.413322
632	2	Writing	https://www.boundless.com/writing/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	writing	\N	2018-05-26 20:55:49.522139	2018-05-26 21:20:51.401414
634	2	Writing for Success	http://www.flatworldknowledge.com/printed-book/225512	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	writing for success	\N	2018-05-26 20:55:49.546324	2018-05-26 21:20:51.426325
635	2	Writing Poetry	http://www.open.edu/openlearn/history-the-arts/writing-poetry?in_menu=317701	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	writing poetry	\N	2018-05-26 20:55:49.558191	2018-05-26 21:20:51.439133
637	2	Writing Spaces: Readings on Writing, Volume 1	http://writingspaces.org/volume1	\N	http://www.newcotorg.cot.education/english-composition-reviews/#wr_spa_1_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	writing spaces: readings on writing, volume 1	\N	2018-05-26 20:55:49.581927	2018-05-26 21:20:51.464073
638	2	Writing Spaces: Readings on Writing, Volume 2	http://writingspaces.org/volume2	\N	http://www.newcotorg.cot.education/english-composition-reviews/#wr_spa_2_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	writing spaces: readings on writing, volume 2	\N	2018-05-26 20:55:49.597092	2018-05-26 21:20:51.480388
639	2	Writing Unleashed	https://issuu.com/scrible77/docs/writing-unleashed-3	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	writing unleashed	\N	2018-05-26 20:55:49.614866	2018-05-26 21:20:51.496373
640	2	Writing What You Know	http://www.open.edu/openlearn/history-the-arts/culture/literature-and-creative-writing/creative-writing/writing-what-you-know/content-section-0?in_menu=317701	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	writing what you know	\N	2018-05-26 20:55:49.633803	2018-05-26 21:20:51.514878
641	2	Cultural Anthropology	https://en.wikibooks.org/wiki/Cultural_Anthropology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	cultural anthropology	\N	2018-05-26 20:55:49.649154	2018-05-26 21:20:51.527094
642	2	Folklife and Fieldwork, An Introduction to Field Techniques	http://www.loc.gov/folklife/fieldwork/pdf/fieldwkComplete.pdf	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	folklife and fieldwork, an introduction to field techniques	\N	2018-05-26 20:55:49.660678	2018-05-26 21:20:51.539572
643	2	Introduction to Paleoanthropology	http://en.wikibooks.org/wiki/Introduction_to_Paleoanthropology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to paleoanthropology	\N	2018-05-26 20:55:49.671457	2018-05-26 21:20:51.551616
644	2	Native Peoples of North America	https://textbooks.opensuny.org/native-peoples-of-north-america/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	native peoples of north america	\N	2018-05-26 20:55:49.682916	2018-05-26 21:20:51.564259
646	2	Bipolar Disorder	http://www.nimh.nih.gov/health/publications/bipolar-disorder/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	bipolar disorder	\N	2018-05-26 20:55:49.706727	2018-05-26 21:20:51.59042
645	2	Attention Deficit/Hyperactivity Disorder (ADHD): The Basics	http://openlearn.open.ac.uk/course/view.php?id=2841	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	attention deficit/hyperactivity disorder (adhd): the basics	\N	2018-05-26 20:55:49.695301	2018-05-26 21:20:51.577768
647	2	The Body: A Phenomenological Psychological Perspective	http://openlearn.open.ac.uk/course/view.php?id=2841	\N	http://www.collegeopentextbooks.org/psychology-reviews/#body_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the body: a phenomenological psychological perspective	\N	2018-05-26 20:55:49.721871	2018-05-26 21:20:51.602357
648	2	Challenging Ideas in Mental Health	http://openlearn.open.ac.uk/course/view.php?id=3505	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	challenging ideas in mental health	\N	2018-05-26 20:55:49.733796	2018-05-26 21:20:51.614438
649	2	Cognitive Psychology and Cognitive Neuroscience	http://en.wikibooks.org/wiki/Cognitive_Psychology_and_Cognitive_Neuroscience	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	cognitive psychology and cognitive neuroscience	\N	2018-05-26 20:55:49.745274	2018-05-26 21:20:51.627038
650	2	Depression Basics	http://www.nimh.nih.gov/health/publications/depression/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	depression basics	\N	2018-05-26 20:55:49.756546	2018-05-26 21:20:51.639636
651	2	Developmental Psychology	https://oer.avu.org/handle/123456789/72	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	developmental psychology	\N	2018-05-26 20:55:49.7679	2018-05-26 21:20:51.652053
652	2	Eating Disorders: About More Than Food	http://www.nimh.nih.gov/health/publications/eating-disorders/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	eating disorders: about more than food	\N	2018-05-26 20:55:49.779182	2018-05-26 21:20:51.664528
653	2	Groups and Teamwork	http://openlearn.open.ac.uk/course/view.php?id=2338	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	groups and teamwork	\N	2018-05-26 20:55:49.805679	2018-05-26 21:20:51.691673
654	2	Introduction to General Psychology	https://oer.avu.org/handle/123456789/71	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to general psychology	\N	2018-05-26 20:55:49.8172	2018-05-26 21:20:51.70382
657	2	The Making of Individual Differences	http://openlearn.open.ac.uk/course/view.php?id=3027	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the making of individual differences	\N	2018-05-26 20:55:49.863339	2018-05-26 21:20:51.752811
658	2	Men and Depression	http://www.nimh.nih.gov/health/publications/men-and-depression/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	men and depression	\N	2018-05-26 20:55:49.87458	2018-05-26 21:20:51.764862
659	2	Mental Health Practice	http://openlearn.open.ac.uk/course/view.php?id=3779	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	mental health practice	\N	2018-05-26 20:55:49.885754	2018-05-26 21:20:51.776109
660	2	Psychology	https://openstax.org/details/psychology	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	psychology	\N	2018-05-26 20:55:49.896774	2018-05-26 20:55:49.923936
631	2	Write or Left: an OER textbooks for creative writing classes	https://issuu.com/scrible77/docs/cw211_oer_writeorleft	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	write or left: an oer textbooks for creative writing classes	\N	2018-05-26 20:55:49.502268	2018-05-26 21:20:51.385827
655	2	Introduction to Psychology	http://en.wikibooks.org/wiki/Introduction_to_Psychology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to psychology	\N	2018-05-26 20:55:49.829391	2018-05-26 20:55:49.841002
656	2	Learning Psychology	https://oer.avu.org/handle/123456789/77	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	learning psychology	\N	2018-05-26 20:55:49.852121	2018-05-26 21:20:51.740619
661	2	The Psychology Of Emotions, Feelings and Thoughts	http://cnx.org/content/col10447/latest/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	the psychology of emotions, feelings and thoughts	\N	2018-05-26 20:55:49.935401	2018-05-26 21:20:51.828429
14	2	The Future of Emergency Management - Papers from the 2005 FEMA Emergency Management Higher Education Conference	https://training.fema.gov/hiedu/aemrc/booksdownload/emfuture/	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	the future of emergency management - papers from the 2005 fema emergency management higher education conference	\N	2018-05-26 20:55:39.514101	2018-05-26 21:20:41.924266
65	2	Operational Amplifiers and Linear Integrated Circuits: Theory and Application - Laboratory Manual	http://www2.mvcc.edu/users/faculty/jfiore/freebooks.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	operational amplifiers and linear integrated circuits: theory and application - laboratory manual	\N	2018-05-26 20:55:40.323431	2018-05-26 21:20:42.623725
458	2	Sociology: Understanding and Changing the Social World, Comprehensive Ed.	http://catalog.flatworldknowledge.com/catalog/editions/barkan-2_0-sociology-understanding-and-changing-the-social-world-comprehensive-edition-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	sociology: understanding and changing the social world, comprehensive ed.	\N	2018-05-26 20:55:46.699045	2018-05-26 21:20:48.716748
664	2	Social Psychology	http://en.wikibooks.org/wiki/Social_Psychology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	social psychology	\N	2018-05-26 20:55:49.973696	2018-05-26 21:20:51.86506
665	2	Starting with Psychology	http://www.open.edu/openlearn/health-sports-psychology/psychology/starting-psychology/content-section-0	\N	http://www.collegeopentextbooks.org/psychology-reviews/#strt_psych_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	starting with psychology	\N	2018-05-26 20:55:49.984964	2018-05-26 21:20:51.878096
666	2	Women and Depression: 5 Things You Should Know	http://www.nimh.nih.gov/health/publications/women-and-depression-discovering-hope/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	women and depression: 5 things you should know	\N	2018-05-26 20:55:49.99612	2018-05-26 21:20:51.890581
667	2	American Literature Before 1860	http://www.riosalado.edu/materials/open-textbook/ENH241-American-Literature-Before-1860.pdf	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	american literature before 1860	\N	2018-05-26 20:55:50.01122	2018-05-26 21:20:51.903536
668	2	Billie Budd	https://www.cali.org/books/billy-budd	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	billie budd	\N	2018-05-26 20:55:50.022998	2018-05-26 21:20:51.916057
669	2	Bleak House	https://www.cali.org/books/bleak-house	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	bleak house	\N	2018-05-26 20:55:50.035314	2018-05-26 21:20:51.928965
670	2	The Brothers Karamazov	https://www.cali.org/books/brothers-karamazov	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the brothers karamazov	\N	2018-05-26 20:55:50.047	2018-05-26 21:20:51.94114
671	2	Bulfinch’s Mythology	http://www.owasu.org/ebooks/bulfinch_mythology.pdf	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	bulfinch’s mythology	\N	2018-05-26 20:55:50.059314	2018-05-26 21:20:51.953388
672	2	Electronic Literature Collection, Volume 1	http://collection.eliterature.org/1/	\N	http://www.newcotorg.cot.education/literature-reviews#elec_lit_col_v1_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	electronic literature collection, volume 1	\N	2018-05-26 20:55:50.075222	2018-05-26 21:20:51.964827
673	2	Electronic Literature Collection, Volume 2	http://collection.eliterature.org/2/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	electronic literature collection, volume 2	\N	2018-05-26 20:55:50.09784	2018-05-26 21:20:51.988915
674	2	Electronic Literature Collection, Volume 3	http://collection.eliterature.org/3/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	electronic literature collection, volume 3	\N	2018-05-26 20:55:50.125034	2018-05-26 21:20:52.011095
675	2	Literature, the Humanities, and Humanity	https://textbooks.opensuny.org/literature-humanities-humanity/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	literature, the humanities, and humanity	\N	2018-05-26 20:55:50.146412	2018-05-26 21:20:52.035754
676	2	The Merchant of Venice	https://www.cali.org/books/merchant-venice	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the merchant of venice	\N	2018-05-26 20:55:50.158012	2018-05-26 21:20:52.048197
677	2	Mythology Unbound: An Online Textbook for Classical Mythology	https://press.rebus.community/mythologyunbound/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	mythology unbound: an online textbook for classical mythology	\N	2018-05-26 20:55:50.170231	2018-05-26 21:20:52.060124
678	2	The Oedipus Cycle	https://www.cali.org/books/oedipus-cycle	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the oedipus cycle	\N	2018-05-26 20:55:50.185624	2018-05-26 21:20:52.076507
680	2	Ovid, "Amores" (Book 1)	https://www.openbookpublishers.com/product/348	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ovid, "amores" (book 1)	\N	2018-05-26 20:55:50.213838	2018-05-26 21:20:52.101752
681	2	Ovid, "Metamorphoses", 3.511-733	https://www.openbookpublishers.com/product/293	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	ovid, "metamorphoses", 3.511-733	\N	2018-05-26 20:55:50.225432	2018-05-26 21:20:52.11434
682	2	Studies in Classic American Literature by D.H. Lawrence	http://xroads.virginia.edu/%7EHYPER/LAWRENCE/lawrence.html	\N	http://www.newcotorg.cot.education/literature-reviews/#stds_cl_am_lit_review	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	studies in classic american literature by d.h. lawrence	\N	2018-05-26 20:55:50.240412	2018-05-26 21:20:52.130685
683	2	The Trial	https://www.cali.org/books/trial	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the trial	\N	2018-05-26 20:55:50.251531	2018-05-26 21:20:52.143286
39	2	Introduction to Financial Accounting - Second Edition	http://open.bccampus.ca/find-open-textbooks/?uuid=0370418e-be7d-4541-b0d1-cf8a0fa0596f&contributor=&keyword=&subject=Accounting	https://open.bccampus.ca/find-open-textbooks/?uuid=0370418e-be7d-4541-b0d1-cf8a0fa0596f&contributor=&keyword=&subject=Accounting	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to financial accounting - second edition	\N	2018-05-26 20:55:39.944015	2018-05-26 21:20:42.280857
97	2	The Principles of Management v. 3.0	http://catalog.flatworldknowledge.com/catalog/editions/carpenter_3_0-principles-of-management-3-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	the principles of management v. 3.0	\N	2018-05-26 20:55:40.838206	2018-05-26 21:20:43.088187
663	2	Schizophrenia	http://www.nimh.nih.gov/health/publications/schizophrenia/index.shtml	\N	\N	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	schizophrenia	\N	2018-05-26 20:55:49.958379	2018-05-26 21:20:51.853154
662	2	Psychology in the 21st Century	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/psychology-the-21st-century/content-section-0	\N	http://www.collegeopentextbooks.org/psychology-reviews/#psych_21_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	psychology in the 21st century	\N	2018-05-26 20:55:49.946711	2018-05-26 21:20:51.840606
155	2	Applied Discrete Structures	http://faculty.uml.edu/klevasseur/ads2/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	applied discrete structures	\N	2018-05-26 20:55:41.815195	2018-05-26 21:20:43.967737
158	2	Basic Analysis: Introduction to Real Analysis	http://www.jirka.org/ra/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	basic analysis: introduction to real analysis	\N	2018-05-26 20:55:41.855017	2018-05-26 21:20:44.007789
532	2	An Introduction to Geology	http://opengeology.org/textbook/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introduction to geology	\N	2018-05-26 20:55:47.984324	2018-05-26 20:55:48.170342
176	2	A Computational Introduction to Number Theory and Algebra	http://www.shoup.net/ntb/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	a computational introduction to number theory and algebra	\N	2018-05-26 20:55:42.193703	2018-05-26 21:20:44.359656
230	2	Tea Time Numerical Analysis	http://lqbrin.github.io/tea-time-numerical/	https://lqbrin.github.io/tea-time-numerical/ancillaries.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	tea time numerical analysis	\N	2018-05-26 20:55:43.131665	2018-05-26 21:20:45.274352
251	2	Educational Psychology	http://www.saylor.org/site/wp-content/uploads/2012/06/Educational-Psychology.pdf	\N	http://www.newcotorg.cot.education/education-reviews#ed_psych_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	educational psychology	\N	2018-05-26 20:55:43.48316	2018-05-26 21:20:45.610805
257	2	Instructional Design Models	http://edutechwiki.unige.ch/en/EduTech_Wiki:Books/Instructional_desing_models	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	instructional design models	\N	2018-05-26 20:55:43.581512	2018-05-26 21:20:45.692882
260	2	The Learning Marketplace: Meaning, Metadata and Content Syndication in the Learning Object Economy	http://www.downes.ca/files/book3.htm	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the learning marketplace: meaning, metadata and content syndication in the learning object economy	\N	2018-05-26 20:55:43.635179	2018-05-26 21:20:45.730883
295	2	Macroeconomics: Theory, Models, and Policy	http://lyryx.com/products/economics/macroeconomics-theory-markets-policy/	http://lyryx.com/products/economics/macroeconomics-theory-markets-policy/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	macroeconomics: theory, models, and policy	\N	2018-05-26 20:55:44.219278	2018-05-26 21:20:46.232757
334	2	First Amendment: Cases, Controversies, and Contexts	https://www.cali.org/books/first-amendment-cases-controversies-and-contexts	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	first amendment: cases, controversies, and contexts	\N	2018-05-26 20:55:44.87178	2018-05-26 21:20:46.867035
351	2	U.S. Federal Taxation of Individuals 2017	https://www.cali.org/books/us-federal-income-taxation-individuals	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	u.s. federal taxation of individuals 2017	\N	2018-05-26 20:55:45.096334	2018-05-26 21:20:47.097314
359	2	Advanced Topics in Learning Object Design and Reuse	http://ocw.usu.edu/instructional-technology-learning-sciences/advanced-topics-in-learning-object-design-and-reuse/Textbook.html	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	advanced topics in learning object design and reuse	\N	2018-05-26 20:55:45.214313	2018-05-26 21:20:47.214168
389	2	How to Think Like a Computer Scientist: Learning with Python	http://www.openbookproject.net/thinkcs/	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	how to think like a computer scientist: learning with python	\N	2018-05-26 20:55:45.671572	2018-05-26 21:20:47.650659
406	2	Introduction to Microsoft PowerPoint 2007	https://vula.uct.ac.za/access/content/group/f779dbd8-4aa3-40c0-b0dd-be10f9392469/manuals/CET%20Powerpoint%202007%20Training%20Manual%20v1.1.pdf	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to microsoft powerpoint 2007	\N	2018-05-26 20:55:45.935162	2018-05-26 21:20:47.925922
414	2	Legal Aspects of the Information Society	http://ftacademy.org/courses/legal-aspects-of-information-society#materials	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	legal aspects of the information society	\N	2018-05-26 20:55:46.031707	2018-05-26 21:20:48.023165
431	2	Structure and Interpretation of Computer Programs	http://mitpress.mit.edu/sicp/full-text/book/book.html	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	structure and interpretation of computer programs	\N	2018-05-26 20:55:46.271864	2018-05-26 21:20:48.27475
453	2	The Social in Social Science	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/the-social-social-science/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	the social in social science	\N	2018-05-26 20:55:46.637152	2018-05-26 21:20:48.646325
489	2	From Algorithms to Z-Scores: Probabilistic and Statistical Modeling in Computer Science	http://heather.cs.ucdavis.edu/%7Ematloff/probstatbook.html	\N	\N	CC BY-ND	https://creativecommons.org/licenses/by-nd/4.0/	CCBYND	from algorithms to z-scores: probabilistic and statistical modeling in computer science	\N	2018-05-26 20:55:47.1914	2018-05-26 21:20:49.191556
509	2	From Sound to Meaning: Hearing, Speech and Language	http://www.open.edu/openlearn/health-sports-psychology/health/health-studies/sound-meaning-hearing-speech-and-language/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	from sound to meaning: hearing, speech and language	\N	2018-05-26 20:55:47.612416	2018-05-26 21:20:49.577802
549	2	The Opensource Handbook of Nanoscience and Nanotechnology	http://en.wikibooks.org/wiki/Nanotechnology	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the opensource handbook of nanoscience and nanotechnology	\N	2018-05-26 20:55:48.247496	2018-05-26 21:20:50.179585
569	2	Medical Ethics	http://www.qcc.cuny.edu/SocialSciences/ppecorino/MEDICAL_ETHICS_TEXT/Table_of_Contents.htm	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	medical ethics	\N	2018-05-26 20:55:48.531231	2018-05-26 21:20:50.451854
587	2	Introductory Chemistry	http://www.flatworldknowledge.com/printed-book/417188	\N	http://www.collegeopentextbooks.org/chemistry-reviews/#intro_chem_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	introductory chemistry	\N	2018-05-26 20:55:48.856793	2018-05-26 21:20:50.769328
131	2	Physics Light and Matter	http://www.lightandmatter.com/lm/	http://www.lightandmatter.com/books.html	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	physics light and matter	\N	2018-05-26 20:55:41.449242	2018-05-26 21:20:43.632958
189	2	A First Course in Linear Algebra	http://lyryx.com/products/mathematics/first-course-linear-algebra/	http://lyryx.com/products/mathematics/first-course-linear-algebra/	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	a first course in linear algebra	\N	2018-05-26 20:55:42.385589	2018-05-26 20:55:42.398292
222	2	Proofs and Concepts: the fundamentals of abstract mathematics	http://people.uleth.ca/~dave.morris/books/proofs+concepts.html	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	proofs and concepts: the fundamentals of abstract mathematics	\N	2018-05-26 20:55:43.031208	2018-05-26 21:20:45.176694
617	2	Exploring Perspectives: A Concise Guide to Analysis	http://catalog.flatworldknowledge.com/catalog/editions/97	\N	http://www.newcotorg.cot.education/english-composition-reviews/#expl_persp_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	exploring perspectives: a concise guide to analysis	\N	2018-05-26 20:55:49.324352	2018-05-26 21:20:51.203399
630	2	University of North Carolina College Writing	http://writingcenter.unc.edu/handouts/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	university of north carolina college writing	\N	2018-05-26 20:55:49.490053	2018-05-26 21:20:51.372733
687	2	Writing Research Papers in a Facebook Age	https://tinyurl.com/y8wv4kaa	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	writing research papers in a facebook age	\N	2018-06-20 16:49:10.63717	2018-11-19 19:16:38.947416
679	2	Outline of American Literature	https://publications.america.gov/publication/outline-of-american-literature-outline-series/	\N	http://www.newcotorg.cot.education/literature-reviews/#outl_am_lit_review	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	outline of american literature	\N	2018-05-26 20:55:50.19803	2018-05-26 21:20:52.089332
33	2	Intermediate Financial Accounting Volume 1	http://lyryx.com/products/accounting/intermediate-financial-accounting-volume-1/	http://lyryx.com/products/accounting/intermediate-financial-accounting-volume-1/	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	intermediate financial accounting volume 1	\N	2018-05-26 20:55:39.841121	2018-05-26 21:20:42.186035
692	2	Direct Energy Conversion	https://www.trine.edu/books/directenergy.aspx/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	direct energy conversion	\N	2018-11-19 19:16:29.763265	\N
70	2	Business Communication for Success v. 2.0	http://catalog.flatworldknowledge.com/catalog/editions/mclean_2_0-business-communication-for-success-2-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	business communication for success v. 2.0	\N	2018-05-26 20:55:40.40479	2018-05-26 20:55:47.415121
686	2	Urban Studies: Like your Garden, Cities Grow and Wither with the Winds	https://tinyurl.com/ycwn2f2t\\	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	urban studies: like your garden, cities grow and wither with the winds	\N	2018-06-20 16:49:08.965323	2018-11-19 19:16:37.176334
86	2	Internet for Business and Management	http://www.vtstutorials.co.uk/ws//tracking/launchcontent.aspx?cv=78911681-E697-49D1-B98C-7901B6648D0E&e=A0000&c=19FCBF04-106D-49FB-BAE8-8274A87C680F&SID=167d2a9c-76e8-4d41-90ab-030635b88532	\N	\N	Custom	http://www.vtstutorials.co.uk/ws//tracking/launchcontent.aspx?cv=78911681-E697-49D1-B98C-7901B6648D0E&e=A0000&c=19FCBF04-106D-49FB-BAE8-8274A87C680F&SID=167d2a9c-76e8-4d41-90ab-030635b88532	CUSTOM	internet for business and management	\N	2018-05-26 20:55:40.642174	2018-05-26 21:20:42.928161
694	2	Introduction to Business	https://openstax.org/details/books/introduction-business	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to business	\N	2018-11-19 19:16:30.279387	\N
695	2	Introductory Business Statistics	https://openstax.org/details/books/introductory-business-statistics	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introductory business statistics	\N	2018-11-19 19:16:30.295663	\N
87	2	Launch! Advertising and Promotion in Real Time	http://www.flatworldknowledge.com/printed-book/2145	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	launch! advertising and promotion in real time	\N	2018-05-26 20:55:40.654999	2018-05-26 21:20:42.940547
697	2	College Physics for AP® Courses	https://openstax.org/details/college-physics-ap-courses	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	college physics for ap® courses	\N	2018-11-19 19:16:30.726991	\N
128	2	Motion Mountain – The Adventure of Physics	http://www.motionmountain.net/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	motion mountain – the adventure of physics	\N	2018-05-26 20:55:41.408178	2018-05-26 21:20:43.593674
36	2	International Trade: Theory and Policy	http://catalog.flatworldknowledge.com/catalog/editions/surantrade-international-trade-theory-and-policy-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	international trade: theory and policy	\N	2018-05-26 20:55:39.890013	2018-05-26 20:55:44.165003
696	2	Microeconomics for Business	https://oer.galileo.usg.edu/business-textbooks/6/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	microeconomics for business	\N	2018-11-19 19:16:30.361404	2018-11-19 19:16:33.463247
487	2	Collaborative Statistics	http://cnx.org/content/col10522/latest/	https://cnx.org/contents/suk7Knt7@7/Collaborative-Statistics-Addit	http://www.newcotorg.cot.education/statistics-probability-reviews/#col_stat_review	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	collaborative statistics	\N	2018-05-26 20:55:47.16229	2018-05-26 21:20:49.164087
69	2	Business Communication for Success v. 1.0	http://catalog.flatworldknowledge.com/catalog/editions/mclean-business-communication-for-success-1-0	\N	http://www.newcotorg.cot.education/languages-communication-reviews/#bus_comm_review	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	business communication for success v. 1.0	\N	2018-05-26 20:55:40.391697	2018-05-26 20:55:47.400852
536	2	Deserts: Geology and Resources	http://pubs.usgs.gov/gip/deserts/	\N	\N	PD	https://en.wikipedia.org/wiki/Public_domain	PD	deserts: geology and resources	\N	2018-05-26 20:55:48.045576	2018-05-26 21:20:49.990294
552	2	Science Appreciation: Introduction to Science Literacy	http://www.compadre.org/Repository/document/ServeFile.cfm?ID=2171&DocID=12&extern_usr=guest&extern_id=2&course_id=1647#Doc12	\N	\N	Custom	http://www.compadre.org/Repository/document/ServeFile.cfm?ID=2171&DocID=12&extern_usr=guest&extern_id=2&course_id=1647#Doc12	CUSTOM	science appreciation: introduction to science literacy	\N	2018-05-26 20:55:48.286761	2018-05-26 21:20:50.216671
567	2	Logic: An Invalid Approach	http://humbox.ac.uk/2475/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	logic: an invalid approach	\N	2018-05-26 20:55:48.504241	2018-05-26 21:20:50.425686
571	2	Reading for Philosophical Inquiry: A Brief Introduction to Philosophical Thinking, An Open Source Reader	http://philosophy.lander.edu/intro/introbook-links.html	\N	\N	GFDL	https://www.gnu.org/licenses/fdl.html	GFDL	reading for philosophical inquiry: a brief introduction to philosophical thinking, an open source reader	\N	2018-05-26 20:55:48.555663	2018-05-26 21:20:50.476057
600	2	Virtual Textbook of Organic Chemistry	http://www2.chemistry.msu.edu/faculty/reusch/VirtTxtJml/intro1.htm	\N	http://www.collegeopentextbooks.org/chemistry-reviews/#virt_org_chem_review	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	virtual textbook of organic chemistry	\N	2018-05-26 20:55:49.049824	2018-05-26 21:20:50.949767
636	2	Writing Skills for Business English: Training for NGO Staff	http://oasis.col.org/handle/11599/463	\N	http://www.newcotorg.cot.education/english-composition-reviews/#wr_skills_review	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	writing skills for business english: training for ngo staff	\N	2018-05-26 20:55:49.569985	2018-05-26 21:20:51.451397
223	2	Ratios, Proportion and Percentages	http://openlearn.open.ac.uk/course/view.php?id=3419	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	ratios, proportion and percentages	\N	2018-05-26 20:55:43.043725	2018-05-26 21:20:45.189044
704	2	Arts Integration in Elementary Curriculum	https://oer.galileo.usg.edu/education-textbooks/3/	\N	\N	CUSTOM	https://oer.galileo.usg.edu/faq.html#faq-5	CUSTOM	arts integration in elementary curriculum	\N	2018-11-19 19:16:32.561716	\N
241	2	Common Wisdom: Peer Production of Educational Materials	http://www.benkler.org/Common_Wisdom.pdf	\N	http://www.newcotorg.cot.education/education-reviews#common_wisdom_review	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	common wisdom: peer production of educational materials	\N	2018-05-26 20:55:43.319729	2018-05-26 21:20:45.452382
705	2	Educational Learning Theories: 2nd Edition	https://oer.galileo.usg.edu/education-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	educational learning theories: 2nd edition	\N	2018-11-19 19:16:32.741452	\N
258	2	The Instructional Use of Learning Objects	http://reusability.org/read/	\N	\N	OPL	https://www.opencontent.org/openpub/	OPL	the instructional use of learning objects	\N	2018-05-26 20:55:43.601808	2018-05-26 21:20:45.705879
706	2	K-5 Math and Technology Resources	https://oer.galileo.usg.edu/education-textbooks/2/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	k-5 math and technology resources	\N	2018-11-19 19:16:32.884023	\N
262	2	Mobile Learning: Transforming the Delivery of Education and Training	http://www.aupress.ca/index.php/books/120155	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	mobile learning: transforming the delivery of education and training	\N	2018-05-26 20:55:43.666439	2018-05-26 21:20:45.760172
707	2	OpenEDUC: Exploring Socio-Cultural Perspectives in Diversity	https://oer.galileo.usg.edu/education-textbooks/8/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	openeduc: exploring socio-cultural perspectives in diversity	\N	2018-11-19 19:16:32.962219	\N
708	2	OpenEDUC: Investigating Critical and Contemporary Issues in Education	https://oer.galileo.usg.edu/education-textbooks/4/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	openeduc: investigating critical and contemporary issues in education	\N	2018-11-19 19:16:32.977679	\N
709	2	OpenNow College Success	https://www.cengage.com/c/opennow-college-success-1e-opennow-cengage/9780357060254	https://www.cengage.com/c/opennow-college-success-1e-opennow-cengage/9780357060254	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	opennow college success	\N	2018-11-19 19:16:32.992083	\N
710	2	Introduction to Art: Design, Context, and Meaning	https://oer.galileo.usg.edu/arts-textbooks/3/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	introduction to art: design, context, and meaning	\N	2018-11-19 19:16:33.195631	\N
711	2	Music Appreciation	http://www.vtstutorials.co.uk/Content/ContentDetail.aspx?q=CB9557A1-348E-4F46-B594-DD0B22ED062C	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	music appreciation	\N	2018-11-19 19:16:33.241193	\N
712	2	Understanding Music: Past and Present	https://oer.galileo.usg.edu/arts-textbooks/1/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	understanding music: past and present	\N	2018-11-19 19:16:33.321584	\N
291	2	International Economics: Theory and Policy	http://catalog.flatworldknowledge.com/catalog/editions/suranovic-international-economics-theory-and-policy-1-0	\N	\N	Custom	http://catalog.flatworldknowledge.com/legal	CUSTOM	international economics: theory and policy	\N	2018-05-26 20:55:44.146227	2018-05-26 21:20:46.171636
297	2	Microeconomics: Markets, Methods, and Models	http://lyryx.com/products/economics/microeconomics-markets-methods-models/	http://lyryx.com/products/economics/microeconomics-markets-methods-models/	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	microeconomics: markets, methods, and models	\N	2018-05-26 20:55:44.24943	2018-05-26 21:20:46.261376
321	2	The Ethics of Tax Lawyering, Third Edition	http://elangdell.cali.org/content/ethics-tax-lawyering	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	the ethics of tax lawyering, third edition	\N	2018-05-26 20:55:44.710855	2018-05-26 21:20:46.693321
352	2	United States Bankruptcy Code 2014-2015	https://www.cali.org/books/united-states-bankruptcy-code-2014-2015	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	united states bankruptcy code 2014-2015	\N	2018-05-26 20:55:45.109144	2018-05-26 21:20:47.110166
713	2	A-level Computing/AQA	https://en.wikibooks.org/wiki/A-level_Computing/AQA	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	a-level computing/aqa	\N	2018-11-19 19:16:34.353755	\N
714	2	Programming Fundamentals – A Modular Structured Approach, 2nd Edition	https://press.rebus.community/programmingfundamentals/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	programming fundamentals – a modular structured approach, 2nd edition	\N	2018-11-19 19:16:35.245622	\N
716	2	An Introduction to Social Work	http://www.open.edu/openlearn/health-sports-psychology/social-care/social-work/introduction-social-work/content-section-0	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	an introduction to social work	\N	2018-11-19 19:16:35.613569	\N
717	2	Introduction to Sociology 2e	http://openstaxcollege.org/textbooks/introduction-to-sociology-2e	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	introduction to sociology 2e	\N	2018-11-19 19:16:35.654907	\N
715	2	Behavioral & Social Science Research	http://www.esourceresearch.org/tabid/226/default.aspx	\N	http://www.collegeopentextbooks.org/psychology-reviews#beh_soc_sci_res_review	PD	https://wiki.creativecommons.org/wiki/Public_domain	PD	behavioral & social science research	\N	2018-11-19 19:16:35.584952	2018-11-19 19:16:39.089022
719	2	Scientific Inquiry in Social Work	https://scientificinquiryinsocialwork.pressbooks.com/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	scientific inquiry in social work	\N	2018-11-19 19:16:35.745976	\N
720	2	Biology 2e	https://openstax.org/details/books/biology-2e	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	biology 2e	\N	2018-11-19 19:16:35.920137	\N
721	2	Biology for AP® Courses	https://openstax.org/details/books/biology-ap-courses	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	biology for ap® courses	\N	2018-11-19 19:16:35.939328	\N
722	2	Concepts of Biology	https://openstax.org/details/books/concepts-biology	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	concepts of biology	\N	2018-11-19 19:16:35.978539	\N
723	2	Instructor's Guide to Concepts of Biology, Chapters 12-21	https://oer.galileo.usg.edu/biology-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	instructor's guide to concepts of biology, chapters 12-21	\N	2018-11-19 19:16:36.091958	\N
342	2	Reading Evidence	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/reading-evidence/content-section-0	\N	http://www.newcotorg.cot.education/sociology-reviews/#rd_ev_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	reading evidence	\N	2018-05-26 20:55:44.963296	2018-05-26 20:55:46.625649
724	2	Microbiology for Allied Health Students	https://oer.galileo.usg.edu/biology-textbooks/15/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	microbiology for allied health students	\N	2018-11-19 19:16:36.147996	\N
725	2	Microbiology for Allied Health Students: Lab Manual	https://oer.galileo.usg.edu/biology-textbooks/16/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	microbiology for allied health students: lab manual	\N	2018-11-19 19:16:36.163468	\N
726	2	Phylogenetic Comparative Methods: Learning from trees	https://lukejharmon.github.io/pcm/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	phylogenetic comparative methods: learning from trees	\N	2018-11-19 19:16:36.239144	\N
727	2	Plants, Society and the Environment	https://oer.galileo.usg.edu/biology-collections/16/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	plants, society and the environment	\N	2018-11-19 19:16:36.262296	\N
728	2	Principles of Biology I Lab Manual	https://oer.galileo.usg.edu/biology-textbooks/3/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	principles of biology i lab manual	\N	2018-11-19 19:16:36.27794	\N
729	2	Principles of Biology II Lab Manual	https://oer.galileo.usg.edu/biology-textbooks/2/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	principles of biology ii lab manual	\N	2018-11-19 19:16:36.29698	\N
490	2	Getting Started with SPSS	http://www.open.edu/openlearn/people-politics-law/politics-policy-people/sociology/getting-started-spss/content-section-0	\N	http://www.newcotorg.cot.education/statistics-probability-reviews/#spss_review	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	getting started with spss	\N	2018-05-26 20:55:47.20379	2018-05-26 21:20:49.203818
220	2	Probability and Statistics	http://wiki.stat.ucla.edu/socr/index.php/EBook	\N	\N	Custom	http://wiki.stat.ucla.edu/socr/index.php/Probability_and_statistics_EBook#Preface	CUSTOM	probability and statistics	\N	2018-05-26 20:55:43.006649	2018-05-26 20:55:47.331755
730	2	Exploring Public Speaking: 2nd Edition	http://oer.galileo.usg.edu/communication-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	exploring public speaking: 2nd edition	\N	2018-11-19 19:16:36.748632	\N
731	2	Hola a Todos: Elementary Spanish I	https://oer.galileo.usg.edu/languages-textbooks/3/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	hola a todos: elementary spanish i	\N	2018-11-19 19:16:36.802456	\N
732	2	Liberte: French 1001: 2nd Edition	https://oer.galileo.usg.edu/languages-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	liberte: french 1001: 2nd edition	\N	2018-11-19 19:16:36.884028	\N
733	2	Liberte: French 1002: 2nd Edition	https://oer.galileo.usg.edu/languages-textbooks/2/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	liberte: french 1002: 2nd edition	\N	2018-11-19 19:16:36.899157	\N
734	2	Sexy Technical Communication	https://oer.galileo.usg.edu/communication-textbooks/2/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	sexy technical communication	\N	2018-11-19 19:16:36.947578	\N
718	2	A quick, free, somewhat easy-to-read introduction to empirical social science research methods	https://scholar.utc.edu/oer/1/	\N	\N	CC BY-NC-ND	https://creativecommons.org/licenses/by-nc-nd/4.0/	CCBYNCND	a quick, free, somewhat easy-to-read introduction to empirical social science research methods	\N	2018-11-19 19:16:35.721276	2018-11-19 19:16:37.15227
735	2	Astronomy	https://openstax.org/details/books/astronomy	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	astronomy	\N	2018-11-19 19:16:37.24354	\N
736	2	Introduction to Environmental Science: 2nd Edition	https://oer.galileo.usg.edu/biology-textbooks/4/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	introduction to environmental science: 2nd edition	\N	2018-11-19 19:16:37.382593	\N
737	2	Laboratory Manual for Introductory Geology	https://oer.galileo.usg.edu/geo-textbooks/1/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	laboratory manual for introductory geology	\N	2018-11-19 19:16:37.439812	\N
738	2	UGA Anatomy and Physiology I Lab Manual	https://oer.galileo.usg.edu/biology-textbooks/13/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	uga anatomy and physiology i lab manual	\N	2018-11-19 19:16:37.575783	\N
739	2	UGA Anatomy and Physiology II Lab Manual	https://oer.galileo.usg.edu/biology-textbooks/14/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	uga anatomy and physiology ii lab manual	\N	2018-11-19 19:16:37.602409	\N
740	2	Chemistry: Atoms First	https://openstax.org/details/books/chemistry-atoms-first	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	chemistry: atoms first	\N	2018-11-19 19:16:37.974379	\N
741	2	Survey of Chemistry II	https://oer.galileo.usg.edu/chemistry-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	survey of chemistry ii	\N	2018-11-19 19:16:38.316108	\N
742	2	Western Civilization I	https://oer.galileo.usg.edu/history-textbooks/3/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	western civilization i	\N	2018-11-19 19:16:38.560775	\N
743	2	World History: Cultures, States, and Societies to 1500	https://oer.galileo.usg.edu/history-textbooks/2/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	world history: cultures, states, and societies to 1500	\N	2018-11-19 19:16:38.576914	\N
744	2	College ESL Writers: Applied Grammar and Composing Strategies for Success	https://oer.galileo.usg.edu/english-textbooks/14/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	college esl writers: applied grammar and composing strategies for success	\N	2018-11-19 19:16:38.624724	\N
745	2	The Gordon State College Writing Handbook	https://oer.galileo.usg.edu/english-textbooks/7/	\N	\N	CUSTOM	https://oer.galileo.usg.edu/faq.html#faq-5	CUSTOM	the gordon state college writing handbook	\N	2018-11-19 19:16:38.680948	\N
746	2	OpenNow Developmental English: Integrated Reading & Writing	https://www.cengage.com/c/opennow-developmental-english-1e-cengage-learning/9780357060247	https://www.cengage.com/c/opennow-developmental-english-1e-cengage-learning/9780357060247	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	opennow developmental english: integrated reading & writing	\N	2018-11-19 19:16:38.732721	\N
747	2	OpenNow English Composition	https://www.cengage.com/c/opennow-english-composition-1e-cengage-learning/9780357060261	https://www.cengage.com/c/opennow-english-composition-1e-cengage-learning/9780357060261	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	opennow english composition	\N	2018-11-19 19:16:38.745324	\N
748	2	The Roadrunner's Guide to English	https://oer.galileo.usg.edu/english-textbooks/9/	\N	\N	CUSTOM	https://oer.galileo.usg.edu/faq.html#faq-5	CUSTOM	the roadrunner's guide to english	\N	2018-11-19 19:16:38.78301	\N
749	2	Successful College Composition	https://oer.galileo.usg.edu/english-textbooks/8/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	successful college composition	\N	2018-11-19 19:16:38.840955	\N
750	2	General Psychology	https://oer.galileo.usg.edu/psychology-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	general psychology	\N	2018-11-19 19:16:39.180308	\N
751	2	Psychological Adjustment	https://oer.galileo.usg.edu/psychology-textbooks/11/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	psychological adjustment	\N	2018-11-19 19:16:39.282939	\N
752	2	UWG Introduction to General Psychology	https://oer.galileo.usg.edu/psychology-textbooks/10/	\N	\N	CC BY	https://creativecommons.org/licenses/by/4.0/	CCBY	uwg introduction to general psychology	\N	2018-11-19 19:16:39.374548	\N
753	2	Compact Anthology of World Literature	https://oer.galileo.usg.edu/english-textbooks/2/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	compact anthology of world literature	\N	2018-11-19 19:16:39.544866	\N
754	2	Open Access Companion to The Canterbury Tales	https://opencanterburytales.dsl.lsu.edu/	\N	\N	CC BY-NC	https://creativecommons.org/licenses/by-nc/4.0/	CCBYNC	open access companion to the canterbury tales	\N	2018-11-19 19:16:39.679426	\N
755	2	Open Anthology of Early World Literatue in English Translation	https://oer.galileo.usg.edu/english-textbooks/1/	\N	\N	CC BY-NC-SA	https://creativecommons.org/licenses/by-nc-sa/4.0/	CCBYNCSA	open anthology of early world literatue in english translation	\N	2018-11-19 19:16:39.695467	\N
756	2	World Literature I: Beginnings to 1650	https://oer.galileo.usg.edu/english-textbooks/6/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	world literature i: beginnings to 1650	\N	2018-11-19 19:16:39.777642	\N
757	2	Writing the Nation: A Concise Introduction to American Literature 1865 to Present	https://oer.galileo.usg.edu/english-textbooks/5/	\N	\N	CC BY-SA	https://creativecommons.org/licenses/by-sa/4.0/	CCBYSA	writing the nation: a concise introduction to american literature 1865 to present	\N	2018-11-19 19:16:39.801272	\N
\.


--
-- Data for Name: resource_author; Type: TABLE DATA; Schema: public; Owner: api
--

COPY resource_author (resource_id, author_id) FROM stdin;
1	1
2	9
2	499
2	2
2	3
2	4
2	5
2	6
2	7
2	8
2	10
3	11
688	665
688	499
4	12
5	11
6	13
7	1
8	14
14	11
9	15
10	16
10	17
11	18
12	19
27	24
13	15
15	20
30	24
16	1
17	1
18	11
19	1
20	21
21	22
22	1
23	1
689	666
689	667
690	668
690	499
24	23
25	1
26	1
691	665
691	499
218	499
28	25
28	26
28	27
29	28
68	24
31	29
32	30
33	31
33	32
33	166
34	31
34	32
34	166
35	33
37	34
37	35
88	24
38	36
38	37
91	24
38	166
39	37
40	38
41	39
42	40
247	260
43	41
43	42
44	43
45	44
46	45
47	46
48	45
49	44
50	47
692	669
113	108
113	109
113	110
114	111
114	112
114	113
114	114
114	115
114	116
275	135
290	24
148	135
149	499
51	48
51	49
52	50
53	44
54	51
55	52
56	53
57	30
169	167
58	54
169	168
59	55
170	169
170	170
170	171
170	172
60	44
61	56
171	170
171	168
171	173
171	174
171	175
62	57
172	176
172	177
63	57
173	499
64	58
65	44
66	44
67	44
71	670
71	671
71	60
71	61
72	62
73	63
75	65
76	66
77	67
77	68
77	69
77	70
78	71
79	72
80	73
81	74
82	74
83	67
84	75
85	76
85	77
86	78
149	137
149	138
694	673
149	139
149	140
149	141
149	142
149	143
694	499
695	674
695	470
695	477
87	79
87	80
87	81
89	19
90	73
92	82
92	83
93	73
94	73
95	84
96	85
96	82
96	86
97	82
97	86
97	87
97	85
98	88
98	89
98	90
99	91
99	92
100	88
101	93
101	94
423	403
102	93
102	94
103	95
104	96
104	97
104	98
173	137
173	138
173	141
173	143
105	99
173	142
105	100
173	178
173	140
106	73
107	101
108	102
108	4
109	103
110	104
111	105
112	106
113	107
113	679
697	111
697	112
697	113
697	114
697	115
697	116
447	73
115	117
116	50
117	118
118	45
119	117
120	119
448	423
448	424
448	425
448	426
448	427
448	428
448	429
448	430
448	431
122	122
123	123
124	124
125	125
125	117
126	126
127	127
128	128
129	127
455	135
130	129
131	117
132	122
133	130
134	123
135	131
136	131
137	122
138	1
139	117
140	50
141	130
142	122
143	127
462	135
698	680
698	681
698	682
465	448
699	680
699	681
699	682
466	55
466	449
466	450
466	451
700	680
700	681
700	682
144	132
145	133
146	133
147	134
149	136
150	144
151	145
152	146
153	146
474	135
154	147
154	148
154	149
154	150
154	151
481	135
155	152
155	153
156	154
701	683
701	684
157	19
158	155
159	156
159	157
160	158
161	159
162	160
163	122
693	672
693	166
164	161
164	162
164	163
165	164
165	165
166	164
218	137
218	138
166	165
218	139
218	140
218	141
218	143
218	142
167	164
167	165
168	163
168	166
173	136
174	179
174	180
175	179
175	181
176	182
702	685
702	686
702	687
502	24
177	1
178	183
179	184
180	185
180	186
180	187
181	188
507	502
507	503
182	189
182	190
182	688
182	689
182	191
236	239
183	192
184	193
236	240
185	193
186	194
188	196
189	197
189	198
189	661
189	166
190	198
191	122
191	199
191	200
192	189
192	201
244	252
244	253
193	147
194	202
531	135
195	73
195	203
703	690
196	156
196	204
196	688
196	205
197	156
197	157
198	1
199	206
200	149
201	207
202	208
540	532
203	156
203	209
202	193
204	210
204	211
204	212
204	213
204	125
205	214
205	166
206	194
207	215
208	216
208	139
209	217
125	218
210	219
211	220
212	221
213	1
214	222
215	223
215	224
215	225
216	226
216	227
217	228
218	136
218	179
218	181
219	139
219	229
220	230
221	231
222	232
223	1
224	1
225	233
226	234
227	234
228	1
229	1
230	235
231	236
231	19
232	237
233	236
234	238
578	564
235	238
578	24
237	241
237	242
704	691
704	676
238	243
239	244
240	245
240	246
240	247
240	248
241	249
242	250
243	251
245	254
245	255
245	256
245	257
245	26
245	258
246	259
247	692
248	261
249	243
705	691
705	676
250	262
251	263
251	264
252	243
253	265
254	266
255	267
255	268
256	251
257	269
258	270
259	271
706	693
706	694
706	695
613	135
260	272
261	273
262	274
263	275
264	275
707	696
707	499
708	696
708	499
709	697
265	276
266	277
267	278
268	279
269	280
270	281
271	282
272	283
273	284
273	285
274	286
632	24
275	45
276	287
277	288
277	289
278	288
278	289
279	45
710	698
710	699
710	700
710	701
280	290
281	78
711	702
711	499
645	601
282	19
283	286
284	287
285	291
285	292
286	287
11	419
11	420
712	703
712	704
712	705
712	706
287	293
288	293
289	294
291	33
36	33
292	295
293	296
294	29
660	627
660	628
660	629
660	630
660	631
660	632
295	297
660	135
295	298
295	166
696	675
696	676
696	677
696	678
296	29
297	297
297	298
297	166
298	299
298	300
299	301
299	302
300	303
301	304
301	305
301	306
301	307
301	308
302	297
302	298
302	166
303	305
303	309
304	305
304	306
302	307
302	308
305	297
305	298
305	166
306	305
306	306
307	305
307	306
305	307
360	342
305	308
308	310
309	311
309	312
310	313
311	249
312	314
313	315
314	188
315	316
315	317
316	318
317	318
318	318
319	319
320	320
321	321
373	354
322	322
323	322
324	322
325	322
326	322
327	322
328	323
329	323
330	324
330	325
331	324
331	325
332	324
332	325
333	323
334	326
335	323
336	327
337	328
338	34
339	34
340	328
341	328
103	330
343	331
343	332
344	322
345	333
345	334
346	335
347	4
348	4
349	336
350	249
351	337
352	323
353	323
354	323
355	323
356	4
357	338
357	339
357	340
713	19
358	73
359	341
361	343
362	45
363	344
363	345
363	346
364	347
364	348
364	349
364	350
365	45
366	131
367	351
368	352
369	342
370	1
371	353
372	73
374	354
375	355
375	356
375	357
376	67
376	68
376	69
376	70
377	358
378	359
379	73
380	360
381	19
382	361
383	362
384	363
385	364
385	365
386	366
386	367
386	368
386	369
387	370
388	371
389	372
389	373
389	374
389	375
390	19
187	120
187	195
121	120
121	121
393	378
393	355
394	73
395	379
396	380
397	73
398	381
399	382
399	383
400	384
401	385
402	73
403	386
404	387
404	388
404	389
405	390
406	390
407	390
408	390
409	54
410	391
411	392
411	393
412	394
413	19
414	395
415	184
416	73
417	19
418	396
419	397
419	398
420	399
420	400
421	401
421	402
422	398
714	403
714	707
424	404
425	405
426	93
426	94
427	406
428	73
429	407
429	101
430	408
430	409
430	410
430	411
431	344
431	412
432	413
433	374
434	374
435	374
436	374
436	414
437	374
438	374
439	415
440	416
441	249
442	417
443	275
444	418
445	19
685	342
446	421
446	422
716	73
448	45
448	432
448	433
448	434
717	423
717	499
449	1
450	1
451	435
452	436
719	709
453	1
454	1
456	432
456	433
456	434
457	437
458	438
459	439
460	440
461	441
462	442
462	443
462	6
462	444
462	445
462	10
720	703
720	443
720	710
721	711
721	712
463	446
464	447
722	713
722	714
722	10
467	452
468	453
469	454
470	455
471	45
391	120
391	376
472	456
472	457
723	715
723	716
473	458
474	717
474	499
475	458
724	715
724	716
725	715
725	716
476	459
477	460
478	461
479	1
480	462
726	718
482	463
727	719
727	720
728	721
728	722
729	721
729	722
483	464
484	1
485	465
485	466
485	467
485	468
485	469
486	1
487	470
487	471
488	472
489	473
490	1
491	474
491	475
492	476
493	470
493	477
493	478
493	479
494	480
495	481
496	482
496	483
496	484
220	485
220	486
497	487
498	470
498	488
499	489
69	59
70	59
500	490
500	491
500	492
500	493
500	494
500	495
500	496
74	64
501	45
503	497
504	497
504	498
504	499
505	500
506	501
730	502
730	503
508	504
509	1
510	1
731	723
731	499
511	505
511	506
512	507
513	508
514	1
515	509
732	724
732	723
733	724
733	723
516	510
517	511
517	512
517	513
517	514
734	725
734	499
518	45
519	515
520	384
521	516
522	517
523	518
523	497
524	519
525	497
526	520
526	521
526	726
526	727
527	522
527	518
527	523
528	524
529	525
530	1
718	708
342	329
686	663
533	19
534	529
735	728
735	729
735	730
535	73
536	530
537	1
538	1
539	531
541	73
542	1
543	45
544	533
544	534
736	731
736	499
532	4
532	526
532	527
532	528
545	535
546	1
737	732
737	291
737	733
547	73
548	536
549	45
550	537
551	1
552	538
552	539
553	540
554	541
554	542
555	543
555	544
738	734
738	696
738	735
738	736
739	734
739	696
739	735
739	736
556	545
557	546
557	547
558	548
559	45
560	1
561	549
561	550
562	45
563	515
564	1
565	551
565	552
566	553
567	547
568	547
569	545
570	545
571	551
571	552
572	554
684	662
573	555
574	556
574	557
574	558
575	555
576	559
577	560
577	561
577	562
578	737
578	738
578	739
578	740
578	563
740	737
740	738
740	739
740	741
740	740
579	555
580	565
581	566
582	555
582	567
392	377
392	120
583	568
584	569
584	555
585	78
586	570
587	556
588	571
588	572
589	567
590	215
591	573
591	574
592	575
592	555
593	576
593	577
594	576
595	578
596	555
597	579
598	579
599	580
741	742
741	743
741	744
741	745
600	581
601	571
602	547
603	582
604	583
605	1
606	584
606	585
606	586
606	587
607	588
608	1
609	589
610	590
611	591
612	592
612	593
613	594
613	595
613	596
613	597
613	598
614	599
742	746
742	747
743	748
743	499
615	600
616	601
744	749
744	750
617	602
618	603
619	604
745	751
745	677
620	605
621	606
622	607
746	697
747	697
623	608
624	45
748	752
748	753
748	754
625	1
626	609
627	610
749	755
749	756
628	611
629	361
629	612
630	613
631	614
631	448
633	615
634	616
635	73
687	664
636	617
637	618
637	606
638	618
638	606
639	614
639	619
639	620
640	73
641	621
642	622
643	19
644	623
715	419
715	420
646	601
647	1
648	1
649	19
650	601
651	624
652	601
750	757
750	758
653	1
654	271
655	625
655	45
656	626
657	1
658	601
659	1
751	757
751	758
660	759
661	633
662	1
663	601
664	45
665	1
752	760
752	761
752	762
666	601
667	634
668	635
669	636
670	637
671	638
753	763
753	764
672	639
672	640
672	641
672	642
673	643
673	644
673	645
673	646
674	647
674	648
674	649
674	650
675	651
676	652
677	653
677	654
678	655
754	765
754	499
755	766
755	767
679	656
680	657
681	497
681	658
682	659
683	660
756	763
756	764
756	768
756	769
757	770
757	771
757	772
757	773
\.


--
-- Data for Name: resource_editor; Type: TABLE DATA; Schema: public; Owner: api
--

COPY resource_editor (resource_id, editor_id) FROM stdin;
\.


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('resource_id_seq', 757, true);


--
-- Data for Name: resource_tag; Type: TABLE DATA; Schema: public; Owner: api
--

COPY resource_tag (resource_id, tag_id, created_date) FROM stdin;
1	9	2018-11-19 19:16:29.031396
1	31	2018-11-19 19:16:29.034302
2	9	2018-11-19 19:16:29.053925
2	31	2018-11-19 19:16:29.056475
3	9	2018-11-19 19:16:29.070045
3	31	2018-11-19 19:16:29.07222
14	9	2018-06-20 16:49:00.504303
14	31	2018-06-20 16:49:00.506168
27	10	2018-06-20 16:49:00.706886
27	3	2018-06-20 16:49:00.708888
30	10	2018-06-20 16:49:00.75314
30	3	2018-06-20 16:49:00.75555
688	9	2018-11-19 19:16:29.090829
688	31	2018-11-19 19:16:29.093247
68	32	2018-06-20 16:49:01.366776
68	3	2018-06-20 16:49:01.368912
88	32	2018-06-20 16:49:01.682566
88	3	2018-06-20 16:49:01.684631
91	32	2018-06-20 16:49:01.7229
91	3	2018-06-20 16:49:01.725458
114	23	2018-06-20 16:49:02.146523
114	33	2018-06-20 16:49:02.148522
148	22	2018-06-20 16:49:02.638521
148	33	2018-06-20 16:49:02.640371
169	22	2018-06-20 16:49:03.001276
169	33	2018-06-20 16:49:03.003226
170	22	2018-06-20 16:49:03.026139
170	33	2018-06-20 16:49:03.02792
171	22	2018-06-20 16:49:03.055616
171	33	2018-06-20 16:49:03.057569
172	22	2018-06-20 16:49:03.076995
172	33	2018-06-20 16:49:03.078745
4	9	2018-11-19 19:16:29.105595
4	31	2018-11-19 19:16:29.107891
5	9	2018-11-19 19:16:29.119597
5	31	2018-11-19 19:16:29.121661
6	9	2018-11-19 19:16:29.133273
6	31	2018-11-19 19:16:29.135385
7	9	2018-11-19 19:16:29.146174
7	31	2018-11-19 19:16:29.148228
8	9	2018-11-19 19:16:29.159059
8	31	2018-11-19 19:16:29.161321
9	9	2018-11-19 19:16:29.172237
9	31	2018-11-19 19:16:29.174365
10	9	2018-11-19 19:16:29.189825
10	31	2018-11-19 19:16:29.19191
11	9	2018-11-19 19:16:29.203644
11	31	2018-11-19 19:16:29.205492
12	9	2018-11-19 19:16:29.215967
12	31	2018-11-19 19:16:29.217807
13	9	2018-11-19 19:16:29.228925
13	31	2018-11-19 19:16:29.230814
15	9	2018-11-19 19:16:29.241851
15	31	2018-11-19 19:16:29.243832
16	9	2018-11-19 19:16:29.254908
16	31	2018-11-19 19:16:29.256923
17	9	2018-11-19 19:16:29.267383
17	31	2018-11-19 19:16:29.269338
18	9	2018-11-19 19:16:29.280433
18	31	2018-11-19 19:16:29.282601
290	26	2018-06-20 16:49:05.067125
290	35	2018-06-20 16:49:05.068981
19	9	2018-11-19 19:16:29.293998
19	31	2018-11-19 19:16:29.29641
20	9	2018-11-19 19:16:29.307318
20	31	2018-11-19 19:16:29.309689
21	9	2018-11-19 19:16:29.321271
21	31	2018-11-19 19:16:29.323191
22	9	2018-11-19 19:16:29.333872
22	31	2018-11-19 19:16:29.335703
23	9	2018-11-19 19:16:29.346667
23	31	2018-11-19 19:16:29.34864
689	9	2018-11-19 19:16:29.363631
689	31	2018-11-19 19:16:29.36563
690	9	2018-11-19 19:16:29.381268
690	31	2018-11-19 19:16:29.383227
24	9	2018-11-19 19:16:29.393688
24	31	2018-11-19 19:16:29.396054
25	9	2018-11-19 19:16:29.407689
25	31	2018-11-19 19:16:29.409475
26	9	2018-11-19 19:16:29.419871
26	31	2018-11-19 19:16:29.421925
691	9	2018-11-19 19:16:29.435855
691	31	2018-11-19 19:16:29.43779
28	10	2018-11-19 19:16:29.46121
28	3	2018-11-19 19:16:29.463268
29	10	2018-11-19 19:16:29.473829
29	3	2018-11-19 19:16:29.475819
31	10	2018-11-19 19:16:29.486856
31	3	2018-11-19 19:16:29.488848
32	10	2018-11-19 19:16:29.500109
32	3	2018-11-19 19:16:29.502299
33	10	2018-11-19 19:16:29.52096
33	3	2018-11-19 19:16:29.523296
34	10	2018-11-19 19:16:29.54116
34	3	2018-11-19 19:16:29.54315
35	10	2018-11-19 19:16:29.553581
35	3	2018-11-19 19:16:29.555633
36	10	2018-11-19 19:16:29.566942
36	3	2018-11-19 19:16:29.568849
37	10	2018-11-19 19:16:29.582063
37	3	2018-11-19 19:16:29.584185
38	10	2018-11-19 19:16:29.602272
38	3	2018-11-19 19:16:29.604163
39	10	2018-11-19 19:16:29.61515
39	3	2018-11-19 19:16:29.617175
40	10	2018-11-19 19:16:29.628535
40	3	2018-11-19 19:16:29.630276
41	10	2018-11-19 19:16:29.64037
41	3	2018-11-19 19:16:29.642325
42	10	2018-11-19 19:16:29.652598
42	3	2018-11-19 19:16:29.65464
43	10	2018-11-19 19:16:29.66874
43	3	2018-11-19 19:16:29.670833
44	10	2018-11-19 19:16:29.681011
44	3	2018-11-19 19:16:29.68298
45	8	2018-11-19 19:16:29.702747
45	31	2018-11-19 19:16:29.704503
46	8	2018-11-19 19:16:29.714155
46	31	2018-11-19 19:16:29.716004
47	8	2018-11-19 19:16:29.724993
47	31	2018-11-19 19:16:29.726685
48	8	2018-11-19 19:16:29.735937
48	31	2018-11-19 19:16:29.73789
423	36	2018-06-20 16:49:07.108327
423	31	2018-06-20 16:49:07.110368
49	8	2018-11-19 19:16:29.747541
49	31	2018-11-19 19:16:29.749432
50	8	2018-11-19 19:16:29.760095
50	31	2018-11-19 19:16:29.762008
692	8	2018-11-19 19:16:29.773154
692	31	2018-11-19 19:16:29.779167
51	8	2018-11-19 19:16:29.79251
51	31	2018-11-19 19:16:29.794461
52	8	2018-11-19 19:16:29.80533
52	31	2018-11-19 19:16:29.807074
53	8	2018-11-19 19:16:29.819361
53	31	2018-11-19 19:16:29.821978
54	8	2018-11-19 19:16:29.83152
54	31	2018-11-19 19:16:29.833331
11	30	2018-06-20 16:49:07.45425
447	30	2018-06-20 16:49:07.48671
447	35	2018-06-20 16:49:07.488465
455	30	2018-06-20 16:49:07.667758
455	35	2018-06-20 16:49:07.669695
465	19	2018-06-20 16:49:07.855054
465	33	2018-06-20 16:49:07.857047
466	19	2018-06-20 16:49:07.880012
466	33	2018-06-20 16:49:07.881907
55	8	2018-11-19 19:16:29.846623
55	31	2018-11-19 19:16:29.848561
56	8	2018-11-19 19:16:29.863534
56	31	2018-11-19 19:16:29.865332
57	8	2018-11-19 19:16:29.874798
57	31	2018-11-19 19:16:29.876487
58	8	2018-11-19 19:16:29.88698
58	31	2018-11-19 19:16:29.888781
59	8	2018-11-19 19:16:29.898808
59	31	2018-11-19 19:16:29.900685
60	8	2018-11-19 19:16:29.911662
60	31	2018-11-19 19:16:29.913525
61	8	2018-11-19 19:16:29.924859
61	31	2018-11-19 19:16:29.926735
62	8	2018-11-19 19:16:29.937358
62	31	2018-11-19 19:16:29.93958
481	19	2018-06-20 16:49:08.100556
481	33	2018-06-20 16:49:08.103002
63	8	2018-11-19 19:16:29.949678
63	31	2018-11-19 19:16:29.951362
64	8	2018-11-19 19:16:29.961844
64	31	2018-11-19 19:16:29.963957
65	8	2018-11-19 19:16:29.974489
65	31	2018-11-19 19:16:29.976448
66	8	2018-11-19 19:16:29.986977
66	31	2018-11-19 19:16:29.988957
67	8	2018-11-19 19:16:29.999395
67	31	2018-11-19 19:16:30.001143
69	32	2018-11-19 19:16:30.018214
69	3	2018-11-19 19:16:30.020356
70	32	2018-11-19 19:16:30.031463
70	3	2018-11-19 19:16:30.033301
71	32	2018-11-19 19:16:30.063463
71	3	2018-11-19 19:16:30.065207
502	37	2018-06-20 16:49:08.519236
502	4	2018-06-20 16:49:08.521479
507	37	2018-06-20 16:49:08.596904
507	4	2018-06-20 16:49:08.599572
531	38	2018-06-20 16:49:08.946339
531	35	2018-06-20 16:49:08.948393
72	32	2018-11-19 19:16:30.075489
72	3	2018-11-19 19:16:30.077242
73	32	2018-11-19 19:16:30.087757
73	3	2018-11-19 19:16:30.089612
693	32	2018-11-19 19:16:30.103784
693	3	2018-11-19 19:16:30.105623
74	32	2018-11-19 19:16:30.115941
74	3	2018-11-19 19:16:30.117826
75	32	2018-11-19 19:16:30.128197
75	3	2018-11-19 19:16:30.130396
76	32	2018-11-19 19:16:30.140575
540	39	2018-06-20 16:49:09.117569
540	33	2018-06-20 16:49:09.119447
76	3	2018-11-19 19:16:30.142846
77	32	2018-11-19 19:16:30.163912
77	3	2018-11-19 19:16:30.165909
78	32	2018-11-19 19:16:30.175728
78	3	2018-11-19 19:16:30.177574
79	32	2018-11-19 19:16:30.188506
79	3	2018-11-19 19:16:30.190282
80	32	2018-11-19 19:16:30.199922
80	3	2018-11-19 19:16:30.201751
81	32	2018-11-19 19:16:30.211844
81	3	2018-11-19 19:16:30.21368
82	32	2018-11-19 19:16:30.223751
82	3	2018-11-19 19:16:30.225734
83	32	2018-11-19 19:16:30.236075
83	3	2018-11-19 19:16:30.237814
84	32	2018-11-19 19:16:30.247881
84	3	2018-11-19 19:16:30.249804
85	32	2018-11-19 19:16:30.264009
85	3	2018-11-19 19:16:30.265977
86	32	2018-11-19 19:16:30.276292
86	3	2018-11-19 19:16:30.278367
694	32	2018-11-19 19:16:30.292685
694	3	2018-11-19 19:16:30.294644
695	32	2018-11-19 19:16:30.312398
695	3	2018-11-19 19:16:30.314718
87	32	2018-11-19 19:16:30.333381
87	3	2018-11-19 19:16:30.335426
89	32	2018-11-19 19:16:30.345871
89	3	2018-11-19 19:16:30.347783
90	32	2018-11-19 19:16:30.358384
90	3	2018-11-19 19:16:30.360311
696	32	2018-11-19 19:16:30.381847
696	3	2018-11-19 19:16:30.383825
92	32	2018-11-19 19:16:30.396896
92	3	2018-11-19 19:16:30.398724
93	32	2018-11-19 19:16:30.409202
93	3	2018-11-19 19:16:30.411058
94	32	2018-11-19 19:16:30.420916
94	3	2018-11-19 19:16:30.422871
95	32	2018-11-19 19:16:30.433546
95	3	2018-11-19 19:16:30.43539
96	32	2018-11-19 19:16:30.45256
96	3	2018-11-19 19:16:30.454568
97	32	2018-11-19 19:16:30.474222
97	3	2018-11-19 19:16:30.476136
98	32	2018-11-19 19:16:30.503028
98	3	2018-11-19 19:16:30.505068
99	32	2018-11-19 19:16:30.519492
99	3	2018-11-19 19:16:30.521559
100	32	2018-11-19 19:16:30.535474
100	3	2018-11-19 19:16:30.537857
101	32	2018-11-19 19:16:30.551725
101	3	2018-11-19 19:16:30.553788
102	32	2018-11-19 19:16:30.568104
102	3	2018-11-19 19:16:30.570077
103	32	2018-11-19 19:16:30.580789
103	3	2018-11-19 19:16:30.58263
104	32	2018-11-19 19:16:30.599542
104	3	2018-11-19 19:16:30.601729
105	32	2018-11-19 19:16:30.615706
105	3	2018-11-19 19:16:30.617949
106	32	2018-11-19 19:16:30.628211
106	3	2018-11-19 19:16:30.630147
107	32	2018-11-19 19:16:30.640891
107	3	2018-11-19 19:16:30.642723
108	32	2018-11-19 19:16:30.656521
108	3	2018-11-19 19:16:30.658304
109	32	2018-11-19 19:16:30.668128
109	3	2018-11-19 19:16:30.670247
632	13	2018-06-20 16:49:10.593493
632	4	2018-06-20 16:49:10.595747
645	29	2018-06-20 16:49:10.797149
645	35	2018-06-20 16:49:10.799116
11	29	2018-06-20 16:49:10.905095
11	35	2018-06-20 16:49:10.907045
110	23	2018-11-19 19:16:30.682862
110	33	2018-11-19 19:16:30.685194
111	23	2018-11-19 19:16:30.695799
111	33	2018-11-19 19:16:30.697642
112	23	2018-11-19 19:16:30.708182
112	33	2018-11-19 19:16:30.71025
113	23	2018-11-19 19:16:30.723931
113	33	2018-11-19 19:16:30.725887
697	23	2018-11-19 19:16:30.752881
697	33	2018-11-19 19:16:30.754638
115	23	2018-11-19 19:16:30.764818
115	33	2018-11-19 19:16:30.766522
116	23	2018-11-19 19:16:30.776721
116	33	2018-11-19 19:16:30.780064
117	23	2018-11-19 19:16:30.789972
117	33	2018-11-19 19:16:30.791623
118	23	2018-11-19 19:16:30.80116
118	33	2018-11-19 19:16:30.802948
119	23	2018-11-19 19:16:30.814176
119	33	2018-11-19 19:16:30.816079
120	23	2018-11-19 19:16:30.825565
120	33	2018-11-19 19:16:30.827457
121	23	2018-11-19 19:16:30.84031
121	33	2018-11-19 19:16:30.841987
122	23	2018-11-19 19:16:30.851459
122	33	2018-11-19 19:16:30.853219
123	23	2018-11-19 19:16:30.863095
123	33	2018-11-19 19:16:30.864827
124	23	2018-11-19 19:16:30.874167
124	33	2018-11-19 19:16:30.875903
125	23	2018-11-19 19:16:30.897175
126	23	2018-11-19 19:16:30.90809
126	33	2018-11-19 19:16:30.909765
127	23	2018-11-19 19:16:30.925012
127	33	2018-11-19 19:16:30.926777
128	23	2018-11-19 19:16:30.936252
128	33	2018-11-19 19:16:30.937943
129	23	2018-11-19 19:16:30.947206
129	33	2018-11-19 19:16:30.949087
130	23	2018-11-19 19:16:30.958254
130	33	2018-11-19 19:16:30.959901
131	23	2018-11-19 19:16:30.969189
131	33	2018-11-19 19:16:30.970889
132	23	2018-11-19 19:16:30.980099
132	33	2018-11-19 19:16:30.981801
133	23	2018-11-19 19:16:30.991347
133	33	2018-11-19 19:16:30.993082
134	23	2018-11-19 19:16:31.002841
134	33	2018-11-19 19:16:31.004523
135	23	2018-11-19 19:16:31.013766
135	33	2018-11-19 19:16:31.015426
136	23	2018-11-19 19:16:31.02491
136	33	2018-11-19 19:16:31.026602
137	23	2018-11-19 19:16:31.035857
137	33	2018-11-19 19:16:31.037525
138	23	2018-11-19 19:16:31.046712
138	33	2018-11-19 19:16:31.048362
139	23	2018-11-19 19:16:31.057583
139	33	2018-11-19 19:16:31.059202
140	23	2018-11-19 19:16:31.068299
140	33	2018-11-19 19:16:31.069998
141	23	2018-11-19 19:16:31.079344
141	33	2018-11-19 19:16:31.080965
142	23	2018-11-19 19:16:31.08984
142	33	2018-11-19 19:16:31.091529
143	23	2018-11-19 19:16:31.100551
143	33	2018-11-19 19:16:31.102154
698	23	2018-11-19 19:16:31.118079
698	33	2018-11-19 19:16:31.119739
699	23	2018-11-19 19:16:31.134672
699	33	2018-11-19 19:16:31.13641
700	23	2018-11-19 19:16:31.151183
700	33	2018-11-19 19:16:31.152796
144	22	2018-11-19 19:16:31.173807
144	33	2018-11-19 19:16:31.175397
145	22	2018-11-19 19:16:31.184315
145	33	2018-11-19 19:16:31.185918
146	22	2018-11-19 19:16:31.195206
146	33	2018-11-19 19:16:31.196889
147	22	2018-11-19 19:16:31.205965
147	33	2018-11-19 19:16:31.207594
149	22	2018-11-19 19:16:31.216663
149	33	2018-11-19 19:16:31.218283
150	22	2018-11-19 19:16:31.227267
150	33	2018-11-19 19:16:31.228934
151	22	2018-11-19 19:16:31.23807
151	33	2018-11-19 19:16:31.23976
152	22	2018-11-19 19:16:31.248684
152	33	2018-11-19 19:16:31.250394
153	22	2018-11-19 19:16:31.259477
153	33	2018-11-19 19:16:31.26111
154	22	2018-11-19 19:16:31.282825
154	33	2018-11-19 19:16:31.284533
155	22	2018-11-19 19:16:31.297084
155	33	2018-11-19 19:16:31.29871
156	22	2018-11-19 19:16:31.307778
156	33	2018-11-19 19:16:31.309397
701	22	2018-11-19 19:16:31.321887
701	33	2018-11-19 19:16:31.323507
157	22	2018-11-19 19:16:31.332633
157	33	2018-11-19 19:16:31.334602
158	22	2018-11-19 19:16:31.343879
158	33	2018-11-19 19:16:31.345573
159	22	2018-11-19 19:16:31.357756
159	33	2018-11-19 19:16:31.359361
160	22	2018-11-19 19:16:31.368623
160	33	2018-11-19 19:16:31.370278
161	22	2018-11-19 19:16:31.379523
161	33	2018-11-19 19:16:31.381287
162	22	2018-11-19 19:16:31.390521
162	33	2018-11-19 19:16:31.392128
163	22	2018-11-19 19:16:31.401435
163	33	2018-11-19 19:16:31.403399
693	22	2018-11-19 19:16:31.416494
693	33	2018-11-19 19:16:31.418269
164	22	2018-11-19 19:16:31.45002
164	33	2018-11-19 19:16:31.45197
165	22	2018-11-19 19:16:31.465791
165	33	2018-11-19 19:16:31.467709
166	22	2018-11-19 19:16:31.483058
166	33	2018-11-19 19:16:31.484848
167	22	2018-11-19 19:16:31.498664
167	33	2018-11-19 19:16:31.500655
168	22	2018-11-19 19:16:31.513995
168	33	2018-11-19 19:16:31.515647
173	22	2018-11-19 19:16:31.525866
173	33	2018-11-19 19:16:31.527971
174	22	2018-11-19 19:16:31.541422
174	33	2018-11-19 19:16:31.543391
175	22	2018-11-19 19:16:31.556453
175	33	2018-11-19 19:16:31.5583
176	22	2018-11-19 19:16:31.567664
176	33	2018-11-19 19:16:31.569428
702	22	2018-11-19 19:16:31.58689
702	33	2018-11-19 19:16:31.588694
177	22	2018-11-19 19:16:31.59887
177	33	2018-11-19 19:16:31.60073
178	22	2018-11-19 19:16:31.610896
178	33	2018-11-19 19:16:31.612879
179	22	2018-11-19 19:16:31.622868
179	33	2018-11-19 19:16:31.624724
180	22	2018-11-19 19:16:31.641795
180	33	2018-11-19 19:16:31.643754
181	22	2018-11-19 19:16:31.654291
181	33	2018-11-19 19:16:31.656184
182	22	2018-11-19 19:16:31.697296
182	33	2018-11-19 19:16:31.699007
183	22	2018-11-19 19:16:31.709573
183	33	2018-11-19 19:16:31.711314
184	22	2018-11-19 19:16:31.721162
184	33	2018-11-19 19:16:31.722979
185	22	2018-11-19 19:16:31.7331
185	33	2018-11-19 19:16:31.734944
186	22	2018-11-19 19:16:31.744878
186	33	2018-11-19 19:16:31.746699
187	22	2018-11-19 19:16:31.759959
187	33	2018-11-19 19:16:31.76186
188	22	2018-11-19 19:16:31.776052
188	33	2018-11-19 19:16:31.777708
189	22	2018-11-19 19:16:31.811266
189	33	2018-11-19 19:16:31.812889
190	22	2018-11-19 19:16:31.822424
190	33	2018-11-19 19:16:31.824077
191	22	2018-11-19 19:16:31.841052
191	33	2018-11-19 19:16:31.842766
192	22	2018-11-19 19:16:31.856273
192	33	2018-11-19 19:16:31.858117
193	22	2018-11-19 19:16:31.867772
193	33	2018-11-19 19:16:31.869593
194	22	2018-11-19 19:16:31.879269
194	33	2018-11-19 19:16:31.881085
195	22	2018-11-19 19:16:31.902595
195	33	2018-11-19 19:16:31.904305
703	22	2018-11-19 19:16:31.914794
703	33	2018-11-19 19:16:31.916607
196	22	2018-11-19 19:16:31.953736
196	33	2018-11-19 19:16:31.95554
197	22	2018-11-19 19:16:31.968567
197	33	2018-11-19 19:16:31.970317
198	22	2018-11-19 19:16:31.980001
198	33	2018-11-19 19:16:31.981721
199	22	2018-11-19 19:16:31.992087
199	33	2018-11-19 19:16:31.99403
200	22	2018-11-19 19:16:32.003921
200	33	2018-11-19 19:16:32.005748
201	22	2018-11-19 19:16:32.016618
201	33	2018-11-19 19:16:32.018514
203	22	2018-11-19 19:16:32.045451
203	33	2018-11-19 19:16:32.047217
236	12	2018-05-26 21:20:45.383657
236	4	2018-05-26 21:20:45.385599
202	22	2018-11-19 19:16:32.057327
202	33	2018-11-19 19:16:32.059118
204	22	2018-11-19 19:16:32.100273
204	33	2018-11-19 19:16:32.102204
205	22	2018-11-19 19:16:32.115542
205	33	2018-11-19 19:16:32.117216
206	22	2018-11-19 19:16:32.126672
206	33	2018-11-19 19:16:32.128492
207	22	2018-11-19 19:16:32.138389
207	33	2018-11-19 19:16:32.14004
244	12	2018-05-26 21:20:45.504677
244	4	2018-05-26 21:20:45.506852
208	22	2018-11-19 19:16:32.162585
208	33	2018-11-19 19:16:32.164482
209	22	2018-11-19 19:16:32.174293
209	33	2018-11-19 19:16:32.175955
125	22	2018-11-19 19:16:32.186737
125	33	2018-11-19 19:16:32.188601
210	22	2018-11-19 19:16:32.198127
210	33	2018-11-19 19:16:32.199771
211	22	2018-11-19 19:16:32.209265
211	33	2018-11-19 19:16:32.211098
212	22	2018-11-19 19:16:32.221055
212	33	2018-11-19 19:16:32.22288
213	22	2018-11-19 19:16:32.232699
213	33	2018-11-19 19:16:32.234493
214	22	2018-11-19 19:16:32.243748
214	33	2018-11-19 19:16:32.245423
215	22	2018-11-19 19:16:32.262493
215	33	2018-11-19 19:16:32.264292
216	22	2018-11-19 19:16:32.277341
216	33	2018-11-19 19:16:32.279227
217	22	2018-11-19 19:16:32.289348
217	33	2018-11-19 19:16:32.291196
218	22	2018-11-19 19:16:32.315821
218	33	2018-11-19 19:16:32.317537
219	22	2018-11-19 19:16:32.331937
219	33	2018-11-19 19:16:32.333893
220	22	2018-11-19 19:16:32.344629
221	22	2018-11-19 19:16:32.356375
221	33	2018-11-19 19:16:32.358286
222	22	2018-11-19 19:16:32.368243
222	33	2018-11-19 19:16:32.370206
223	22	2018-11-19 19:16:32.380225
223	33	2018-11-19 19:16:32.382024
224	22	2018-11-19 19:16:32.391961
224	33	2018-11-19 19:16:32.393896
225	22	2018-11-19 19:16:32.404608
225	33	2018-11-19 19:16:32.406487
226	22	2018-11-19 19:16:32.416684
226	33	2018-11-19 19:16:32.418442
227	22	2018-11-19 19:16:32.428307
227	33	2018-11-19 19:16:32.430098
228	22	2018-11-19 19:16:32.439859
228	33	2018-11-19 19:16:32.441582
229	22	2018-11-19 19:16:32.451394
229	33	2018-11-19 19:16:32.453125
230	22	2018-11-19 19:16:32.463313
230	33	2018-11-19 19:16:32.465013
231	22	2018-11-19 19:16:32.486237
231	33	2018-11-19 19:16:32.488254
232	22	2018-11-19 19:16:32.498702
232	33	2018-11-19 19:16:32.500738
233	22	2018-11-19 19:16:32.510777
233	33	2018-11-19 19:16:32.512627
234	22	2018-11-19 19:16:32.522653
234	33	2018-11-19 19:16:32.52442
235	22	2018-11-19 19:16:32.533812
235	33	2018-11-19 19:16:32.53567
237	12	2018-11-19 19:16:32.558244
237	4	2018-11-19 19:16:32.560708
704	12	2018-11-19 19:16:32.57431
704	4	2018-11-19 19:16:32.576468
238	12	2018-11-19 19:16:32.589223
238	4	2018-11-19 19:16:32.591252
239	12	2018-11-19 19:16:32.601235
239	4	2018-11-19 19:16:32.603254
240	12	2018-11-19 19:16:32.623902
240	4	2018-11-19 19:16:32.625791
241	12	2018-11-19 19:16:32.636147
241	4	2018-11-19 19:16:32.638083
242	12	2018-11-19 19:16:32.648311
242	4	2018-11-19 19:16:32.650363
243	12	2018-11-19 19:16:32.660525
243	4	2018-11-19 19:16:32.662584
245	12	2018-11-19 19:16:32.689821
245	4	2018-11-19 19:16:32.691811
246	12	2018-11-19 19:16:32.701939
246	4	2018-11-19 19:16:32.703915
247	12	2018-11-19 19:16:32.714273
247	4	2018-11-19 19:16:32.716116
248	12	2018-11-19 19:16:32.725957
248	4	2018-11-19 19:16:32.728078
249	12	2018-11-19 19:16:32.738438
249	4	2018-11-19 19:16:32.740547
705	12	2018-11-19 19:16:32.753672
705	4	2018-11-19 19:16:32.755543
250	12	2018-11-19 19:16:32.76539
250	4	2018-11-19 19:16:32.767307
251	12	2018-11-19 19:16:32.780986
251	4	2018-11-19 19:16:32.782915
252	12	2018-11-19 19:16:32.792672
252	4	2018-11-19 19:16:32.794576
253	12	2018-11-19 19:16:32.80502
253	4	2018-11-19 19:16:32.806995
254	12	2018-11-19 19:16:32.817151
254	4	2018-11-19 19:16:32.81895
255	12	2018-11-19 19:16:32.833156
255	4	2018-11-19 19:16:32.834953
256	12	2018-11-19 19:16:32.845281
256	4	2018-11-19 19:16:32.847211
257	12	2018-11-19 19:16:32.85729
257	4	2018-11-19 19:16:32.859226
258	12	2018-11-19 19:16:32.86922
258	4	2018-11-19 19:16:32.87099
259	12	2018-11-19 19:16:32.881068
259	4	2018-11-19 19:16:32.882872
706	12	2018-11-19 19:16:32.900064
706	4	2018-11-19 19:16:32.901995
260	12	2018-11-19 19:16:32.911767
260	4	2018-11-19 19:16:32.913543
261	12	2018-11-19 19:16:32.923506
261	4	2018-11-19 19:16:32.925653
262	12	2018-11-19 19:16:32.935009
262	4	2018-11-19 19:16:32.937054
263	12	2018-11-19 19:16:32.947479
263	4	2018-11-19 19:16:32.949301
264	12	2018-11-19 19:16:32.959247
264	4	2018-11-19 19:16:32.961282
707	12	2018-11-19 19:16:32.974529
707	4	2018-11-19 19:16:32.976672
708	12	2018-11-19 19:16:32.989141
708	4	2018-11-19 19:16:32.990977
709	12	2018-11-19 19:16:33.000498
709	4	2018-11-19 19:16:33.002322
265	12	2018-11-19 19:16:33.011656
265	4	2018-11-19 19:16:33.013483
266	12	2018-11-19 19:16:33.022722
266	4	2018-11-19 19:16:33.024572
267	12	2018-11-19 19:16:33.033857
267	4	2018-11-19 19:16:33.035672
268	12	2018-11-19 19:16:33.046297
268	4	2018-11-19 19:16:33.048134
269	12	2018-11-19 19:16:33.057132
269	4	2018-11-19 19:16:33.05891
270	12	2018-11-19 19:16:33.068386
270	4	2018-11-19 19:16:33.070475
271	12	2018-11-19 19:16:33.08091
271	4	2018-11-19 19:16:33.082935
272	12	2018-11-19 19:16:33.093444
272	4	2018-11-19 19:16:33.095335
273	34	2018-11-19 19:16:33.110849
273	4	2018-11-19 19:16:33.112853
274	34	2018-11-19 19:16:33.123201
274	4	2018-11-19 19:16:33.125238
275	34	2018-11-19 19:16:33.135703
275	4	2018-11-19 19:16:33.137739
276	34	2018-11-19 19:16:33.148135
276	4	2018-11-19 19:16:33.15006
277	34	2018-11-19 19:16:33.164209
277	4	2018-11-19 19:16:33.166566
278	34	2018-11-19 19:16:33.180859
278	4	2018-11-19 19:16:33.182835
279	34	2018-11-19 19:16:33.1927
279	4	2018-11-19 19:16:33.194722
710	34	2018-11-19 19:16:33.214667
710	4	2018-11-19 19:16:33.216495
280	34	2018-11-19 19:16:33.226641
280	4	2018-11-19 19:16:33.228791
281	34	2018-11-19 19:16:33.23848
281	4	2018-11-19 19:16:33.240297
711	34	2018-11-19 19:16:33.253161
711	4	2018-11-19 19:16:33.254934
282	34	2018-11-19 19:16:33.264661
282	4	2018-11-19 19:16:33.266732
283	34	2018-11-19 19:16:33.277431
283	4	2018-11-19 19:16:33.279448
284	34	2018-11-19 19:16:33.289897
284	4	2018-11-19 19:16:33.292054
285	34	2018-11-19 19:16:33.305935
285	4	2018-11-19 19:16:33.307937
286	34	2018-11-19 19:16:33.318134
286	4	2018-11-19 19:16:33.320314
712	34	2018-11-19 19:16:33.340949
712	4	2018-11-19 19:16:33.342889
287	26	2018-11-19 19:16:33.359647
287	35	2018-11-19 19:16:33.361445
288	26	2018-11-19 19:16:33.371128
288	35	2018-11-19 19:16:33.372947
289	26	2018-11-19 19:16:33.382741
289	35	2018-11-19 19:16:33.38462
291	26	2018-11-19 19:16:33.394986
291	35	2018-11-19 19:16:33.396774
36	26	2018-11-19 19:16:33.40659
36	35	2018-11-19 19:16:33.408621
292	26	2018-11-19 19:16:33.418675
292	35	2018-11-19 19:16:33.420436
293	26	2018-11-19 19:16:33.430301
293	35	2018-11-19 19:16:33.431912
294	26	2018-11-19 19:16:33.441998
294	35	2018-11-19 19:16:33.443647
295	26	2018-11-19 19:16:33.460355
295	35	2018-11-19 19:16:33.462239
696	26	2018-11-19 19:16:33.482847
696	35	2018-11-19 19:16:33.485014
296	26	2018-11-19 19:16:33.494835
296	35	2018-11-19 19:16:33.49648
297	26	2018-11-19 19:16:33.51343
297	35	2018-11-19 19:16:33.515328
298	26	2018-11-19 19:16:33.528833
298	35	2018-11-19 19:16:33.530639
299	26	2018-11-19 19:16:33.544597
299	35	2018-11-19 19:16:33.54623
300	26	2018-11-19 19:16:33.556339
300	35	2018-11-19 19:16:33.558058
301	26	2018-11-19 19:16:33.599101
301	35	2018-11-19 19:16:33.601047
303	26	2018-11-19 19:16:33.633351
303	35	2018-11-19 19:16:33.635429
304	26	2018-11-19 19:16:33.648177
304	35	2018-11-19 19:16:33.650046
302	26	2018-11-19 19:16:33.663929
302	35	2018-11-19 19:16:33.665816
306	26	2018-11-19 19:16:33.697662
306	35	2018-11-19 19:16:33.699625
307	26	2018-11-19 19:16:33.712881
307	35	2018-11-19 19:16:33.71472
305	26	2018-11-19 19:16:33.728123
305	35	2018-11-19 19:16:33.729832
308	26	2018-11-19 19:16:33.738994
308	35	2018-11-19 19:16:33.740642
309	26	2018-11-19 19:16:33.753573
309	35	2018-11-19 19:16:33.755277
310	26	2018-11-19 19:16:33.764866
310	35	2018-11-19 19:16:33.766876
311	26	2018-11-19 19:16:33.77637
311	35	2018-11-19 19:16:33.778118
684	26	2018-11-19 19:16:33.788185
312	27	2018-11-19 19:16:33.808603
312	35	2018-11-19 19:16:33.810252
313	27	2018-11-19 19:16:33.81968
313	35	2018-11-19 19:16:33.821307
314	27	2018-11-19 19:16:33.830484
314	35	2018-11-19 19:16:33.832155
360	36	2018-05-26 21:20:47.235613
360	31	2018-05-26 21:20:47.23764
315	27	2018-11-19 19:16:33.844076
315	35	2018-11-19 19:16:33.845687
316	27	2018-11-19 19:16:33.854717
316	35	2018-11-19 19:16:33.856339
317	27	2018-11-19 19:16:33.865782
317	35	2018-11-19 19:16:33.867361
318	27	2018-11-19 19:16:33.876319
318	35	2018-11-19 19:16:33.877868
319	27	2018-11-19 19:16:33.886732
319	35	2018-11-19 19:16:33.888318
320	27	2018-11-19 19:16:33.896836
320	35	2018-11-19 19:16:33.898413
321	27	2018-11-19 19:16:33.907217
321	35	2018-11-19 19:16:33.90899
322	27	2018-11-19 19:16:33.917964
322	35	2018-11-19 19:16:33.91954
323	27	2018-11-19 19:16:33.928385
323	35	2018-11-19 19:16:33.930231
324	27	2018-11-19 19:16:33.939361
324	35	2018-11-19 19:16:33.941008
325	27	2018-11-19 19:16:33.949895
325	35	2018-11-19 19:16:33.951702
326	27	2018-11-19 19:16:33.960529
326	35	2018-11-19 19:16:33.962123
373	36	2018-05-26 21:20:47.418255
373	31	2018-05-26 21:20:47.420784
327	27	2018-11-19 19:16:33.97099
327	35	2018-11-19 19:16:33.972613
328	27	2018-11-19 19:16:33.981707
328	35	2018-11-19 19:16:33.983419
329	27	2018-11-19 19:16:33.992357
329	35	2018-11-19 19:16:33.994084
330	27	2018-11-19 19:16:34.005762
330	35	2018-11-19 19:16:34.007436
331	27	2018-11-19 19:16:34.019421
331	35	2018-11-19 19:16:34.021028
332	27	2018-11-19 19:16:34.032815
332	35	2018-11-19 19:16:34.034464
333	27	2018-11-19 19:16:34.043194
333	35	2018-11-19 19:16:34.044875
334	27	2018-11-19 19:16:34.054007
334	35	2018-11-19 19:16:34.055696
335	27	2018-11-19 19:16:34.0645
335	35	2018-11-19 19:16:34.066169
336	27	2018-11-19 19:16:34.075165
336	35	2018-11-19 19:16:34.076839
337	27	2018-11-19 19:16:34.08585
337	35	2018-11-19 19:16:34.0875
338	27	2018-11-19 19:16:34.096362
338	35	2018-11-19 19:16:34.097992
339	27	2018-11-19 19:16:34.106735
339	35	2018-11-19 19:16:34.108312
340	27	2018-11-19 19:16:34.117506
340	35	2018-11-19 19:16:34.119121
341	27	2018-11-19 19:16:34.128713
341	35	2018-11-19 19:16:34.130639
342	27	2018-11-19 19:16:34.140719
103	27	2018-11-19 19:16:34.152327
103	35	2018-11-19 19:16:34.154247
343	27	2018-11-19 19:16:34.167682
343	35	2018-11-19 19:16:34.169485
344	27	2018-11-19 19:16:34.17971
344	35	2018-11-19 19:16:34.18153
345	27	2018-11-19 19:16:34.195028
345	35	2018-11-19 19:16:34.196803
346	27	2018-11-19 19:16:34.206616
346	35	2018-11-19 19:16:34.208553
347	27	2018-11-19 19:16:34.218394
347	35	2018-11-19 19:16:34.220091
348	27	2018-11-19 19:16:34.229678
348	35	2018-11-19 19:16:34.231298
349	27	2018-11-19 19:16:34.241256
349	35	2018-11-19 19:16:34.243028
350	27	2018-11-19 19:16:34.252769
350	35	2018-11-19 19:16:34.254603
351	27	2018-11-19 19:16:34.264508
351	35	2018-11-19 19:16:34.266507
352	27	2018-11-19 19:16:34.276578
352	35	2018-11-19 19:16:34.278594
353	27	2018-11-19 19:16:34.289034
353	35	2018-11-19 19:16:34.290665
354	27	2018-11-19 19:16:34.300346
354	35	2018-11-19 19:16:34.302648
355	27	2018-11-19 19:16:34.312875
355	35	2018-11-19 19:16:34.31446
356	27	2018-11-19 19:16:34.324208
356	35	2018-11-19 19:16:34.325971
357	27	2018-11-19 19:16:34.343038
357	35	2018-11-19 19:16:34.344874
713	36	2018-11-19 19:16:34.362248
713	31	2018-11-19 19:16:34.363846
358	36	2018-11-19 19:16:34.374445
358	31	2018-11-19 19:16:34.376326
359	36	2018-11-19 19:16:34.386876
359	31	2018-11-19 19:16:34.388677
361	36	2018-11-19 19:16:34.398849
361	31	2018-11-19 19:16:34.400577
362	36	2018-11-19 19:16:34.411203
362	31	2018-11-19 19:16:34.41311
363	36	2018-11-19 19:16:34.429832
363	31	2018-11-19 19:16:34.43149
364	36	2018-11-19 19:16:34.451408
364	31	2018-11-19 19:16:34.453099
365	36	2018-11-19 19:16:34.463221
365	31	2018-11-19 19:16:34.465302
366	36	2018-11-19 19:16:34.475577
366	31	2018-11-19 19:16:34.47732
367	36	2018-11-19 19:16:34.487584
367	31	2018-11-19 19:16:34.489591
368	36	2018-11-19 19:16:34.498984
368	31	2018-11-19 19:16:34.500709
369	36	2018-11-19 19:16:34.510968
369	31	2018-11-19 19:16:34.51306
370	36	2018-11-19 19:16:34.523179
370	31	2018-11-19 19:16:34.525065
371	36	2018-11-19 19:16:34.535612
371	31	2018-11-19 19:16:34.537426
372	36	2018-11-19 19:16:34.547248
372	31	2018-11-19 19:16:34.549137
374	36	2018-11-19 19:16:34.559452
374	31	2018-11-19 19:16:34.561002
375	36	2018-11-19 19:16:34.577534
375	31	2018-11-19 19:16:34.579392
376	36	2018-11-19 19:16:34.600324
376	31	2018-11-19 19:16:34.602278
377	36	2018-11-19 19:16:34.612438
377	31	2018-11-19 19:16:34.614008
378	36	2018-11-19 19:16:34.623526
378	31	2018-11-19 19:16:34.625245
379	36	2018-11-19 19:16:34.63529
379	31	2018-11-19 19:16:34.637344
380	36	2018-11-19 19:16:34.64745
380	31	2018-11-19 19:16:34.649169
381	36	2018-11-19 19:16:34.658747
381	31	2018-11-19 19:16:34.66044
382	36	2018-11-19 19:16:34.670198
382	31	2018-11-19 19:16:34.671833
383	36	2018-11-19 19:16:34.682281
383	31	2018-11-19 19:16:34.6841
384	36	2018-11-19 19:16:34.694462
384	31	2018-11-19 19:16:34.696102
385	36	2018-11-19 19:16:34.709435
385	31	2018-11-19 19:16:34.711193
386	36	2018-11-19 19:16:34.731077
386	31	2018-11-19 19:16:34.732763
387	36	2018-11-19 19:16:34.743088
387	31	2018-11-19 19:16:34.744776
388	36	2018-11-19 19:16:34.754853
388	31	2018-11-19 19:16:34.756577
389	36	2018-11-19 19:16:34.776974
389	31	2018-11-19 19:16:34.778872
390	36	2018-11-19 19:16:34.788586
390	31	2018-11-19 19:16:34.790615
391	36	2018-11-19 19:16:34.804239
391	31	2018-11-19 19:16:34.805936
392	36	2018-11-19 19:16:34.819639
392	31	2018-11-19 19:16:34.821486
187	36	2018-11-19 19:16:34.835133
187	31	2018-11-19 19:16:34.8369
121	36	2018-11-19 19:16:34.84991
121	31	2018-11-19 19:16:34.851895
393	36	2018-11-19 19:16:34.866165
393	31	2018-11-19 19:16:34.868053
394	36	2018-11-19 19:16:34.877952
394	31	2018-11-19 19:16:34.879676
395	36	2018-11-19 19:16:34.889979
395	31	2018-11-19 19:16:34.891633
396	36	2018-11-19 19:16:34.902786
396	31	2018-11-19 19:16:34.904517
397	36	2018-11-19 19:16:34.914846
397	31	2018-11-19 19:16:34.91656
398	36	2018-11-19 19:16:34.926298
398	31	2018-11-19 19:16:34.928234
399	36	2018-11-19 19:16:34.941764
399	31	2018-11-19 19:16:34.943607
400	36	2018-11-19 19:16:34.953627
400	31	2018-11-19 19:16:34.955362
401	36	2018-11-19 19:16:34.965016
401	31	2018-11-19 19:16:34.966887
402	36	2018-11-19 19:16:34.976652
402	31	2018-11-19 19:16:34.978414
403	36	2018-11-19 19:16:34.987915
403	31	2018-11-19 19:16:34.989977
404	36	2018-11-19 19:16:35.00747
404	31	2018-11-19 19:16:35.009296
405	36	2018-11-19 19:16:35.019446
405	31	2018-11-19 19:16:35.021117
406	36	2018-11-19 19:16:35.031078
406	31	2018-11-19 19:16:35.032857
407	36	2018-11-19 19:16:35.042796
407	31	2018-11-19 19:16:35.04471
408	36	2018-11-19 19:16:35.054608
408	31	2018-11-19 19:16:35.056226
409	36	2018-11-19 19:16:35.066822
409	31	2018-11-19 19:16:35.068431
410	36	2018-11-19 19:16:35.079424
410	31	2018-11-19 19:16:35.081223
411	36	2018-11-19 19:16:35.095814
411	31	2018-11-19 19:16:35.097662
412	36	2018-11-19 19:16:35.10844
412	31	2018-11-19 19:16:35.110487
413	36	2018-11-19 19:16:35.121557
413	31	2018-11-19 19:16:35.123373
414	36	2018-11-19 19:16:35.133381
414	31	2018-11-19 19:16:35.135143
415	36	2018-11-19 19:16:35.145396
415	31	2018-11-19 19:16:35.14713
416	36	2018-11-19 19:16:35.157754
416	31	2018-11-19 19:16:35.159485
417	36	2018-11-19 19:16:35.169765
417	31	2018-11-19 19:16:35.171722
418	36	2018-11-19 19:16:35.181652
418	31	2018-11-19 19:16:35.183626
419	36	2018-11-19 19:16:35.197746
419	31	2018-11-19 19:16:35.19977
420	36	2018-11-19 19:16:35.216656
420	31	2018-11-19 19:16:35.218342
421	36	2018-11-19 19:16:35.231125
421	31	2018-11-19 19:16:35.233191
422	36	2018-11-19 19:16:35.242777
422	31	2018-11-19 19:16:35.24453
714	36	2018-11-19 19:16:35.258779
714	31	2018-11-19 19:16:35.260848
424	36	2018-11-19 19:16:35.271478
424	31	2018-11-19 19:16:35.273358
425	36	2018-11-19 19:16:35.284215
425	31	2018-11-19 19:16:35.286017
426	36	2018-11-19 19:16:35.299548
426	31	2018-11-19 19:16:35.301595
427	36	2018-11-19 19:16:35.311368
427	31	2018-11-19 19:16:35.313239
428	36	2018-11-19 19:16:35.323159
428	31	2018-11-19 19:16:35.325122
429	36	2018-11-19 19:16:35.34194
429	31	2018-11-19 19:16:35.344165
430	36	2018-11-19 19:16:35.371139
430	31	2018-11-19 19:16:35.373191
431	36	2018-11-19 19:16:35.390098
431	31	2018-11-19 19:16:35.391994
432	36	2018-11-19 19:16:35.402753
432	31	2018-11-19 19:16:35.404617
433	36	2018-11-19 19:16:35.414828
433	31	2018-11-19 19:16:35.41661
434	36	2018-11-19 19:16:35.427229
434	31	2018-11-19 19:16:35.429238
435	36	2018-11-19 19:16:35.439664
435	31	2018-11-19 19:16:35.441412
436	36	2018-11-19 19:16:35.455121
436	31	2018-11-19 19:16:35.45702
437	36	2018-11-19 19:16:35.467506
437	31	2018-11-19 19:16:35.469196
438	36	2018-11-19 19:16:35.478878
438	31	2018-11-19 19:16:35.480743
439	36	2018-11-19 19:16:35.490657
439	31	2018-11-19 19:16:35.492516
440	36	2018-11-19 19:16:35.501896
440	31	2018-11-19 19:16:35.503939
441	36	2018-11-19 19:16:35.513742
441	31	2018-11-19 19:16:35.51562
442	36	2018-11-19 19:16:35.525641
442	31	2018-11-19 19:16:35.527524
443	36	2018-11-19 19:16:35.537258
443	31	2018-11-19 19:16:35.53904
444	36	2018-11-19 19:16:35.548611
444	31	2018-11-19 19:16:35.550301
445	36	2018-11-19 19:16:35.560314
445	31	2018-11-19 19:16:35.562022
685	36	2018-11-19 19:16:35.571687
685	31	2018-11-19 19:16:35.573363
715	30	2018-11-19 19:16:35.596576
446	30	2018-11-19 19:16:35.610623
446	35	2018-11-19 19:16:35.612583
716	30	2018-11-19 19:16:35.621883
716	35	2018-11-19 19:16:35.623644
448	30	2018-11-19 19:16:35.652278
448	35	2018-11-19 19:16:35.653986
717	30	2018-11-19 19:16:35.666964
717	35	2018-11-19 19:16:35.668879
449	30	2018-11-19 19:16:35.678806
449	35	2018-11-19 19:16:35.680526
450	30	2018-11-19 19:16:35.69028
450	35	2018-11-19 19:16:35.692119
451	30	2018-11-19 19:16:35.703908
451	35	2018-11-19 19:16:35.705896
452	30	2018-11-19 19:16:35.716049
452	35	2018-11-19 19:16:35.720024
718	30	2018-11-19 19:16:35.73076
342	30	2018-11-19 19:16:35.743128
719	30	2018-11-19 19:16:35.754509
719	35	2018-11-19 19:16:35.756484
453	30	2018-11-19 19:16:35.766133
453	35	2018-11-19 19:16:35.767839
454	30	2018-11-19 19:16:35.777905
454	35	2018-11-19 19:16:35.77963
456	30	2018-11-19 19:16:35.79677
456	35	2018-11-19 19:16:35.798643
457	30	2018-11-19 19:16:35.809201
457	35	2018-11-19 19:16:35.811101
458	30	2018-11-19 19:16:35.821395
458	35	2018-11-19 19:16:35.823199
521	30	2018-11-19 19:16:35.833932
521	35	2018-11-19 19:16:35.835747
459	30	2018-11-19 19:16:35.845361
459	35	2018-11-19 19:16:35.84739
684	30	2018-11-19 19:16:35.857778
684	35	2018-11-19 19:16:35.859535
460	19	2018-11-19 19:16:35.877468
460	33	2018-11-19 19:16:35.879127
461	19	2018-11-19 19:16:35.888288
461	33	2018-11-19 19:16:35.889999
462	19	2018-11-19 19:16:35.917113
462	33	2018-11-19 19:16:35.918969
720	19	2018-11-19 19:16:35.936372
720	33	2018-11-19 19:16:35.938255
721	19	2018-11-19 19:16:35.951639
721	33	2018-11-19 19:16:35.95341
463	19	2018-11-19 19:16:35.963541
463	33	2018-11-19 19:16:35.965205
464	19	2018-11-19 19:16:35.97583
464	33	2018-11-19 19:16:35.977487
722	19	2018-11-19 19:16:35.994695
722	33	2018-11-19 19:16:35.996606
467	19	2018-11-19 19:16:36.007235
467	33	2018-11-19 19:16:36.009055
468	19	2018-11-19 19:16:36.019798
468	33	2018-11-19 19:16:36.021602
469	19	2018-11-19 19:16:36.034675
469	33	2018-11-19 19:16:36.036622
470	19	2018-11-19 19:16:36.046785
470	33	2018-11-19 19:16:36.048505
471	19	2018-11-19 19:16:36.058308
471	33	2018-11-19 19:16:36.060304
391	19	2018-11-19 19:16:36.073504
391	33	2018-11-19 19:16:36.075399
472	19	2018-11-19 19:16:36.089114
472	33	2018-11-19 19:16:36.090994
723	19	2018-11-19 19:16:36.104689
723	33	2018-11-19 19:16:36.106607
473	19	2018-11-19 19:16:36.11711
473	33	2018-11-19 19:16:36.11893
474	19	2018-11-19 19:16:36.132893
474	33	2018-11-19 19:16:36.134868
475	19	2018-11-19 19:16:36.14513
475	33	2018-11-19 19:16:36.14695
724	19	2018-11-19 19:16:36.160714
724	33	2018-11-19 19:16:36.162491
725	19	2018-11-19 19:16:36.175301
725	33	2018-11-19 19:16:36.177078
476	19	2018-11-19 19:16:36.187452
476	33	2018-11-19 19:16:36.189244
477	19	2018-11-19 19:16:36.199619
477	33	2018-11-19 19:16:36.201549
478	19	2018-11-19 19:16:36.211164
478	33	2018-11-19 19:16:36.213035
479	19	2018-11-19 19:16:36.223973
479	33	2018-11-19 19:16:36.225971
480	19	2018-11-19 19:16:36.236201
480	33	2018-11-19 19:16:36.238144
726	19	2018-11-19 19:16:36.248215
726	33	2018-11-19 19:16:36.249936
482	19	2018-11-19 19:16:36.259602
482	33	2018-11-19 19:16:36.261395
727	19	2018-11-19 19:16:36.27485
727	33	2018-11-19 19:16:36.276736
728	19	2018-11-19 19:16:36.29052
728	33	2018-11-19 19:16:36.292411
729	19	2018-11-19 19:16:36.312245
729	33	2018-11-19 19:16:36.31404
483	19	2018-11-19 19:16:36.324059
483	33	2018-11-19 19:16:36.32594
484	19	2018-11-19 19:16:36.335693
484	33	2018-11-19 19:16:36.337473
485	19	2018-11-19 19:16:36.361862
485	33	2018-11-19 19:16:36.363662
486	19	2018-11-19 19:16:36.373667
486	33	2018-11-19 19:16:36.375454
487	24	2018-11-19 19:16:36.396996
487	33	2018-11-19 19:16:36.399028
488	24	2018-11-19 19:16:36.409522
488	33	2018-11-19 19:16:36.411252
489	24	2018-11-19 19:16:36.421251
489	33	2018-11-19 19:16:36.422956
490	24	2018-11-19 19:16:36.433049
490	33	2018-11-19 19:16:36.434882
491	24	2018-11-19 19:16:36.448427
491	33	2018-11-19 19:16:36.45045
492	24	2018-11-19 19:16:36.4606
492	33	2018-11-19 19:16:36.46245
493	24	2018-11-19 19:16:36.492258
493	33	2018-11-19 19:16:36.494185
494	24	2018-11-19 19:16:36.504455
494	33	2018-11-19 19:16:36.506262
495	24	2018-11-19 19:16:36.516109
495	33	2018-11-19 19:16:36.518009
496	24	2018-11-19 19:16:36.534419
496	33	2018-11-19 19:16:36.536076
220	24	2018-11-19 19:16:36.558408
220	33	2018-11-19 19:16:36.560176
497	24	2018-11-19 19:16:36.570492
497	33	2018-11-19 19:16:36.572345
498	24	2018-11-19 19:16:36.585886
498	33	2018-11-19 19:16:36.587626
499	24	2018-11-19 19:16:36.598106
499	33	2018-11-19 19:16:36.599834
69	37	2018-11-19 19:16:36.617148
69	4	2018-11-19 19:16:36.618955
70	37	2018-11-19 19:16:36.630208
70	4	2018-11-19 19:16:36.63219
500	37	2018-11-19 19:16:36.662457
500	4	2018-11-19 19:16:36.664434
74	37	2018-11-19 19:16:36.677416
74	4	2018-11-19 19:16:36.679347
501	37	2018-11-19 19:16:36.68961
501	4	2018-11-19 19:16:36.691627
503	37	2018-11-19 19:16:36.701972
503	4	2018-11-19 19:16:36.703909
504	37	2018-11-19 19:16:36.721325
504	4	2018-11-19 19:16:36.723536
505	37	2018-11-19 19:16:36.733495
505	4	2018-11-19 19:16:36.735333
506	37	2018-11-19 19:16:36.745439
506	4	2018-11-19 19:16:36.747587
730	37	2018-11-19 19:16:36.761373
730	4	2018-11-19 19:16:36.763439
508	37	2018-11-19 19:16:36.773835
508	4	2018-11-19 19:16:36.775978
509	37	2018-11-19 19:16:36.78669
509	4	2018-11-19 19:16:36.788854
510	37	2018-11-19 19:16:36.799448
510	4	2018-11-19 19:16:36.801286
731	37	2018-11-19 19:16:36.815571
731	4	2018-11-19 19:16:36.817385
511	37	2018-11-19 19:16:36.831267
511	4	2018-11-19 19:16:36.833215
512	37	2018-11-19 19:16:36.843955
512	4	2018-11-19 19:16:36.845974
513	37	2018-11-19 19:16:36.856312
513	4	2018-11-19 19:16:36.858497
514	37	2018-11-19 19:16:36.869628
514	4	2018-11-19 19:16:36.871516
515	37	2018-11-19 19:16:36.881136
515	4	2018-11-19 19:16:36.882986
732	37	2018-11-19 19:16:36.896341
732	4	2018-11-19 19:16:36.8982
733	37	2018-11-19 19:16:36.910973
733	4	2018-11-19 19:16:36.912874
516	37	2018-11-19 19:16:36.922942
516	4	2018-11-19 19:16:36.924783
517	37	2018-11-19 19:16:36.944816
517	4	2018-11-19 19:16:36.946654
734	37	2018-11-19 19:16:36.960625
734	4	2018-11-19 19:16:36.962862
518	37	2018-11-19 19:16:36.973043
518	4	2018-11-19 19:16:36.975247
519	37	2018-11-19 19:16:36.985772
519	4	2018-11-19 19:16:36.988006
520	37	2018-11-19 19:16:36.997621
520	4	2018-11-19 19:16:36.999537
521	37	2018-11-19 19:16:37.011557
521	4	2018-11-19 19:16:37.013679
522	37	2018-11-19 19:16:37.02428
522	4	2018-11-19 19:16:37.026274
523	37	2018-11-19 19:16:37.038924
523	4	2018-11-19 19:16:37.040768
524	37	2018-11-19 19:16:37.050625
524	4	2018-11-19 19:16:37.052626
525	37	2018-11-19 19:16:37.062815
525	4	2018-11-19 19:16:37.064876
526	38	2018-11-19 19:16:37.095105
526	35	2018-11-19 19:16:37.096981
527	38	2018-11-19 19:16:37.112844
527	35	2018-11-19 19:16:37.1148
528	38	2018-11-19 19:16:37.124976
528	35	2018-11-19 19:16:37.126637
529	38	2018-11-19 19:16:37.137061
529	35	2018-11-19 19:16:37.13876
530	38	2018-11-19 19:16:37.149024
530	35	2018-11-19 19:16:37.15094
718	38	2018-11-19 19:16:37.160949
718	35	2018-11-19 19:16:37.162803
342	38	2018-11-19 19:16:37.173277
342	35	2018-11-19 19:16:37.175019
686	38	2018-11-19 19:16:37.18586
686	35	2018-11-19 19:16:37.187875
533	39	2018-11-19 19:16:37.228785
533	33	2018-11-19 19:16:37.230718
534	39	2018-11-19 19:16:37.240286
534	33	2018-11-19 19:16:37.242432
735	39	2018-11-19 19:16:37.258729
735	33	2018-11-19 19:16:37.260519
535	39	2018-11-19 19:16:37.270506
535	33	2018-11-19 19:16:37.272349
536	39	2018-11-19 19:16:37.281954
536	33	2018-11-19 19:16:37.283671
537	39	2018-11-19 19:16:37.294353
537	33	2018-11-19 19:16:37.29614
538	39	2018-11-19 19:16:37.30941
538	33	2018-11-19 19:16:37.311299
539	39	2018-11-19 19:16:37.321971
539	33	2018-11-19 19:16:37.323791
541	39	2018-11-19 19:16:37.333895
541	33	2018-11-19 19:16:37.336058
542	39	2018-11-19 19:16:37.345682
542	33	2018-11-19 19:16:37.347492
543	39	2018-11-19 19:16:37.363995
543	33	2018-11-19 19:16:37.36614
544	39	2018-11-19 19:16:37.379986
544	33	2018-11-19 19:16:37.381637
736	39	2018-11-19 19:16:37.393884
736	33	2018-11-19 19:16:37.395525
532	39	2018-11-19 19:16:37.413818
532	33	2018-11-19 19:16:37.415463
545	39	2018-11-19 19:16:37.425397
545	33	2018-11-19 19:16:37.427092
546	39	2018-11-19 19:16:37.437002
546	33	2018-11-19 19:16:37.438698
737	39	2018-11-19 19:16:37.455584
737	33	2018-11-19 19:16:37.457156
547	39	2018-11-19 19:16:37.466907
547	33	2018-11-19 19:16:37.46884
548	39	2018-11-19 19:16:37.478845
548	33	2018-11-19 19:16:37.480623
549	39	2018-11-19 19:16:37.49045
549	33	2018-11-19 19:16:37.492295
550	39	2018-11-19 19:16:37.502723
550	33	2018-11-19 19:16:37.504408
551	39	2018-11-19 19:16:37.514674
551	33	2018-11-19 19:16:37.516283
552	39	2018-11-19 19:16:37.529742
552	33	2018-11-19 19:16:37.531565
553	39	2018-11-19 19:16:37.541769
553	33	2018-11-19 19:16:37.543628
554	39	2018-11-19 19:16:37.5579
554	33	2018-11-19 19:16:37.559818
555	39	2018-11-19 19:16:37.572498
555	33	2018-11-19 19:16:37.574241
738	39	2018-11-19 19:16:37.599569
738	33	2018-11-19 19:16:37.601415
739	39	2018-11-19 19:16:37.621524
739	33	2018-11-19 19:16:37.623231
556	18	2018-11-19 19:16:37.635442
556	4	2018-11-19 19:16:37.637309
557	18	2018-11-19 19:16:37.650968
557	4	2018-11-19 19:16:37.653136
558	18	2018-11-19 19:16:37.663436
558	4	2018-11-19 19:16:37.665306
559	18	2018-11-19 19:16:37.675653
559	4	2018-11-19 19:16:37.677754
560	18	2018-11-19 19:16:37.688342
560	4	2018-11-19 19:16:37.690232
561	18	2018-11-19 19:16:37.703722
561	4	2018-11-19 19:16:37.705695
562	18	2018-11-19 19:16:37.716093
562	4	2018-11-19 19:16:37.718069
563	18	2018-11-19 19:16:37.72831
563	4	2018-11-19 19:16:37.730219
564	18	2018-11-19 19:16:37.74084
564	4	2018-11-19 19:16:37.74268
565	18	2018-11-19 19:16:37.756173
565	4	2018-11-19 19:16:37.758319
566	18	2018-11-19 19:16:37.769186
566	4	2018-11-19 19:16:37.771066
567	18	2018-11-19 19:16:37.781637
567	4	2018-11-19 19:16:37.783622
568	18	2018-11-19 19:16:37.793643
568	4	2018-11-19 19:16:37.795641
569	18	2018-11-19 19:16:37.805267
569	4	2018-11-19 19:16:37.807346
570	18	2018-11-19 19:16:37.817252
570	4	2018-11-19 19:16:37.819034
571	18	2018-11-19 19:16:37.832792
571	4	2018-11-19 19:16:37.834724
572	18	2018-11-19 19:16:37.84502
572	4	2018-11-19 19:16:37.847077
684	18	2018-11-19 19:16:37.857686
684	4	2018-11-19 19:16:37.859692
573	20	2018-11-19 19:16:37.877094
573	33	2018-11-19 19:16:37.878823
574	20	2018-11-19 19:16:37.893763
574	33	2018-11-19 19:16:37.895394
575	20	2018-11-19 19:16:37.90468
575	33	2018-11-19 19:16:37.906286
576	20	2018-11-19 19:16:37.915825
576	33	2018-11-19 19:16:37.917489
577	20	2018-11-19 19:16:37.936221
577	33	2018-11-19 19:16:37.937866
578	20	2018-11-19 19:16:37.971654
578	33	2018-11-19 19:16:37.973366
740	20	2018-11-19 19:16:37.998245
740	33	2018-11-19 19:16:38.000229
579	20	2018-11-19 19:16:38.011055
579	33	2018-11-19 19:16:38.012877
580	20	2018-11-19 19:16:38.023736
580	33	2018-11-19 19:16:38.025687
581	20	2018-11-19 19:16:38.035515
581	33	2018-11-19 19:16:38.037271
582	20	2018-11-19 19:16:38.059372
582	33	2018-11-19 19:16:38.061583
392	20	2018-11-19 19:16:38.075502
392	33	2018-11-19 19:16:38.077222
583	20	2018-11-19 19:16:38.08692
583	33	2018-11-19 19:16:38.088748
584	20	2018-11-19 19:16:38.110389
584	33	2018-11-19 19:16:38.112289
585	20	2018-11-19 19:16:38.121963
585	33	2018-11-19 19:16:38.123626
586	20	2018-11-19 19:16:38.133477
586	33	2018-11-19 19:16:38.135293
587	20	2018-11-19 19:16:38.14521
587	33	2018-11-19 19:16:38.147032
588	20	2018-11-19 19:16:38.160778
588	33	2018-11-19 19:16:38.162746
589	20	2018-11-19 19:16:38.173207
589	33	2018-11-19 19:16:38.175041
590	20	2018-11-19 19:16:38.186243
590	33	2018-11-19 19:16:38.187944
591	20	2018-11-19 19:16:38.201694
591	33	2018-11-19 19:16:38.203549
592	20	2018-11-19 19:16:38.229214
592	33	2018-11-19 19:16:38.230843
593	20	2018-11-19 19:16:38.243344
593	33	2018-11-19 19:16:38.244979
594	20	2018-11-19 19:16:38.255385
594	33	2018-11-19 19:16:38.256965
595	20	2018-11-19 19:16:38.266776
595	33	2018-11-19 19:16:38.268507
596	20	2018-11-19 19:16:38.278247
596	33	2018-11-19 19:16:38.28001
597	20	2018-11-19 19:16:38.289817
597	33	2018-11-19 19:16:38.291672
598	20	2018-11-19 19:16:38.301558
598	33	2018-11-19 19:16:38.303371
599	20	2018-11-19 19:16:38.313198
599	33	2018-11-19 19:16:38.315032
741	20	2018-11-19 19:16:38.335362
741	33	2018-11-19 19:16:38.337334
600	20	2018-11-19 19:16:38.347198
600	33	2018-11-19 19:16:38.348842
601	20	2018-11-19 19:16:38.360614
601	33	2018-11-19 19:16:38.362478
602	15	2018-11-19 19:16:38.377632
602	4	2018-11-19 19:16:38.379511
603	15	2018-11-19 19:16:38.390064
603	4	2018-11-19 19:16:38.391949
604	15	2018-11-19 19:16:38.401702
604	4	2018-11-19 19:16:38.403564
605	15	2018-11-19 19:16:38.413916
605	4	2018-11-19 19:16:38.415883
606	15	2018-11-19 19:16:38.4364
606	4	2018-11-19 19:16:38.438345
607	15	2018-11-19 19:16:38.448324
607	4	2018-11-19 19:16:38.450465
608	15	2018-11-19 19:16:38.467978
608	4	2018-11-19 19:16:38.469932
609	15	2018-11-19 19:16:38.480368
609	4	2018-11-19 19:16:38.482381
610	15	2018-11-19 19:16:38.492833
610	4	2018-11-19 19:16:38.494814
611	15	2018-11-19 19:16:38.504776
611	4	2018-11-19 19:16:38.506674
612	15	2018-11-19 19:16:38.519786
612	4	2018-11-19 19:16:38.521563
613	15	2018-11-19 19:16:38.544926
613	4	2018-11-19 19:16:38.546986
614	15	2018-11-19 19:16:38.557306
614	4	2018-11-19 19:16:38.559566
742	15	2018-11-19 19:16:38.573713
742	4	2018-11-19 19:16:38.575747
743	15	2018-11-19 19:16:38.59016
743	4	2018-11-19 19:16:38.59231
615	13	2018-11-19 19:16:38.609724
615	4	2018-11-19 19:16:38.611791
616	13	2018-11-19 19:16:38.621863
616	4	2018-11-19 19:16:38.623769
744	13	2018-11-19 19:16:38.641891
744	4	2018-11-19 19:16:38.643751
617	13	2018-11-19 19:16:38.653685
617	4	2018-11-19 19:16:38.655553
618	13	2018-11-19 19:16:38.665478
618	4	2018-11-19 19:16:38.667607
619	13	2018-11-19 19:16:38.677704
619	4	2018-11-19 19:16:38.679686
745	13	2018-11-19 19:16:38.69429
745	4	2018-11-19 19:16:38.696303
620	13	2018-11-19 19:16:38.706315
620	4	2018-11-19 19:16:38.708179
621	13	2018-11-19 19:16:38.71804
621	4	2018-11-19 19:16:38.719963
622	13	2018-11-19 19:16:38.729588
622	4	2018-11-19 19:16:38.731584
746	13	2018-11-19 19:16:38.741992
746	4	2018-11-19 19:16:38.744148
747	13	2018-11-19 19:16:38.753833
747	4	2018-11-19 19:16:38.755665
623	13	2018-11-19 19:16:38.766645
623	4	2018-11-19 19:16:38.768598
624	13	2018-11-19 19:16:38.779641
624	4	2018-11-19 19:16:38.781699
748	13	2018-11-19 19:16:38.800222
748	4	2018-11-19 19:16:38.802215
625	13	2018-11-19 19:16:38.812517
625	4	2018-11-19 19:16:38.814595
626	13	2018-11-19 19:16:38.824616
626	4	2018-11-19 19:16:38.826836
627	13	2018-11-19 19:16:38.837698
627	4	2018-11-19 19:16:38.839789
749	13	2018-11-19 19:16:38.853569
749	4	2018-11-19 19:16:38.855496
628	13	2018-11-19 19:16:38.865599
628	4	2018-11-19 19:16:38.867537
629	13	2018-11-19 19:16:38.881066
629	4	2018-11-19 19:16:38.88293
630	13	2018-11-19 19:16:38.892823
630	4	2018-11-19 19:16:38.89512
631	13	2018-11-19 19:16:38.908375
631	4	2018-11-19 19:16:38.910426
633	13	2018-11-19 19:16:38.920163
633	4	2018-11-19 19:16:38.922281
634	13	2018-11-19 19:16:38.932358
634	4	2018-11-19 19:16:38.934427
635	13	2018-11-19 19:16:38.943995
635	4	2018-11-19 19:16:38.945967
687	13	2018-11-19 19:16:38.956479
687	4	2018-11-19 19:16:38.958327
636	13	2018-11-19 19:16:38.968661
636	4	2018-11-19 19:16:38.970591
637	13	2018-11-19 19:16:38.984895
637	4	2018-11-19 19:16:38.987036
638	13	2018-11-19 19:16:39.000419
638	4	2018-11-19 19:16:39.002335
639	13	2018-11-19 19:16:39.019611
639	4	2018-11-19 19:16:39.021654
640	13	2018-11-19 19:16:39.031622
640	4	2018-11-19 19:16:39.03364
641	25	2018-11-19 19:16:39.044431
641	35	2018-11-19 19:16:39.046112
642	25	2018-11-19 19:16:39.055906
642	35	2018-11-19 19:16:39.05766
643	25	2018-11-19 19:16:39.067731
643	35	2018-11-19 19:16:39.069501
644	25	2018-11-19 19:16:39.079917
644	35	2018-11-19 19:16:39.081675
715	29	2018-11-19 19:16:39.102589
715	35	2018-11-19 19:16:39.104221
646	29	2018-11-19 19:16:39.113479
646	35	2018-11-19 19:16:39.115096
647	29	2018-11-19 19:16:39.124065
647	35	2018-11-19 19:16:39.125683
648	29	2018-11-19 19:16:39.134867
648	35	2018-11-19 19:16:39.13653
649	29	2018-11-19 19:16:39.145805
649	35	2018-11-19 19:16:39.147482
650	29	2018-11-19 19:16:39.156426
650	35	2018-11-19 19:16:39.158069
651	29	2018-11-19 19:16:39.166903
651	35	2018-11-19 19:16:39.168584
652	29	2018-11-19 19:16:39.177677
652	35	2018-11-19 19:16:39.179356
750	29	2018-11-19 19:16:39.191455
750	35	2018-11-19 19:16:39.193108
653	29	2018-11-19 19:16:39.205137
653	35	2018-11-19 19:16:39.206798
654	29	2018-11-19 19:16:39.215967
654	35	2018-11-19 19:16:39.217591
655	29	2018-11-19 19:16:39.237462
655	35	2018-11-19 19:16:39.239016
656	29	2018-11-19 19:16:39.248037
656	35	2018-11-19 19:16:39.249662
657	29	2018-11-19 19:16:39.258572
657	35	2018-11-19 19:16:39.260205
658	29	2018-11-19 19:16:39.269471
658	35	2018-11-19 19:16:39.271152
659	29	2018-11-19 19:16:39.280296
659	35	2018-11-19 19:16:39.282046
751	29	2018-11-19 19:16:39.29382
751	35	2018-11-19 19:16:39.295434
660	29	2018-11-19 19:16:39.304599
660	35	2018-11-19 19:16:39.306215
661	29	2018-11-19 19:16:39.315175
661	35	2018-11-19 19:16:39.316843
662	29	2018-11-19 19:16:39.325774
662	35	2018-11-19 19:16:39.327618
663	29	2018-11-19 19:16:39.348222
663	35	2018-11-19 19:16:39.350084
664	29	2018-11-19 19:16:39.359922
664	35	2018-11-19 19:16:39.361583
665	29	2018-11-19 19:16:39.37139
665	35	2018-11-19 19:16:39.373321
752	29	2018-11-19 19:16:39.390195
752	35	2018-11-19 19:16:39.391888
666	29	2018-11-19 19:16:39.401848
666	35	2018-11-19 19:16:39.403399
667	17	2018-11-19 19:16:39.497434
667	4	2018-11-19 19:16:39.499272
668	17	2018-11-19 19:16:39.50854
668	4	2018-11-19 19:16:39.510325
669	17	2018-11-19 19:16:39.519508
669	4	2018-11-19 19:16:39.521485
670	17	2018-11-19 19:16:39.53094
670	4	2018-11-19 19:16:39.53283
671	17	2018-11-19 19:16:39.542055
671	4	2018-11-19 19:16:39.543862
753	17	2018-11-19 19:16:39.556386
753	4	2018-11-19 19:16:39.558156
672	17	2018-11-19 19:16:39.576413
672	4	2018-11-19 19:16:39.578221
673	17	2018-11-19 19:16:39.596624
673	4	2018-11-19 19:16:39.598445
674	17	2018-11-19 19:16:39.616865
674	4	2018-11-19 19:16:39.618589
675	17	2018-11-19 19:16:39.628306
675	4	2018-11-19 19:16:39.630318
676	17	2018-11-19 19:16:39.640703
676	4	2018-11-19 19:16:39.642855
677	17	2018-11-19 19:16:39.663283
677	4	2018-11-19 19:16:39.665385
678	17	2018-11-19 19:16:39.67571
678	4	2018-11-19 19:16:39.678214
754	17	2018-11-19 19:16:39.692628
754	4	2018-11-19 19:16:39.694512
755	17	2018-11-19 19:16:39.708812
755	4	2018-11-19 19:16:39.710573
679	17	2018-11-19 19:16:39.720814
679	4	2018-11-19 19:16:39.722772
680	17	2018-11-19 19:16:39.733559
680	4	2018-11-19 19:16:39.735603
681	17	2018-11-19 19:16:39.749258
681	4	2018-11-19 19:16:39.751382
682	17	2018-11-19 19:16:39.761785
682	4	2018-11-19 19:16:39.763799
683	17	2018-11-19 19:16:39.774291
683	4	2018-11-19 19:16:39.776691
756	17	2018-11-19 19:16:39.797954
756	4	2018-11-19 19:16:39.800217
757	17	2018-11-19 19:16:39.820215
757	4	2018-11-19 19:16:39.82215
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: api
--

COPY review (id, resource_id, reviewer_id, review_type, score, chart_url, comments, created_date, updated_date) FROM stdin;
\.


--
-- Data for Name: review_category; Type: TABLE DATA; Schema: public; Owner: api
--

COPY review_category (id, name, description, review_type, sort_order, min_score, max_score, created_date, updated_date) FROM stdin;
1	Clarity and comprehensibility		CONTENT	1	1	5	2018-05-26 18:47:40.570619	\N
2	Clarity and comprehensibility		CONTENT	2	1	5	2018-05-26 18:47:40.570619	\N
3	Accuracy		CONTENT	3	1	5	2018-05-26 18:47:40.570619	\N
4	Readability		CONTENT	4	1	5	2018-05-26 18:47:40.570619	\N
5	Consistency		CONTENT	5	1	5	2018-05-26 18:47:40.570619	\N
6	Appropriateness		CONTENT	6	1	5	2018-05-26 18:47:40.570619	\N
7	Interface		CONTENT	7	1	5	2018-05-26 18:47:40.570619	\N
8	Content usefulness		CONTENT	8	1	5	2018-05-26 18:47:40.570619	\N
9	Modularity		CONTENT	9	1	5	2018-05-26 18:47:40.570619	\N
10	Content errors		CONTENT	10	1	5	2018-05-26 18:47:40.570619	\N
11	Reading level		CONTENT	11	1	5	2018-05-26 18:47:40.570619	\N
12	Cultural relevance		CONTENT	12	1	5	2018-05-26 18:47:40.570619	\N
\.


--
-- Name: review_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('review_category_id_seq', 12, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('review_id_seq', 1, false);


--
-- Data for Name: reviewer; Type: TABLE DATA; Schema: public; Owner: api
--

COPY reviewer (id, organization_id, name, title, biography, search_name, created_date, updated_date) FROM stdin;
\.


--
-- Name: reviewer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('reviewer_id_seq', 1, false);


--
-- Data for Name: sub_tag; Type: TABLE DATA; Schema: public; Owner: api
--

COPY sub_tag (tag_id, parent_tag_id, created_date) FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: api
--

COPY tag (id, name, tag_type, parent_tag_id, search_name, created_date) FROM stdin;
1	Featured	GENERAL	\N	featured	2018-05-26 18:47:29.971449
2	Applied Sciences	DISCIPLINE	\N	applied sciences	2018-05-26 18:47:29.971449
5	Natural Sciences	DISCIPLINE	\N	natural sciences	2018-05-26 18:47:29.971449
6	Social Sciences	DISCIPLINE	\N	social sciences	2018-05-26 18:47:29.971449
7	Computer and Information Science	DISCIPLINE	2	computer and information science	2018-05-26 18:47:35.753186
11	General Business	DISCIPLINE	3	general business	2018-05-26 18:47:35.753186
24	statistics and probability	DISCIPLINE	\N	statistics and probability	2018-05-26 18:47:35.753186
23	physics	DISCIPLINE	\N	physics	2018-05-26 18:47:35.753186
14	Fine Arts	DISCIPLINE	4	fine arts	2018-05-26 18:47:35.753186
16	Languages and Communication	DISCIPLINE	4	languages and communication	2018-05-26 18:47:35.753186
25	anthropology and archaeology	DISCIPLINE	\N	anthropology and archaeology	2018-05-26 18:47:35.753186
36	computer and informationscience	SUB_DISCIPLINE	\N	computer and informationscience	2018-05-26 20:55:45.205241
21	General Sciences	DISCIPLINE	5	general sciences	2018-05-26 18:47:35.753186
31	Applied Science	DISCIPLINE	\N	applied science	2018-05-26 20:55:39.204404
17	literature	DISCIPLINE	\N	literature	2018-05-26 18:47:35.753186
27	law	DISCIPLINE	\N	law	2018-05-26 18:47:35.753186
4	Humanities	DISCIPLINE	\N	humanities	2018-05-26 18:47:29.971449
22	mathematics	DISCIPLINE	\N	mathematics	2018-05-26 18:47:35.753186
28	Political Science	DISCIPLINE	6	political science	2018-05-26 18:47:35.753186
38	politicalscience	SUB_DISCIPLINE	\N	politicalscience	2018-05-26 20:55:47.881695
10	accounting and finance	DISCIPLINE	\N	accounting and finance	2018-05-26 18:47:35.753186
37	language and communication	SUB_DISCIPLINE	\N	language and communication	2018-05-26 20:55:47.403972
19	biology and genetics	DISCIPLINE	\N	biology and genetics	2018-05-26 18:47:35.753186
29	psychology	DISCIPLINE	\N	psychology	2018-05-26 18:47:35.753186
35	Social Science	DISCIPLINE	\N	social science	2018-05-26 20:55:44.094489
26	economics	DISCIPLINE	\N	economics	2018-05-26 18:47:35.753186
12	education	DISCIPLINE	\N	education	2018-05-26 18:47:35.753186
18	philosophy	DISCIPLINE	\N	philosophy	2018-05-26 18:47:35.753186
20	chemistry	DISCIPLINE	\N	chemistry	2018-05-26 18:47:35.753186
33	Natural Science	DISCIPLINE	\N	natural science	2018-05-26 20:55:41.111435
13	english and composition	DISCIPLINE	\N	english and composition	2018-05-26 18:47:35.753186
15	history	DISCIPLINE	\N	history	2018-05-26 18:47:35.753186
8	engineering and electronics	DISCIPLINE	\N	engineering and electronics	2018-05-26 18:47:35.753186
9	health and nursing	DISCIPLINE	\N	health and nursing	2018-05-26 18:47:35.753186
39	generalscience	SUB_DISCIPLINE	\N	generalscience	2018-05-26 20:55:47.992714
30	sociology	DISCIPLINE	\N	sociology	2018-05-26 18:47:35.753186
32	generalbusiness	SUB_DISCIPLINE	\N	generalbusiness	2018-05-26 20:55:40.381653
3	Business	DISCIPLINE	\N	business	2018-05-26 18:47:29.971449
34	finearts	SUB_DISCIPLINE	\N	finearts	2018-05-26 20:55:43.855965
\.


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: api
--

SELECT pg_catalog.setval('tag_id_seq', 39, true);


--
-- Data for Name: tag_keyword; Type: TABLE DATA; Schema: public; Owner: api
--

COPY tag_keyword (tag_id, keyword, created_date) FROM stdin;
22	graphs	2018-05-26 18:48:04.073225
22	inequalities	2018-05-26 18:48:04.073225
22	factoring	2018-05-26 18:48:04.073225
22	real numbers	2018-05-26 18:48:04.073225
22	equations	2018-05-26 18:48:04.073225
22	conversion of units	2018-05-26 18:48:04.073225
22	geometry	2018-05-26 18:48:04.073225
22	similar triangles	2018-05-26 18:48:04.073225
22	euler diagrams	2018-05-26 18:48:04.073225
22	euler paths	2018-05-26 18:48:04.073225
22	euler circuits	2018-05-26 18:48:04.073225
22	hamilton paths	2018-05-26 18:48:04.073225
22	hamilton circuits	2018-05-26 18:48:04.073225
22	logical statements	2018-05-26 18:48:04.073225
22	negations	2018-05-26 18:48:04.073225
22	numeration systems	2018-05-26 18:48:04.073225
22	base 2	2018-05-26 18:48:04.073225
22	roman numerals	2018-05-26 18:48:04.073225
22	egyptian numerals	2018-05-26 18:48:04.073225
24	conditional probability	2018-05-26 18:48:04.073225
24	standard distribution	2018-05-26 18:48:04.073225
24	central tendency	2018-05-26 18:48:04.073225
24	statistics	2018-05-26 18:48:04.073225
24	probability	2018-05-26 18:48:04.073225
24	odds	2018-05-26 18:48:04.073225
24	discrete	2018-05-26 18:48:04.073225
24	discrete random variables	2018-05-26 18:48:04.073225
24	standard deviation	2018-05-26 18:48:04.073225
24	common discrete probability distribution functions	2018-05-26 18:48:04.073225
24	binomial	2018-05-26 18:48:04.073225
24	summary of functions	2018-05-26 18:48:04.073225
17	literature	2018-05-26 18:48:04.073225
17	literary	2018-05-26 18:48:04.073225
17	fernando del paso	2018-05-26 18:48:04.073225
17	mexican literature	2018-05-26 18:48:04.073225
17	mexican authors	2018-05-26 18:48:04.073225
17	literary criticism	2018-05-26 18:48:04.073225
17	sherlock	2018-05-26 18:48:04.073225
19	biology	2018-05-26 18:48:04.073225
\.


--
-- Name: author_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- Name: chapter_review_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY chapter_review
    ADD CONSTRAINT chapter_review_pkey PRIMARY KEY (id);


--
-- Name: chapter_review_score_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY chapter_review_score
    ADD CONSTRAINT chapter_review_score_pkey PRIMARY KEY (id);


--
-- Name: editor_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_pkey PRIMARY KEY (id);


--
-- Name: organization_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: repository_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY repository
    ADD CONSTRAINT repository_pkey PRIMARY KEY (id);


--
-- Name: resource_author_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY resource_author
    ADD CONSTRAINT resource_author_pkey PRIMARY KEY (resource_id, author_id);


--
-- Name: resource_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY resource_editor
    ADD CONSTRAINT resource_editor_pkey PRIMARY KEY (resource_id, editor_id);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY resource_tag
    ADD CONSTRAINT resource_tag_pkey PRIMARY KEY (resource_id, tag_id);


--
-- Name: review_category_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY review_category
    ADD CONSTRAINT review_category_pkey PRIMARY KEY (id);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: reviewer_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY reviewer
    ADD CONSTRAINT reviewer_pkey PRIMARY KEY (id);


--
-- Name: sub_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY sub_tag
    ADD CONSTRAINT sub_tag_pkey PRIMARY KEY (parent_tag_id, tag_id);


--
-- Name: tag_pkey; Type: CONSTRAINT; Schema: public; Owner: api; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: idx_author_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_author_search_name ON author USING btree (search_name);


--
-- Name: idx_editor_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_editor_search_name ON editor USING btree (search_name);


--
-- Name: idx_organization_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_organization_search_name ON organization USING btree (search_name);


--
-- Name: idx_repository_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_repository_search_name ON repository USING btree (search_name);


--
-- Name: idx_resource_search_license; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_resource_search_license ON resource USING btree (license_name);


--
-- Name: idx_resource_search_title; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_resource_search_title ON resource USING btree (search_title);


--
-- Name: idx_reviewer_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_reviewer_search_name ON reviewer USING btree (search_name);


--
-- Name: idx_tag_keyword; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_tag_keyword ON tag_keyword USING btree (keyword);


--
-- Name: idx_tag_parent_tag_id; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_tag_parent_tag_id ON tag USING btree (parent_tag_id);


--
-- Name: idx_tag_search_name; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_tag_search_name ON tag USING btree (search_name);


--
-- Name: idx_tag_tag_type; Type: INDEX; Schema: public; Owner: api; Tablespace: 
--

CREATE INDEX idx_tag_tag_type ON tag USING btree (tag_type);


--
-- Name: set_created_date_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_created_date_trigger BEFORE INSERT ON tag FOR EACH ROW EXECUTE PROCEDURE set_created_date_trigger_fn();


--
-- Name: set_created_date_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_created_date_trigger BEFORE INSERT ON resource_tag FOR EACH ROW EXECUTE PROCEDURE set_created_date_trigger_fn();


--
-- Name: set_created_date_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_created_date_trigger BEFORE INSERT ON sub_tag FOR EACH ROW EXECUTE PROCEDURE set_created_date_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON repository FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON resource FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON author FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON editor FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON reviewer FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON review FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON review_category FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON chapter_review FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: set_dates_trigger; Type: TRIGGER; Schema: public; Owner: api
--

CREATE TRIGGER set_dates_trigger BEFORE INSERT OR UPDATE ON chapter_review_score FOR EACH ROW EXECUTE PROCEDURE set_dates_trigger_fn();


--
-- Name: author_repositoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_repositoryid_fkey FOREIGN KEY (repositoryid) REFERENCES repository(id);


--
-- Name: chapter_review_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY chapter_review
    ADD CONSTRAINT chapter_review_review_id_fkey FOREIGN KEY (review_id) REFERENCES review(id) ON DELETE CASCADE;


--
-- Name: chapter_review_score_chapter_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY chapter_review_score
    ADD CONSTRAINT chapter_review_score_chapter_review_id_fkey FOREIGN KEY (chapter_review_id) REFERENCES chapter_review(id) ON DELETE CASCADE;


--
-- Name: chapter_review_score_review_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY chapter_review_score
    ADD CONSTRAINT chapter_review_score_review_category_id_fkey FOREIGN KEY (review_category_id) REFERENCES review_category(id) ON DELETE CASCADE;


--
-- Name: repository_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY repository
    ADD CONSTRAINT repository_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE;


--
-- Name: resource_author_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_author
    ADD CONSTRAINT resource_author_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(id);


--
-- Name: resource_author_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_author
    ADD CONSTRAINT resource_author_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(id);


--
-- Name: resource_editor_editor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_editor
    ADD CONSTRAINT resource_editor_editor_id_fkey FOREIGN KEY (editor_id) REFERENCES editor(id);


--
-- Name: resource_editor_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_editor
    ADD CONSTRAINT resource_editor_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(id);


--
-- Name: resource_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES repository(id) ON DELETE CASCADE;


--
-- Name: resource_tag_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_tag
    ADD CONSTRAINT resource_tag_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE;


--
-- Name: resource_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY resource_tag
    ADD CONSTRAINT resource_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE;


--
-- Name: review_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE;


--
-- Name: review_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES reviewer(id);


--
-- Name: reviewer_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY reviewer
    ADD CONSTRAINT reviewer_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE;


--
-- Name: sub_tag_parent_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY sub_tag
    ADD CONSTRAINT sub_tag_parent_tag_id_fkey FOREIGN KEY (parent_tag_id) REFERENCES tag(id) ON DELETE CASCADE;


--
-- Name: sub_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY sub_tag
    ADD CONSTRAINT sub_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE;


--
-- Name: tag_keyword_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: api
--

ALTER TABLE ONLY tag_keyword
    ADD CONSTRAINT tag_keyword_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

