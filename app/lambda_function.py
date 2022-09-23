import boto3
import datetime
import resourceController

resourcegroupstaggingapi = boto3.client('resourcegroupstaggingapi')
ec2 = boto3.client('ec2')


# Get today week day
def getTodayWeekDay():
    return str(datetime.datetime.today().weekday())

# Get current hour
def getCurrentHour():
    return str(datetime.datetime.now().hour)

#  Check if the resource should be processed in the current week
def isProcessWeek(weekTag):
  for tag in weekTag:
    if tag['Key'] == 'Week':
      week = str(tag['Value'])
      if getTodayWeekDay() in week:
        return True

# Get resource by tag
def getResourceByTag(tag, paginationToken=''):
  response = resourcegroupstaggingapi.get_resources(
      TagFilters=tag,
      ResourceTypeFilters=[
          'ec2:instance',
      ]
  )
  paginationToken = response['PaginationToken'] if 'PaginationToken' in response else ''
  resourceTagMappingList = response['ResourceTagMappingList']
  return paginationToken, resourceTagMappingList

# |_____Tag_______|__Allow Value__|
# |week           |[0 1 2 3 4 5 6]|
# |timeSlotStart  |[0 - 23]       |
# |timeSlotStop   |[0 - 23]       |
def lambda_handler(event, context):
  hour = getCurrentHour()
  resourceList = []
  paginationToken = None
  jobMapping = {
    'start': "TimeSlotStart",
    'stop': "TimeSlotStop"
  }
  jobTag = jobMapping[event['job']]

  resourceTagFilters = [
          {
              'Key': jobTag,
              'Values': [
                  hour,
              ]
          },
      ]
  
  # Loop to get all resources by tag if have pagination
  while paginationToken != '':
    paginationToken, resourceTagMappingList = getResourceByTag(resourceTagFilters, paginationToken)
    resourceList.extend(resourceTagMappingList)

  # Assign resource id to list
  ec2InstanceList = []
  for resource in resourceList:
    if isProcessWeek(resource['Tags']):
      resourceArn = resource['ResourceARN']
      resourceType = resourceArn.split(':')[2]
      if resourceType == 'ec2':
        ec2InstanceList.append(resourceArn.split('/')[1])

  # Start or stop resource
  if jobTag == 'TimeSlotStart':
    if len(ec2InstanceList) > 0:
      resourceController.startEc2Instace(ec2, ec2InstanceList)
  elif jobTag == 'TimeSlotStop':
    if len(ec2InstanceList) > 0:
      resourceController.stopEc2Instace(ec2, ec2InstanceList)

# if __name__ == "__main__":
#   lambda_handler()