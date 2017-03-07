# cborm-versioning
## Version any orm entity for easy rollbacks

### Installation

```bash
box install cborm-versioning
```

### Usage

#### Automatic Versioning
If the entity has a `verisioned` attribute on the entities, the module will create a version of that entity.  Installing registers an interceptor on all `ORMPreInsert` and `ORMPreUpdate` events to version entities.

#### Manual Versioning
You can also manually create a version.  Doing so skips the check for the `versioned` attribute.

```js
var versioner = wirebox.createInstance( "Versioner@cborm-versioning" );
versioner.version( myEntity );
```

#### Restoring Entities from Versions
Once you have a version, restoring it to an entity is simple:

```js
var version = entityNew( "Version@cborm-versioning" ).get( id );
var restoredEntity = version.restore();
// then if you want this to be the new current version
restoredEntity.save();
```

#### Automatic Pruning of Old Versions
If you set a numeric value (`n`) for your `versioned` attribute (e.g. `versioned="4"` ), then the module will delete all versions in excess of `n` after creating a version.  By default, `cborm-versioning` doesn't delete any versions.