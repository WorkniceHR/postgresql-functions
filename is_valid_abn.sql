/*

Checks if the given text is a valid ABN (Australian Business Number) using the formula provided by the ABR:

https://abr.business.gov.au/Help/AbnFormat

Leading and trailing whitespace is allowed as is any whitespace between digits.

*/

CREATE FUNCTION is_valid_abn(text) RETURNS boolean
AS $$
  select sum(multiplier * cast(value as int)) % 89 = 0
  from unnest(
    array[10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19],
    string_to_array(
      cast((cast((
        case
          when $1 ~ '^(\\s*\\d\\s*){11}$'
            then regexp_replace($1, '\\s', '', 'g')
          else '11111111111'
        end
      ) as bigint) - 10000000000) as text),
      NULL
    )
  ) as x(multiplier, value);
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;
