/*

Removes leading or trailing whitespace (no just spaces) from the given text.

This is different from the built-in trim() and btrim() functions as they only remove a set aof specified characters.

*/

CREATE FUNCTION trim_whitespace(text) RETURNS text
AS $$
  select regexp_replace(regexp_replace($1, '^\s+', ''), '\s+$', '');
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;
