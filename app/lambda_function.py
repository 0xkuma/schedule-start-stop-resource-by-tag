import boto3
import pytz
import datetime
import resourceController
import json

resourcegroupstaggingapi = boto3.client('resourcegroupstaggingapi')
ec2 = boto3.client('ec2')
rds = boto3.client('rds')
hkt = pytz.timezone('Asia/Hong_Kong')
ResourceTypeFilters = [
    'ec2:instance',
    'rds:db',
]


def getTodayWeekDay():
    # Get today week day
    week = str(datetime.datetime.now(hkt).isoweekday())
    print('Today week day: ' + week)
    return week


def getCurrentHour():
  # Get current hour
    hour = str(datetime.datetime.now(hkt).hour)
    print('Current hour: ' + hour)
    return hour


def isProcessWeek(weekTag):
    #  Check if the resource should be processed in the current week
    for tag in weekTag:
        if tag['Key'] == 'Week':
            week = str(tag['Value'])
            if getTodayWeekDay() in week:
                return True
    return False


def getResourceByTag(tag, paginationToken=''):
    # Get resource by tag
    response = resourcegroupstaggingapi.get_resources(
        TagFilters=tag,
        ResourceTypeFilters=ResourceTypeFilters
    )
    paginationToken = response['PaginationToken'] if 'PaginationToken' in response else ''
    resourceTagMappingList = response['ResourceTagMappingList']
    return paginationToken, resourceTagMappingList

# |_____Tag_______|__Allow Value__|
# |Week           |[0 1 2 3 4 5 6]|
# |TimeSlotStart  |[0 - 23]       |
# |TimeSlotStop   |[0 - 23]       |


def lambda_handler(event, context):
    print(json.dumps(event))
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
        paginationToken, resourceTagMappingList = getResourceByTag(
            resourceTagFilters, paginationToken)
        resourceList.extend(resourceTagMappingList)

    # Assign resource id to list
    ec2InstanceList = []
    rdsInstanceList = []
    for resource in resourceList:
        if isProcessWeek(resource['Tags']):
            resourceArn = resource['ResourceARN']
            resourceType = resourceArn.split(':')[2]
            if resourceType == 'ec2':
                ec2InstanceList.append(resourceArn.split('/')[1])
            elif resourceType == 'rds':
                rdsInstanceList.append(resourceArn.split(':')[6])

    # Start or stop resource
    if jobTag == 'TimeSlotStart':
        if len(ec2InstanceList) > 0:
            print('Start EC2 instance: ' + str(ec2InstanceList))
            resourceController.startEc2Instace(ec2, ec2InstanceList)
        if len(rdsInstanceList) > 0:
            print('Start RDS instance: ' + str(rdsInstanceList))
            resourceController.startRdsInstace(rds, rdsInstanceList)
    elif jobTag == 'TimeSlotStop':
        if len(ec2InstanceList) > 0:
            print('Stop EC2 instance: ' + str(ec2InstanceList))
            resourceController.stopEc2Instace(ec2, ec2InstanceList)
        if len(rdsInstanceList) > 0:
            print('Stop RDS instance: ' + str(rdsInstanceList))
            resourceController.stopRdsInstace(rds, rdsInstanceList)

# if __name__ == "__main__":
#   lambda_handler({"job":"start"}, None)
