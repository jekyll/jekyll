#!/bin/bash
# -----------------------------------------------------------------------------
# If you send us a ruby then we use that, if you do not then we test with
# whatever we can detect, this way you can run both suites when you test out
# your source, we expect full coverage now, not just MRI.
# -----------------------------------------------------------------------------

rubies=()
for r in ruby jruby; do
  if which "$r" > /dev/null 2>&1
  then
    echo $r
  fi
done
