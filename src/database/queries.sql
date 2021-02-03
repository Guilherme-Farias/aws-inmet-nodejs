CREATE OR REPLACE STREAM "api_stream" (
    "name" varchar(255), 
    "temperature" DOUBLE,
    "humidity" DOUBLE
);


CREATE OR REPLACE PUMP "api_pump" AS INSERT INTO "api_stream" SELECT STREAM 
    "name", (("temperature" * (9/5)) + 32), ("humidity" * 0.01)
    FROM "SOURCE_SQL_STREAM_001";
