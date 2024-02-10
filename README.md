# Pets2U animal sorting

## Description

The problem solution is available in the PDF file `description.pdf` in the root directory of the project.

The codebase has a `main.rb` file that uses classes from the modules `Animals` and `Boxes`. Each file under both these modules represents either a different animal or a box type, containing the area it occupies.

All the boxes extend the `Box` class, which contains useful methods for "box manipulation".

## Requirements

- Ruby 3.2.3
  - RSpec 3.13.0

## Explanation

The solution is implemented in Ruby. The main file is `main.rb` in the root directory of the project.

The approach used in this solution was to first fit all animals in their respective-size boxes.
The special case of mixing a B1 and B3 was considered when inserting the animals.

After that, the B1 boxes were merged into B2 boxes, and the B2 boxes were merged into B3 boxes.
The special case of having only one B1 and one B2 box was considered when merging the boxes, since similar cases show up in the example input.

### Alternative solution

The `merge_b1_and_b2_boxes` method usage depends whether we prefer to have more smaller boxes or less bigger boxes. If we prefer the former alternative, we should keep the remaining B1 and B2 boxes. However, if we prefer the latter alternative, we should merge the remaining B1s and B2s into a B3 box with some remaining space.

## Running the code

To run the code, you need to have Ruby installed in your machine. Then, you can run the following command in the root directory of the project:

```bash
ruby main.rb
```

Input your data and press `Enter` to see the output.

## Running the tests

To run the tests, you need to have Ruby installed in your machine. Then, you can run the following command in the root directory of the project:

```bash
ruby test.rb
```
