% Common command-line option handling for RACK prolog utilities

parse_args(ExtraArgs, Opts, PosArgs) :-
    working_directory(Cwd, Cwd),
    atom_concat(Cwd, 'OwlModels/', OwlDir),
    atom_concat(Cwd, 'models/TurnstileSystem/src', DataDir),
    atom_concat(Cwd, 'databin/databin.rack', RFile),
    append([ [opt(verbose), type(boolean), default(false),
                 shortflags([v]), longflags(['verbose']),
                 help('Enable verbose output')],

                [opt(ontology_dir), meta('DIR_OR_URL'), type(atom),
                 shortflags([o]), longflags(['ontology', 'model']),
                 default(OwlDir),
                 help('Where to load ontology from')],

                [opt(recognizers), meta('FILE'), type(atom),
                 shortflags([r]), longflags(['recognizer', 'recognizers']),
                 default(RFile),
                 help('File containing data recognizers to use')],

                [opt(data_dir), meta('DIR'), type(atom),
                 shortflags([d]), longflags(['data']),
                 default(DataDir),
                 help('Where to load data from')],

                [opt(data_namespace), meta('NS'), type(atom),
                 shortflags([n]), longflags(['namespace']),
                 default('http://testdata'),
                 help('Namespace to load data into')]
           ], ExtraArgs, OptSpec),
    opt_arguments(OptSpec, Opts, PosArgs),
    % write('Opts: '), write(Opts), nl,
    % write('PosArgs: '), write(PosArgs), nl,
    set_verbosity(Opts),
    get_ontology_dir(Opts, ODir),
    print_message(informational, loading_ontology_dir(ODir)),
    load_local_model(ODir),
    load_recognizers(Opts),
    load_data_from_dir(Opts).


get_ontology_dir(Opts, Path) :- member(ontology_dir(Path), Opts), !.
get_ontology_dir(_, '.').

load_recognizers(Opts) :-
    member(recognizers(R), Opts),
    load_recognizer(R).

load_data_from_dir(Opts) :-
    member(data_dir(D), Opts),
    member(data_namespace(NS), Opts),
    print_message(informational, loading_data(NS, D)),
    load_data(NS, D).

set_verbosity([]).
set_verbosity([verbose(true)|_]) :- set_prolog_flag(verbose, normal).
set_verbosity([verbose(false)|_]) :- set_prolog_flag(verbose, silent).
set_verbosity([_|Opts]) :- set_verbosity(Opts).


prolog:message(loading_ontology_dir(D)) -->
    [ 'loading ontology from ~w'-[D] ].
prolog:message(loading_data(NS, D)) -->
    [ 'loading data from ~w into ~w'-[D, NS] ].