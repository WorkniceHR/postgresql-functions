/*

Removes leading or trailing whitespace from the given text.

This is different from the built-in trim() or btrim() functions as they only remove a specific set of characters instead of any whitespace.

*/

CREATE FUNCTION trim_whitespace(text) RETURNS text
AS $$
  select regexp_replace(regexp_replace($1, '^\s+', ''), '\s+$', '');
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;
