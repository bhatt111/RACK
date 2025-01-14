# Copyright (c) 2020, Galois, Inc.
#
# All Rights Reserved
#
# This material is based upon work supported by the Defense Advanced Research
# Projects Agency (DARPA) under Contract No. FA8750-20-C-0203.
#
# Any opinions, findings and conclusions or recommendations expressed in this
# material are those of the author(s) and do not necessarily reflect the views
# of the Defense Advanced Research Projects Agency (DARPA).

from dataclasses import dataclass

import semtk

from migration_helpers.name_space import NameSpace, get_uri
from ontology_changes.ontology_change import stylize_class, OntologyChange


@dataclass
class AddClass(OntologyChange):
    """
    Represents the addition of a new class.
    """

    name_space: NameSpace
    class_id: str

    def text_description(self) -> str:
        class_str = stylize_class(get_uri(self.name_space, self.class_id))
        return f"Class {class_str} was created."

    def migrate_json(self, json: semtk.SemTKJSON) -> None:
        json.accept(MigrationVisitor(self))


class MigrationVisitor(semtk.DefaultSemTKVisitor):
    def __init__(self, data: AddClass):
        self.data = data

    # TODO
