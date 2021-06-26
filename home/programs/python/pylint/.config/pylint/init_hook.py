import os
import sys


python_dir = "/Users/yevhenshymotiuk/dev/python"

for p in os.listdir(python_dir):
    if p not in sys.path:
        sys.path.append(os.path.join(python_dir, p))
