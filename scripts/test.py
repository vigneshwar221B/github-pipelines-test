import json
import os

traffic_policy_file = "./templates/r53-weighted-policy.json"
redirect_region = "secondary"

# Get the list of files and directories in the current directory
files_and_directories = os.listdir()

# Print the list
for item in files_and_directories:
    print(item)

def load_traffic_policy(policy_file, primary_endpoint, secondary_endpoint):
  #read the json file
  with open(policy_file, 'r') as file:
    data = json.load(file)

  #replace endpoint values
  data['Endpoints']['primary-endpoint']['Value'] = primary_endpoint
  data['Endpoints']['secondary-endpoint']['Value'] = secondary_endpoint

  #assign weights
  primary_endpoint_weight = 100 if redirect_region == "primary" else 0
  secondary_endpoint_weight = 100 if redirect_region == "secondary" else 0

  data["Rules"]["weighted-rule"]["Items"][0]["Weight"] = primary_endpoint_weight
  data["Rules"]["weighted-rule"]["Items"][1]["Weight"] = secondary_endpoint_weight

  return json.dumps(data)

load_traffic_policy(traffic_policy_file, "a", "b")