from popper.util import Result


class EvaluateMixin(object):
    def __init__(self, *args, **kwargs):
        self.context.add_child('evaluate')
        super().__init__(*args, **kwargs)

    def evaluate(self, program, example):
        with self.context.evaluate:
            if example in self.atom_strs:
                return Result.Success, set((program,))
            return Result.Failure, set((program,))
