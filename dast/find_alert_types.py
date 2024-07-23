#!/usr/bin/env python

import subprocess
import json
import sys

# Invokes a given command and returns the stdout
def invoke(command):
    try:
        output = subprocess.check_output(command, shell=True, universal_newlines=True)
    except subprocess.CalledProcessError as exc:
        print("Status : FAIL", exc.returncode, exc.output)
        return exc.returncode, exc.output
    return 0, output


def get_results(folder_name):
    total_alerts = {"High": 0, "Medium": 0, "Low":0, "Informational":0, "NotFound": 0}
    try: 
        folder_zap = invoke(f'cat {folder_name}/*/*/*/zap-report.json')
        if folder_zap[0] != 0:
            print(f'total alerts for {folder_name} : zap report not found - failure in run')
            total_alerts['NotFound'] = 1
            return total_alerts
        zap_str = folder_zap[1]
    except:
        print(f'total alerts for {folder_name} : zap report not found - failure in run')
        total_alerts['NotFound'] = 1
        return total_alerts
    
    zap_json = json.loads(zap_str)
    for site in zap_json['site']:
        if "alerts" in site.keys():
            for alert in site['alerts']:
                risk_type = alert['riskdesc'].split(" ")[0]
                total_alerts[risk_type] += 1

    print(f'total alerts for {folder_name} : ' + str(total_alerts))
    return total_alerts

result_folder = "./results"
result = "Pass"
folders = invoke('ls ' + str(result_folder))[1].split('\n')
for folder in folders: 
    if folder != "":
        alert_results = get_results(result_folder + "/" +folder)
        if alert_results['High'] > 0 or alert_results['NotFound'] > 0:
            result = "Fail"

if result == "Fail": 
    sys.exit(1)

sys.exit(0)