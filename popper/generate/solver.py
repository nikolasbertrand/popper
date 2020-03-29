import uuid
from sys import stderr

from clingo import Function

from .representation import model_to_program


class SolverMixin(object):
    def __init__(self, *args, **kwargs):
        self.context.add_child('solver')
        self.context.solver.add_child('adding')
        self.context.solver.add_child('grounding')
        self.context.solver.add_child('solving')
        super().__init__(*args, **kwargs)


    def set_program_size(self, size):
        with self.context.solver:
            if self.debug: print(f"START SETTING PROGRAM SIZE", file=stderr)
            for i in range(1, size):
                self.clingo_ctl.release_external(Function("num_literals", [i]))
            # NB: might well attempt to reground the old parts of base as well
            # TODO: To be guaranteed to be efficient should carefully construct "shells" that depend on the program size
            # RESPONSE: This might actually already be done by the solver...
            if self.debug: print(f"START GROUNDING (set_program_size)", file=stderr)
            with self.context.solver.grounding:
                self.clingo_ctl.ground([("program_size", [size])])
            if self.debug: print(f"DONE GROUNDING (set_program_size)", file=stderr)
            self.clingo_ctl.assign_external(Function("num_literals", [size]), True)
            if self.debug: print(f"DONE SETTING PROGRAM SIZE", file=stderr)


    def get_program(self):
        with self.context.solver:
            model = self.get_model()
            if model:
                return model_to_program(model)
            return model


    # not an abstraction API method
    def get_model(self):
        # NB: no context here because not an API method
        if self.debug: print("START SOLVING", file=stderr)
        self.context.solver.solving.enter()
        with self.clingo_ctl.solve(yield_=True) as handle:
            self.context.solver.solving.exit()
            if self.debug: print("DONE SOLVING", file=stderr)

            # None indicates no model could be found (could try with more allowed literals)
            model = next(handle, None)
            if model:
                return model.symbols(atoms=True)
            return model


    def impose_constraints(self, constraints):
        with self.context.solver:
            code = ""
            for constr_name, constr in constraints:
                code += f"%%%%% {constr_name} %%%%%\n{constr}\n\n"
            if code:
                code_name = constr[0][0] # the name of the first constraint
                with self.context.solver.adding:
                    self.clingo_ctl.add(code_name, [], code)
                if self.debug: print(f"START GROUNDING (impose_constraints)", file=stderr)
                with self.context.solver.grounding:
                    self.clingo_ctl.ground([(code_name, [])])
                if self.debug: print(f"DONE GROUNDING (impose_constraints)", file=stderr)


    # not an abstraction API method
    def impose_constraint(self, constraint, constraint_name=None):
        # NB: no context here because not an API method
        name = constraint_name or str(uuid.uuid4())
        self.clingo_ctl.add(name, [], constraint)
        self.clingo_ctl.ground([(name, [])])