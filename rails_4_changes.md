# Rails 3/4 compatibility changes

## `default_scope` returns a relation when disabled

**Was:** `unless IsParanoid.disabled?` (returns `nil` when disabled)
**Now:** Returns `where(nil)` when disabled, `where(...)` otherwise.
**Why:** Rails 4 requires `default_scope` blocks to return a Relation, not `nil`.

## `has_many` signature mismatch

Rails 3 `has_many(name, options_hash, &block)` vs Rails 4 `has_many(name, scope_lambda, options_hash, &block)`. A single method can't accept both because Rails 3 rejects a lambda in position 2, and Rails 4 requires it. Solved with `if IsParanoid::RAILS_4` at the module body level to define two different method signatures.

The **Rails 4 path** also includes a `scope.is_a?(Hash)` guard - when Rails internals (e.g. HABTM) call `has_many` with a hash in the scope position, we shift it to options.

## `has_many` through - HABTM guard

**Added:** Check that the through model is actually paranoid before injecting conditions.
**Why:** Rails 4 reimplements `has_and_belongs_to_many` as `has_many :through` internally. The join table (e.g. `androids_places`) has no `deleted_at` column, so blindly adding `androids_places.deleted_at IS NULL` causes a PG error. Rails 3 HABTM doesn't go through `has_many`, so this was never hit before.

## `restore` - two `update_all` styles

**Rails 3:** `with_exclusive_scope { update_all("col = val", conditions) }` - two-argument `update_all` with string SET clause and conditions hash.
**Rails 4:** `unscoped.where(pk => id).update_all(col => val)` - `update_all` only accepts the SET argument; conditions go through `where`. `with_exclusive_scope` doesn't exist.

###`method_missing` dynamic methods (`_with_destroyed`, `_destroyed_only`)

**Was:** Always uses `with_exclusive_scope` and `with_scope`.
**Now:** Rails 4 path uses `unscoped { send(...) }` for `_with_destroyed` and `unscoped.where.not(...)` for `_destroyed_only`. Rails 3 path unchanged.
**Also:** Captured `$1`/`$2` into local variables (`method_name`, `suffix`) before entering the `Module.new` block, because the regex globals get clobbered.

## `with_exclusive_scope` / `current_scoped_methods` overrides - Rails 3 only

Wrapped in `unless IsParanoid::RAILS_4`. Neither method exists in Rails 4. The `with_exclusive_scope` override is still load-bearing for Rails 3 due to `find_in_batches_with_scoping_fix` in RG calling `preload_associations` inside a `with_exclusive_scope` block.

### `restore_related` - two finder styles

**Rails 3:** `klass.find_destroyed_only(:all, :conditions => ...)` - uses the dynamic `find_destroyed_only` with old finder syntax.
**Rails 4:** `klass.unscoped.where.not(destroyed_field => not_destroyed).where(key => id)` - direct query.

## Instance `_with_destroyed` methods

**Was:** Uses `first_with_destroyed`/`all_with_destroyed` class methods with `:conditions` hash.
**Now:** Uses `unscoped.where(...)` directly for both has and belongs_to associations. This works on both Rails 3 and 4 (no version branch needed).

## `alt_destroy_without_callbacks` - two `update_all` styles

Same issue as `restore`: Rails 4 removed the two-argument form. Rails 4 uses `where(pk => id).update_all(col => val)`, Rails 3 uses `update_all("string", conditions)`.

## `destroy` - re-entry guard

**Added:** `return self if @_is_paranoid_destroying` check.
**Why:** Circular `dependent: :destroy` (Android -> Component -> Android) causes infinite recursion in Rails 4. Standard AR's `destroy` has implicit protections (freeze, `persisted?` checks) that our override bypasses. Rails 3 handled this differently in the association internals. The guard prevents the same instance from re-entering `destroy` while its callbacks are still running.
