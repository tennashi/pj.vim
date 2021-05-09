from denite.source.base import Base
from denite.util import Candidates, UserContext, Nvim
import subprocess
import json


class Source(Base):
    def __init__(self, vim: Nvim):
        super().__init__(vim)
        self.name = "pj/workspace"
        self.kind = "directory"
        self.default_action = "cd"

    def gather_candidates(self, context: UserContext) -> Candidates:
        cmd_path = self.vim.eval('g:pj_command_path')
        cmd = [cmd_path, '-o', 'json', 'workspace', 'list']
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        workspaces = json.loads(result.stdout.decode('utf-8'))

        def to_candidate(w):
            return {
                'word': w['path'],
                'action__path': w['path'],
            }

        return [to_candidate(w) for w in workspaces]
