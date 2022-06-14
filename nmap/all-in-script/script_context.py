import re
from internal_commands import InternalCommandsFactory, InternalCommand
from abc import ABC


class BasePathAware(ABC):
    def base_path(self):
        return self.base_path

    @staticmethod
    def format_path(value: str):
        return re.sub("/{2,}", "/", value)


class InternalCommandContext(BasePathAware):
    def __init__(self, base_path: str, _dict: dict):
        self.base_path = BasePathAware.format_path(base_path)
        self.context = _dict["context"]
        self.params=_dict["parameters"]
        self.name=_dict["name"]
        self.command = InternalCommandsFactory.generate_command(
            params=self.params,
            name=self.name,
            absolute_context_path=self.base_path + '/' + self.context,
            input=None
        )

    @property
    def context(self) -> str:
        return self._context

    @context.setter
    def context(self, value):
        self._context = value

    @property
    def params(self) -> dict:
        return self._params

    @params.setter
    def params(self, value):
        self._params = value

    @property
    def name(self) -> str:
        return self._name

    @name.setter
    def name(self, value):
        self._name = value

    @property
    def command(self) -> InternalCommand:
        return self._command

    @command.setter
    def command(self, value):
        self._command = value

    def command_input(self, value: dict):
        if value is not None:
            self.command = InternalCommandsFactory.generate_command(
                params=self.params,
                name=self.name,
                absolute_context_path=self.base_path + '/' + self.context,
                input=value
            )



class Instruction(BasePathAware):
    def __init__(self, base_path: str, _dict: dict):
        self.base_path = BasePathAware.format_path(base_path)
        self.context = _dict["context"]
        self.bash_commands = _dict["bash_commands"]
        internal_commands_contexts = []
        for item in list(_dict["internal_commands"]):
            internal_commands_contexts.append(InternalCommandContext(
                _dict=item,
                base_path=self.base_path + '/' + self.context
            ))
        self.internal_commands = internal_commands_contexts

    @property
    def context(self) -> str:
        return self._context

    @property
    def bash_commands(self) -> list:
        return self._bash_commands

    @property
    def internal_commands(self) -> [InternalCommandContext]:
        return self._internal_commands

    @context.setter
    def context(self, value):
        self._context = value

    @bash_commands.setter
    def bash_commands(self, value):
        self._bash_commands = value

    @internal_commands.setter
    def internal_commands(self, value):
        self._internal_commands = value


class ScriptContext(BasePathAware):
    def __init__(self, dictionary):
        self.context = BasePathAware.format_path(dictionary["context"])
        instructions = list()
        for item in list(dictionary["instructions"]):
            instructions.append(Instruction(
                base_path=self.context + '/',
                _dict=item
            ))
        self.instructions = instructions

    @property
    def context(self) -> str:
        return self._context

    @property
    def instructions(self) -> [Instruction]:
        return self._instructions

    @context.setter
    def context(self, value):
        self._context = value

    @instructions.setter
    def instructions(self, value):
        self._instructions = value
