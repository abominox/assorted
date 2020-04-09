#!/usr/bin/env python3
"""systat"""

import psutil

def main():
    print(str(psutil.cpu_percent()) + "/" + str(psutil.virtual_memory()._asdict().get("percent")))

main()