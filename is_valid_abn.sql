/*

Checks if the given text is a valid ABN (Australian Business Number) using the formula provided by the ABR:

https://abr.business.gov.au/Help/AbnFormat

Leading and trailing whitespace is allowed as is any whitespace between digits.

*/

create function is_valid_abn(text) returns boolean
as $$
  declare
    digits text[] := array[]::text[];
    weighting_factors int[] := array[10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
    total int := 0;
    i int := 0;
  begin
    if $1 ~ '^(\s*\d\s*){11}$' then
      digits := string_to_array(regexp_replace($1, '\s', '', 'g'), null);
      digits[1] := cast(cast(digits[1] as int) - 1 as text);
      for i in 1..11 loop
        total := total + cast(digits[i] as int) * weighting_factors[i];
      end loop;
      return total % 89 = 0;
    else
      return false;
    end if;
  end;
$$
language 'plpgsql'
immutable
returns null on null input;
