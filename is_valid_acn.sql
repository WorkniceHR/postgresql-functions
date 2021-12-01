/*

Checks if the given text is a valid ABN (Australian Company Number) using the formula provided by ASIC:

https://asic.gov.au/for-business/registering-a-company/steps-to-register-a-company/australian-company-numbers/australian-company-number-digit-check/

Leading and trailing whitespace is allowed as is any whitespace between digits.

*/

create function is_valid_acn(text) returns boolean
as $$
  declare
    digits text[] := array[]::text[];
    total int := 0;
    i int := 0;
  begin
    if $1 ~ '^(\s*\d\s*){9}$' then
      digits := string_to_array(regexp_replace($1, '\s', '', 'g'), null);
      for i in 1..8 loop
        total := total + cast(digits[i] as int) * (9 - i);
      end loop;
      return (10 - (total % 10)) % 10 = cast(digits[9] as int);
    else
      return false;
    end if;
  end;
$$
language 'plpgsql'
immutable
returns null on null input;
