# export startEc2Instace function
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