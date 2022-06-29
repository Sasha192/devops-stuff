import time
import json
import os
import subprocess
import sys
import logging
from script_context import ScriptContext, InternalCommandContext, Instruction, BasePathAware
from logger import Logger

default_script_context_path = "script_context.json"
fail_on_error = True


def create_script_context(path: str) -> ScriptContext:
    with open(path, "r") as conf:
        script_context = json.load(conf)
    if script_context is None:
        Logger.log(f"Error: can not load {path}")
        sys.exit(1)
    return ScriptContext(script_context)


def execute_command(command):
    Logger.log("executing {}".format(command))
    time.sleep(2)
    process = subprocess.Popen([command],
                               stdout=subprocess.PIPE,
                               universal_newlines=True,
                               shell=True)
    while True:
        output = process.stdout.readline()
        Logger.log(output.strip())
        return_code = process.poll()
        if return_code is not None:
            Logger.log(f'RETURN CODE {return_code}')
            for output in process.stdout.readlines():
                Logger.log(output.strip())
            if fail_on_error and return_code != 0:
                Logger.log("Command {} returned non 0 code".format(command))
                sys.exit(1)
            break


def execute_internal_command(command_ctx: InternalCommandContext):
    if command_ctx.context is not None and command_ctx.context != "":
        os.chdir(BasePathAware.format_path(command_ctx.base_path + '/' + command_ctx.context))
    return command_ctx.command.run()


def set_input(command: InternalCommandContext, command_input: dict):
    command.command_input(value=command_input)


def execute_internal_commands(instruction: Instruction, internal_commands: [InternalCommandContext]):
    base_dir_context = BasePathAware.format_path(instruction.base_path + '/' + instruction.context)
    output_dict = None
    for command in internal_commands:
        os.chdir(base_dir_context)
        if output_dict is not None:
            set_input(command, output_dict)
        output_dict = execute_internal_command(command)


def execute(instruction: Instruction):
    os.chdir(instruction.context)
    for command in instruction.bash_commands:
        execute_command(command)
    execute_internal_commands(instruction, instruction.internal_commands)


def start():
    configuration_context = create_script_context(default_script_context_path)
    super_context = configuration_context.context
    for instruction in configuration_context.instructions:
        os.chdir(super_context)
        execute(instruction)


if __name__ == "__main__":
    start()

