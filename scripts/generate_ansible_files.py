#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def output_value(outputs, name):
    return outputs[name]["value"]


def yaml_scalar(value):
    return json.dumps(str(value))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ansible-dir", required=True)
    args = parser.parse_args()

    outputs = json.load(sys.stdin)
    ansible_dir = Path(args.ansible_dir)

    inventory = ansible_dir / "inventory.ini"
    vault = ansible_dir / "group_vars" / "webservers" / "vault.yml"
    vault.parent.mkdir(parents=True, exist_ok=True)

    vm_user = output_value(outputs, "vm_admin_username")
    inventory.write_text(
        "\n".join(
            [
                "[webservers]",
                f"host-1 ansible_host={output_value(outputs, 'vm_1_external_ip')} ansible_user={vm_user}",
                f"host-2 ansible_host={output_value(outputs, 'vm_2_external_ip')} ansible_user={vm_user}",
                "",
            ]
        ),
        encoding="utf-8",
    )

    vault_vars = {
        "vault_db_host": output_value(outputs, "db_host"),
        "vault_db_name": output_value(outputs, "db_name"),
        "vault_db_port": output_value(outputs, "db_port"),
        "vault_db_username": output_value(outputs, "db_user"),
        "vault_db_password": output_value(outputs, "db_password"),
        "vault_datadog_api_key": output_value(outputs, "datadog_api_key"),
    }
    vault.write_text(
        "".join(f"{key}: {yaml_scalar(value)}\n" for key, value in vault_vars.items()),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
