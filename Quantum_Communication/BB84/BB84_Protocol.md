# The BB84 Protocal

* Step 1. Alice creates string 0's and 1's.
* Step 2. Alice polarizes photons with different basis (x and +) and mapping.
* Step 3. Bob chooses a random basis from x and + and measures the photon. Then, he stores the result.
* Step 4. Alice calls Bob on classical channel and discusses basis each used to find where basis agreed.
* Step 5. Error correction by classical methods or quantum error correction method.
* Step 6. Privacy amplification (help improve security)

|Alice's string|1|1|0|1|0|0|1|0|1|1|1|1|0|0|
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
|Alice's basis|+|+|+|x|x|+|x|x|x|x|+|+|+|+|
|Bob's basis|+|x|+|+|x|+|x|+|x|x|+|+|+|+|
|Bob's string|1|R|0|R|0|0|1|R|1|1|1|1|0|0|
|Same basis?|Y|N|Y|N|Y|Y|Y|N|Y|Y|Y|Y|Y|Y|
|Bits to keep|1|-|0|-|0|-|0|0|1|-|1|1|1|1|0|0|
|Test|Y|-|N|-|N|Y|N|-|N|N|N|Y|Y|N|
|Key|-|-|0|-|0|-|1|-|1|1|1|-|-|0|

_“Y” and “N” stands for “yes” and “no” respectively, and “R” means that Bob obtains a random result._
