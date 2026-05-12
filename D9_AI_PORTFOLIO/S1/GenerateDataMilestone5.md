# Input

What algorithms are there to uniformly random permutate a list or array, preferrably of a O(n) sequence?

# Output

The canonical algorithm is the Fisher-Yates shuffle (also called the Knuth shuffle), which runs in O(n) time and produces a uniformly random permutation.

Fisher-Yates (Modern / Knuth variant)

for i from n-1 down to 1:
j = random integer in [0, i]  (inclusive)
swap(array[i], array[j])

Each element ends up in any position with equal probability 1/n.

Python:
import random

def fisher_yates(arr):
for i in range(len(arr) - 1, 0, -1):
j = random.randint(0, i)
arr[i], arr[j] = arr[j], arr[i]

This is exactly what random.shuffle() implements under the hood.

Why it's uniform

At each step i, you pick uniformly from the remaining i+1 unshuffled positions. The probability of any particular permutation is exactly 1/n! — provably uniform.

Common mistake to avoid

The naive swap swap(arr[i], arr[randint(0, n-1)]) (picking from the full range every time) is not uniform — it produces n^n outcomes but only n! valid permutations, and n^n is not divisible by n! for n > 2.

Alternatives

┌─────────────────────────────┬────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────┐
│          Algorithm          │    Time    │                                              Notes                                               │
├─────────────────────────────┼────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Fisher-Yates (in-place)     │ O(n)       │ The standard choice                                                                              │
├─────────────────────────────┼────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Fisher-Yates (out-of-place) │ O(n)       │ Builds a new array; useful if original must be preserved                                         │
├─────────────────────────────┼────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Sort by random key          │ O(n log n) │ arr.sort(key=lambda _: random()) — simple but slower and has floating-point collision edge cases │
└─────────────────────────────┴────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────┘

Fisher-Yates in-place is the right answer for almost every use case.

# Input

And to spread randomly across another array? So each element of one array should be connected to 0-max amount of the other array?  

# Output

For spreading elements of array B across array A (each A element gets 0–max B elements):

Option 1: Random cut-points (uniform spread)

Shuffle B, then randomly partition it across A elements.

import random

def assign_one_to_many(A, B):
B_shuffled = B[:]
random.shuffle(B_shuffled)

      n = len(A)
      cuts = sorted(random.sample(range(len(B_shuffled) + 1), n - 1))
      cuts = [0] + cuts + [len(B_shuffled)]

      return {
          A[i]: B_shuffled[cuts[i]:cuts[i+1]]
          for i in range(n)
      }

O(n + m). Each A element gets a roughly equal share. Some may get 0.

Option 2: Stick-breaking (skewed / realistic spread)

Break a "stick" of length 1 into random proportions, then use those to size each chunk.

def assign_stick_breaking(A, B, alpha=1.0):
B_shuffled = B[:]
random.shuffle(B_shuffled)

      n, m = len(A), len(B)
      weights, remaining = [], 1.0
      for _ in range(n - 1):
          frac = random.betavariate(1, alpha)
          weights.append(frac * remaining)
          remaining *= (1 - frac)
      weights.append(remaining)
  
      sizes = [round(w * m) for w in weights]
      sizes[-1] = m - sum(sizes[:-1])  # fix rounding

      result, idx = {}, 0
      for a, size in zip(A, sizes):
          result[a] = B_shuffled[idx:idx + size]
          idx += size
      return result

O(n + m). alpha=1 gives exponential decay (first A elements get more); higher alpha approaches uniform.

When to use which

┌─────────────────┬────────────────────────┬─────────────────────────────────────────┐
│                 │       Cut-points       │             Stick-breaking              │
├─────────────────┼────────────────────────┼─────────────────────────────────────────┤
│ Distribution    │ ~uniform               │ Skewed (power-law-like)                 │
├─────────────────┼────────────────────────┼─────────────────────────────────────────┤
│ Real-world feel │ Artificial             │ More natural                            │
├─────────────────┼────────────────────────┼─────────────────────────────────────────┤
│ Control         │ None                   │ Via alpha                               │
├─────────────────┼────────────────────────┼─────────────────────────────────────────┤
│ Use case        │ Even load distribution │ Realistic data (popular items dominate) │
└─────────────────┴────────────────────────┴─────────────────────────────────────────┘
