from denite.base.kind import Base
from denite.util import UserContext, Nvim
import subprocess


class Kind(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self.name = 'pj'
        self.default_action = 'change'

    def action_change(self, context: UserContext) -> None:
        target = context['targets'][0]
        cmd = ['pj', '-o', 'json', 'change', target['action__project']]
        subprocess.run(cmd)
        self.vim.call('denite#util#cd', target['action__path'])
