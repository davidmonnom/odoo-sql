
# Dump & Restore by Tags

These scripts allow you to dump / restore your database according to the current branch name.

These scripts expect to find a database with the same name as the branch. If you're on the `master-some_improvement-moda` branch, a database with the same name should be created.

The [Joseph Caburnay VSC extension](https://marketplace.visualstudio.com/items?itemName=JosephCaburnay.odoo-dev-plugin) allows you to do this automatically

If you don't want to have a database name equal to the current branch, you can fill the global variable `_DB_OVERRIDE`.

## Installation

Adapt the global variables in the `sql_common.sh` file. You must provide
- The odoo community path.
- The odoo enterprise path.

If you wish, you can add aliases to your `.bashrc` so that you can call these scripts from anywhere.

```
alias sql_dump='~/src/with_helpers/sql/sql_dump.sh'
alias sql_restore='~/src/with_helpers/sql/sql_restore.sh'
alias sql_tags='~/src/with_helpers/sql/sql_tags.sh'
```

Don't forget to create the `data/` folder next to the SQL scripts.

## Usage
Type the command `sql_dump tag_example` this command will create a dump of the current database.

Type the command `sql_restore tag example` this command will restore the dump of the corresponding branch with the corresponding tag name.

Type the command `sql_tags` to see the available dumps for your branch.
