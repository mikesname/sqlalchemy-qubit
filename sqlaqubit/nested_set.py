"""
Nested set mapper for updating the database when a nested
item is inserted, deleted, or moved.  Implementation
algorithms largely borrowed from here:

    https://github.com/django-mptt
"""

from sqlalchemy import select, case, func
from sqlalchemy.orm import MapperExtension, sessionmaker
from sqlalchemy.sql import and_

Session = sessionmaker()

class NestedSetExtension(MapperExtension):
    """Mapper extension to update table nested set records
    when an object is created, updated, or deleted."""
    def before_insert(self, mapper, connection, instance):
        if instance.lft and instance.rgt:
            return

        table = instance.nested_object_table()
        if not instance.parent_id:
            max = connection.scalar(func.max(table.c.rgt))
            instance.lft = max + 1
            instance.rgt = max + 2
        else:
            right_most_sibling = connection.scalar(
                select([table.c.rgt]).where(table.c.id==instance.parent_id)
            )
            connection.execute(
                table.update(table.c.rgt>=right_most_sibling).values(
                    lft = case(
                            [(table.c.lft>right_most_sibling, table.c.lft + 2)],
                            else_ = table.c.lft
                          ),
                    rgt = case(
                            [(table.c.rgt>=right_most_sibling, table.c.rgt + 2)],
                            else_ = table.c.rgt
                          )
                )
            )
            instance.lft = right_most_sibling
            instance.rgt = right_most_sibling + 1

    def before_update(self, mapper, connection, instance):
        """Updated nested tree values."""
        modified = Session.object_session(instance)\
                .is_modified(instance, include_collections=False)
        if not modified:
            return

        table = instance.nested_object_table()
        old_parent_id = connection.scalar(
                select([table.c.parent_id]).where(table.c.id==instance.id)
        )
        # FIXME: This depends on a `parent` object having been set,
        # rather than just the `parent_id` FK
        if old_parent_id != instance.parent_id:
            if instance.parent:
                self._move_within_tree(instance, instance.parent, connection, table)
            else:
                self._unparent_and_close_gap(instance, connection, table)

    def before_delete(self, mapper, connection, instance):
        """Delete nested tree values for this model."""
        table = instance.nested_object_table()
        delta = instance.rgt - instance.lft + 1

        connection.execute(
            table.update(table.c.rgt>=instance.rgt).values(
                lft = case(
                    [(table.c.lft > instance.lft, table.c.lft - delta)],
                    else_ = table.c.lft
                ),
                rgt = case(
                    [(table.c.rgt >= instance.rgt, table.c.rgt - delta)],
                    else_ = table.c.rgt
                )
            )
        )

    def _unparent_and_close_gap(self, node, connection, table):
        gap_size = node.rgt - node.lft + 1
        lft_rgt_change = gap_lft = node.lft - 1
        maxrgt = connection.scalar(func.max(table.c.rgt))

        connection.execute(
            table.update().values(
                lft = case([
                        (and_(table.c.lft >= node.lft, table.c.lft <= node.rgt), 
                                table.c.lft - lft_rgt_change),
                        (table.c.lft > gap_lft,
                                table.c.lft - gap_size),
                    ],
                    else_ = table.c.lft
                ),
                rgt = case([
                        (and_(table.c.rgt >= node.lft, table.c.rgt <= node.rgt),
                                table.c.rgt - lft_rgt_change),
                        (table.c.rgt > gap_lft,
                                table.c.rgt - gap_size)
                    ],
                    else_ = table.c.rgt
                ),
                parent_id = case([(table.c.id == node.id, None)],
                        else_ = table.c.parent_id
                )
            )
        )
        node.lft = maxrgt - 1
        node.rgt = maxrgt

    def _move_within_tree(self, node, parent, connection, table):        
        width = node.rgt - node.lft + 1
        target_lft = parent.lft
        target_rgt = parent.rgt

        if target_rgt > node.rgt:
            new_lft = target_rgt - width
            new_rgt = target_rgt - 1
        else:
            new_lft = target_rgt
            new_rgt = target_rgt + width - 1
            
        lft_boundary = min(node.lft, new_lft)
        rgt_boundary = max(node.rgt, new_rgt)
        lft_rgt_change = new_lft - node.lft
        gap_size = width
        if lft_rgt_change > 0:
            gap_size = -gap_size

        connection.execute(
            table.update().values(
                lft = case([
                        (and_(table.c.lft >= node.lft, table.c.lft <= node.rgt), 
                                table.c.lft + lft_rgt_change),
                        (and_(table.c.lft >= lft_boundary, table.c.lft <= rgt_boundary),
                                table.c.lft + gap_size),
                    ],
                    else_ = table.c.lft
                ),
                rgt = case([
                        (and_(table.c.rgt >= node.lft, table.c.rgt <= node.rgt),
                                table.c.rgt + lft_rgt_change),
                        (and_(table.c.rgt >= lft_boundary, table.c.rgt <= rgt_boundary),
                                table.c.rgt + gap_size)
                    ],
                    else_ = table.c.rgt
                )
            )
        )
        node.lft = new_lft
        node.rgt = new_rgt



