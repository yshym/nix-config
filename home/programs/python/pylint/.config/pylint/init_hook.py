import os
import sys


dev_dir = os.path.expanduser("~/dev")

for p in os.listdir(dev_dir):
    if p not in sys.path:
        sys.path.append(os.path.join(dev_dir, p))
