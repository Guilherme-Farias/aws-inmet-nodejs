CREATE OR REPLACE STREAM "api_stream" (
    "name" varchar(255), 
    "temperature" DOUBLE,
    "humidity" DOUBLE
);


CREATE OR REPLACE PUMP "api_pump" AS INSERT INTO "api_stream" SELECT STREAM 
    "name", (("temperature" * (9/5)) + 32), ("humidity" * 0.01)
    FROM "SOURCE_SQL_STREAM_001";


CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
            "name"  varchar(255),
            "heat_index" decimal
);

CREATE OR REPLACE PUMP "Output_Pump" AS INSERT INTO "DESTINATION_SQL_STREAM" SELECT STREAM "name", 
        CASE
            WHEN ((1.1 * "temperature") - 10.3 + (0.047 * "humidity")) < 80 
            THEN ((1.1 * "temperature") - 10.3 + (0.047 * "humidity"))
            
            WHEN (80.0 <= "temperature") AND ("temperature" <= 112.0) AND ("humidity" <= 0.13)
            THEN (
                - 42.379 + 2.04901523 * "temperature" + 10.14333127 * "humidity"
                - 0.22475541 * "temperature" * "humidity" 
                - POWER(6.83783, -3) * POWER("temperature", 2)
                - POWER(5.481717, -2) * POWER("humidity", 2)
                + POWER(1.22874, -5) * POWER("temperature", 2) * "humidity"
                - POWER(8.5282, -4) * "temperature" * POWER("humidity", 2)
                - POWER(1.99, -6) * POWER("temperature", 2) * POWER("humidity", 2)
                ) - (3.25 - 0.25 * "humidity") * ((17 - abs("temperature"-95)) / 17) * 0.5
            
            WHEN (80 <= "temperature") AND ("temperature" <= 87) AND "humidity" > 0.85
            THEN (
                - 42.379 + 2.04901523 * "temperature" + 10.14333127 * "humidity"
                - 0.22475541 * "temperature" * "humidity" 
                - POWER(6.83783, -3) * POWER("temperature", 2)
                - POWER(5.481717, -2) * POWER("humidity", 2)
                + POWER(1.22874, -5) * POWER("temperature", 2) * "humidity"
                - POWER(8.5282, -4) * "temperature" * POWER("humidity", 2)
                - POWER(1.99, -6) * POWER("temperature", 2) * POWER("humidity", 2)
                ) + (0.02 * ("humidity" - 85) * (87 - "temperature"))
        ELSE (
                - 42.379 + 2.04901523 * "temperature" + 10.14333127 * "humidity"
                - 0.22475541 * "temperature" * "humidity" 
                - POWER(6.83783, -3) * POWER("temperature", 2)
                - POWER(5.481717, -2) * POWER("humidity", 2)
                + POWER(1.22874, -5) * POWER("temperature", 2) * "humidity"
                - POWER(8.5282, -4) * "temperature" * POWER("humidity", 2)
                - POWER(1.99, -6) * POWER("temperature", 2) * POWER("humidity", 2)
                )
        END
FROM "api_stream";
