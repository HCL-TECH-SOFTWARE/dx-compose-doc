---
id: webengine-db2-hadr
title: Enabling support for DB2 high availability data replication
---

# DB2: Enabling support for high availability data replication

Optional: To prevent data loss on DB2, modify the JCR schema to support high availability data replication (HADR) on WebEngine.

Before you enable HADR, use the Database Transfer option in your configuration values configuration templates to transfer your data from Apache Derby to DB2®.

!!! tip "Architectural Design and Compliance Guardrails"
    Read the following tips before you enable support for high availability data replication within your WebEngine containers:
    -   Do NOT attempt to declare or inject legacy WebSphere-specific properties such as `<transaction>` timeout boundaries (`totalTranLifetimeTimeout`) into your Open Liberty XML DOM templates. Liberty handles timeout isolation contexts cleanly using standalone `<connectionManager>` elements.
    -   Do NOT set the custom property **enableClientAffinitiesList** to true. It is not necessary with newer DB2 versions. Setting this value to true means that ONLY servers that are listed in the alternative server names list are used for connecting to the database.
    -   The db2inst1 and lcuser values need to be the same passwords on both DB2 servers.

---

## Phase 1: Database Tier Schema and Replication Configuration

1.  **Back up the active JCR database repository schema.** The HADR initialization processes permanently alter the schema layout.

2.  **Execute JCR wide-table LOB column logging migration.** DB2 HADR setups strictly require all wide-table Large Objects (LOBs) to be logged for standby replication purposes. Unlogged BLOB structures are silently excluded from transaction streams, leading to data corruption on failover.
    * In a Helm-managed orchestration, your deployment container will automatically identify if `db2HadrEnabled` is flagged true.
    * On initial primary container cold boot, the startup sequence triggers `reconfigure_jcr_for_hadr.sh` to safely transform column data from `NOT LOGGED BLOB` to `BLOB(1G) LOGGED` inside the `ICMUTMWIDE0` table definitions.
    * For clustered environments, run this task only from one node to avoid concurrent DDL database modifications.

3.  **Establish High Availability Ports on the Primary Database Node:**
    Open an administrative shell terminal on your primary database system and ensure the replication communication parameters match your environment's `/etc/services` routing records:
    ```text
    db2c_db2inst1     50000/tcp
    DB2_HADR_JCR_1    50005/tcp
    DB2_HADR_JCR_2    50006/tcp
    DB2_HADR_REL_1    50011/tcp
    DB2_HADR_REL_2    50012/tcp
    ```

4.  **Configure Database Archiving and HADR Parameters on the Primary Node:**
    Execute the following command sequence to put the primary instances into an appropriate backup state and provision replication paths:
    ```bash
    db2 update db cfg for WPJCR using LOGARCHMETH1 LOGRETAIN
    db2 "backup database WPJCR"
    
    db2 update db cfg for WPJCR using HADR_LOCAL_HOST IP_ADDRESS_OF_PRIMARY
    db2 update db cfg for WPJCR using HADR_LOCAL_SVC 50005
    db2 update db cfg for WPJCR using HADR_REMOTE_HOST IP_ADDRESS_OF_STNDBY
    db2 update db cfg for WPJCR using HADR_REMOTE_SVC 50006
    db2 update db cfg for WPJCR using HADR_REMOTE_INST db2inst1
    db2 update db cfg for WPJCR using HADR_TIMEOUT 120
    db2 update db cfg for WPJCR using HADR_SYNCMODE NEARSYNC
    db2 update db cfg for WPJCR using LOGINDEXBUILD ON
    ```

5.  **Provision the Alternate Client Reroute Map on the Primary Server:**
    Inform the native database catalog layer about the fallback standby server node route:
    ```bash
    db2 UPDATE ALTERNATE SERVER FOR DATABASE WPJCR USING HOSTNAME IP_ADDRESS_OF_STNDBY PORT 50000
    db2 "backup database WPJCR"
    ```

6.  **Synchronize and Initialize the Standby Database Node:**
    Copy the primary database offline backup image parameters over to your fallback node and restore the structure:
    ```bash
    db2 "restore database WPJCR"
    
    db2 update db cfg for WPJCR using HADR_LOCAL_HOST IP_ADDRESS_OF_STNDBY
    db2 update db cfg for WPJCR using HADR_LOCAL_SVC 50006
    db2 update db cfg for WPJCR using HADR_REMOTE_HOST IP_ADDRESS_OF_PRIMARY
    db2 update db cfg for WPJCR using HADR_REMOTE_SVC 50005
    db2 update db cfg for WPJCR using HADR_REMOTE_INST db2inst1
    db2 update db cfg for WPJCR using HADR_TIMEOUT 120
    db2 update db cfg for WPJCR using HADR_SYNCMODE NEARSYNC
    db2 update db cfg for WPJCR using LOGINDEXBUILD ON
    
    db2 UPDATE ALTERNATE SERVER FOR DATABASE WPJCR USING HOSTNAME IP_ADDRESS_OF_PRIMARY PORT 50000
    ```

7.  **Activate High Availability Replication:**
    Start the engine targets in order, initiating the standby tracking state before starting the primary database node:
    * **On the Standby System:**
        ```bash
        db2 start hadr on database WPJCR as standby
        ```
    * **On the Primary System:**
        ```bash
        db2 activate database WPJCR
        db2 start hadr on database WPJCR as primary
        ```

8.  **Validate Replication Synchronization:**
    Verify your cluster state maps correctly using the database utility engine:
    ```bash
    db2pd -db WPJCR -hadr
    ```

---

## Phase 2: WebEngine Container Deployment Configuration

To wire your containerized Open Liberty application nodes to the newly established database cluster, you must pass high availability parameters directly into your chart attributes.

1.  Open your deployment manifest file (`values.yaml`).
2.  Locate the `configuration.webEngine` block and update the attributes to enable dynamic client-side failover tracking:
    ```yaml
    configuration:
      webEngine:
        # Step A: Enable external database authority mapping configurations
        useExternalDatabase: true
        
        # Step B: Activate high availability database replication support routines
        db2HadrEnabled: true
        
        # Step C: Supply the alternate target host name mapping records
        db2HadrStandbyHost: "standby-db2-hadr2.team-q-dev.com"
        db2HadrStandbyPort: "50000"
        
        # Step D: Configure dynamic client re-route parameters
        db2HadrMaxRetries: "20"
        db2HadrRetryInterval: "5"
    ```
3.  Apply and deploy the configuration parameters upgrade directly to your Kubernetes layout cluster using standard Helm commands:
    ```bash
    helm upgrade <release-name> hcl-dx/dx-deployment -f values.yaml
    ```

---

## Phase 3: On-The-Fly Failover Execution Flow

Once applied, the application tier automatically handles forward database takeovers and backward recovery switches seamlessly on the fly with zero manual container restarts, pipeline automation steps, or pod deletions.

### Under-the-Hood Self-Healing Architecture
1.  **Automatic Client Reroute (ACR):** When an explicit `TAKEOVER HADR` command switches the roles of your databases, the underlying DB2 JCC driver leverages the alternates map generated by `UpdateServerXML.java` to dynamically redirect physical network traffic to the alternate host.
2.  **Foreground Log Supervisor Monitoring:** To safely evict lingering in-memory lockouts, stale connection handles, and cached blacklists, a non-intrusive foreground supervisor loop runs inside `entryPoint.sh`. It continuously inspects the active application log stream (`SystemOut.log`) for the signature DB2 standby error string (`-1776` or `-1,776`).
3.  **Graceful Application Termination:** The moment a transaction exception occurs, the supervisor intercepts the log footprint, executes a graceful Open Liberty server stop command (`$SERVER_CMD stop $SERVER`), and exits the script natively using an exit code of `0`.
4.  **Zero-Downtime Clean State Restoration:** Because the main script runs as PID 1 inside the container, calling `exit 0` terminates the container naturally. Kubernetes instantly captures this termination, pulls down the degraded environment, and spins up a brand-new Pod instance. During this fresh initialization phase, the application establishes clean connection pools directly tied to your newly promoted active primary DB2 node without human intervention.