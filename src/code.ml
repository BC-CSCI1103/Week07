(* CSCI 1103 Computer Science 1 Honors

   Robert Muller - Boston College

   Some code working with numeral systems.
*)

(* add : int list -> int list -> int -> int list

   add [2; 3; 5] [4; 0; 9] ==> [6; 4; 4]
*)
let addDigits a b c base =
  let sum = a + b + c
  in
  (sum / base, sum mod base)

(* add : int list -> int list -> int -> int list *)
let add ms ns base =
  let rec loop ms ns carryIn answer =
    match (ms, ns) with
    | ([], []) -> answer
    | (m :: ms, n :: ns) ->
      let (carryOut, digit) = addDigits m n carryIn base
      in
      loop ms ns carryOut (digit :: answer)
    | _ -> failwith "inputs must be of the same length"
  in
  loop (List.rev ms) (List.rev ns) 0 []


(* toDecimal : int list -> int -> int

   toDecimal [2; 0; 2; 0] 10 ==> 2020
*)
let intPower m n = int_of_float((float m) ** (float n))

let toDecimal digits base =
  let rec loop digits power answer =
    match digits with
    | [] -> answer
    | digit :: digits ->
      let newAnswer = answer + digit * (intPower base power)
      in
      loop digits (power - 1) newAnswer
  in
  loop digits (List.length digits - 1) 0

(* div : int -> int -> int * int *)
let div m n = (m / n, m mod n)

(* decimalTo : int -> int -> int list

   (decminalTo number base) converts decimal number to list
   of digits in base.  E.g.,

   (decimalTo 23 2) => [1; 0; 1; 1; 1]

   div 23 2 = (11, 1)
   div 11 2 = (5,  1)
   div  5 2 = (2,  1)
   div  2 2 = (1,  0)
   div  1 2 = (0,  1)
*)
let decimalTo n base =
  let rec repeat n answer =
    match n = 0 with
    | true  -> answer
    | false ->
      let (quotient, remainder) = div n base
      in
      repeat quotient (remainder :: answer)
  in
  repeat n []

(* baseToBase : int list -> int -> int -> int list *)
let baseToBase digits base1 base2 =
  let decimal = toDecimal digits base1
  in
  decimalTo decimal base2

(* The connection between toDecimal and decimalTo:

   toDecimal (decimalTo N base) base = N
*)

(* base 2 digit symbols = [0, 1]. Consider strings of length 2:

   00, 01, 10, 11 - there are 2^2 = 5 2-bit patterns;

   000, 001, 010, 011, 100, 101, 110, 111 - there are 2^3 = 8 3-bit patterns

   0000, 0001, ..., 1001, 1010, 1011, ... 1111 - 2^4 = 16 4-bit patterns
     0     1          9    10    11        15

   Base 16 (hexadecimal or hex) digits = [0, .., 9, A, B, C, D, E, F]

   0000, 0001, ..., 1001, 1010, 1011, ... 1111
     0     1          9    A     B         F

   Hexadecimal is convenient short-hand for a string of 8 bits. E.g.,

   1111 1000 = F8
*)
