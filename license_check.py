#!/usr/bin/env python3

# Copyright (c) 2018 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

import argparse
import sys
import json

def analyze_file(scancode_file, scanned_files_dir):

    report = ""
    never_check_ext =  ['.yaml', '.html', '.rst', '.conf', '.cfg']
    never_check_langs = ['HTML']
    check_langs = ['CMake']
    with open(scancode_file, 'r') as json_fp:
        scancode_results = json.load(json_fp)
        for file in scancode_results['files']:
            if file['type'] == 'directory':
                continue

            orig_path = str(file['path']).replace(scanned_files_dir, '')
            licenses = file['licenses']
            file_type = file.get("file_type")
            kconfig = "Kconfig" in orig_path and file_type in ['ASCII text']
            check = False

            if file.get("extension") in never_check_ext:
                check = False
            elif file.get("programming_language") in never_check_langs:
                check = False
            elif kconfig:
                check = True
            elif file.get("programming_language") in check_langs:
                check = True
            elif file.get("is_script"):
                check = True
            elif file.get("is_source"):
                check = True

            if check:
                if not licenses:
                    report += ("* {} missing license.\n".format(orig_path))
                else:
                    for lic in licenses:
                        if lic['key'] != "apache-2.0":
                            report += ("* {} is not apache-2.0 licensed: {}\n".format(
                                orig_path, lic['key']))
                        if lic['category'] != 'Permissive':
                            report += ("* {} has non-permissive license: {}\n".format(
                                orig_path, lic['key']))
                        if lic['key'] == 'unknown-spdx':
                            report += ("* {} has unknown SPDX: {}\n".format(
                                orig_path, lic['key']))

                if not file['copyrights'] and file.get("programming_language") != 'CMake':
                    report += ("* {} missing copyright.\n".format(orig_path))


    return(report)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Analyze licenses...")
    parser.add_argument('-s', '--scancode-output',
                        help='''JSON output from scancode-toolkit''')
    parser.add_argument('-f', '--scanned-files',
                        help="Directory with scanned files")
    return parser.parse_args()

if __name__ == "__main__":

    args = parse_args()


    if args.scancode_output and args.scanned_files:
        report = analyze_file(args.scancode_output, args.scanned_files)
        print(report)
    else:
        sys.exit("Provide files to analyze")
