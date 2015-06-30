#!/usr/bin/env python

import json
import os
import subprocess
import sys

def run_cmd(cmd):
  print(cmd)
  subprocess.call(cmd, shell=True)

if len(sys.argv) < 2:
  print('Usage: {} RING_JSON_ENV_VAR'.format(sys.argv[0]))
  sys.exit(1)

ring_json = os.environ.get(sys.argv[1])
if not ring_json:
  print('ERROR: {} is empty'.format(sys.argv[1]))
  sys.exit(1)

ring_conf = json.loads(ring_json)

run_cmd('/usr/bin/swift-ring-builder {} create {} {} {}'.format(
        ring_conf['ring_config']['name'],
        ring_conf['ring_config']['part_power'],
        ring_conf['ring_config']['replicas'],
        ring_conf['ring_config']['min_part_hours']))

for count, host in enumerate(ring_conf['hosts']):
  run_cmd('/usr/bin/swift-ring-builder {} add z{}-{}/{} {}'.format(
          ring_conf['ring_config']['name'],
          count,
          host['ip'],
          host['device'],
          host['weight']))

run_cmd('/usr/bin/swift-ring-builder {} rebalance'.format(
        ring_conf['ring_config']['name']))
