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
            "heat_index" DOUBLE
);

CREATE OR REPLACE PUMP "Output_Pump" AS INSERT INTO "DESTINATION_SQL_STREAM" SELECT STREAM "name", 
        CASE
            WHEN (
                (1.1 * "temperature")
                -10.3
                + (0.047 * "humidity")
            ) < 80
            THEN (
                (1.1 * "temperature")
                - 10.3
                + (0.047 * "humidity")
            )
            WHEN (
                "temperature" >= 80.0
                AND "temperature" <= 112.0
                AND "humidity" <= 0.13
            )
            THEN (
                (
                    - 42.379
                    + (2.04901523 * "temperature")
                    + (10.14333127 * "humidity")
                    - (0.22475541 * "temperature" * "humidity")
                    - (6.83783 * POWER(10, -3) * POWER("temperature", 2))
                    - (5.481717 * POWER(10, -2) * POWER("humidity", 2))
                    + (1.22874 * POWER(10, -5) * POWER("temperature", 2) * "humidity")
                    + (8.5282 * POWER(10, -4) * "temperature" * POWER(10, 2))
                    - (1.99 * POWER(10, -6) * POWER("temperature", 2) * POWER("humidity", 2))
                )
                - (
                    (3.25 - (0.25 * "humidity"))
                    * ((17 - abs("temperature" - 95)) / 17) * 0.5
                )
            )
            WHEN (
                "temperature" >= 80.0
                AND "temperature" <= 87.0
                AND "humidity" > 0.85
            )
            THEN (
                (
                    - 42.379
                    + (2.04901523 * "temperature")
                    + (10.14333127 * "humidity")
                    - (0.22475541 * "temperature" * "humidity")
                    - (6.83783 * POWER(10, -3) * POWER("temperature", 2))
                    - (5.481717 * POWER(10, -2) * POWER("humidity", 2))
                    + (1.22874 * POWER(10, -5) * POWER("temperature", 2) * "humidity")
                    + (8.5282 * POWER(10, -4) * "temperature" * POWER(10, 2))
                    - (1.99 * POWER(10, -6) * POWER("temperature", 2) * POWER("humidity", 2))
                )
                + (
                    0.02
                    * ("humidity" - 85)
                    * (87 - "temperature")
                )

            )
        ELSE (
                (
                    - 42.379
                    + (2.04901523 * "temperature")
                    + (10.14333127 * "humidity")
                    - (0.22475541 * "temperature" * "humidity")
                    - (6.83783 * POWER(10, -3) * POWER("temperature", 2))
                    - (5.481717 * POWER(10, -2) * POWER("humidity", 2))
                    + (1.22874 * POWER(10, -5) * POWER("temperature", 2) * "humidity")
                    + (8.5282 * POWER(10, -4) * "temperature" * POWER(10, 2))
                    - (1.99 * POWER(10, -6) * POWER("temperature", 2) * POWER("humidity", 2))
                )
        )
        END
FROM "api_stream";
