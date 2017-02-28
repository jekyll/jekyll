---
test1:
  a:
    aa: inline_overriden_a_aa
    xx: inline_added_a_xx
  c:
    cc: inline_added_c_cc
test3: inline
---
this scenario should prove that inline front matter overrides detached front matter values via deep hash merging
