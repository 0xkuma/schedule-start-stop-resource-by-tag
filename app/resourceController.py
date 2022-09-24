def startEc2Instace(ec2, instanceIdList):
  response = ec2.start_instances(
    InstanceIds=instanceIdList,
    DryRun=False
  )
  return response

def stopEc2Instace(ec2, instanceIdList):
  response = ec2.stop_instances(
    InstanceIds=instanceIdList,
    DryRun=False
  )
  return response

def startRdsInstace(rds, instanceIdList):
  for instanceId in instanceIdList:
    rds.start_db_instance(
      DBInstanceIdentifier=instanceId,
    )

def stopRdsInstace(rds, instanceIdList):
  for instanceId in instanceIdList:
    rds.stop_db_instance(
      DBInstanceIdentifier=instanceId,
    )