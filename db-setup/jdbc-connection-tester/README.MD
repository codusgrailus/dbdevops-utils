#### Compile the java class files
```bash
mvn -q clean package
```

#### Run the standalone java jdbc connection tester
```bash
DB_HOST='senthil-aurora-mysql-apr14-c001.cluster-ctsyoy2uexi7.ap-south-1.rds.amazonaws.com' \
DB_USER='auroramysqladmin' \
DB_PASSWORD='xxxxxxxxxx' \
DB_JDBC_DRIVER='jdbc:mysql' \
java -cp "target/jdbc-connection-tester.jar:target/libs/*" com.harness.jdbc.ConnectionTester
```

#### Build the docker image
```bash
export DOCKER_ACCOUNT='codusgrailus' && \
docker build -t $DOCKER_ACCOUNT/jdbc-connection-tester:latest -f Dockerfile.AMD64 .

docker push $DOCKER_ACCOUNT/jdbc-connection-tester:latest 
```

#### Run the test on k8s
```bash
  cp k8s/secret.yml.example k8s/secret.yml
  # edit and modify k8s/secret.yml
  kubectl apply -f k8s/secret.yml
  kubectl apply -f k8s/job.yml
  kubectl get job jdbc-connection-tester -w
  kubectl logs -l job-name=jdbc-connection-tester
```

### you should see something like this
```text
$   kubectl logs -l job-name=jdbc-connection-tester

  - information_schema
  - mydb
  - mysql
  - performance_schema
  - sys
-------------------------------------------------
  Total: 5 database(s)
=================================================
  Test PASSED
=================================================
```

#### Check aurora has public / private ip
```bash
 kubectl run dnscheck --rm -it --restart=Never --image=busybox -- nslookup senthil-aurora-mysql-apr14-c001.cluster-ctsyoy2uexi7.ap-south-1.rds.amazonaws.com
Server:         172.20.0.10
Address:        172.20.0.10:53

# You may see output like below for public ip
#Non-authoritative answer:
#senthil-aurora-mysql-apr14-c001.cluster-ctsyoy2uexi7.ap-south-1.rds.amazonaws.com       canonical name = senthil-aurora-mysql-apr14-c001-instance-1.ctsyoy2uexi7.ap-south-1.rds.amazonaws.com
#senthil-aurora-mysql-apr14-c001-instance-1.ctsyoy2uexi7.ap-south-1.rds.amazonaws.com    canonical name = ec2-3-111-207-199.ap-south-1.compute.amazonaws.com
#Name:   ec2-3-111-207-199.ap-south-1.compute.amazonaws.com
#Address: 3.111.207.199 
 
```

### Cleanup settings
```bash
  kubectl delete -f k8s/job.yml
  kubectl delete -f k8s/secret.yml     
```
