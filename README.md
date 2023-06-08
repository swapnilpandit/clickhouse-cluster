# Clickhouse Containerized Cluster

## Test it

Login to clickhouse01 console

```sh
clickhouse-client -h localhost
```

Create a test database and table (sharded and replicated)

```sql
CREATE DATABASE testing ON CLUSTER 'docker_cluster';

CREATE TABLE testing.events ON CLUSTER 'docker_cluster' (
    time DateTime,
    uid  Int64,
    type LowCardinality(String)
)
ENGINE = ReplicatedMergeTree('clickhouse/data/testing/{shard}/events', '{replica}')
PARTITION BY toDate(time)
ORDER BY (uid);

CREATE TABLE testing.events_distr ON CLUSTER 'docker_cluster' AS testing.events
ENGINE = Distributed('docker_cluster', testing, events, uid);
```

Load some data

```sql
INSERT INTO testing.events_distr VALUES
    ('2020-01-01 10:00:00', 100, 'view'),
    ('2020-01-01 10:05:00', 101, 'view'),
    ('2020-01-01 11:00:00', 100, 'contact'),
    ('2020-01-01 12:10:00', 101, 'view'),
    ('2020-01-02 08:10:00', 100, 'view'),
    ('2020-01-03 13:00:00', 103, 'view');
```

Check data from the current shard

```sql
SELECT * FROM testing.events;
```

Check data from all cluster

```sql
SELECT * FROM testing.events_distr;
```
