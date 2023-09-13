# Configure SonarQube

```bash
# Launch postgres sql.
sudo -u postgres psql
```

```bash
#create the user.
CREATE USER sonarqube WITH PASSWORD '<password>';

# Create the database
CREATE DATABASE sonarqube OWNER sonarqube;

# Give the privileges
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;

exit;
```

```bash
sudo vim /etc/sysctl.conf

# Add below lines
vm.max_map_count=524288
fs.file-max=131072
```

```bash
# Reload the sysctl configuration
sudo sysctl --system
```

```bash
sudo vim /opt/sonarqube/conf/sonar.properties

# Edit below lines and enter the password details.
sonar.jdbc.username=sonarqube
sonar.jdbc.password=<password>
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
```

```bash
# Uncomment all the below lines in /opt/sonarqube/conf/sonar.properties
sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError
sonar.web.javaAdditionalOpts=-server
sonar.web.host=0.0.0.0.0
sonar.web.port=9000
sonar.log.level=INFO
sonar.path.logs=logs
```

```bash
#Create a system service file for sonar
sudo vim /etc/systemd/system/sonarqube.service
```

```bash
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
```

```bash
# Reload and start the service
sudo systemctl daemon-reload
sudo systemctl start sonarqube.service
sudo systemctl enable sonarqube.service
```

### Secure the sonar scanner

```bash
sudo vim /opt/sonarqube/conf/sonar.properties

# Add below line to the end of the file.
sonar.secretKeyPath=/opt/sonarqube/conf/sonar-secret.txt
```

```bash
# Add a new file and enter the token
sudo vim /opt/sonarqube/conf/sonar-secret.txt
```

```bash
# Restrict to the user
sudo chown sonarqube:sonarqube /opt/sonarqube/conf/sonar-secret.txt

# Restart the service
sudo systemctl restart sonarqube
```

```bash
#Encrypt the database password

#Administration >> Configuration >> Encryption section >> database password.
#Press the Encrypt button to generate the encrypted password.
# Update the password in /opt/sonarqube/conf/sonar.properties
```
