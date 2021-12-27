[![Haskell CI](https://github.com/DrearyLisper/sloe/actions/workflows/haskell.yml/badge.svg)](https://github.com/DrearyLisper/sloe/actions/workflows/haskell.yml)

# Sloe: Pure-functiononal language

Sloe is a simple pure-functional language based on lambda-calculus. It uses [Lambda](https://github.com/DrearyLisper/lambda) as dependency for evaluation of Lambda-expressions.

## Examples

### FizzBuzz

For full source code see [fizzbuzz.sloe](https://github.com/DrearyLisper/sloe/blob/master/examples/fizzbuzz.sloe)

```
...
fizzbuzz n = if (and (iszero (mod n 3)) (iszero (mod n 5))) FizzBuzz (if (iszero (mod n 3)) Fizz (if (iszero (mod n 5)) Buzz n))

result = rangef fizzbuzz 0 20

select 1 result
select 2 result
select 3 result
select 4 result
select 5 result
select 6 result
s
...
```

``` 
$ cabal run sloe examples/fizzbuzz.sloe
Up to date
\f.\x.(f x)
\f.\x.(f (f x))
Fizz
\f.\x.(f (f (f (f x))))
Buzz
Fizz
\f.\x.(f (f (f (f (f (f (f x)))))))
\f.\x.(f (f (f (f (f (f (f (f x))))))))
Fizz
Buzz
\f.\x.(f (f (f (f (f (f (f (f (f (f (f x)))))))))))
Fizz
\f.\x.(f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))
\f.\x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))
FizzBuzz
\f.\x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))
\f.\x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))))))
Fizz

```

