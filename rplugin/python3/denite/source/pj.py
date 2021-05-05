from denite.source.base import Base
from denite.util import Candidates, UserContext, Nvim
import subprocess
import json

BUFFER_HIGHLIGHT_SYNTAX = [
    {'name': 'Name', 'link': 'Function', 're': r'.*\ze\s'},
]


class Source(Base):
    def __init__(self, vim: Nvim):
        super().__init__(vim)
        self.name = "pj"
        self.kind = "pj"
        self.default_action = "change"

    def highlight(self) -> None:
        for syn in BUFFER_HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

    def gather_candidates(self, context: UserContext) -> Candidates:
        cmd_path = self.vim.eval('g:pj_command_path')
        cmd = [cmd_path, '-o', 'json', 'list']
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        projects = json.loads(result.stdout.decode('utf-8'))

        max_len = 0
        for project in projects:
            max_len = max(max_len, len(project['name']))

        def to_candidate(proj):
            return {
                'word': proj['name'],
                'abbr': '{} {}'.format(
                    proj['name'].ljust(max_len, ' '),
                    proj['currentWorkspace'],
                ),
                'action__path': proj['currentWorkspace'],
                'action__project': proj['name'],
            }

        return [to_candidate(proj) for proj in projects]
