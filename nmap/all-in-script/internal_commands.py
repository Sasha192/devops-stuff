import os
import xmltodict
import json
import re
from logger import Logger
from abc import ABC, abstractmethod


class InternalCommand(ABC):
    def __init__(self, _params: dict, absolute_context_path: str, input: any):
        self.absolute_context_path = absolute_context_path
        self.parameters = _params
        self.input = input

    @property
    def parameters(self) -> dict:
        return self._parameters

    @parameters.setter
    def parameters(self, value):
        self._parameters = value

    @property
    def input(self) -> dict:
        return self._input

    @input.setter
    def input(self, value):
        self._input = value

    @property
    def absolute_context_path(self) -> str:
        return self._absolute_context_path

    @absolute_context_path.setter
    def absolute_context_path(self, value):
        self._absolute_context_path = value

    def run(self) -> dict:
        os.chdir(self.absolute_context_path)
        return self.execute()

    @abstractmethod
    def execute(self) -> dict:
        pass


class ConvertXmlToJson(InternalCommand):

    def execute(self) -> dict:
        """
        target -- target file in xml format
        output -- name of output file
        """
        Logger.log("... started ConvertXmlToJson ...")
        target = self.parameters["target"]
        output = self.parameters["output"]
        Logger.log(f"{target} -t-o-> {output}")
        xml_content = None
        with open(target) as read_from:
            xml_content = read_from.read()
        dictionary = xmltodict.parse(xml_content)
        json_content = json.dumps(dictionary, indent=4)
        with open(output, 'w') as write_to:
            write_to.write(json_content)
        Logger.log(f"Done")
        return None


class HostIpExtractor(InternalCommand):

    def execute(self) -> dict:
        """
        target -- target file in json format
        hostname_pattern -- hostname pattern to retrieve
        """
        Logger.log("... started HostIpExtractor ...")
        target = self.parameters['target']
        host_name_prefix = self.parameters['hostNamePrefix']
        output = self.parameters['output']
        Logger.log(f" ... reading {target} ... ")
        content = "{ }"
        with open(target) as read_file:
            content = read_file.read()
        content = json.loads(content)
        hosts = content["nmaprun"]["host"]
        hosts_and_addr = list()
        for host in hosts:
            hostname, host_address = self.fetch_host_info(host)
            if str(hostname).startswith(host_name_prefix):
                hosts_and_addr.append(
                    {
                        "host_name": hostname,
                        "host_address": host_address
                    }
                )

        Logger.log(f" ... foun {str(hosts_and_addr)} ... ")
        Logger.log(f" ... writing to {output} ... ")
        with open(output, 'w') as write_to:
            write_to.write(json.dumps(hosts_and_addr, indent=4))
        Logger.log(f"Done")
        return None

    @staticmethod
    def fetch_host_info(host: dict):
        try:
            return host["hostnames"]["hostname"]["@name"], host["address"]["@addr"]
        except Exception:
            return "", ""


class InternalCommandsFactory:

    @staticmethod
    def generate_command(name: str, params: dict, absolute_context_path: str, input: any) -> InternalCommand:
        return getattr(__import__('internal_commands'), name)(params, absolute_context_path, input)
