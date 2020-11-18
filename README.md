# IOCLA_Assignments

Home assignments for the Year 2 Sem 1 Computer Architecture &amp; Assembly 
Language Course at the Faculty of Automatic Control and Computer Science.

## IOCLA1

The first assignment refers to an implementation of the printf function from 
the C programming language.

**List of available format specifiers:**

* %d - signed integer;
* %u - unsigned integer;
* %x - unsigned integer in hexadecimal format;
* %c - single char in ASCII format;
* %s - string;

## IOCLA2

The second assignment revolves around string opartions in NASM x86 Assembly. 

The first task was implementing **One Time Pad** encryption using a plaintext 
string and a key string. To get the encrypted character, XOR was performed on 
each plaintext character and it's corresponding key character.

The second task consisted of implementing the **Caesar Cipher** using a 
plaintext string and a key integer. 

The third assignment was a step up from the second one, implementing 
**Vigenere Cipher**. It uses a plaintext string and a key string. The key 
string contains only upper-case characters and each character represents the 
offset of that letter from 'A'. That offset is added to each character from 
the plaintext to get the encrypted character.

The fourth assignment was an implementation of the C string function 
**strstr**.

The fifth and final assignment required us to implement a **binary to 
hexadecimal** converter that worked on bit arrays of variable lengths, not 
necessarily multiple of 4 lengths.

