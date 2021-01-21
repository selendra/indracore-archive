# Indracore Archive 
Run alongside a indracore-backed chain to index all Blocks, State, and Extrinsic data into PostgreSQL.

### Usage
The schema for the PostgreSQL database is described in the [PDF](https://github.com/selendra/indracore-archive/blob/master/IndracoreArchiveSchema.pdf) File.
Indracore Archive aims to eliminate any ambiguity while building apps by exposing a more traditional means of fetching data from indracore-based chains through an SQL database. Users will be able to craft their own queries based on an analysis of their needs, and apply them against a relational database which mirrors all of the data on a running chain. It's intentionally generic, in order to fit many use-cases.

## Prerequisites
- depending on the chain you want to index, ~60GB free space
- PostgreSQL with a database ready for lots of new data
- Indracore-based Blockchain running with RocksDB as the backend
- Indracore-based Blockchain running under `--pruning=archive`
- 
### Quick Start

```bash
$ git clone https://github.com/selendra/indracore-archive.git
$ cargo build --release
# Start the normal indracore node with `pruning` set to `archive`
$ indracore --chain=indracore --pruning=archive
# Start up the indracore-archive node. `chain` can be one of `indacore-local`, `indracore`.
$ ./target/release/indracore-archive -c db_conf.toml --chain=indracore -vv
```
* Note : [db_conf.toml](https://github.com/selendra/indracore-archive/blob/master/db_conf.toml) use to config postgres db 

## Troubleshooting

### Archive fails to start with a `too many open files` error.

Because of the way a [RocksDB Secondary Instance](https://github.com/facebook/rocksdb/wiki/Secondary-instance) works, it requires that all the files of the primary instance remain open in the secondary instance. This could trigger the error on linux, but simply requires that you raise the max open files limit (`ulimit`):

- With Docker: `$ docker run --ulimit nofile=90000:90000 <image-tag>`
- For Current Shell Session: `ulimit -a 90000`
- Permanantly Per-User
  - Edit `/etc/security/limits.conf`

    ```
    # /etc/security/limits.conf
    *           hard    nofile      4096
    *           soft    nofile      1024
    some_usr    hard    nofile      90000
    some_usr    soft    nofile      90000
    insipx      hard    nofile      90000
    insipx      soft    nofile      90000
    root        hard    nofile      90000
    root        soft    nofile      90000
    ```

For macOS and Linux, a warning message will be raised on the startup when there is a low fd sources limit in the current system, but Windows won't have such a low fd limit warning.



#### License
The part of code within this repository is licensed under the [substrate-archive](https://github.com/paritytech/substrate-archive)
