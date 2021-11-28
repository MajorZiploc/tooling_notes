# Example

## Overview

This Markdown cheat sheet provides a quick overview of all the Markdown syntax elements. It can’t cover every edge case, so if you need more information about any of these elements, refer to the reference guides for basic syntax and extended syntax.

## Basic Syntax

These are the elements outlined in John Gruber’s original design document. All Markdown applications support these elements.

**bold text**

*italicized text*

> blockquote

### Ordered List
1. First item
2. Second item
3. Third item

### Unordered List
- Second item
- Third item

### Code
`code`

### Horizontal Rule
---

### Link
[title](https://www.example.com)

### Image
![alt text](image.jpg)

## Extended Syntax

These elements extend the basic syntax by adding additional features. Not all Markdown applications support these elements.

### Table

| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |

### Fenced Code Block
```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

### Footnote
Here's a sentence with a footnote. [^1]

[^1]: This is the footnote.

### Heading ID
#### My Great Heading {#custom-id}

### Definition List
term
: definition

### Strikethrough
~~The world is flat.~~

### Task List
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

### Emoji
That is so funny! :joy:

### Highlight
I need to highlight these ==very important words==.

### Subscript
H~2~O

### Superscript
X^2^
