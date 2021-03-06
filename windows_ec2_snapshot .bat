set AWS_HOME=C:\AWS
set AWS_VOLUME=vol-12345678
set AWS_SNAPSHOT_KEEP=7

:: Create snapshot for this volume
CMD /C ec2-create-snapshot %AWS_VOLUME% -d "Daily Snapshot"

:: Find old snapshots for this volume, sort them by date desc
ec2-describe-snapshots -F "volume-id=%AWS_VOLUME%" -F "status=completed"|find /I "Daily Snapshot"|sort /R /+49>%AWS_HOME%\snapshots.txt

:: Loop over old snapshots, skip the first 7, delete the rest
for /f "tokens=2 skip=%AWS_SNAPSHOT_KEEP%" %%s in (%AWS_HOME%\snapshots.txt) do ec2-delete-snapshot %%s
